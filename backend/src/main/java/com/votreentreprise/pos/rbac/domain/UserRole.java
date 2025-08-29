package com.votreentreprise.pos.rbac.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.users.domain.User;
import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "user_roles", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "role_id"})
})
public class UserRole extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    // Constructors
    public UserRole() {}

    public UserRole(User user, Role role) {
        this.user = user;
        this.role = role;
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    @Override
    public String toString() {
        return "UserRole{" +
                "id=" + id +
                ", userId=" + (user != null ? user.getId() : null) +
                ", roleKey=" + (role != null ? role.getKey() : null) +
                '}';
    }
}
