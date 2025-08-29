package com.votreentreprise.pos.attendance.service;

import com.votreentreprise.pos.attendance.domain.Attendance;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface AttendanceService {
    Attendance record(UUID storeId, UUID employeeId, String createdBy);
    List<Attendance> list(UUID storeId, LocalDateTime from, LocalDateTime to);
}


