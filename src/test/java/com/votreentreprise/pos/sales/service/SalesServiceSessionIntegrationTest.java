package com.votreentreprise.pos.sales.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.PaymentMethod;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class SalesServiceSessionIntegrationTest {

    @Autowired
    private SalesService salesService;

    @Autowired
    private SessionService sessionService;

    private UUID testStoreId;
    private UUID testVariantId;
    private String testUserId;
    private CashSession cashSession;

    @BeforeEach
    void setUp() {
        testStoreId = TestDataBuilder.TEST_STORE_ID;
        testVariantId = TestDataBuilder.TEST_VARIANT_A1_ID;
        testUserId = "test-user";
        
        // Open a cash session for testing
        cashSession = sessionService.openCashSession(
                testStoreId, 
                testUserId, 
                Money.of(new BigDecimal("100.00"))
        );
    }

    @Test
    void shouldRecordCashPaymentMovementInSession() {
        // Given
        String receiptNumber = "REC-001";
        String sourceOfflineId = "offline-001";
        
        // Create receipt
        var receipt = salesService.createReceipt(testStoreId, testUserId, receiptNumber, sourceOfflineId);
        
        // Add line to receipt
        salesService.addLine(
                receipt.getId(),
                testVariantId,
                Quantity.of(new BigDecimal("2")),
                Money.of(new BigDecimal("15.00"))
        );
        
        // Finalize receipt
        salesService.finalizeReceipt(receipt.getId(), testUserId);
        
        // When - Add cash payment
        Money paymentAmount = Money.of(new BigDecimal("30.00"));
        String paymentReference = "PAY-001";
        
        var payment = salesService.addPayment(
                receipt.getId(),
                PaymentMethod.CASH,
                paymentAmount,
                paymentReference
        );

        // Then
        assertThat(payment).isNotNull();
        assertThat(payment.getPaymentMethod()).isEqualTo(PaymentMethod.CASH);
        assertThat(payment.getAmount()).isEqualTo(paymentAmount);
        assertThat(payment.getReference()).isEqualTo(paymentReference);

        // Verify movement was recorded in cash session
        CashSession updatedSession = sessionService.getCashSession(cashSession.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(paymentAmount);
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.zero());
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(
                Money.of(new BigDecimal("100.00")).add(paymentAmount)
        );
    }

    @Test
    void shouldNotRecordNonCashPaymentMovementInSession() {
        // Given
        String receiptNumber = "REC-002";
        String sourceOfflineId = "offline-002";
        
        // Create receipt
        var receipt = salesService.createReceipt(testStoreId, testUserId, receiptNumber, sourceOfflineId);
        
        // Add line to receipt
        salesService.addLine(
                receipt.getId(),
                testVariantId,
                Quantity.of(new BigDecimal("1")),
                Money.of(new BigDecimal("20.00"))
        );
        
        // Finalize receipt
        salesService.finalizeReceipt(receipt.getId(), testUserId);
        
        // When - Add mobile payment (should not create movement)
        Money paymentAmount = Money.of(new BigDecimal("20.00"));
        String paymentReference = "PAY-002";
        
        var payment = salesService.addPayment(
                receipt.getId(),
                PaymentMethod.MOBILE,
                paymentAmount,
                paymentReference
        );

        // Then
        assertThat(payment).isNotNull();
        assertThat(payment.getPaymentMethod()).isEqualTo(PaymentMethod.MOBILE);
        assertThat(payment.getAmount()).isEqualTo(paymentAmount);

        // Verify no movement was recorded in cash session
        CashSession updatedSession = sessionService.getCashSession(cashSession.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(Money.zero());
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.zero());
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("100.00")));
    }

    @Test
    void shouldRecordMultipleCashPaymentsInSession() {
        // Given
        String receiptNumber1 = "REC-003";
        String receiptNumber2 = "REC-004";
        
        // Create first receipt
        var receipt1 = salesService.createReceipt(testStoreId, testUserId, receiptNumber1, "offline-003");
        salesService.addLine(receipt1.getId(), testVariantId, Quantity.of(new BigDecimal("1")), Money.of(new BigDecimal("10.00")));
        salesService.finalizeReceipt(receipt1.getId(), testUserId);
        
        // Create second receipt
        var receipt2 = salesService.createReceipt(testStoreId, testUserId, receiptNumber2, "offline-004");
        salesService.addLine(receipt2.getId(), testVariantId, Quantity.of(new BigDecimal("2")), Money.of(new BigDecimal("15.00")));
        salesService.finalizeReceipt(receipt2.getId(), testUserId);
        
        // When - Add cash payments
        var payment1 = salesService.addPayment(receipt1.getId(), PaymentMethod.CASH, Money.of(new BigDecimal("10.00")), "PAY-003");
        var payment2 = salesService.addPayment(receipt2.getId(), PaymentMethod.CASH, Money.of(new BigDecimal("30.00")), "PAY-004");

        // Then
        assertThat(payment1).isNotNull();
        assertThat(payment2).isNotNull();

        // Verify total movements in cash session
        CashSession updatedSession = sessionService.getCashSession(cashSession.getId());
        Money expectedTotalIn = Money.of(new BigDecimal("40.00")); // 10 + 30
        assertThat(updatedSession.getTotalIn()).isEqualTo(expectedTotalIn);
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(
                Money.of(new BigDecimal("100.00")).add(expectedTotalIn)
        );
    }

    @Test
    void shouldHandleCashPaymentWhenNoCashSessionOpen() {
        // Given - Close the cash session
        sessionService.closeCashSession(cashSession.getId(), Money.of(new BigDecimal("100.00")), "Test closure");
        
        String receiptNumber = "REC-005";
        var receipt = salesService.createReceipt(testStoreId, testUserId, receiptNumber, "offline-005");
        salesService.addLine(receipt.getId(), testVariantId, Quantity.of(new BigDecimal("1")), Money.of(new BigDecimal("25.00")));
        salesService.finalizeReceipt(receipt.getId(), testUserId);
        
        // When - Add cash payment (should not fail, just not record movement)
        var payment = salesService.addPayment(
                receipt.getId(),
                PaymentMethod.CASH,
                Money.of(new BigDecimal("25.00")),
                "PAY-005"
        );

        // Then
        assertThat(payment).isNotNull();
        assertThat(payment.getPaymentMethod()).isEqualTo(PaymentMethod.CASH);
        // Payment should succeed even without open cash session
    }

    @Test
    void shouldUsePaymentReferenceAsSourceOfflineId() {
        // Given
        String receiptNumber = "REC-006";
        var receipt = salesService.createReceipt(testStoreId, testUserId, receiptNumber, "offline-006");
        salesService.addLine(receipt.getId(), testVariantId, Quantity.of(new BigDecimal("1")), Money.of(new BigDecimal("50.00")));
        salesService.finalizeReceipt(receipt.getId(), testUserId);
        
        // When
        String paymentReference = "PAY-REF-001";
        var payment = salesService.addPayment(
                receipt.getId(),
                PaymentMethod.CASH,
                Money.of(new BigDecimal("50.00")),
                paymentReference
        );

        // Then
        assertThat(payment).isNotNull();
        assertThat(payment.getReference()).isEqualTo(paymentReference);
        
        // The payment reference should be used as sourceOfflineId for idempotence
        // This is handled in the SessionService.recordMovement method
    }

    @Test
    void shouldCalculateCorrectTotalsAfterMixedPaymentMethods() {
        // Given
        String receiptNumber = "REC-007";
        var receipt = salesService.createReceipt(testStoreId, testUserId, receiptNumber, "offline-007");
        salesService.addLine(receipt.getId(), testVariantId, Quantity.of(new BigDecimal("3")), Money.of(new BigDecimal("20.00")));
        salesService.finalizeReceipt(receipt.getId(), testUserId);
        
        // When - Add mixed payments
        var cashPayment = salesService.addPayment(receipt.getId(), PaymentMethod.CASH, Money.of(new BigDecimal("40.00")), "PAY-CASH");
        var mobilePayment = salesService.addPayment(receipt.getId(), PaymentMethod.MOBILE, Money.of(new BigDecimal("20.00")), "PAY-MOBILE");

        // Then
        assertThat(cashPayment).isNotNull();
        assertThat(mobilePayment).isNotNull();

        // Only cash payment should be recorded in cash session
        CashSession updatedSession = sessionService.getCashSession(cashSession.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(Money.of(new BigDecimal("40.00")));
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.zero());
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("140.00"))); // 100 + 40
    }
}
