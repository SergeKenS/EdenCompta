package com.votreentreprise.pos.sales.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import jakarta.persistence.*;

@Entity
@Table(name = "receipt_lines")
public class ReceiptLine extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receipt_id", nullable = false)
    private Receipt receipt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariant variant;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "quantity"))
    private Quantity quantity;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "unit_price"))
    private Money unitPrice;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "line_total"))
    private Money lineTotal;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "unit_cost"))
    private Money unitCost; // capturé pour COGS

    @Column(name = "line_number", nullable = false)
    private Integer lineNumber;

    public ReceiptLine() {}

    public ReceiptLine(Receipt receipt, ProductVariant variant, Quantity quantity, Money unitPrice, int lineNumber) {
        this.receipt = receipt;
        this.variant = variant;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineNumber = lineNumber;
        calculateLineTotal();
    }

    public Receipt getReceipt() { return receipt; }
    public void setReceipt(Receipt receipt) { this.receipt = receipt; }
    public ProductVariant getVariant() { return variant; }
    public void setVariant(ProductVariant variant) { this.variant = variant; }
    public Quantity getQuantity() { return quantity; }
    public void setQuantity(Quantity quantity) { this.quantity = quantity; calculateLineTotal(); }
    public Money getUnitPrice() { return unitPrice; }
    public void setUnitPrice(Money unitPrice) { this.unitPrice = unitPrice; calculateLineTotal(); }
    public Money getLineTotal() { return lineTotal; }
    public void setLineTotal(Money lineTotal) { this.lineTotal = lineTotal; }
    public Money getUnitCost() { return unitCost; }
    public void setUnitCost(Money unitCost) { this.unitCost = unitCost; }
    public Integer getLineNumber() { return lineNumber; }
    public void setLineNumber(Integer lineNumber) { this.lineNumber = lineNumber; }

    public void calculateLineTotal() {
        if (quantity != null && unitPrice != null) {
            this.lineTotal = unitPrice.multiply(quantity.getValue());
        }
    }
}


