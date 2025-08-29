package com.votreentreprise.pos.attendance.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.users.domain.User;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "attendance")
public class Attendance extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User employee;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(name = "timestamp", nullable = false)
    private LocalDateTime timestamp;

    public Attendance() {}

    public Attendance(User employee, Store store, LocalDateTime timestamp) {
        this.employee = employee;
        this.store = store;
        this.timestamp = timestamp;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public User getEmployee() { return employee; }
    public void setEmployee(User employee) { this.employee = employee; }
    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}


