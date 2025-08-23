package com.votreentreprise.pos.cashflow.web.dto;

import com.votreentreprise.pos.cashflow.domain.CashMovement;
import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

public record CashMovementDto(
        UUID id,
        UUID storeId,
        String storeName,
        CashMovementType movementType,
        CashMovementReason reason,
        BigDecimal amount,
        String reference,
        String referenceType,
        String description,
        LocalDateTime movementDate,
        String createdBy,
        LocalDateTime createdAt,
        String sourceOfflineId
) {
    
    public static CashMovementDto fromEntity(CashMovement movement) {
        return new CashMovementDto(
                movement.getId(),
                movement.getStore().getId(),
                movement.getStore().getName(),
                movement.getMovementType(),
                movement.getReason(),
                movement.getAmount().getAmount(),
                movement.getReference(),
                movement.getReferenceType(),
                movement.getDescription(),
                movement.getMovementDate(),
                movement.getCreatedBy(),
                movement.getCreatedAt(),
                movement.getSourceOfflineId()
        );
    }
}


