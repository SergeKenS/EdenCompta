package com.votreentreprise.pos.inventory.web;

import com.votreentreprise.pos.inventory.domain.InventoryLevel;
import com.votreentreprise.pos.inventory.repository.InventoryLevelRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
public class ProductQueryController {

    private final InventoryLevelRepository inventoryLevelRepository;

    public ProductQueryController(InventoryLevelRepository inventoryLevelRepository) {
        this.inventoryLevelRepository = inventoryLevelRepository;
    }

    @PreAuthorize("hasAuthority('INVENTORY.VIEW') or hasAuthority('INVENTORY.RECEIVE') or hasAuthority('REPORTS.VIEW')")
    @GetMapping("/low-stock")
    public ResponseEntity<?> getLowStock(
            @RequestParam UUID storeId,
            @RequestParam(defaultValue = "5") BigDecimal threshold
    ) {
        List<InventoryLevel> levels = inventoryLevelRepository.findByStoreId(storeId);
        var result = levels.stream()
                .filter(l -> l.getQuantityOnHand().getValue().compareTo(BigDecimal.ZERO) > 0
                        && l.getQuantityOnHand().getValue().compareTo(threshold) <= 0)
                .map(l -> Map.of(
                        "productId", l.getVariant().getProduct().getId(),
                        "name", l.getVariant().getProduct().getName(),
                        "stock", l.getQuantityOnHand().getValue(),
                        "stockStatus", "LOW_STOCK"
                ))
                .collect(Collectors.toList());
        return ResponseEntity.ok().body(result);
    }

    @PreAuthorize("hasAuthority('INVENTORY.VIEW') or hasAuthority('INVENTORY.RECEIVE') or hasAuthority('REPORTS.VIEW')")
    @GetMapping("/out-of-stock")
    public ResponseEntity<?> getOutOfStock(@RequestParam UUID storeId) {
        List<InventoryLevel> levels = inventoryLevelRepository.findOutOfStockByStore(storeId);
        var result = levels.stream()
                .map(l -> Map.of(
                        "productId", l.getVariant().getProduct().getId(),
                        "name", l.getVariant().getProduct().getName(),
                        "stockStatus", "OUT_OF_STOCK"
                ))
                .collect(Collectors.toList());
        return ResponseEntity.ok().body(result);
    }
}


