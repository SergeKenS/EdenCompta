package com.votreentreprise.pos.cashflow.web;

import com.votreentreprise.pos.cashflow.service.CashflowService;
import com.votreentreprise.pos.cashflow.web.dto.CashMovementDto;
import com.votreentreprise.pos.cashflow.web.dto.CashflowSummaryDto;
import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;
import com.votreentreprise.pos.common.types.Money;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/cashflow")
public class CashflowController {

    private final CashflowService cashflowService;

    public CashflowController(CashflowService cashflowService) {
        this.cashflowService = cashflowService;
    }

    // CRUD operations
    @PostMapping("/movements")
    public ResponseEntity<CashMovementDto> createMovement(@RequestBody CreateMovementRequest request) {
        var movement = cashflowService.createMovement(
                request.storeId(),
                request.movementType(),
                request.reason(),
                Money.of(request.amount()),
                request.reference(),
                request.referenceType(),
                request.description(),
                request.createdBy(),
                request.sourceOfflineId()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(CashMovementDto.fromEntity(movement));
    }

    @GetMapping("/movements/{movementId}")
    public ResponseEntity<CashMovementDto> getMovement(@PathVariable UUID movementId) {
        var movement = cashflowService.getMovementById(movementId);
        return ResponseEntity.ok(CashMovementDto.fromEntity(movement));
    }

    @PutMapping("/movements/{movementId}")
    public ResponseEntity<CashMovementDto> updateMovement(@PathVariable UUID movementId, 
                                                         @RequestBody UpdateMovementRequest request) {
        var movement = cashflowService.updateMovement(
                movementId,
                request.movementType(),
                request.reason(),
                request.amount() != null ? Money.of(request.amount()) : null,
                request.reference(),
                request.referenceType(),
                request.description()
        );
        return ResponseEntity.ok(CashMovementDto.fromEntity(movement));
    }

    @DeleteMapping("/movements/{movementId}")
    public ResponseEntity<Void> deleteMovement(@PathVariable UUID movementId) {
        cashflowService.deleteMovement(movementId);
        return ResponseEntity.noContent().build();
    }

    // Query operations
    @GetMapping("/stores/{storeId}/movements")
    public ResponseEntity<List<CashMovementDto>> getMovementsByStore(@PathVariable UUID storeId) {
        var movements = cashflowService.getMovementsByStore(storeId);
        var dtos = movements.stream().map(CashMovementDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/stores/{storeId}/movements/paged")
    public ResponseEntity<Page<CashMovementDto>> getMovementsByStorePaged(@PathVariable UUID storeId, Pageable pageable) {
        var movements = cashflowService.getMovementsByStore(storeId, pageable);
        var dtos = movements.map(CashMovementDto::fromEntity);
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/stores/{storeId}/movements/by-date-range")
    public ResponseEntity<List<CashMovementDto>> getMovementsByDateRange(
            @PathVariable UUID storeId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        var movements = cashflowService.getMovementsByStoreAndDateRange(storeId, startDate, endDate);
        var dtos = movements.stream().map(CashMovementDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/stores/{storeId}/movements/by-type/{movementType}")
    public ResponseEntity<List<CashMovementDto>> getMovementsByType(@PathVariable UUID storeId, 
                                                                   @PathVariable CashMovementType movementType) {
        var movements = cashflowService.getMovementsByStoreAndType(storeId, movementType);
        var dtos = movements.stream().map(CashMovementDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/stores/{storeId}/movements/by-reason/{reason}")
    public ResponseEntity<List<CashMovementDto>> getMovementsByReason(@PathVariable UUID storeId, 
                                                                     @PathVariable CashMovementReason reason) {
        var movements = cashflowService.getMovementsByStoreAndReason(storeId, reason);
        var dtos = movements.stream().map(CashMovementDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // Business operations
    @PostMapping("/stores/{storeId}/cash-in")
    public ResponseEntity<CashMovementDto> recordCashIn(@PathVariable UUID storeId, 
                                                       @RequestBody RecordCashInRequest request) {
        var movement = cashflowService.recordCashIn(
                storeId,
                request.reason(),
                Money.of(request.amount()),
                request.reference(),
                request.referenceType(),
                request.description(),
                request.createdBy(),
                request.sourceOfflineId()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(CashMovementDto.fromEntity(movement));
    }

    @PostMapping("/stores/{storeId}/cash-out")
    public ResponseEntity<CashMovementDto> recordCashOut(@PathVariable UUID storeId, 
                                                        @RequestBody RecordCashOutRequest request) {
        var movement = cashflowService.recordCashOut(
                storeId,
                request.reason(),
                Money.of(request.amount()),
                request.reference(),
                request.referenceType(),
                request.description(),
                request.createdBy(),
                request.sourceOfflineId()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(CashMovementDto.fromEntity(movement));
    }

    // Reporting operations
    @GetMapping("/stores/{storeId}/summary")
    public ResponseEntity<CashflowSummaryDto> getCashflowSummary(
            @PathVariable UUID storeId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        
        var totalsByType = cashflowService.getTotalAmountsByType(storeId, startDate, endDate);
        var totalsByReason = cashflowService.getTotalAmountsByReason(storeId, startDate, endDate);
        var netCashflow = cashflowService.getNetCashflow(storeId, startDate, endDate);
        var movementCount = cashflowService.getMovementCount(storeId, startDate, endDate);

        // Convert Money to BigDecimal for DTO
        var totalsByTypeBigDecimal = totalsByType.entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> e.getValue().getAmount()));
        var totalsByReasonBigDecimal = totalsByReason.entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> e.getValue().getAmount()));

        var summary = CashflowSummaryDto.create(
                storeId,
                "Store Name", // TODO: Get from store service
                startDate,
                endDate,
                totalsByType.getOrDefault(CashMovementType.IN, Money.zero()).getAmount(),
                totalsByType.getOrDefault(CashMovementType.OUT, Money.zero()).getAmount(),
                netCashflow.getAmount(),
                movementCount,
                totalsByTypeBigDecimal,
                totalsByReasonBigDecimal
        );

        return ResponseEntity.ok(summary);
    }

    // Request/Response records
    public record CreateMovementRequest(
            UUID storeId,
            CashMovementType movementType,
            CashMovementReason reason,
            BigDecimal amount,
            String reference,
            String referenceType,
            String description,
            String createdBy,
            String sourceOfflineId
    ) {}

    public record UpdateMovementRequest(
            CashMovementType movementType,
            CashMovementReason reason,
            BigDecimal amount,
            String reference,
            String referenceType,
            String description
    ) {}

    public record RecordCashInRequest(
            CashMovementReason reason,
            BigDecimal amount,
            String reference,
            String referenceType,
            String description,
            String createdBy,
            String sourceOfflineId
    ) {}

    public record RecordCashOutRequest(
            CashMovementReason reason,
            BigDecimal amount,
            String reference,
            String referenceType,
            String description,
            String createdBy,
            String sourceOfflineId
    ) {}
}


