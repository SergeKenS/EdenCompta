package com.votreentreprise.pos.sales.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.PaymentMethod;
import jakarta.persistence.*;

@Entity
@Table(name = "payments")
public class Payment extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receipt_id", nullable = false)
    private Receipt receipt;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false)
    private PaymentMethod paymentMethod;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "amount"))
    private Money amount;

    @Column(name = "reference")
    private String reference;

    public Payment() {}

    public Payment(Receipt receipt, PaymentMethod paymentMethod, Money amount, String reference) {
        this.receipt = receipt;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
        this.reference = reference;
    }

    public Receipt getReceipt() { return receipt; }
    public void setReceipt(Receipt receipt) { this.receipt = receipt; }
    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }
    public Money getAmount() { return amount; }
    public void setAmount(Money amount) { this.amount = amount; }
    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }
}


