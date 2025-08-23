package com.votreentreprise.pos.repository;

import com.votreentreprise.pos.common.types.ReceiptStatusType;
import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.repository.GoodsReceiptRepository;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class GoodsReceiptRepositoryTest {

    @Autowired
    private GoodsReceiptRepository goodsReceiptRepository;

    @Autowired
    private StoreRepository storeRepository;

    private Store testStore;

    @BeforeEach
    void setUp() {
        testStore = storeRepository.save(TestDataBuilder.createTestStore());
    }

    @Test
    void shouldSaveAndFindGoodsReceipt() {
        // Given
        GoodsReceipt receipt = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt.setSourceOfflineId("OFFLINE-001");

        // When
        GoodsReceipt saved = goodsReceiptRepository.save(receipt);
        Optional<GoodsReceipt> found = goodsReceiptRepository.findById(saved.getId());

        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getCreatedBy()).isEqualTo("admin");
        assertThat(found.get().getStatus()).isEqualTo(ReceiptStatusType.DRAFT);
        assertThat(found.get().getStore().getId()).isEqualTo(testStore.getId());
    }

    @Test
    void shouldFindBySourceOfflineId() {
        // Given
        GoodsReceipt receipt = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt.setSourceOfflineId("OFFLINE-002");
        goodsReceiptRepository.save(receipt);

        // When
        Optional<GoodsReceipt> found = goodsReceiptRepository.findBySourceOfflineId("OFFLINE-002");

        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getSourceOfflineId()).isEqualTo("OFFLINE-002");
    }

    @Test
    void shouldFindByStoreAndDateRange() {
        // Given
        LocalDateTime now = LocalDateTime.now();
        GoodsReceipt receipt1 = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt1.setReceivedAt(now.minusHours(1));

        GoodsReceipt receipt2 = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt2.setReceivedAt(now.plusHours(1));

        goodsReceiptRepository.save(receipt1);
        goodsReceiptRepository.save(receipt2);

        // When
        List<GoodsReceipt> receipts = goodsReceiptRepository.findByStoreAndDateRangeAndStatus(
                testStore.getId(),
                now.minusHours(2),
                now,
                null
        );

        // Then
        assertThat(receipts).hasSize(1);
        assertThat(receipts.get(0).getReceivedAt()).isBefore(now);
    }

    @Test
    void shouldCountByStoreAndStatus() {
        // Given
        GoodsReceipt receipt1 = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt1.setStatus(ReceiptStatusType.DRAFT);

        GoodsReceipt receipt2 = TestDataBuilder.createTestReceipt(testStore, "admin");
        receipt2.setStatus(ReceiptStatusType.RECEIVED);

        goodsReceiptRepository.save(receipt1);
        goodsReceiptRepository.save(receipt2);

        // When & Then
        assertThat(goodsReceiptRepository.countByStoreAndStatus(testStore.getId(), ReceiptStatusType.DRAFT)).isEqualTo(1);
        assertThat(goodsReceiptRepository.countByStoreAndStatus(testStore.getId(), ReceiptStatusType.RECEIVED)).isEqualTo(1);
    }
}