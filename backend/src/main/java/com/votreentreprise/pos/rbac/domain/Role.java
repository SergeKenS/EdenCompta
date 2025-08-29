package com.votreentreprise.pos.rbac.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "roles", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"key"})
})
public class Role extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "\"key\"", nullable = false, length = 64, unique = true)
    @NotBlank
    @Size(max = 64)
    private String key;

    @Column(name = "name", nullable = false, length = 128)
    @NotBlank
    @Size(max = 128)
    private String name;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "role_permissions",
        joinColumns = @JoinColumn(name = "role_id"),
        inverseJoinColumns = @JoinColumn(name = "permission_id")
    )
    private Set<Permission> permissions = new HashSet<>();

    // Constructors
    public Role() {}

    public Role(String key, String name) {
        this.key = key;
        this.name = name;
    }

    // Business methods
    public void addPermission(Permission permission) {
        this.permissions.add(permission);
    }

    public void removePermission(Permission permission) {
        this.permissions.remove(permission);
    }

    public boolean hasPermission(String permissionKey) {
        return this.permissions.stream()
                .anyMatch(p -> p.getKey().equals(permissionKey));
    }

    public boolean hasAnyPermission(String... permissionKeys) {
        for (String permissionKey : permissionKeys) {
            if (hasPermission(permissionKey)) {
                return true;
            }
        }
        return false;
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getKey() { return key; }
    public void setKey(String key) { this.key = key; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Set<Permission> getPermissions() { return permissions; }
    public void setPermissions(Set<Permission> permissions) { this.permissions = permissions; }

    @Override
    public String toString() {
        return "Role{" +
                "id=" + id +
                ", key='" + key + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
