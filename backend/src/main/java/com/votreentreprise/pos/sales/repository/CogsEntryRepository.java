package com.votreentreprise.pos.sales.repository;

import com.votreentreprise.pos.sales.domain.CogsEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface CogsEntryRepository extends JpaRepository<CogsEntry, UUID> {}


