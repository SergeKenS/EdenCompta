package com.votreentreprise.pos.sales.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.PaymentMethod;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.sales.domain.Payment;
import com.votreentreprise.pos.sales.domain.Receipt;
import com.votreentreprise.pos.sales.domain.ReceiptLine;

import java.util.List;
import java.util.UUID;

public interface SalesService {
    Receipt createReceipt(UUID storeId, String createdBy, String receiptNumber, String sourceOfflineId);
    ReceiptLine addLine(UUID receiptId, UUID variantId, Quantity quantity, Money unitPrice);
    Receipt finalizeReceipt(UUID receiptId, String finalizedBy);
    Payment addPayment(UUID receiptId, PaymentMethod method, Money amount, String reference);
    Receipt getReceipt(UUID receiptId);
    List<Receipt> listReceipts(UUID storeId);
}


