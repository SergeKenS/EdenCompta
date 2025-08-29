package com.votreentreprise.pos.attendance.service;

import com.votreentreprise.pos.attendance.domain.Attendance;
import com.votreentreprise.pos.attendance.repository.AttendanceRepository;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class AttendanceServiceImpl implements AttendanceService {

    private final AttendanceRepository attendanceRepository;
    private final StoreRepository storeRepository;
    private final UserRepository userRepository;

    public AttendanceServiceImpl(AttendanceRepository attendanceRepository,
                                 StoreRepository storeRepository,
                                 UserRepository userRepository) {
        this.attendanceRepository = attendanceRepository;
        this.storeRepository = storeRepository;
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public Attendance record(UUID storeId, UUID employeeId, String createdBy) {
        Store store = storeRepository.findById(storeId).orElseThrow();
        User employee = userRepository.findById(employeeId).orElseThrow();
        Attendance attendance = new Attendance(employee, store, LocalDateTime.now());
        attendance.setCreatedBy(createdBy);
        return attendanceRepository.save(attendance);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Attendance> list(UUID storeId, LocalDateTime from, LocalDateTime to) {
        LocalDateTime start = from != null ? from : LocalDateTime.now().minusDays(30);
        LocalDateTime end = to != null ? to : LocalDateTime.now();
        return attendanceRepository.findByStoreAndDateRange(storeId, start, end);
    }
}


