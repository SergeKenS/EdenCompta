package com.votreentreprise.pos.receiving.web;

import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.receiving.web.dto.GoodsReceiptDto;
import com.votreentreprise.pos.receiving.web.dto.GoodsReceiptLineDto;
import com.votreentreprise.pos.receiving.service.ReceivingService;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.common.types.ReceiptStatusType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/receiving")
public class ReceivingController {

    private static final Logger log = LoggerFactory.getLogger(ReceivingController.class);

    private final ReceivingService receivingService;

    public ReceivingController(ReceivingService receivingService) {
        this.receivingService = receivingService;
    }

    @PreAuthorize("hasAuthority('INVENTORY.RECEIVE')")
    @PostMapping("/receipts")
    public ResponseEntity<GoodsReceiptDto> createReceipt(
            @RequestParam UUID storeId,
            @RequestParam String createdBy,
            @RequestParam(required = false) String sourceOfflineId) {

        log.debug("Création réception - store: {}, user: {}", storeId, createdBy);

        GoodsReceipt receipt = receivingService.createReceipt(storeId, createdBy, sourceOfflineId);
        return ResponseEntity.status(HttpStatus.CREATED).body(GoodsReceiptDto.fromEntity(receipt));
    }

    @PreAuthorize("hasAuthority('INVENTORY.RECEIVE')")
    @PostMapping("/receipts/{receiptId}/lines")
    public ResponseEntity<GoodsReceiptLineDto> addLine(
            @PathVariable UUID receiptId,
            @RequestParam UUID variantId,
            @RequestParam BigDecimal quantityReceived,
            @RequestParam BigDecimal unitCost,
            @RequestParam(required = false) String batchNumber,
            @RequestParam(required = false) String notes) {

        log.debug("Ajout ligne - receipt: {}, variant: {}, qty: {}",
                receiptId, variantId, quantityReceived);

        GoodsReceiptLine line = receivingService.addLineToReceipt(
                receiptId,
                variantId,
                Quantity.of(quantityReceived),
                Money.of(unitCost),
                batchNumber,
                notes
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(GoodsReceiptLineDto.fromEntity(line));
    }

    @PostMapping("/receipts/{receiptId}/finalize")
    public ResponseEntity<GoodsReceiptDto> finalizeReceipt(
            @PathVariable UUID receiptId,
            @RequestParam String finalizedBy) {

        log.debug("Finalisation réception - ID: {}, user: {}", receiptId, finalizedBy);

        GoodsReceipt receipt = receivingService.finalizeReceipt(receiptId, finalizedBy);
        return ResponseEntity.ok(GoodsReceiptDto.fromEntity(receipt));
    }

    @PostMapping("/receipts/{receiptId}/cancel")
    public ResponseEntity<Void> cancelReceipt(
            @PathVariable UUID receiptId,
            @RequestParam String cancelledBy) {

        log.debug("Annulation réception - ID: {}, user: {}", receiptId, cancelledBy);

        receivingService.cancelReceipt(receiptId, cancelledBy);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/receipts/{receiptId}")
    public ResponseEntity<GoodsReceiptDto> getReceipt(@PathVariable UUID receiptId) {
        GoodsReceipt receipt = receivingService.getReceiptById(receiptId);
        return ResponseEntity.ok(GoodsReceiptDto.fromEntity(receipt));
    }

    @GetMapping("/receipts")
    public ResponseEntity<List<GoodsReceiptDto>> getReceipts(
            @RequestParam UUID storeId,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to,
            @RequestParam(required = false) ReceiptStatusType status) {

        // Valeurs par défaut si non spécifiées
        if (from == null) {
            from = LocalDateTime.now().minusDays(30);
        }
        if (to == null) {
            to = LocalDateTime.now();
        }

        List<GoodsReceipt> receipts = receivingService.getReceiptsByStoreAndDateRange(
                storeId, from, to, status);

        List<GoodsReceiptDto> dtoList = receipts.stream()
                .map(GoodsReceiptDto::fromEntity)
                .toList();

        return ResponseEntity.ok(dtoList);
    }

    @DeleteMapping("/receipts/{receiptId}/lines/{lineId}")
    public ResponseEntity<Void> removeLine(
            @PathVariable UUID receiptId,
            @PathVariable UUID lineId) {

        log.debug("Suppression ligne - receipt: {}, line: {}", receiptId, lineId);

        receivingService.removeLineFromReceipt(receiptId, lineId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/lines/{lineId}")
    public ResponseEntity<GoodsReceiptLineDto> updateLine(
            @PathVariable UUID lineId,
            @RequestParam BigDecimal quantityReceived,
            @RequestParam BigDecimal unitCost,
            @RequestParam(required = false) String notes) {

        log.debug("Mise à jour ligne - ID: {}, qty: {}, cost: {}",
                lineId, quantityReceived, unitCost);

        GoodsReceiptLine line = receivingService.updateReceiptLine(
                lineId,
                Quantity.of(quantityReceived),
                Money.of(unitCost),
                notes
        );

        return ResponseEntity.ok(GoodsReceiptLineDto.fromEntity(line));
    }
}