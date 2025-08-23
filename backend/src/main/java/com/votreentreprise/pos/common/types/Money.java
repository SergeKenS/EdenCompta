package com.votreentreprise.pos.common.types;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

@Embeddable
public class Money {
    @Column(precision = 10, scale = 2)
    private BigDecimal amount;

    public Money() {}

    private Money(BigDecimal amount) {
        this.amount = amount.setScale(2, RoundingMode.HALF_EVEN);
    }

    public static Money of(BigDecimal amount) {
        return new Money(amount.setScale(2, RoundingMode.HALF_EVEN));
    }

    public static Money of(double amount) {
        return of(BigDecimal.valueOf(amount));
    }

    public static Money zero() {
        return of(BigDecimal.ZERO);
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public Money add(Money other) {
        return of(this.amount.add(other.amount));
    }

    public Money subtract(Money other) {
        return of(this.amount.subtract(other.amount));
    }

    public Money multiply(BigDecimal factor) {
        return of(this.amount.multiply(factor));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Money money = (Money) o;
        return Objects.equals(amount, money.amount);
    }

    @Override
    public int hashCode() {
        return Objects.hash(amount);
    }

    @Override
    public String toString() {
        return amount.toString();
    }
}