package com.votreentreprise.pos.reporting.web.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public class DailySummaryDto {
    private UUID storeId;
    private LocalDate date;
    private BigDecimal totalSales;
    private BigDecimal totalRefunds;
    private BigDecimal totalExpenses;
    private BigDecimal netAmount;
    private int totalTransactions;
    private int totalReceipts;

    public DailySummaryDto() {}

    public DailySummaryDto(UUID storeId, LocalDate date, BigDecimal totalSales, BigDecimal totalRefunds,
                           BigDecimal totalExpenses, BigDecimal netAmount, int totalTransactions, int totalReceipts) {
        this.storeId = storeId;
        this.date = date;
        this.totalSales = totalSales;
        this.totalRefunds = totalRefunds;
        this.totalExpenses = totalExpenses;
        this.netAmount = netAmount;
        this.totalTransactions = totalTransactions;
        this.totalReceipts = totalReceipts;
    }

    // Getters and Setters
    public UUID getStoreId() { return storeId; }
    public void setStoreId(UUID storeId) { this.storeId = storeId; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public BigDecimal getTotalSales() { return totalSales; }
    public void setTotalSales(BigDecimal totalSales) { this.totalSales = totalSales; }

    public BigDecimal getTotalRefunds() { return totalRefunds; }
    public void setTotalRefunds(BigDecimal totalRefunds) { this.totalRefunds = totalRefunds; }

    public BigDecimal getTotalExpenses() { return totalExpenses; }
    public void setTotalExpenses(BigDecimal totalExpenses) { this.totalExpenses = totalExpenses; }

    public BigDecimal getNetAmount() { return netAmount; }
    public void setNetAmount(BigDecimal netAmount) { this.netAmount = netAmount; }

    public int getTotalTransactions() { return totalTransactions; }
    public void setTotalTransactions(int totalTransactions) { this.totalTransactions = totalTransactions; }

    public int getTotalReceipts() { return totalReceipts; }
    public void setTotalReceipts(int totalReceipts) { this.totalReceipts = totalReceipts; }
}

