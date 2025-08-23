package com.votreentreprise.pos.integration;

import com.votreentreprise.pos.common.types.ReceiptStatusType;
import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.receiving.service.ReceivingService;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@ActiveProfiles("test")
@Transactional
class ReceivingIntegrationTest {

    @Autowired
    private ReceivingService receivingService;

    @Test
    void shouldCompleteFullReceivingWorkflow() {
        // 1. Créer une réception
        GoodsReceipt receipt = receivingService.createReceipt(
                TestDataBuilder.TEST_STORE_ID,
                "admin",
                "INTEGRATION-TEST-001"
        );

        assertThat(receipt).isNotNull();
        assertThat(receipt.getId()).isNotNull();
        assertThat(receipt.getStatus()).isEqualTo(ReceiptStatusType.DRAFT);

        // 2. Ajouter des lignes
        GoodsReceiptLine line1 = receivingService.addLineToReceipt(
                receipt.getId(),
                TestDataBuilder.TEST_VARIANT_A1_ID,
                TestDataBuilder.quantity(10.0),
                TestDataBuilder.money(5.50),
                "BATCH-001",
                "Première ligne"
        );

        GoodsReceiptLine line2 = receivingService.addLineToReceipt(
                receipt.getId(),
                TestDataBuilder.TEST_VARIANT_A2_ID,
                TestDataBuilder.quantity(20.0),
                TestDataBuilder.money(3.25),
                "BATCH-002",
                "Deuxième ligne"
        );

        assertThat(line1).isNotNull();
        assertThat(line1.getLineNumber()).isEqualTo(1);
        assertThat(line2).isNotNull();
        assertThat(line2.getLineNumber()).isEqualTo(2);

        // 3. Récupérer et vérifier la réception
        GoodsReceipt retrievedReceipt = receivingService.getReceiptById(receipt.getId());
        assertThat(retrievedReceipt.getLines()).hasSize(2);

        // 4. Finaliser la réception
        GoodsReceipt finalizedReceipt = receivingService.finalizeReceipt(receipt.getId(), "admin");

        assertThat(finalizedReceipt.getStatus()).isEqualTo(ReceiptStatusType.RECEIVED);
        assertThat(finalizedReceipt.getReceivedAt()).isNotNull();

        // 5. Vérifier que la réception ne peut plus être modifiée
        assertThat(finalizedReceipt.canBeModified()).isFalse();
    }

    @Test
    void shouldHandleIdempotentCreation() {
        // Première création
        GoodsReceipt receipt1 = receivingService.createReceipt(
                TestDataBuilder.TEST_STORE_ID,
                "admin",
                "IDEMPOTENT-TEST-001"
        );

        // Deuxième création avec le même sourceOfflineId
        GoodsReceipt receipt2 = receivingService.createReceipt(
                TestDataBuilder.TEST_STORE_ID,
                "admin",
                "IDEMPOTENT-TEST-001"
        );

        // Doivent être la même réception
        assertThat(receipt1.getId()).isEqualTo(receipt2.getId());
        assertThat(receipt1.getSourceOfflineId()).isEqualTo("IDEMPOTENT-TEST-001");
    }
}