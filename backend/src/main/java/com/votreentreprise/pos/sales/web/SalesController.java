package com.votreentreprise.pos.sales.web;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.PaymentMethod;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.sales.domain.Payment;
import com.votreentreprise.pos.sales.domain.Receipt;
import com.votreentreprise.pos.sales.domain.ReceiptLine;
import com.votreentreprise.pos.sales.service.SalesService;
import com.votreentreprise.pos.sales.web.dto.ReceiptDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sales")
public class SalesController {

    private final SalesService salesService;

    public SalesController(SalesService salesService) {
        this.salesService = salesService;
    }

    @PreAuthorize("hasAuthority('SALE.MAKE')")
    @PostMapping("/receipts")
    public ResponseEntity<ReceiptDto> createReceipt(
            @RequestParam UUID storeId,
            @RequestParam String createdBy,
            @RequestParam String receiptNumber,
            @RequestParam(required = false) String sourceOfflineId) {
        Receipt r = salesService.createReceipt(storeId, createdBy, receiptNumber, sourceOfflineId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ReceiptDto.fromEntity(r));
    }

    @PostMapping("/receipts/{receiptId}/lines")
    public ResponseEntity<Void> addLine(
            @PathVariable UUID receiptId,
            @RequestParam UUID variantId,
            @RequestParam BigDecimal quantity,
            @RequestParam BigDecimal unitPrice) {
        ReceiptLine line = salesService.addLine(
                receiptId,
                variantId,
                Quantity.of(quantity),
                Money.of(unitPrice)
        );
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PostMapping("/receipts/{receiptId}/finalize")
    public ResponseEntity<ReceiptDto> finalizeReceipt(
            @PathVariable UUID receiptId,
            @RequestParam String finalizedBy) {
        Receipt r = salesService.finalizeReceipt(receiptId, finalizedBy);
        return ResponseEntity.ok(ReceiptDto.fromEntity(r));
    }

    @PostMapping("/receipts/{receiptId}/payments")
    public ResponseEntity<Void> addPayment(
            @PathVariable UUID receiptId,
            @RequestParam PaymentMethod method,
            @RequestParam BigDecimal amount,
            @RequestParam(required = false) String reference) {
        Payment p = salesService.addPayment(receiptId, method, Money.of(amount), reference);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @GetMapping("/receipts/{receiptId}")
    public ResponseEntity<ReceiptDto> getReceipt(@PathVariable UUID receiptId) {
        Receipt r = salesService.getReceipt(receiptId);
        return ResponseEntity.ok(ReceiptDto.fromEntity(r));
    }

    @GetMapping("/receipts")
    public ResponseEntity<List<ReceiptDto>> listReceipts(@RequestParam UUID storeId) {
        List<ReceiptDto> list = salesService.listReceipts(storeId).stream()
                .map(ReceiptDto::fromEntity)
                .toList();
        return ResponseEntity.ok(list);
    }
}


