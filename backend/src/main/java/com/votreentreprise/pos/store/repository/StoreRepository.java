package com.votreentreprise.pos.store.repository;

import com.votreentreprise.pos.store.domain.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface StoreRepository extends JpaRepository<Store, UUID> {

    Optional<Store> findByName(String name);

    List<Store> findByNameContainingIgnoreCase(String name);

    boolean existsByName(String name);
}