package com.votreentreprise.pos.rbac.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "permissions", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"key"})
})
public class Permission extends AuditableEntity {

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

    @ManyToMany(mappedBy = "permissions", fetch = FetchType.LAZY)
    private Set<Role> roles = new HashSet<>();

    // Constructors
    public Permission() {}

    public Permission(String key, String name) {
        this.key = key;
        this.name = name;
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getKey() { return key; }
    public void setKey(String key) { this.key = key; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Set<Role> getRoles() { return roles; }
    public void setRoles(Set<Role> roles) { this.roles = roles; }

    @Override
    public String toString() {
        return "Permission{" +
                "id=" + id +
                ", key='" + key + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
