package com.votreentreprise.pos.reporting.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.reporting.web.dto.*;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.sessions.service.SessionService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class ReportingServiceImpl implements ReportingService {

    private final SessionService sessionService;

    public ReportingServiceImpl(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    @Override
    public ZReportDto generateZReport(UUID storeId, LocalDate date) {
        // Récupérer les sessions pour la date donnée
        List<CashSession> cashSessions = getCashSessionsForDate(storeId, date);
        List<MobileSession> mobileSessions = getMobileSessionsForDate(storeId, date);
        List<OtherSession> otherSessions = getOtherSessionsForDate(storeId, date);

        // Créer les totaux par session
        SessionTotalsDto cashTotals = createSessionTotals(cashSessions, "CASH");
        SessionTotalsDto mobileTotals = createSessionTotals(mobileSessions, "MOBILE");
        SessionTotalsDto otherTotals = createSessionTotals(otherSessions, "OTHER");

        // Calculer les totaux globaux
        BigDecimal totalInitialAmount = calculateTotalInitialAmount(cashTotals, mobileTotals, otherTotals);
        BigDecimal totalIn = calculateTotalIn(cashTotals, mobileTotals, otherTotals);
        BigDecimal totalOut = calculateTotalOut(cashTotals, mobileTotals, otherTotals);
        BigDecimal totalExpectedAmount = totalInitialAmount.add(totalIn).subtract(totalOut);
        BigDecimal totalRealClosingAmount = calculateTotalRealClosingAmount(cashTotals, mobileTotals, otherTotals);
        BigDecimal totalDiscrepancy = totalRealClosingAmount.subtract(totalExpectedAmount);

        // Créer le résumé des mouvements
        MovementSummaryDto movementSummary = createMovementSummary(storeId, date);

        return new ZReportDto(
                UUID.randomUUID(), // ID généré pour le rapport
                storeId,
                date,
                LocalDateTime.now(),
                "system", // TODO: Récupérer l'utilisateur connecté
                cashTotals,
                mobileTotals,
                otherTotals,
                totalInitialAmount,
                totalIn,
                totalOut,
                totalExpectedAmount,
                totalRealClosingAmount,
                totalDiscrepancy,
                movementSummary
        );
    }

    @Override
    public DailySummaryDto generateDailySummary(UUID storeId, LocalDate date) {
        // Récupérer les sessions pour la date
        List<CashSession> cashSessions = getCashSessionsForDate(storeId, date);
        List<MobileSession> mobileSessions = getMobileSessionsForDate(storeId, date);
        List<OtherSession> otherSessions = getOtherSessionsForDate(storeId, date);

        // Calculer les totaux
        BigDecimal totalSales = calculateTotalSales(cashSessions, mobileSessions, otherSessions);
        BigDecimal totalRefunds = calculateTotalRefunds(cashSessions, mobileSessions, otherSessions);
        BigDecimal totalExpenses = calculateTotalExpenses(cashSessions, mobileSessions, otherSessions);
        BigDecimal netAmount = totalSales.subtract(totalRefunds).subtract(totalExpenses);

        // Compter les transactions
        int totalTransactions = countTotalTransactions(cashSessions, mobileSessions, otherSessions);
        int totalReceipts = countTotalReceipts(cashSessions, mobileSessions, otherSessions);

        return new DailySummaryDto(
                storeId,
                date,
                totalSales,
                totalRefunds,
                totalExpenses,
                netAmount,
                totalTransactions,
                totalReceipts
        );
    }

    @Override
    public ZReportDto generateCurrentZReport(UUID storeId) {
        return generateZReport(storeId, LocalDate.now());
    }

    @Override
    public ZReportDto generateSessionReport(UUID storeId, String sessionType, LocalDate date) {
        switch (sessionType.toUpperCase()) {
            case "CASH":
                return generateCashSessionReport(storeId, date);
            case "MOBILE":
                return generateMobileSessionReport(storeId, date);
            case "OTHER":
                return generateOtherSessionReport(storeId, date);
            default:
                throw new IllegalArgumentException("Type de session non supporté: " + sessionType);
        }
    }

    // Méthodes privées utilitaires
    private List<CashSession> getCashSessionsForDate(UUID storeId, LocalDate date) {
        List<CashSession> allSessions = sessionService.getCashSessionsByStore(storeId);
        return allSessions.stream()
                .filter(session -> isSessionForDate(session.getOpenedAt().toLocalDate(), date))
                .toList();
    }

    private List<MobileSession> getMobileSessionsForDate(UUID storeId, LocalDate date) {
        List<MobileSession> allSessions = sessionService.getMobileSessionsByStore(storeId);
        return allSessions.stream()
                .filter(session -> isSessionForDate(session.getOpenedAt().toLocalDate(), date))
                .toList();
    }

    private List<OtherSession> getOtherSessionsForDate(UUID storeId, LocalDate date) {
        List<OtherSession> allSessions = sessionService.getOtherSessionsByStore(storeId);
        return allSessions.stream()
                .filter(session -> isSessionForDate(session.getOpenedAt().toLocalDate(), date))
                .toList();
    }

    private boolean isSessionForDate(LocalDate sessionDate, LocalDate targetDate) {
        return sessionDate.equals(targetDate);
    }

    private SessionTotalsDto createSessionTotals(List<?> sessions, String sessionType) {
        if (sessions.isEmpty()) {
            return new SessionTotalsDto(
                    null, sessionType, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO,
                    BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"
            );
        }

        // Prendre la première session (normalement il n'y en a qu'une par jour par type)
        var session = sessions.get(0);
        
        if (session instanceof CashSession cashSession) {
            return new SessionTotalsDto(
                    cashSession.getId(),
                    sessionType,
                    cashSession.getInitialAmount() != null ? cashSession.getInitialAmount().getAmount() : BigDecimal.ZERO,
                    cashSession.getTotalIn() != null ? cashSession.getTotalIn().getAmount() : BigDecimal.ZERO,
                    cashSession.getTotalOut() != null ? cashSession.getTotalOut().getAmount() : BigDecimal.ZERO,
                    cashSession.getExpectedAmount() != null ? cashSession.getExpectedAmount().getAmount() : BigDecimal.ZERO,
                    cashSession.getRealClosingAmount() != null ? cashSession.getRealClosingAmount().getAmount() : BigDecimal.ZERO,
                    cashSession.getDiscrepancy() != null ? cashSession.getDiscrepancy().getAmount() : BigDecimal.ZERO,
                    cashSession.getStatus() != null ? cashSession.getStatus().name() : "UNKNOWN"
            );
        } else if (session instanceof MobileSession mobileSession) {
            return new SessionTotalsDto(
                    mobileSession.getId(),
                    sessionType,
                    mobileSession.getInitialAmount() != null ? mobileSession.getInitialAmount().getAmount() : BigDecimal.ZERO,
                    mobileSession.getTotalIn() != null ? mobileSession.getTotalIn().getAmount() : BigDecimal.ZERO,
                    mobileSession.getTotalOut() != null ? mobileSession.getTotalOut().getAmount() : BigDecimal.ZERO,
                    mobileSession.getExpectedAmount() != null ? mobileSession.getExpectedAmount().getAmount() : BigDecimal.ZERO,
                    mobileSession.getRealClosingAmount() != null ? mobileSession.getRealClosingAmount().getAmount() : BigDecimal.ZERO,
                    mobileSession.getDiscrepancy() != null ? mobileSession.getDiscrepancy().getAmount() : BigDecimal.ZERO,
                    mobileSession.getStatus() != null ? mobileSession.getStatus().name() : "UNKNOWN"
            );
        } else if (session instanceof OtherSession otherSession) {
            return new SessionTotalsDto(
                    otherSession.getId(),
                    sessionType,
                    otherSession.getInitialAmount() != null ? otherSession.getInitialAmount().getAmount() : BigDecimal.ZERO,
                    otherSession.getTotalIn() != null ? otherSession.getTotalIn().getAmount() : BigDecimal.ZERO,
                    otherSession.getTotalOut() != null ? otherSession.getTotalOut().getAmount() : BigDecimal.ZERO,
                    otherSession.getExpectedAmount() != null ? otherSession.getExpectedAmount().getAmount() : BigDecimal.ZERO,
                    otherSession.getRealClosingAmount() != null ? otherSession.getRealClosingAmount().getAmount() : BigDecimal.ZERO,
                    otherSession.getDiscrepancy() != null ? otherSession.getDiscrepancy().getAmount() : BigDecimal.ZERO,
                    otherSession.getStatus() != null ? otherSession.getStatus().name() : "UNKNOWN"
            );
        }

        return new SessionTotalsDto(
                null, sessionType, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO,
                BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "UNKNOWN"
        );
    }

    private BigDecimal calculateTotalInitialAmount(SessionTotalsDto cash, SessionTotalsDto mobile, SessionTotalsDto other) {
        return cash.getInitialAmount()
                .add(mobile.getInitialAmount())
                .add(other.getInitialAmount());
    }

    private BigDecimal calculateTotalIn(SessionTotalsDto cash, SessionTotalsDto mobile, SessionTotalsDto other) {
        return cash.getTotalIn()
                .add(mobile.getTotalIn())
                .add(other.getTotalIn());
    }

    private BigDecimal calculateTotalOut(SessionTotalsDto cash, SessionTotalsDto mobile, SessionTotalsDto other) {
        return cash.getTotalOut()
                .add(mobile.getTotalOut())
                .add(other.getTotalOut());
    }

    private BigDecimal calculateTotalRealClosingAmount(SessionTotalsDto cash, SessionTotalsDto mobile, SessionTotalsDto other) {
        return cash.getRealClosingAmount()
                .add(mobile.getRealClosingAmount())
                .add(other.getRealClosingAmount());
    }

    private MovementSummaryDto createMovementSummary(UUID storeId, LocalDate date) {
        // TODO: Implémenter la logique pour récupérer et agréger les mouvements
        // Pour l'instant, retourner des données vides
        Map<String, BigDecimal> movementsByReason = new HashMap<>();
        Map<String, BigDecimal> movementsByType = new HashMap<>();
        
        return new MovementSummaryDto(
                movementsByReason,
                movementsByType,
                0,
                BigDecimal.ZERO
        );
    }

    private BigDecimal calculateTotalSales(List<?>... sessionLists) {
        // TODO: Implémenter la logique pour calculer les ventes totales
        return BigDecimal.ZERO;
    }

    private BigDecimal calculateTotalRefunds(List<?>... sessionLists) {
        // TODO: Implémenter la logique pour calculer les remboursements totaux
        return BigDecimal.ZERO;
    }

    private BigDecimal calculateTotalExpenses(List<?>... sessionLists) {
        // TODO: Implémenter la logique pour calculer les dépenses totales
        return BigDecimal.ZERO;
    }

    private int countTotalTransactions(List<?>... sessionLists) {
        // TODO: Implémenter la logique pour compter les transactions
        return 0;
    }

    private int countTotalReceipts(List<?>... sessionLists) {
        // TODO: Implémenter la logique pour compter les reçus
        return 0;
    }

    private ZReportDto generateCashSessionReport(UUID storeId, LocalDate date) {
        List<CashSession> cashSessions = getCashSessionsForDate(storeId, date);
        SessionTotalsDto cashTotals = createSessionTotals(cashSessions, "CASH");
        
        return new ZReportDto(
                UUID.randomUUID(),
                storeId,
                date,
                LocalDateTime.now(),
                "system",
                cashTotals,
                new SessionTotalsDto(null, "MOBILE", BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"),
                new SessionTotalsDto(null, "OTHER", BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"),
                cashTotals.getInitialAmount(),
                cashTotals.getTotalIn(),
                cashTotals.getTotalOut(),
                cashTotals.getExpectedAmount(),
                cashTotals.getRealClosingAmount(),
                cashTotals.getDiscrepancy(),
                createMovementSummary(storeId, date)
        );
    }

    private ZReportDto generateMobileSessionReport(UUID storeId, LocalDate date) {
        List<MobileSession> mobileSessions = getMobileSessionsForDate(storeId, date);
        SessionTotalsDto mobileTotals = createSessionTotals(mobileSessions, "MOBILE");
        
        return new ZReportDto(
                UUID.randomUUID(),
                storeId,
                date,
                LocalDateTime.now(),
                "system",
                new SessionTotalsDto(null, "CASH", BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"),
                mobileTotals,
                new SessionTotalsDto(null, "OTHER", BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"),
                mobileTotals.getInitialAmount(),
                mobileTotals.getTotalIn(),
                mobileTotals.getTotalOut(),
                mobileTotals.getExpectedAmount(),
                mobileTotals.getRealClosingAmount(),
                mobileTotals.getDiscrepancy(),
                createMovementSummary(storeId, date)
        );
    }

    private ZReportDto generateOtherSessionReport(UUID storeId, LocalDate date) {
        List<OtherSession> otherSessions = getOtherSessionsForDate(storeId, date);
        SessionTotalsDto otherTotals = createSessionTotals(otherSessions, "OTHER");
        
        return new ZReportDto(
                UUID.randomUUID(),
                storeId,
                date,
                LocalDateTime.now(),
                "system",
                new SessionTotalsDto(null, "CASH", BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"),
                new SessionTotalsDto(null, "MOBILE", BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, "NONE"),
                otherTotals,
                otherTotals.getInitialAmount(),
                otherTotals.getTotalIn(),
                otherTotals.getTotalOut(),
                otherTotals.getExpectedAmount(),
                otherTotals.getRealClosingAmount(),
                otherTotals.getDiscrepancy(),
                createMovementSummary(storeId, date)
        );
    }
}

