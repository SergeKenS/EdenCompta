package com.votreentreprise.pos.sessions.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
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
class OtherSessionServiceIntegrationTest {

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
    void shouldOpenOtherSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));

        // When
        OtherSession session = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);

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
    void shouldNotOpenSecondOtherSessionForSameStore() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        sessionService.openOtherSession(testStoreId, testUserId, initialAmount);

        // When & Then
        assertThatThrownBy(() -> 
            sessionService.openOtherSession(testStoreId, "another-user", Money.of(new BigDecimal("15.00")))
        ).hasMessageContaining("Une session autre est déjà ouverte pour ce magasin");
    }

    @Test
    void shouldGetOpenOtherSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        OtherSession createdSession = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);

        // When
        OtherSession foundSession = sessionService.getOpenOtherSession(testStoreId);

        // Then
        assertThat(foundSession).isNotNull();
        assertThat(foundSession.getId()).isEqualTo(createdSession.getId());
        assertThat(foundSession.getStatus()).isEqualTo(SessionStatus.OPEN);
    }

    @Test
    void shouldReturnNullWhenNoOpenOtherSession() {
        // When
        OtherSession foundSession = sessionService.getOpenOtherSession(testStoreId);

        // Then
        assertThat(foundSession).isNull();
    }

    @Test
    void shouldCloseOtherSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        OtherSession session = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);
        Money realClosingAmount = Money.of(new BigDecimal("30.00"));
        String note = "Fermeture autre normale";

        // When
        OtherSession closedSession = sessionService.closeOtherSession(session.getId(), realClosingAmount, note);

        // Then
        assertThat(closedSession.getStatus()).isEqualTo(SessionStatus.CLOSED);
        assertThat(closedSession.getClosedAt()).isNotNull();
        assertThat(closedSession.getRealClosingAmount()).isEqualTo(realClosingAmount);
        assertThat(closedSession.getNote()).isEqualTo(note);
        assertThat(closedSession.getDiscrepancy()).isEqualTo(Money.of(new BigDecimal("5.00"))); // 30 - 25
    }

    @Test
    void shouldRecordMovementInOtherSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        OtherSession session = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);
        Money movementAmount = Money.of(new BigDecimal("12.50"));
        String reference = "OTHER-PAY-001";
        String sourceOfflineId = "other-offline-001";

        // When
        SessionMovement movement = sessionService.recordMovement(
                session.getId().toString(),
                "OTHER",
                MovementType.IN,
                MovementReason.SALE,
                movementAmount,
                reference,
                "OTHER_PAYMENT",
                testUserId,
                sourceOfflineId
        );

        // Then
        assertThat(movement).isNotNull();
        assertThat(movement.getId()).isNotNull();
        assertThat(movement.getSessionId()).isEqualTo(session.getId().toString());
        assertThat(movement.getSessionType()).isEqualTo("OTHER");
        assertThat(movement.getType()).isEqualTo(MovementType.IN);
        assertThat(movement.getReason()).isEqualTo(MovementReason.SALE);
        assertThat(movement.getAmount()).isEqualTo(movementAmount);
        assertThat(movement.getReference()).isEqualTo(reference);
        assertThat(movement.getReferenceType()).isEqualTo("OTHER_PAYMENT");
        assertThat(movement.getCreatedBy()).isEqualTo(testUserId);
        assertThat(movement.getSourceOfflineId()).isEqualTo(sourceOfflineId);
        assertThat(movement.getOccurredAt()).isNotNull();

        // Verify session totals are updated
        OtherSession updatedSession = sessionService.getOtherSession(session.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(movementAmount);
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.zero());
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(initialAmount.add(movementAmount));
    }

    @Test
    void shouldRecordMultipleMovementsInOtherSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        OtherSession session = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);

        // When
        sessionService.recordMovement(
                session.getId().toString(),
                "OTHER",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("10.00")),
                "OTHER-PAY-001",
                "OTHER_PAYMENT",
                testUserId,
                "other-offline-001"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "OTHER",
                MovementType.OUT,
                MovementReason.EXPENSE,
                Money.of(new BigDecimal("3.00")),
                "OTHER-EXPENSE-001",
                "OTHER_EXPENSE",
                testUserId,
                "other-offline-002"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "OTHER",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("8.00")),
                "OTHER-PAY-002",
                "OTHER_PAYMENT",
                testUserId,
                "other-offline-003"
        );

        // Then
        OtherSession updatedSession = sessionService.getOtherSession(session.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(Money.of(new BigDecimal("18.00"))); // 10 + 8
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.of(new BigDecimal("3.00")));
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("40.00"))); // 25 + 18 - 3
    }

    @Test
    void shouldGetOtherSessionsByStore() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        OtherSession session1 = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);
        sessionService.closeOtherSession(session1.getId(), Money.of(new BigDecimal("28.00")), "Note 1");
        
        OtherSession session2 = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);

        // When
        List<OtherSession> sessions = sessionService.getOtherSessionsByStore(testStoreId);

        // Then
        assertThat(sessions).hasSize(2);
        assertThat(sessions).extracting("id").contains(session1.getId(), session2.getId());
    }

    @Test
    void shouldCalculateExpectedAmountCorrectly() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("25.00"));
        OtherSession session = sessionService.openOtherSession(testStoreId, testUserId, initialAmount);

        // When
        sessionService.recordMovement(
                session.getId().toString(),
                "OTHER",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("15.00")),
                "OTHER-PAY-001",
                "OTHER_PAYMENT",
                testUserId,
                "other-offline-001"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "OTHER",
                MovementType.OUT,
                MovementReason.EXPENSE,
                Money.of(new BigDecimal("7.50")),
                "OTHER-EXPENSE-001",
                "OTHER_EXPENSE",
                testUserId,
                "other-offline-002"
        );

        // Then
        OtherSession updatedSession = sessionService.getOtherSession(session.getId());
        Money expectedAmount = initialAmount
                .add(Money.of(new BigDecimal("15.00")))
                .subtract(Money.of(new BigDecimal("7.50")));
        
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(expectedAmount);
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("32.50")));
    }
}

