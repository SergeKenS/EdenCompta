package com.votreentreprise.pos.attendance.repository;

import com.votreentreprise.pos.attendance.domain.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, UUID> {

    @Query("SELECT a FROM Attendance a WHERE a.store.id = :storeId AND a.timestamp BETWEEN :from AND :to ORDER BY a.timestamp DESC")
    List<Attendance> findByStoreAndDateRange(@Param("storeId") UUID storeId,
                                             @Param("from") LocalDateTime from,
                                             @Param("to") LocalDateTime to);
}


