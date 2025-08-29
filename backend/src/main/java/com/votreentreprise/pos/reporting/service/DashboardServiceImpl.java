package com.votreentreprise.pos.reporting.service;

import com.votreentreprise.pos.cashflow.service.CashflowService;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.expenses.service.ExpenseService;
import com.votreentreprise.pos.inventory.domain.InventoryLevel;
import com.votreentreprise.pos.inventory.repository.InventoryLevelRepository;
import com.votreentreprise.pos.reporting.web.dto.DashboardSummaryDto;
import com.votreentreprise.pos.reporting.web.dto.TopProductDto;
import com.votreentreprise.pos.sales.domain.Receipt;
import com.votreentreprise.pos.sales.service.SalesService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class DashboardServiceImpl implements DashboardService {

    private final CashflowService cashflowService;
    private final ExpenseService expenseService;
    private final SalesService salesService;
    private final InventoryLevelRepository inventoryLevelRepository;

    public DashboardServiceImpl(CashflowService cashflowService,
                                ExpenseService expenseService,
                                SalesService salesService,
                                InventoryLevelRepository inventoryLevelRepository) {
        this.cashflowService = cashflowService;
        this.expenseService = expenseService;
        this.salesService = salesService;
        this.inventoryLevelRepository = inventoryLevelRepository;
    }

    @Override
    public DashboardSummaryDto buildSummary(UUID storeId, LocalDateTime from, LocalDateTime to) {
        LocalDateTime start = from != null ? from : LocalDateTime.now().minusDays(30);
        LocalDateTime end = to != null ? to : LocalDateTime.now();

        // Totaux flux
        var totalIn = cashflowService.getTotalAmountsByType(storeId, start, end)
                .getOrDefault(com.votreentreprise.pos.common.types.CashMovementType.IN, Money.zero());
        var totalOut = cashflowService.getTotalAmountsByType(storeId, start, end)
                .getOrDefault(com.votreentreprise.pos.common.types.CashMovementType.OUT, Money.zero());
        Money net = cashflowService.getNetCashflow(storeId, start, end);

        // Dépenses
        var expensesInRange = expenseService.getExpensesByStoreAndDateRange(storeId, start, end);
        BigDecimal totalExpenses = expensesInRange.stream()
                .map(e -> e.getAmount().getAmount())
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Ventes (total sur reçus finalisés)
        List<Receipt> receipts = salesService.listReceipts(storeId);
        BigDecimal totalSales = receipts.stream()
                .filter(r -> r.getFinalizedAt() != null && !r.getFinalizedAt().isBefore(start) && !r.getFinalizedAt().isAfter(end))
                .map(r -> r.getTotalAmount().getAmount())
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Top produits (par quantité vendue)
        List<TopProductDto> topProducts = receipts.stream()
                .filter(r -> r.getFinalizedAt() != null && !r.getFinalizedAt().isBefore(start) && !r.getFinalizedAt().isAfter(end))
                .flatMap(r -> r.getLines().stream())
                .collect(Collectors.groupingBy(l -> l.getVariant().getProduct(),
                        Collectors.reducing(BigDecimal.ZERO, l -> l.getQuantity().getValue(), BigDecimal::add)))
                .entrySet().stream()
                .sorted(Map.Entry.<com.votreentreprise.pos.inventory.domain.Product, BigDecimal>comparingByValue().reversed())
                .limit(5)
                .map(e -> new TopProductDto(e.getKey().getId(), e.getKey().getName(), e.getValue()))
                .toList();

        // Low stock / Out of stock
        List<InventoryLevel> allLevels = inventoryLevelRepository.findByStoreId(storeId);
        var lowStock = allLevels.stream()
                .filter(l -> l.getQuantityOnHand().getValue().compareTo(new BigDecimal("5")) <= 0
                        && l.getQuantityOnHand().getValue().compareTo(BigDecimal.ZERO) > 0)
                .limit(10)
                .map(l -> new DashboardSummaryDto.LowStockItem(
                        l.getVariant().getProduct().getId(),
                        l.getVariant().getProduct().getName(),
                        l.getQuantityOnHand().getValue()
                ))
                .toList();

        var outOfStock = allLevels.stream()
                .filter(l -> l.getQuantityOnHand().getValue().compareTo(BigDecimal.ZERO) <= 0)
                .limit(10)
                .map(l -> new DashboardSummaryDto.OutOfStockItem(
                        l.getVariant().getProduct().getId(),
                        l.getVariant().getProduct().getName()
                ))
                .toList();

        return new DashboardSummaryDto(
                totalSales,
                totalExpenses,
                net.getAmount(),
                cashTotal(storeId, start, end),
                mobileTotal(storeId, start, end),
                topProducts,
                lowStock,
                outOfStock
        );
    }

    private BigDecimal cashTotal(UUID storeId, LocalDateTime start, LocalDateTime end) {
        var totals = cashflowService.getTotalAmountsByType(storeId, start, end);
        return totals.getOrDefault(com.votreentreprise.pos.common.types.CashMovementType.IN, Money.zero()).getAmount();
    }

    private BigDecimal mobileTotal(UUID storeId, LocalDateTime start, LocalDateTime end) {
        // Placeholder: dépend des colonnes de cashflow par méthode de paiement (à étendre plus tard)
        return BigDecimal.ZERO;
    }
}


