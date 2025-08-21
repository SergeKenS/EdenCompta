package com.votreentreprise.pos;

import com.votreentreprise.pos.inventory.repository.InventoryLevelRepository;
import com.votreentreprise.pos.inventory.repository.ProductRepository;
import com.votreentreprise.pos.inventory.repository.ProductVariantRepository;
import com.votreentreprise.pos.inventory.service.InventoryService;
import com.votreentreprise.pos.receiving.repository.GoodsReceiptRepository;
import com.votreentreprise.pos.receiving.service.ReceivingService;
import com.votreentreprise.pos.store.repository.StoreRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class PosApplicationTests {

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductVariantRepository productVariantRepository;

    @Autowired
    private GoodsReceiptRepository goodsReceiptRepository;

    @Autowired
    private InventoryLevelRepository inventoryLevelRepository;

    @Autowired
    private ReceivingService receivingService;

    @Autowired
    private InventoryService inventoryService;

    @Test
    void contextLoads() {
        // Vérifier que le contexte Spring se charge sans erreur
        assertThat(storeRepository).isNotNull();
        assertThat(productRepository).isNotNull();
        assertThat(productVariantRepository).isNotNull();
        assertThat(goodsReceiptRepository).isNotNull();
        assertThat(inventoryLevelRepository).isNotNull();
        assertThat(receivingService).isNotNull();
        assertThat(inventoryService).isNotNull();
    }

    @Test
    void shouldLoadTestData() {
        // Vérifier que les données de test sont chargées
        assertThat(storeRepository.count()).isGreaterThan(0);
        assertThat(productRepository.count()).isGreaterThan(0);
        assertThat(productVariantRepository.count()).isGreaterThan(0);

        // Vérifier les données spécifiques
        assertThat(storeRepository.existsByName("Magasin Test")).isTrue();
        assertThat(productVariantRepository.existsBySku("SKU-A-001")).isTrue();
    }
}