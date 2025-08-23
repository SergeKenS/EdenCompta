package com.votreentreprise.pos.sessions.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class MultiSessionIntegrationTest {

    @Autowired
    private SessionService sessionService;

    private UUID testStoreId;
    private String testUserId;

    @BeforeEach
    void setUp() {
        testStoreId = TestDataBuilder.TEST_STORE_ID;
        testUserId = "test-user";
    }

    @Test
    void shouldOpenAllThreeSessionTypesSimultaneously() {
        // Given & When
        CashSession cashSession = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        MobileSession mobileSession = sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));
        OtherSession otherSession = sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("25.00")));

        // Then
        assertThat(cashSession).isNotNull();
        assertThat(mobileSession).isNotNull();
        assertThat(otherSession).isNotNull();
        assertThat(cashSession.getStatus().name()).isEqualTo("OPEN");
        assertThat(mobileSession.getStatus().name()).isEqualTo("OPEN");
        assertThat(otherSession.getStatus().name()).isEqualTo("OPEN");
    }

    @Test
    void shouldRecordMovementsInAllSessionTypes() {
        // Given - Open all sessions
        CashSession cashSession = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        MobileSession mobileSession = sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));
        OtherSession otherSession = sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("25.00")));

        // When - Record movements in each session
        sessionService.recordMovement(
                cashSession.getId().toString(),
                "CASH",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("25.00")),
                "CASH-SALE-001",
                "CASH_SALE",
                testUserId,
                "cash-offline-001"
        );

        sessionService.recordMovement(
                mobileSession.getId().toString(),
                "MOBILE",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("15.00")),
                "MOBILE-SALE-001",
                "MOBILE_SALE",
                testUserId,
                "mobile-offline-001"
        );

        sessionService.recordMovement(
                otherSession.getId().toString(),
                "OTHER",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("10.00")),
                "OTHER-SALE-001",
                "OTHER_SALE",
                testUserId,
                "other-offline-001"
        );

        // Then - Verify each session has correct totals
        CashSession updatedCash = sessionService.getCashSession(cashSession.getId());
        MobileSession updatedMobile = sessionService.getMobileSession(mobileSession.getId());
        OtherSession updatedOther = sessionService.getOtherSession(otherSession.getId());

        assertThat(updatedCash.getTotalIn()).isEqualTo(Money.of(new BigDecimal("25.00")));
        assertThat(updatedCash.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("125.00"))); // 100 + 25

        assertThat(updatedMobile.getTotalIn()).isEqualTo(Money.of(new BigDecimal("15.00")));
        assertThat(updatedMobile.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("65.00"))); // 50 + 15

        assertThat(updatedOther.getTotalIn()).isEqualTo(Money.of(new BigDecimal("10.00")));
        assertThat(updatedOther.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("35.00"))); // 25 + 10
    }

    @Test
    void shouldCloseAllSessionsAndCalculateDiscrepancies() {
        // Given - Open and add movements to all sessions
        CashSession cashSession = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        MobileSession mobileSession = sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));
        OtherSession otherSession = sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("25.00")));

        // Add some movements
        sessionService.recordMovement(
                cashSession.getId().toString(),
                "CASH",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("30.00")),
                "CASH-SALE-001",
                "CASH_SALE",
                testUserId,
                "cash-offline-001"
        );

        sessionService.recordMovement(
                mobileSession.getId().toString(),
                "MOBILE",
                MovementType.OUT,
                MovementReason.REFUND,
                Money.of(new BigDecimal("5.00")),
                "MOBILE-REFUND-001",
                "MOBILE_REFUND",
                testUserId,
                "mobile-offline-001"
        );

        // When - Close all sessions
        CashSession closedCash = sessionService.closeCashSession(
                cashSession.getId(), 
                Money.of(new BigDecimal("135.00")), 
                "Fermeture cash"
        );
        
        MobileSession closedMobile = sessionService.closeMobileSession(
                mobileSession.getId(), 
                Money.of(new BigDecimal("42.00")), 
                "Fermeture mobile"
        );
        
        OtherSession closedOther = sessionService.closeOtherSession(
                otherSession.getId(), 
                Money.of(new BigDecimal("25.00")), 
                "Fermeture other"
        );

        // Then - Verify discrepancies
        // Cash: Expected = 100 + 30 = 130, Real = 135, Discrepancy = 135 - 130 = 5
        assertThat(closedCash.getDiscrepancy()).isEqualTo(Money.of(new BigDecimal("5.00")));
        
        // Mobile: Expected = 50 - 5 = 45, Real = 42, Discrepancy = 42 - 45 = -3
        assertThat(closedMobile.getDiscrepancy()).isEqualTo(Money.of(new BigDecimal("-3.00")));
        
        // Other: Expected = 25, Real = 25, Discrepancy = 25 - 25 = 0
        assertThat(closedOther.getDiscrepancy()).isEqualTo(Money.of(new BigDecimal("0.00")));
    }

    @Test
    void shouldGetAllSessionsByStore() {
        // Given - Create multiple sessions of each type
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));
        sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("25.00")));

        // When
        var cashSessions = sessionService.getCashSessionsByStore(testStoreId);
        var mobileSessions = sessionService.getMobileSessionsByStore(testStoreId);
        var otherSessions = sessionService.getOtherSessionsByStore(testStoreId);

        // Then
        assertThat(cashSessions).hasSize(1);
        assertThat(mobileSessions).hasSize(1);
        assertThat(otherSessions).hasSize(1);
        
        assertThat(cashSessions.get(0).getStatus().name()).isEqualTo("OPEN");
        assertThat(mobileSessions.get(0).getStatus().name()).isEqualTo("OPEN");
        assertThat(otherSessions.get(0).getStatus().name()).isEqualTo("OPEN");
    }
}

