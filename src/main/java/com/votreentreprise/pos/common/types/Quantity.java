package com.votreentreprise.pos.common.types;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

@Embeddable
@NoArgsConstructor
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@Getter
public class Quantity {
    @Column(precision = 10, scale = 3)
    private BigDecimal value;

    public static Quantity of(BigDecimal value) {
        return new Quantity(value.setScale(3, RoundingMode.HALF_EVEN));
    }

    public static Quantity of(int value) {
        return of(BigDecimal.valueOf(value));
    }

    public Quantity add(Quantity other) {
        return of(this.value.add(other.value));
    }

    public Quantity subtract(Quantity other) {
        return of(this.value.subtract(other.value));
    }

    public boolean isPositive() {
        return value.compareTo(BigDecimal.ZERO) > 0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Quantity quantity = (Quantity) o;
        return Objects.equals(value, quantity.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public String toString() {
        return value.toString();
    }
}