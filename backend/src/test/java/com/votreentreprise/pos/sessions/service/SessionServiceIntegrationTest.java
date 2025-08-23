package com.votreentreprise.pos.sessions.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.store.domain.Store;
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
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class SessionServiceIntegrationTest {

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
    void shouldOpenCashSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));

        // When
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // Then
        assertThat(session).isNotNull();
        assertThat(session.getId()).isNotNull();
        assertThat(session.getStore().getId()).isEqualTo(testStoreId);
        assertThat(session.getUserId()).isEqualTo(testUserId);
        assertThat(session.getInitialAmount()).isEqualTo(initialAmount);
        assertThat(session.getStatus()).isEqualTo(SessionStatus.OPEN);
        assertThat(session.getOpenedAt()).isNotNull();
        assertThat(session.getClosedAt()).isNull();
        assertThat(session.getTotalIn()).isEqualTo(Money.zero());
        assertThat(session.getTotalOut()).isEqualTo(Money.zero());
    }

    @Test
    void shouldNotOpenSecondCashSessionForSameStore() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // When & Then
        assertThatThrownBy(() -> 
            sessionService.openCashSession(testStoreId, "another-user", Money.of(new BigDecimal("50.00")))
        ).hasMessageContaining("Une session espèces est déjà ouverte pour ce magasin");
    }

    @Test
    void shouldGetOpenCashSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession createdSession = sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // When
        CashSession foundSession = sessionService.getOpenCashSession(testStoreId);

        // Then
        assertThat(foundSession).isNotNull();
        assertThat(foundSession.getId()).isEqualTo(createdSession.getId());
        assertThat(foundSession.getStatus()).isEqualTo(SessionStatus.OPEN);
    }

    @Test
    void shouldReturnNullWhenNoOpenCashSession() {
        // When
        CashSession foundSession = sessionService.getOpenCashSession(testStoreId);

        // Then
        assertThat(foundSession).isNull();
    }

    @Test
    void shouldCloseCashSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, initialAmount);
        Money realClosingAmount = Money.of(new BigDecimal("150.00"));
        String note = "Fermeture normale";

        // When
        CashSession closedSession = sessionService.closeCashSession(session.getId(), realClosingAmount, note);

        // Then
        assertThat(closedSession.getStatus()).isEqualTo(SessionStatus.CLOSED);
        assertThat(closedSession.getClosedAt()).isNotNull();
        assertThat(closedSession.getRealClosingAmount()).isEqualTo(realClosingAmount);
        assertThat(closedSession.getNote()).isEqualTo(note);
        assertThat(closedSession.getDiscrepancy()).isEqualTo(Money.of(new BigDecimal("50.00"))); // 150 - 100
    }

    @Test
    void shouldRecordMovementInCashSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, initialAmount);
        Money movementAmount = Money.of(new BigDecimal("25.50"));
        String reference = "RECEIPT-001";
        String sourceOfflineId = "offline-001";

        // When
        SessionMovement movement = sessionService.recordMovement(
                session.getId().toString(),
                "CASH",
                MovementType.IN,
                MovementReason.SALE,
                movementAmount,
                reference,
                "RECEIPT_PAYMENT",
                testUserId,
                sourceOfflineId
        );

        // Then
        assertThat(movement).isNotNull();
        assertThat(movement.getId()).isNotNull();
        assertThat(movement.getSessionId()).isEqualTo(session.getId().toString());
        assertThat(movement.getSessionType()).isEqualTo("CASH");
        assertThat(movement.getType()).isEqualTo(MovementType.IN);
        assertThat(movement.getReason()).isEqualTo(MovementReason.SALE);
        assertThat(movement.getAmount()).isEqualTo(movementAmount);
        assertThat(movement.getReference()).isEqualTo(reference);
        assertThat(movement.getReferenceType()).isEqualTo("RECEIPT_PAYMENT");
        assertThat(movement.getCreatedBy()).isEqualTo(testUserId);
        assertThat(movement.getSourceOfflineId()).isEqualTo(sourceOfflineId);
        assertThat(movement.getOccurredAt()).isNotNull();

        // Verify session totals are updated
        CashSession updatedSession = sessionService.getCashSession(session.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(movementAmount);
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.zero());
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(initialAmount.add(movementAmount));
    }

    @Test
    void shouldRecordMultipleMovementsInCashSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // When
        sessionService.recordMovement(
                session.getId().toString(),
                "CASH",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("25.00")),
                "RECEIPT-001",
                "RECEIPT_PAYMENT",
                testUserId,
                "offline-001"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "CASH",
                MovementType.OUT,
                MovementReason.EXPENSE,
                Money.of(new BigDecimal("10.00")),
                "EXPENSE-001",
                "EXPENSE",
                testUserId,
                "offline-002"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "CASH",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("15.00")),
                "RECEIPT-002",
                "RECEIPT_PAYMENT",
                testUserId,
                "offline-003"
        );

        // Then
        CashSession updatedSession = sessionService.getCashSession(session.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(Money.of(new BigDecimal("40.00"))); // 25 + 15
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.of(new BigDecimal("10.00")));
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("130.00"))); // 100 + 40 - 10
    }

    @Test
    void shouldGetCashSessionsByStore() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession session1 = sessionService.openCashSession(testStoreId, testUserId, initialAmount);
        sessionService.closeCashSession(session1.getId(), Money.of(new BigDecimal("120.00")), "Note 1");
        
        CashSession session2 = sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // When
        List<CashSession> sessions = sessionService.getCashSessionsByStore(testStoreId);

        // Then
        assertThat(sessions).hasSize(2);
        assertThat(sessions).extracting("id").contains(session1.getId(), session2.getId());
    }

    @Test
    void shouldThrowExceptionForInvalidSessionType() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // When & Then
        assertThatThrownBy(() -> 
            sessionService.recordMovement(
                    session.getId().toString(),
                    "INVALID_TYPE",
                    MovementType.IN,
                    MovementReason.SALE,
                    Money.of(new BigDecimal("25.00")),
                    "REF-001",
                    "TYPE",
                    testUserId,
                    "offline-001"
            )
        ).hasMessageContaining("Type de session invalide");
    }

    @Test
    void shouldCalculateExpectedAmountCorrectly() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("100.00"));
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, initialAmount);

        // When
        sessionService.recordMovement(
                session.getId().toString(),
                "CASH",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("50.00")),
                "RECEIPT-001",
                "RECEIPT_PAYMENT",
                testUserId,
                "offline-001"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "CASH",
                MovementType.OUT,
                MovementReason.EXPENSE,
                Money.of(new BigDecimal("20.00")),
                "EXPENSE-001",
                "EXPENSE",
                testUserId,
                "offline-002"
        );

        // Then
        CashSession updatedSession = sessionService.getCashSession(session.getId());
        Money expectedAmount = initialAmount
                .add(Money.of(new BigDecimal("50.00")))
                .subtract(Money.of(new BigDecimal("20.00")));
        
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(expectedAmount);
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("130.00")));
    }
}
