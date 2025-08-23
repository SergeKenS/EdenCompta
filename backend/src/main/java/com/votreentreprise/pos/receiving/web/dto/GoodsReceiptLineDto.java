package com.votreentreprise.pos.receiving.web.dto;

import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;

import java.util.UUID;

public class GoodsReceiptLineDto {

    private UUID id;
    private UUID variantId;
    private String batchNumber;
    private String notes;

    public GoodsReceiptLineDto() {}

    private GoodsReceiptLineDto(UUID id, UUID variantId, String batchNumber, String notes) {
        this.id = id;
        this.variantId = variantId;
        this.batchNumber = batchNumber;
        this.notes = notes;
    }

    public static GoodsReceiptLineDto fromEntity(GoodsReceiptLine line) {
        UUID variantId = line.getVariant() != null ? line.getVariant().getId() : null;
        return new GoodsReceiptLineDto(
                line.getId(),
                variantId,
                line.getBatchNumber(),
                line.getNotes()
        );
    }

    public UUID getId() { return id; }
    public UUID getVariantId() { return variantId; }
    public String getBatchNumber() { return batchNumber; }
    public String getNotes() { return notes; }
}


