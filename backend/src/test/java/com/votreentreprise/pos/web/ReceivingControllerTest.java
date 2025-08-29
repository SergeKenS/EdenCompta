package com.votreentreprise.pos.web;
import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.receiving.service.ReceivingService;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;

import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.context.support.WithMockUser;

import java.math.BigDecimal;
import java.util.UUID;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@Transactional
@ActiveProfiles("test")
@Import(TestSecurityConfig.class)
@WithMockUser(username = "test", authorities = {"INVENTORY.RECEIVE"})
class ReceivingControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ReceivingService receivingService;

    // Repository non utilisé directement depuis que les IDs sont semés
    // private StoreRepository storeRepository;

    private UUID testStoreId;
    private UUID testVariantId;

    @BeforeEach
    void setUp() {
        // Utiliser les données semées par sample-data.sql
        testStoreId = com.votreentreprise.pos.utils.TestDataBuilder.TEST_STORE_ID;
        testVariantId = com.votreentreprise.pos.utils.TestDataBuilder.TEST_VARIANT_A1_ID;
    }

    @Test
    void shouldCreateReceipt() throws Exception {
        mockMvc.perform(post("/api/receiving/receipts")
                        .param("storeId", testStoreId.toString())
                        .param("createdBy", "admin"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.storeId").value(testStoreId.toString()))
                .andExpect(jsonPath("$.createdBy").value("admin"))
                .andExpect(jsonPath("$.status").value("DRAFT"));
    }

    @Test
    void shouldAddLineToReceipt() throws Exception {
        // Given - Créer une réception d'abord
        GoodsReceipt receipt = receivingService.createReceipt(testStoreId, "admin", null);

        // When & Then
        mockMvc.perform(post("/api/receiving/receipts/{receiptId}/lines", receipt.getId())
                        .param("variantId", testVariantId.toString())
                        .param("quantityReceived", "10.0")
                        .param("unitCost", "5.50")
                        .param("batchNumber", "BATCH-001")
                        .param("notes", "Test notes"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.variantId").value(testVariantId.toString()))
                .andExpect(jsonPath("$.batchNumber").value("BATCH-001"))
                .andExpect(jsonPath("$.notes").value("Test notes"));
    }

    @Test
    void shouldFinalizeReceipt() throws Exception {
        // Given - Créer une réception avec une ligne
        GoodsReceipt receipt = receivingService.createReceipt(testStoreId, "admin", null);
        receivingService.addLineToReceipt(
                receipt.getId(),
                testVariantId,
                Quantity.of(new BigDecimal("10.0")),
                Money.of(new BigDecimal("5.50")),
                "BATCH-001",
                "Test notes"
        );

        // When & Then
        mockMvc.perform(post("/api/receiving/receipts/{receiptId}/finalize", receipt.getId())
                        .param("finalizedBy", "admin"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("RECEIVED"));
    }

    @Test
    void shouldGetReceipt() throws Exception {
        // Given
        GoodsReceipt receipt = receivingService.createReceipt(testStoreId, "admin", null);

        // When & Then
        mockMvc.perform(get("/api/receiving/receipts/{receiptId}", receipt.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(receipt.getId().toString()))
                .andExpect(jsonPath("$.createdBy").value("admin"));
    }

    @Test
    void shouldGetReceiptsList() throws Exception {
        // Given - Créer quelques réceptions
        receivingService.createReceipt(testStoreId, "admin", null);
        receivingService.createReceipt(testStoreId, "admin", null);

        // When & Then
        mockMvc.perform(get("/api/receiving/receipts")
                        .param("storeId", testStoreId.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(2));
    }

    @Test
    void shouldRemoveLine() throws Exception {
        // Given - Créer une réception avec une ligne
        GoodsReceipt receipt = receivingService.createReceipt(testStoreId, "admin", null);
        GoodsReceiptLine line = receivingService.addLineToReceipt(
                receipt.getId(),
                testVariantId,
                Quantity.of(new BigDecimal("10.0")),
                Money.of(new BigDecimal("5.50")),
                "BATCH-001",
                "Test notes"
        );

        // When & Then
        mockMvc.perform(delete("/api/receiving/receipts/{receiptId}/lines/{lineId}",
                        receipt.getId(), line.getId()))
                .andExpect(status().isNoContent());
    }

    @Test
    void shouldUpdateLine() throws Exception {
        // Given - Créer une réception avec une ligne
        GoodsReceipt receipt = receivingService.createReceipt(testStoreId, "admin", null);
        GoodsReceiptLine line = receivingService.addLineToReceipt(
                receipt.getId(),
                testVariantId,
                Quantity.of(new BigDecimal("10.0")),
                Money.of(new BigDecimal("5.50")),
                "BATCH-001",
                "Test notes"
        );

        // When & Then
        mockMvc.perform(put("/api/receiving/lines/{lineId}", line.getId())
                        .param("quantityReceived", "15.0")
                        .param("unitCost", "6.00")
                        .param("notes", "Updated notes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(line.getId().toString()));
    }
}