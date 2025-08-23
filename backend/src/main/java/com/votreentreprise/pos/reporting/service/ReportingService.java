package com.votreentreprise.pos.reporting.service;

import com.votreentreprise.pos.reporting.web.dto.ZReportDto;
import com.votreentreprise.pos.reporting.web.dto.DailySummaryDto;

import java.time.LocalDate;
import java.util.UUID;

public interface ReportingService {

    /**
     * Génère un Z-Report pour une date donnée et un magasin
     * Agrége les données des 3 types de sessions (Cash, Mobile, Other)
     */
    ZReportDto generateZReport(UUID storeId, LocalDate date);

    /**
     * Génère un résumé quotidien pour un magasin
     * Inclut les totaux par type de session et le total global
     */
    DailySummaryDto generateDailySummary(UUID storeId, LocalDate date);

    /**
     * Génère un Z-Report pour la période en cours (aujourd'hui)
     */
    ZReportDto generateCurrentZReport(UUID storeId);

    /**
     * Génère un rapport de session spécifique (Cash, Mobile, Other)
     */
    ZReportDto generateSessionReport(UUID storeId, String sessionType, LocalDate date);
}

