package com.votreentreprise.pos.sessions.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.UUID;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@Transactional
@ActiveProfiles("test")
class SessionControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

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
    void shouldOpenCashSession() throws Exception {
        // Given
        String requestBody = """
            {
                "storeId": "%s",
                "userId": "%s",
                "initialAmount": 100.00
            }
            """.formatted(testStoreId, testUserId);

        // When & Then
        mockMvc.perform(post("/api/sessions/cash/open")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.storeId").value(testStoreId.toString()))
                .andExpect(jsonPath("$.userId").value(testUserId))
                .andExpect(jsonPath("$.initialAmount").value(100.00))
                .andExpect(jsonPath("$.status").value("OPEN"))
                .andExpect(jsonPath("$.openedAt").exists())
                .andExpect(jsonPath("$.closedAt").doesNotExist())
                .andExpect(jsonPath("$.totalIn").value(0.00))
                .andExpect(jsonPath("$.totalOut").value(0.00));
    }

    @Test
    void shouldNotOpenSecondCashSessionForSameStore() throws Exception {
        // Given - Open first session
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));

        String requestBody = """
            {
                "storeId": "%s",
                "userId": "another-user",
                "initialAmount": 50.00
            }
            """.formatted(testStoreId);

        // When & Then
        mockMvc.perform(post("/api/sessions/cash/open")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Une session espèces est déjà ouverte pour ce magasin"));
    }

    @Test
    void shouldCloseCashSession() throws Exception {
        // Given
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        
        String requestBody = """
            {
                "realClosingAmount": 150.00,
                "note": "Fermeture normale"
            }
            """;

        // When & Then
        mockMvc.perform(post("/api/sessions/cash/{sessionId}/close", session.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(session.getId().toString()))
                .andExpect(jsonPath("$.status").value("CLOSED"))
                .andExpect(jsonPath("$.closedAt").exists())
                .andExpect(jsonPath("$.realClosingAmount").value(150.00))
                .andExpect(jsonPath("$.note").value("Fermeture normale"))
                .andExpect(jsonPath("$.discrepancy").value(50.00));
    }

    @Test
    void shouldGetOpenCashSession() throws Exception {
        // Given
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));

        // When & Then
        mockMvc.perform(get("/api/sessions/cash/open")
                        .param("storeId", testStoreId.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(session.getId().toString()))
                .andExpect(jsonPath("$.storeId").value(testStoreId.toString()))
                .andExpect(jsonPath("$.status").value("OPEN"));
    }

    @Test
    void shouldReturnNotFoundWhenNoOpenCashSession() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/sessions/cash/open")
                        .param("storeId", testStoreId.toString()))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Aucune session espèces ouverte trouvée"));
    }

    @Test
    void shouldRecordMovement() throws Exception {
        // Given
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        
        String requestBody = """
            {
                "type": "IN",
                "reason": "SALE",
                "amount": 25.50,
                "reference": "RECEIPT-001",
                "referenceType": "RECEIPT_PAYMENT",
                "createdBy": "%s",
                "sourceOfflineId": "offline-001"
            }
            """.formatted(testUserId);

        // When & Then
        mockMvc.perform(post("/api/sessions/cash/{sessionId}/movements", session.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.sessionId").value(session.getId().toString()))
                .andExpect(jsonPath("$.sessionType").value("CASH"))
                .andExpect(jsonPath("$.type").value("IN"))
                .andExpect(jsonPath("$.reason").value("SALE"))
                .andExpect(jsonPath("$.amount").value(25.50))
                .andExpect(jsonPath("$.reference").value("RECEIPT-001"))
                .andExpect(jsonPath("$.referenceType").value("RECEIPT_PAYMENT"))
                .andExpect(jsonPath("$.createdBy").value(testUserId))
                .andExpect(jsonPath("$.sourceOfflineId").value("offline-001"))
                .andExpect(jsonPath("$.occurredAt").exists());
    }

    @Test
    void shouldGetCashSessionsByStore() throws Exception {
        // Given
        CashSession session1 = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        sessionService.closeCashSession(session1.getId(), Money.of(new BigDecimal("120.00")), "Note 1");
        
        CashSession session2 = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));

        // When & Then
        mockMvc.perform(get("/api/sessions/cash")
                        .param("storeId", testStoreId.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(session1.getId().toString()))
                .andExpect(jsonPath("$[0].status").value("CLOSED"))
                .andExpect(jsonPath("$[1].id").value(session2.getId().toString()))
                .andExpect(jsonPath("$[1].status").value("OPEN"));
    }

    @Test
    void shouldGetSessionById() throws Exception {
        // Given
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));

        // When & Then
        mockMvc.perform(get("/api/sessions/cash/{sessionId}", session.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(session.getId().toString()))
                .andExpect(jsonPath("$.storeId").value(testStoreId.toString()))
                .andExpect(jsonPath("$.userId").value(testUserId))
                .andExpect(jsonPath("$.initialAmount").value(100.00))
                .andExpect(jsonPath("$.status").value("OPEN"));
    }

    @Test
    void shouldReturnNotFoundForInvalidSessionId() throws Exception {
        // Given
        UUID invalidId = UUID.randomUUID();

        // When & Then
        mockMvc.perform(get("/api/sessions/cash/{sessionId}", invalidId))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Session espèces non trouvée: " + invalidId));
    }

    @Test
    void shouldGetMovementsBySession() throws Exception {
        // Given
        CashSession session = sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        
        // Record some movements
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

        // When & Then
        mockMvc.perform(get("/api/sessions/cash/{sessionId}/movements", session.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].type").value("IN"))
                .andExpect(jsonPath("$[0].amount").value(25.00))
                .andExpect(jsonPath("$[0].reference").value("RECEIPT-001"))
                .andExpect(jsonPath("$[1].type").value("OUT"))
                .andExpect(jsonPath("$[1].amount").value(10.00))
                .andExpect(jsonPath("$[1].reference").value("EXPENSE-001"));
    }
}
