package com.votreentreprise.pos.users.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "users", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"username"}),
    @UniqueConstraint(columnNames = {"email"})
})
public class User extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "username", nullable = false, length = 50, unique = true)
    @NotBlank
    @Size(min = 3, max = 50)
    private String username;

    @Column(name = "email", nullable = false, length = 100, unique = true)
    @NotBlank
    @Email
    @Size(max = 100)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    @NotBlank
    private String passwordHash;

    @Column(name = "first_name", nullable = false, length = 50)
    @NotBlank
    @Size(max = 50)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 50)
    @NotBlank
    @Size(max = 50)
    private String lastName;

    @Column(name = "phone", length = 20)
    @Size(max = 20)
    private String phone;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id")
    private Store store;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false, length = 20)
    @NotNull
    private UserRole role;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    @NotNull
    private UserStatus status;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "password_changed_at")
    private LocalDateTime passwordChangedAt;

    @Column(name = "failed_login_attempts")
    private Integer failedLoginAttempts = 0;

    @Column(name = "account_locked_until")
    private LocalDateTime accountLockedUntil;

    // Constructors
    public User() {
        this.status = UserStatus.ACTIVE;
        this.failedLoginAttempts = 0;
    }

    public User(String username, String email, String password, String firstName, String lastName, UserRole role) {
        this();
        this.username = username;
        this.email = email;
        this.setPassword(password);
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
    }

    // Business methods
    public void setPassword(String plainPassword) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        this.passwordHash = encoder.encode(plainPassword);
        this.passwordChangedAt = LocalDateTime.now();
    }

    public boolean checkPassword(String plainPassword) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        return encoder.matches(plainPassword, this.passwordHash);
    }

    public void recordSuccessfulLogin() {
        this.lastLogin = LocalDateTime.now();
        this.failedLoginAttempts = 0;
        this.accountLockedUntil = null;
    }

    public void recordFailedLogin() {
        this.failedLoginAttempts++;
        if (this.failedLoginAttempts >= 5) {
            this.accountLockedUntil = LocalDateTime.now().plusMinutes(30);
        }
    }

    public boolean isAccountLocked() {
        return this.accountLockedUntil != null && 
               LocalDateTime.now().isBefore(this.accountLockedUntil);
    }

    public boolean isActive() {
        return UserStatus.ACTIVE.equals(this.status);
    }

    public String getFullName() {
        return this.firstName + " " + this.lastName;
    }

    public boolean hasRole(UserRole role) {
        return this.role.equals(role);
    }

    public boolean hasAnyRole(UserRole... roles) {
        for (UserRole role : roles) {
            if (this.role.equals(role)) {
                return true;
            }
        }
        return false;
    }

    // Permission methods
    public boolean canManageUsers() {
        return this.role.canManageUsers();
    }

    public boolean canManageStores() {
        return this.role.canManageStores();
    }

    public boolean canManageInventory() {
        return this.role.canManageInventory();
    }

    public boolean canManageSales() {
        return this.role.canManageSales();
    }

    public boolean canManageExpenses() {
        return this.role.canManageExpenses();
    }

    public boolean canViewReports() {
        return this.role.canViewReports();
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }

    public UserRole getRole() { return role; }
    public void setRole(UserRole role) { this.role = role; }

    public UserStatus getStatus() { return status; }
    public void setStatus(UserStatus status) { this.status = status; }

    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }

    public LocalDateTime getPasswordChangedAt() { return passwordChangedAt; }
    public void setPasswordChangedAt(LocalDateTime passwordChangedAt) { this.passwordChangedAt = passwordChangedAt; }

    public Integer getFailedLoginAttempts() { return failedLoginAttempts; }
    public void setFailedLoginAttempts(Integer failedLoginAttempts) { this.failedLoginAttempts = failedLoginAttempts; }

    public LocalDateTime getAccountLockedUntil() { return accountLockedUntil; }
    public void setAccountLockedUntil(LocalDateTime accountLockedUntil) { this.accountLockedUntil = accountLockedUntil; }
}
