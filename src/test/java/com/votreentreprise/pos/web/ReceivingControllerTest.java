package com.votreentreprise.pos.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.receiving.service.ReceivingService;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.inventory.repository.ProductRepository;
import com.votreentreprise.pos.inventory.repository.ProductVariantRepository;
import com.votreentreprise.pos.inventory.domain.Product;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.UUID;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ActiveProfiles("test")
class ReceivingControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ReceivingService receivingService;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductVariantRepository productVariantRepository;

    private UUID testStoreId;
    private UUID testVariantId;

    @BeforeEach
    void setUp() {
        // Créer un magasin de test
        Store store = new Store();
        store.setName("Magasin Test");
        store.setAddress("123 Rue Test");
        store.setPhone("514-123-4567");
        store = storeRepository.save(store);
        testStoreId = store.getId();

        // Utiliser TestDataBuilder pour créer le produit et la variante
        // (À adapter selon votre TestDataBuilder)
        testVariantId = UUID.randomUUID(); // Temporaire

        // TODO: Remplacer par la vraie création avec vos entités
        // Une fois que vous montrez Product.java et ProductVariant.java
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