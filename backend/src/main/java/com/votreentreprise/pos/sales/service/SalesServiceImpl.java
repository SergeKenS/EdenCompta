package com.votreentreprise.pos.sales.service;

import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.PaymentMethod;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import com.votreentreprise.pos.inventory.repository.ProductVariantRepository;
import com.votreentreprise.pos.inventory.service.InventoryService;
import com.votreentreprise.pos.sales.domain.Payment;
import com.votreentreprise.pos.sales.domain.Receipt;
import com.votreentreprise.pos.sales.domain.ReceiptLine;
import com.votreentreprise.pos.sales.repository.PaymentRepository;
import com.votreentreprise.pos.sales.repository.ReceiptLineRepository;
import com.votreentreprise.pos.sales.repository.ReceiptRepository;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class SalesServiceImpl implements SalesService {

    private final ReceiptRepository receiptRepository;
    private final ReceiptLineRepository receiptLineRepository;
    private final PaymentRepository paymentRepository;
    private final StoreRepository storeRepository;
    private final ProductVariantRepository productVariantRepository;
    private final InventoryService inventoryService;
    private final SessionService sessionService;

    public SalesServiceImpl(ReceiptRepository receiptRepository,
                            ReceiptLineRepository receiptLineRepository,
                            PaymentRepository paymentRepository,
                            StoreRepository storeRepository,
                            ProductVariantRepository productVariantRepository,
                            InventoryService inventoryService,
                            SessionService sessionService) {
        this.receiptRepository = receiptRepository;
        this.receiptLineRepository = receiptLineRepository;
        this.paymentRepository = paymentRepository;
        this.storeRepository = storeRepository;
        this.productVariantRepository = productVariantRepository;
        this.inventoryService = inventoryService;
        this.sessionService = sessionService;
    }

    @Override
    @Transactional
    public Receipt createReceipt(UUID storeId, String createdBy, String receiptNumber, String sourceOfflineId) {
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));

        return receiptRepository.findByStore_IdAndReceiptNumber(storeId, receiptNumber)
                .orElseGet(() -> {
                    Receipt r = new Receipt(store, receiptNumber, createdBy);
                    r.setSourceOfflineId(sourceOfflineId);
                    return receiptRepository.save(r);
                });
    }

    @Override
    @Transactional
    public ReceiptLine addLine(UUID receiptId, UUID variantId, Quantity quantity, Money unitPrice) {
        if (!quantity.isPositive()) {
            throw new BusinessException("La quantité doit être positive");
        }

        Receipt receipt = receiptRepository.findById(receiptId)
                .orElseThrow(() -> new ResourceNotFoundException("Reçu non trouvé: " + receiptId));

        if (!receipt.canBeModified()) {
            throw new BusinessException("Ce reçu ne peut plus être modifié");
        }

        ProductVariant variant = productVariantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variante non trouvée: " + variantId));

        int nextLineNumber = receipt.getLines().size() + 1;
        ReceiptLine line = new ReceiptLine(receipt, variant, quantity, unitPrice, nextLineNumber);

        // Fixer le coût unitaire au moment de la vente (à récupérer d'avg cost plus tard)
        line.setUnitCost(Money.zero());

        receipt.addLine(line);
        line = receiptLineRepository.save(line);
        receiptRepository.save(receipt);

        return line;
    }

    @Override
    @Transactional
    public Receipt finalizeReceipt(UUID receiptId, String finalizedBy) {
        Receipt receipt = receiptRepository.findById(receiptId)
                .orElseThrow(() -> new ResourceNotFoundException("Reçu non trouvé: " + receiptId));

        if (!receipt.canBeModified()) {
            throw new BusinessException("Seuls les reçus en brouillon peuvent être finalisés");
        }
        if (receipt.getLines().isEmpty()) {
            throw new BusinessException("Impossible de finaliser un reçu sans lignes");
        }

        // Déduire le stock
        for (ReceiptLine line : receipt.getLines()) {
            inventoryService.removeStock(
                    receipt.getStore().getId(),
                    line.getVariant().getId(),
                    line.getQuantity(),
                    receiptId.toString(),
                    "RECEIPT"
            );
        }

        receipt.finalizeReceipt();
        return receiptRepository.save(receipt);
    }

    @Override
    @Transactional
    public Payment addPayment(UUID receiptId, PaymentMethod method, Money amount, String reference) {
        Receipt receipt = receiptRepository.findById(receiptId)
                .orElseThrow(() -> new ResourceNotFoundException("Reçu non trouvé: " + receiptId));
        Payment payment = new Payment(receipt, method, amount, reference);
        payment = paymentRepository.save(payment);
        receipt.addPayment(payment);
        receiptRepository.save(receipt);

        // Enregistrer le mouvement dans la session appropriée si c'est un paiement CASH
        if (method == PaymentMethod.CASH) {
            try {
                // Récupérer la session espèces ouverte
                var cashSession = sessionService.getOpenCashSession(receipt.getStore().getId());
                if (cashSession != null) {
                    sessionService.recordMovement(
                            cashSession.getId().toString(),
                            "CASH",
                            MovementType.IN,
                            MovementReason.SALE,
                            amount,
                            receiptId.toString(),
                            "RECEIPT_PAYMENT",
                            receipt.getCreatedBy(),
                            reference // Utiliser la référence comme sourceOfflineId
                    );
                }
            } catch (Exception e) {
                // Log l'erreur mais ne pas faire échouer le paiement
                // TODO: Ajouter un logger
                System.err.println("Erreur lors de l'enregistrement du mouvement de caisse: " + e.getMessage());
            }
        }

        return payment;
    }

    @Override
    @Transactional(readOnly = true)
    public Receipt getReceipt(UUID receiptId) {
        return receiptRepository.findById(receiptId)
                .orElseThrow(() -> new ResourceNotFoundException("Reçu non trouvé: " + receiptId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Receipt> listReceipts(UUID storeId) {
        // Simple: filtrage en mémoire après fetch; à optimiser par requête si nécessaire
        return receiptRepository.findAll().stream()
                .filter(r -> r.getStore() != null && storeId.equals(r.getStore().getId()))
                .toList();
    }
}


