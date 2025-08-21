package com.votreentreprise.pos.receiving.web.dto;

import com.votreentreprise.pos.receiving.domain.GoodsReceipt;

import java.util.UUID;

public class GoodsReceiptDto {

    private UUID id;
    private UUID storeId;
    private String createdBy;
    private String status;

    public GoodsReceiptDto() {}

    private GoodsReceiptDto(UUID id, UUID storeId, String createdBy, String status) {
        this.id = id;
        this.storeId = storeId;
        this.createdBy = createdBy;
        this.status = status;
    }

    public static GoodsReceiptDto fromEntity(GoodsReceipt receipt) {
        UUID storeId = receipt.getStore() != null ? receipt.getStore().getId() : null;
        return new GoodsReceiptDto(
                receipt.getId(),
                storeId,
                receipt.getCreatedBy(),
                receipt.getStatus() != null ? receipt.getStatus().name() : null
        );
    }

    public UUID getId() {
        return id;
    }

    public UUID getStoreId() {
        return storeId;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public String getStatus() {
        return status;
    }
}


