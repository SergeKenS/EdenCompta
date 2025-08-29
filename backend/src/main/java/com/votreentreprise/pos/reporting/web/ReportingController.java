package com.votreentreprise.pos.reporting.web;

import com.votreentreprise.pos.reporting.service.ReportingService;
import com.votreentreprise.pos.reporting.web.dto.DailySummaryDto;
import com.votreentreprise.pos.reporting.web.dto.ZReportDto;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.UUID;

@RestController
@RequestMapping("/api/reporting")
public class ReportingController {

    private final ReportingService reportingService;

    public ReportingController(ReportingService reportingService) {
        this.reportingService = reportingService;
    }

    /**
     * Génère un Z-Report pour une date spécifique
     */
    @PreAuthorize("hasAuthority('REPORTS.VIEW')")
    @GetMapping("/z-report")
    public ResponseEntity<ZReportDto> generateZReport(
            @RequestParam UUID storeId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        
        ZReportDto report = reportingService.generateZReport(storeId, date);
        return ResponseEntity.ok(report);
    }

    /**
     * Génère un Z-Report pour aujourd'hui
     */
    @GetMapping("/z-report/current")
    public ResponseEntity<ZReportDto> generateCurrentZReport(@RequestParam UUID storeId) {
        ZReportDto report = reportingService.generateCurrentZReport(storeId);
        return ResponseEntity.ok(report);
    }

    /**
     * Génère un rapport pour un type de session spécifique
     */
    @GetMapping("/z-report/session/{sessionType}")
    public ResponseEntity<ZReportDto> generateSessionReport(
            @PathVariable String sessionType,
            @RequestParam UUID storeId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        
        ZReportDto report = reportingService.generateSessionReport(storeId, sessionType, date);
        return ResponseEntity.ok(report);
    }

    /**
     * Génère un résumé quotidien
     */
    @GetMapping("/daily-summary")
    public ResponseEntity<DailySummaryDto> generateDailySummary(
            @RequestParam UUID storeId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        
        DailySummaryDto summary = reportingService.generateDailySummary(storeId, date);
        return ResponseEntity.ok(summary);
    }

    /**
     * Génère un résumé quotidien pour aujourd'hui
     */
    @GetMapping("/daily-summary/current")
    public ResponseEntity<DailySummaryDto> generateCurrentDailySummary(@RequestParam UUID storeId) {
        DailySummaryDto summary = reportingService.generateDailySummary(storeId, LocalDate.now());
        return ResponseEntity.ok(summary);
    }
}

