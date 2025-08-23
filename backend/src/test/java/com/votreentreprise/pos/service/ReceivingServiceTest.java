package com.votreentreprise.pos.service;

import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.ReceiptStatusType;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import com.votreentreprise.pos.inventory.repository.ProductVariantRepository;
import com.votreentreprise.pos.inventory.service.InventoryService;
import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.receiving.repository.GoodsReceiptLineRepository;
import com.votreentreprise.pos.receiving.repository.GoodsReceiptRepository;
import com.votreentreprise.pos.receiving.service.ReceivingServiceImpl;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ReceivingServiceTest {

    @Mock
    private GoodsReceiptRepository goodsReceiptRepository;

    @Mock
    private GoodsReceiptLineRepository goodsReceiptLineRepository;

    @Mock
    private StoreRepository storeRepository;

    @Mock
    private ProductVariantRepository productVariantRepository;

    @Mock
    private InventoryService inventoryService;

    private ReceivingServiceImpl receivingService;

    private Store testStore;
    private ProductVariant testVariant;

    @BeforeEach
    void setUp() {
        receivingService = new ReceivingServiceImpl(
                goodsReceiptRepository,
                goodsReceiptLineRepository,
                storeRepository,
                productVariantRepository,
                inventoryService
        );

        testStore = TestDataBuilder.createTestStore();
        testVariant = TestDataBuilder.createTestVariant(null, "Test Variant", "SKU-001");
        testVariant.setId(TestDataBuilder.TEST_VARIANT_A1_ID);
    }

    @Test
    void shouldCreateReceipt() {
        // Given
        UUID storeId = TestDataBuilder.TEST_STORE_ID;
        String createdBy = "admin";

        when(storeRepository.findById(storeId)).thenReturn(Optional.of(testStore));
        when(goodsReceiptRepository.save(any(GoodsReceipt.class))).thenAnswer(invocation -> {
            GoodsReceipt receipt = invocation.getArgument(0);
            receipt.setId(UUID.randomUUID());
            return receipt;
        });

        // When
        GoodsReceipt result = receivingService.createReceipt(storeId, createdBy, null);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getStore()).isEqualTo(testStore);
        assertThat(result.getCreatedBy()).isEqualTo(createdBy);
        assertThat(result.getStatus()).isEqualTo(ReceiptStatusType.DRAFT);

        verify(storeRepository).findById(storeId);
        verify(goodsReceiptRepository).save(any(GoodsReceipt.class));
    }

    @Test
    void shouldThrowExceptionWhenStoreNotFound() {
        // Given
        UUID storeId = UUID.randomUUID();
        when(storeRepository.findById(storeId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> receivingService.createReceipt(storeId, "admin", null))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Magasin non trouvé");
    }

    @Test
    void shouldCreateReceiptWithIdempotence() {
        // Given
        String sourceOfflineId = "OFFLINE-001";
        GoodsReceipt existingReceipt = TestDataBuilder.createTestReceipt(testStore, "admin");

        when(goodsReceiptRepository.findBySourceOfflineId(sourceOfflineId))
                .thenReturn(Optional.of(existingReceipt));

        // When
        GoodsReceipt result = receivingService.createReceipt(
                TestDataBuilder.TEST_STORE_ID, "admin", sourceOfflineId);

        // Then
        assertThat(result).isEqualTo(existingReceipt);
        verify(goodsReceiptRepository).findBySourceOfflineId(sourceOfflineId);
        verify(storeRepository, never()).findById(any());
        verify(goodsReceiptRepository, never()).save(any());
    }

    @Test
    void shouldAddLineToReceipt() {
        // Given
        UUID receiptId = UUID.randomUUID();
        GoodsReceipt receipt = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt.setId(receiptId);
        receipt.setLines(new ArrayList<>());

        when(goodsReceiptRepository.findById(receiptId)).thenReturn(Optional.of(receipt));
        when(productVariantRepository.findById(TestDataBuilder.TEST_VARIANT_A1_ID))
                .thenReturn(Optional.of(testVariant));
        when(goodsReceiptLineRepository.save(any(GoodsReceiptLine.class))).thenAnswer(invocation -> {
            GoodsReceiptLine line = invocation.getArgument(0);
            line.setId(UUID.randomUUID());
            return line;
        });

        // When
        GoodsReceiptLine result = receivingService.addLineToReceipt(
                receiptId,
                TestDataBuilder.TEST_VARIANT_A1_ID,
                TestDataBuilder.quantity(10.0),
                TestDataBuilder.money(5.50),
                "BATCH-001",
                "Notes de test"
        );

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getQuantityReceived()).isEqualTo(TestDataBuilder.quantity(10.0));
        assertThat(result.getUnitCostEffective()).isEqualTo(TestDataBuilder.money(5.50));
        assertThat(result.getBatchNumber()).isEqualTo("BATCH-001");
        assertThat(result.getLineNumber()).isEqualTo(1);

        verify(goodsReceiptRepository).findById(receiptId);
        verify(productVariantRepository).findById(TestDataBuilder.TEST_VARIANT_A1_ID);
        verify(goodsReceiptLineRepository).save(any(GoodsReceiptLine.class));
    }

    @Test
    void shouldThrowExceptionWhenAddingLineToNonModifiableReceipt() {
        // Given
        UUID receiptId = UUID.randomUUID();
        GoodsReceipt receipt = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt.setStatus(ReceiptStatusType.RECEIVED);

        when(goodsReceiptRepository.findById(receiptId)).thenReturn(Optional.of(receipt));

        // When & Then
        assertThatThrownBy(() -> receivingService.addLineToReceipt(
                receiptId,
                TestDataBuilder.TEST_VARIANT_A1_ID,
                TestDataBuilder.quantity(10.0),
                TestDataBuilder.money(5.50),
                null,
                null
        )).isInstanceOf(BusinessException.class)
                .hasMessageContaining("ne peut plus être modifiée");
    }

    @Test
    void shouldFinalizeReceipt() {
        // Given
        UUID receiptId = UUID.randomUUID();
        GoodsReceipt receipt = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt.setId(receiptId);

        GoodsReceiptLine line = TestDataBuilder.createTestReceiptLine(
                receipt, testVariant, 10.0, 5.50, 1);
        receipt.setLines(java.util.List.of(line));

        when(goodsReceiptRepository.findById(receiptId)).thenReturn(Optional.of(receipt));
        when(goodsReceiptRepository.save(any(GoodsReceipt.class))).thenReturn(receipt);

        // When
        GoodsReceipt result = receivingService.finalizeReceipt(receiptId, "admin");

        // Then
        assertThat(result.getStatus()).isEqualTo(ReceiptStatusType.RECEIVED);

        verify(inventoryService).addStock(
                eq(testStore.getId()),
                eq(testVariant.getId()),
                eq(line.getQuantityReceived()),
                eq(line.getUnitCostEffective()),
                eq(receiptId.toString()),
                eq("GOODS_RECEIPT")
        );
        verify(goodsReceiptRepository).save(receipt);
    }

    @Test
    void shouldThrowExceptionWhenFinalizingEmptyReceipt() {
        // Given
        UUID receiptId = UUID.randomUUID();
        GoodsReceipt receipt = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt.setLines(new ArrayList<>());

        when(goodsReceiptRepository.findById(receiptId)).thenReturn(Optional.of(receipt));

        // When & Then
        assertThatThrownBy(() -> receivingService.finalizeReceipt(receiptId, "admin"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sans lignes");
    }
}