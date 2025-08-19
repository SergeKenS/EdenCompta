package com.votreentreprise.pos.store.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "stores")
@Getter
@Setter
@NoArgsConstructor
public class Store extends AuditableEntity {

    @Column(nullable = false)
    private String name;

    private String address;

    private String phone;

    public Store(String name) {
        this.name = name;
    }
}