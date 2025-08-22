package com.votreentreprise.pos.sales.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import jakarta.persistence.*;

@Entity
@Table(name = "cogs_entries")
public class CogsEntry extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receipt_line_id", nullable = false)
    private ReceiptLine receiptLine;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariant variant;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "quantity_sold"))
    private Quantity quantitySold;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "unit_cost"))
    private Money unitCost;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "total_cogs"))
    private Money totalCogs;

    public CogsEntry() {}

    public CogsEntry(Store store, ReceiptLine receiptLine, ProductVariant variant,
                     Quantity quantitySold, Money unitCost, Money totalCogs) {
        this.store = store;
        this.receiptLine = receiptLine;
        this.variant = variant;
        this.quantitySold = quantitySold;
        this.unitCost = unitCost;
        this.totalCogs = totalCogs;
    }

    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }
    public ReceiptLine getReceiptLine() { return receiptLine; }
    public void setReceiptLine(ReceiptLine receiptLine) { this.receiptLine = receiptLine; }
    public ProductVariant getVariant() { return variant; }
    public void setVariant(ProductVariant variant) { this.variant = variant; }
    public Quantity getQuantitySold() { return quantitySold; }
    public void setQuantitySold(Quantity quantitySold) { this.quantitySold = quantitySold; }
    public Money getUnitCost() { return unitCost; }
    public void setUnitCost(Money unitCost) { this.unitCost = unitCost; }
    public Money getTotalCogs() { return totalCogs; }
    public void setTotalCogs(Money totalCogs) { this.totalCogs = totalCogs; }
}


