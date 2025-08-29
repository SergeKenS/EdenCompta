package com.votreentreprise.pos.attendance.web;

import com.votreentreprise.pos.attendance.domain.Attendance;
import com.votreentreprise.pos.attendance.service.AttendanceService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/attendance")
public class AttendanceController {

    private final AttendanceService attendanceService;

    public AttendanceController(AttendanceService attendanceService) {
        this.attendanceService = attendanceService;
    }

    @PreAuthorize("hasAuthority('ATTENDANCE.MANAGE') or hasRole('MANAGER')")
    @PostMapping
    public ResponseEntity<Map<String, Object>> record(@RequestBody RecordRequest request) {
        Attendance a = attendanceService.record(request.storeId(), request.employeeId(), request.createdBy());
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.<String, Object>of(
                "id", a.getId(),
                "employeeId", a.getEmployee().getId(),
                "storeId", a.getStore().getId(),
                "timestamp", a.getTimestamp()
        ));
    }

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> list(
            @RequestParam UUID storeId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to
    ) {
        List<Attendance> list = attendanceService.list(storeId, from, to);
        var out = list.stream().map(a -> Map.<String, Object>of(
                "id", a.getId(),
                "employeeId", a.getEmployee().getId(),
                "storeId", a.getStore().getId(),
                "timestamp", a.getTimestamp()
        )).collect(Collectors.toList());
        return ResponseEntity.ok(out);
    }

    public record RecordRequest(UUID storeId, UUID employeeId, String createdBy) {}
}


