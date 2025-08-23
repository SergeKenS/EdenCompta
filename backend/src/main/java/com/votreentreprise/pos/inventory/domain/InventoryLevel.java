package com.votreentreprise.pos.inventory.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "inventory_levels",
        uniqueConstraints = @UniqueConstraint(columnNames = {"store_id", "variant_id"}))
public class InventoryLevel extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariant variant;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "quantity_on_hand"))
    private Quantity quantityOnHand = Quantity.of(0);

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "average_cost"))
    private Money averageCost = Money.zero();

    @Column(name = "last_updated", nullable = false)
    private LocalDateTime lastUpdated = LocalDateTime.now();

    public InventoryLevel() {}

    public InventoryLevel(Store store, ProductVariant variant) {
        this.store = store;
        this.variant = variant;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public Quantity getQuantityOnHand() {
        return quantityOnHand;
    }

    public void setQuantityOnHand(Quantity quantityOnHand) {
        this.quantityOnHand = quantityOnHand;
    }

    public Money getAverageCost() {
        return averageCost;
    }

    public void setAverageCost(Money averageCost) {
        this.averageCost = averageCost;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public void updateQuantityAndCost(Quantity newQuantity, Money newAverageCost) {
        this.quantityOnHand = newQuantity;
        this.averageCost = newAverageCost;
        this.lastUpdated = LocalDateTime.now();
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }
}