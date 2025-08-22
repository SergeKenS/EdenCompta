package com.votreentreprise.pos.sales.web.dto;

import com.votreentreprise.pos.sales.domain.Receipt;

import java.util.UUID;

public class ReceiptDto {
    private UUID id;
    private UUID storeId;
    private String receiptNumber;
    private String status;
    private String createdBy;

    public static ReceiptDto fromEntity(Receipt r) {
        ReceiptDto dto = new ReceiptDto();
        dto.id = r.getId();
        dto.storeId = r.getStore() != null ? r.getStore().getId() : null;
        dto.receiptNumber = r.getReceiptNumber();
        dto.status = r.getStatus() != null ? r.getStatus().name() : null;
        dto.createdBy = r.getCreatedBy();
        return dto;
    }

    public UUID getId() { return id; }
    public UUID getStoreId() { return storeId; }
    public String getReceiptNumber() { return receiptNumber; }
    public String getStatus() { return status; }
    public String getCreatedBy() { return createdBy; }
}


