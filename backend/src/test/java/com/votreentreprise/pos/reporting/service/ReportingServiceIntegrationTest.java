package com.votreentreprise.pos.reporting.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.reporting.web.dto.DailySummaryDto;
import com.votreentreprise.pos.reporting.web.dto.ZReportDto;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class ReportingServiceIntegrationTest {

    @Autowired
    private ReportingService reportingService;

    @Autowired
    private SessionService sessionService;

    private UUID testStoreId;
    private String testUserId;
    private LocalDate testDate;

    @BeforeEach
    void setUp() {
        testStoreId = TestDataBuilder.TEST_STORE_ID;
        testUserId = "test-user";
        testDate = LocalDate.now();
    }

    @Test
    void shouldGenerateZReportForCurrentDate() {
        // Given - Open sessions for testing
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));
        sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("25.00")));

        // When
        ZReportDto report = reportingService.generateCurrentZReport(testStoreId);

        // Then
        assertThat(report).isNotNull();
        assertThat(report.getStoreId()).isEqualTo(testStoreId);
        assertThat(report.getReportDate()).isEqualTo(testDate);
        assertThat(report.getGeneratedAt()).isNotNull();
        assertThat(report.getGeneratedBy()).isEqualTo("system");

        // Verify session totals
        assertThat(report.getCashSession()).isNotNull();
        assertThat(report.getMobileSession()).isNotNull();
        assertThat(report.getOtherSession()).isNotNull();

        // Verify global totals
        assertThat(report.getTotalInitialAmount()).isEqualTo(new BigDecimal("175.00")); // 100 + 50 + 25
        assertThat(report.getTotalIn()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getTotalOut()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getTotalExpectedAmount()).isEqualTo(new BigDecimal("175.00"));
    }

    @Test
    void shouldGenerateZReportForSpecificDate() {
        // Given - Open sessions
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));

        // When
        ZReportDto report = reportingService.generateZReport(testStoreId, testDate);

        // Then
        assertThat(report).isNotNull();
        assertThat(report.getReportDate()).isEqualTo(testDate);
        assertThat(report.getCashSession().getInitialAmount()).isEqualTo(new BigDecimal("100.00"));
        assertThat(report.getMobileSession().getInitialAmount()).isEqualTo(new BigDecimal("50.00"));
        assertThat(report.getOtherSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    void shouldGenerateDailySummary() {
        // Given - Open sessions
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));

        // When
        DailySummaryDto summary = reportingService.generateDailySummary(testStoreId, testDate);

        // Then
        assertThat(summary).isNotNull();
        assertThat(summary.getStoreId()).isEqualTo(testStoreId);
        assertThat(summary.getDate()).isEqualTo(testDate);
        // Note: Les calculs de ventes/remboursements sont TODO dans l'implémentation
        assertThat(summary.getTotalSales()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(summary.getTotalRefunds()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(summary.getTotalExpenses()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(summary.getNetAmount()).isEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    void shouldGenerateCashSessionReport() {
        // Given - Open cash session
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));

        // When
        ZReportDto report = reportingService.generateSessionReport(testStoreId, "CASH", testDate);

        // Then
        assertThat(report).isNotNull();
        assertThat(report.getCashSession().getInitialAmount()).isEqualTo(new BigDecimal("100.00"));
        assertThat(report.getMobileSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getOtherSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getTotalInitialAmount()).isEqualTo(new BigDecimal("100.00"));
    }

    @Test
    void shouldGenerateMobileSessionReport() {
        // Given - Open mobile session
        sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("75.00")));

        // When
        ZReportDto report = reportingService.generateSessionReport(testStoreId, "MOBILE", testDate);

        // Then
        assertThat(report).isNotNull();
        assertThat(report.getCashSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getMobileSession().getInitialAmount()).isEqualTo(new BigDecimal("75.00"));
        assertThat(report.getOtherSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getTotalInitialAmount()).isEqualTo(new BigDecimal("75.00"));
    }

    @Test
    void shouldGenerateOtherSessionReport() {
        // Given - Open other session
        sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("30.00")));

        // When
        ZReportDto report = reportingService.generateSessionReport(testStoreId, "OTHER", testDate);

        // Then
        assertThat(report).isNotNull();
        assertThat(report.getCashSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getMobileSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getOtherSession().getInitialAmount()).isEqualTo(new BigDecimal("30.00"));
        assertThat(report.getTotalInitialAmount()).isEqualTo(new BigDecimal("30.00"));
    }

    @Test
    void shouldHandleEmptySessions() {
        // Given - No sessions opened

        // When
        ZReportDto report = reportingService.generateZReport(testStoreId, testDate);

        // Then
        assertThat(report).isNotNull();
        assertThat(report.getCashSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getMobileSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getOtherSession().getInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getTotalInitialAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(report.getTotalExpectedAmount()).isEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    void shouldCalculateGlobalTotalsCorrectly() {
        // Given - Open sessions with different amounts
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));
        sessionService.openMobileSession(testStoreId, testUserId, Money.of(new BigDecimal("50.00")));
        sessionService.openOtherSession(testStoreId, testUserId, Money.of(new BigDecimal("25.00")));

        // When
        ZReportDto report = reportingService.generateZReport(testStoreId, testDate);

        // Then
        assertThat(report.getTotalInitialAmount()).isEqualTo(new BigDecimal("175.00")); // 100 + 50 + 25
        assertThat(report.getTotalExpectedAmount()).isEqualTo(new BigDecimal("175.00")); // Initial + In - Out (0 + 0 - 0)
    }
}
