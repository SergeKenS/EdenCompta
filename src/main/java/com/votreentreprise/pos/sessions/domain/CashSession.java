package com.votreentreprise.pos.sessions.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "cash_sessions")
public class CashSession extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(name = "opened_at", nullable = false)
    private LocalDateTime openedAt;

    @Column(name = "closed_at")
    private LocalDateTime closedAt;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "initial_amount"))
    private Money initialAmount = Money.zero();

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "total_in"))
    private Money totalIn = Money.zero();

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "total_out"))
    private Money totalOut = Money.zero();

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "real_closing_amount"))
    private Money realClosingAmount;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "discrepancy"))
    private Money discrepancy;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private SessionStatus status = SessionStatus.OPEN;

    @OneToMany(mappedBy = "cashSession", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SessionMovement> movements = new ArrayList<>();

    public CashSession() {}

    public CashSession(Store store, String userId, Money initialAmount) {
        this.store = store;
        this.userId = userId;
        this.initialAmount = initialAmount;
        this.openedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public LocalDateTime getOpenedAt() { return openedAt; }
    public void setOpenedAt(LocalDateTime openedAt) { this.openedAt = openedAt; }

    public LocalDateTime getClosedAt() { return closedAt; }
    public void setClosedAt(LocalDateTime closedAt) { this.closedAt = closedAt; }

    public Money getInitialAmount() { return initialAmount; }
    public void setInitialAmount(Money initialAmount) { this.initialAmount = initialAmount; }

    public Money getTotalIn() { return totalIn; }
    public void setTotalIn(Money totalIn) { this.totalIn = totalIn; }

    public Money getTotalOut() { return totalOut; }
    public void setTotalOut(Money totalOut) { this.totalOut = totalOut; }

    public Money getRealClosingAmount() { return realClosingAmount; }
    public void setRealClosingAmount(Money realClosingAmount) { this.realClosingAmount = realClosingAmount; }

    public Money getDiscrepancy() { return discrepancy; }
    public void setDiscrepancy(Money discrepancy) { this.discrepancy = discrepancy; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public SessionStatus getStatus() { return status; }
    public void setStatus(SessionStatus status) { this.status = status; }

    public List<SessionMovement> getMovements() { return movements; }
    public void setMovements(List<SessionMovement> movements) { this.movements = movements; }

    // Business methods
    public void addMovement(SessionMovement movement) {
        movements.add(movement);
        movement.setCashSession(this);
        recalculateTotals();
    }

    public void closeSession(Money realClosingAmount, String note) {
        this.status = SessionStatus.CLOSED;
        this.closedAt = LocalDateTime.now();
        this.realClosingAmount = realClosingAmount;
        this.note = note;
        calculateDiscrepancy();
    }

    public Money getExpectedAmount() {
        return initialAmount.add(totalIn).subtract(totalOut);
    }

    private void recalculateTotals() {
        Money newTotalIn = Money.zero();
        Money newTotalOut = Money.zero();

        for (SessionMovement movement : movements) {
            if (movement.getType() == MovementType.IN) {
                newTotalIn = newTotalIn.add(movement.getAmount());
            } else {
                newTotalOut = newTotalOut.add(movement.getAmount());
            }
        }

        this.totalIn = newTotalIn;
        this.totalOut = newTotalOut;
    }

    private void calculateDiscrepancy() {
        Money expected = getExpectedAmount();
        if (realClosingAmount != null) {
            this.discrepancy = realClosingAmount.subtract(expected);
        }
    }

    public boolean isOpen() {
        return status == SessionStatus.OPEN;
    }
}
