package com.votreentreprise.pos.inventory.web;

import com.votreentreprise.pos.sales.repository.ReceiptLineRepository;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ReceiptLineRepository receiptLineRepository;

    public ProductController(ReceiptLineRepository receiptLineRepository) {
        this.receiptLineRepository = receiptLineRepository;
    }

    /**
     * Endpoint pour récupérer les produits les plus vendus
     * GET /api/products/top-sellers?storeId&categoryId&from&to
     */
    @PreAuthorize("hasAuthority('REPORTS.VIEW')")
    @GetMapping("/top-sellers")
    public ResponseEntity<List<TopSellerDto>> getTopSellers(
            @RequestParam UUID storeId,
            @RequestParam(required = false) String categoryId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to) {
        
        List<Object[]> results = receiptLineRepository.findTopSellersByQuantity(storeId, categoryId, from, to);
        
        List<TopSellerDto> topSellers = results.stream()
                .map(row -> new TopSellerDto(
                    (UUID) row[0],        // variant.id
                    (String) row[1],      // variant.name
                    (String) row[2],      // product.name
                    (String) row[3],      // product.category
                    (BigDecimal) row[4]   // totalQuantity
                ))
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(topSellers);
    }

    /**
     * DTO pour les produits les plus vendus
     */
    public record TopSellerDto(
            UUID variantId,
            String variantName,
            String productName,
            String category,
            BigDecimal totalQuantitySold
    ) {}
}
