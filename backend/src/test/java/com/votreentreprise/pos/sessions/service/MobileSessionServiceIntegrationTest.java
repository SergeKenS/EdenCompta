package com.votreentreprise.pos.sessions.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.MobileSession;
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
class MobileSessionServiceIntegrationTest {

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
    void shouldOpenMobileSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));

        // When
        MobileSession session = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);

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
    void shouldNotOpenSecondMobileSessionForSameStore() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        sessionService.openMobileSession(testStoreId, testUserId, initialAmount);

        // When & Then
        assertThatThrownBy(() -> 
            sessionService.openMobileSession(testStoreId, "another-user", Money.of(new BigDecimal("25.00")))
        ).hasMessageContaining("Une session mobile est déjà ouverte pour ce magasin");
    }

    @Test
    void shouldGetOpenMobileSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        MobileSession createdSession = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);

        // When
        MobileSession foundSession = sessionService.getOpenMobileSession(testStoreId);

        // Then
        assertThat(foundSession).isNotNull();
        assertThat(foundSession.getId()).isEqualTo(createdSession.getId());
        assertThat(foundSession.getStatus()).isEqualTo(SessionStatus.OPEN);
    }

    @Test
    void shouldReturnNullWhenNoOpenMobileSession() {
        // When
        MobileSession foundSession = sessionService.getOpenMobileSession(testStoreId);

        // Then
        assertThat(foundSession).isNull();
    }

    @Test
    void shouldCloseMobileSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        MobileSession session = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);
        Money realClosingAmount = Money.of(new BigDecimal("75.00"));
        String note = "Fermeture mobile normale";

        // When
        MobileSession closedSession = sessionService.closeMobileSession(session.getId(), realClosingAmount, note);

        // Then
        assertThat(closedSession.getStatus()).isEqualTo(SessionStatus.CLOSED);
        assertThat(closedSession.getClosedAt()).isNotNull();
        assertThat(closedSession.getRealClosingAmount()).isEqualTo(realClosingAmount);
        assertThat(closedSession.getNote()).isEqualTo(note);
        assertThat(closedSession.getDiscrepancy()).isEqualTo(Money.of(new BigDecimal("25.00"))); // 75 - 50
    }

    @Test
    void shouldRecordMovementInMobileSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        MobileSession session = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);
        Money movementAmount = Money.of(new BigDecimal("15.25"));
        String reference = "MOBILE-PAY-001";
        String sourceOfflineId = "mobile-offline-001";

        // When
        SessionMovement movement = sessionService.recordMovement(
                session.getId().toString(),
                "MOBILE",
                MovementType.IN,
                MovementReason.SALE,
                movementAmount,
                reference,
                "MOBILE_PAYMENT",
                testUserId,
                sourceOfflineId
        );

        // Then
        assertThat(movement).isNotNull();
        assertThat(movement.getId()).isNotNull();
        assertThat(movement.getSessionId()).isEqualTo(session.getId().toString());
        assertThat(movement.getSessionType()).isEqualTo("MOBILE");
        assertThat(movement.getType()).isEqualTo(MovementType.IN);
        assertThat(movement.getReason()).isEqualTo(MovementReason.SALE);
        assertThat(movement.getAmount()).isEqualTo(movementAmount);
        assertThat(movement.getReference()).isEqualTo(reference);
        assertThat(movement.getReferenceType()).isEqualTo("MOBILE_PAYMENT");
        assertThat(movement.getCreatedBy()).isEqualTo(testUserId);
        assertThat(movement.getSourceOfflineId()).isEqualTo(sourceOfflineId);
        assertThat(movement.getOccurredAt()).isNotNull();

        // Verify session totals are updated
        MobileSession updatedSession = sessionService.getMobileSession(session.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(movementAmount);
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.zero());
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(initialAmount.add(movementAmount));
    }

    @Test
    void shouldRecordMultipleMovementsInMobileSession() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        MobileSession session = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);

        // When
        sessionService.recordMovement(
                session.getId().toString(),
                "MOBILE",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("20.00")),
                "MOBILE-PAY-001",
                "MOBILE_PAYMENT",
                testUserId,
                "mobile-offline-001"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "MOBILE",
                MovementType.OUT,
                MovementReason.REFUND,
                Money.of(new BigDecimal("5.00")),
                "MOBILE-REFUND-001",
                "MOBILE_REFUND",
                testUserId,
                "mobile-offline-002"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "MOBILE",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("10.00")),
                "MOBILE-PAY-002",
                "MOBILE_PAYMENT",
                testUserId,
                "mobile-offline-003"
        );

        // Then
        MobileSession updatedSession = sessionService.getMobileSession(session.getId());
        assertThat(updatedSession.getTotalIn()).isEqualTo(Money.of(new BigDecimal("30.00"))); // 20 + 10
        assertThat(updatedSession.getTotalOut()).isEqualTo(Money.of(new BigDecimal("5.00")));
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("75.00"))); // 50 + 30 - 5
    }

    @Test
    void shouldGetMobileSessionsByStore() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        MobileSession session1 = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);
        sessionService.closeMobileSession(session1.getId(), Money.of(new BigDecimal("60.00")), "Note 1");
        
        MobileSession session2 = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);

        // When
        List<MobileSession> sessions = sessionService.getMobileSessionsByStore(testStoreId);

        // Then
        assertThat(sessions).hasSize(2);
        assertThat(sessions).extracting("id").contains(session1.getId(), session2.getId());
    }

    @Test
    void shouldCalculateExpectedAmountCorrectly() {
        // Given
        Money initialAmount = Money.of(new BigDecimal("50.00"));
        MobileSession session = sessionService.openMobileSession(testStoreId, testUserId, initialAmount);

        // When
        sessionService.recordMovement(
                session.getId().toString(),
                "MOBILE",
                MovementType.IN,
                MovementReason.SALE,
                Money.of(new BigDecimal("25.00")),
                "MOBILE-PAY-001",
                "MOBILE_PAYMENT",
                testUserId,
                "mobile-offline-001"
        );

        sessionService.recordMovement(
                session.getId().toString(),
                "MOBILE",
                MovementType.OUT,
                MovementReason.REFUND,
                Money.of(new BigDecimal("10.00")),
                "MOBILE-REFUND-001",
                "MOBILE_REFUND",
                testUserId,
                "mobile-offline-002"
        );

        // Then
        MobileSession updatedSession = sessionService.getMobileSession(session.getId());
        Money expectedAmount = initialAmount
                .add(Money.of(new BigDecimal("25.00")))
                .subtract(Money.of(new BigDecimal("10.00")));
        
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(expectedAmount);
        assertThat(updatedSession.getExpectedAmount()).isEqualTo(Money.of(new BigDecimal("65.00")));
    }
}

