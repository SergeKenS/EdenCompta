package com.votreentreprise.pos.sessions.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;

import java.util.List;
import java.util.UUID;

public interface SessionService {
    
    // Cash Session operations
    CashSession openCashSession(UUID storeId, String userId, Money initialAmount);
    CashSession closeCashSession(UUID sessionId, Money realClosingAmount, String note);
    CashSession getCashSession(UUID sessionId);
    CashSession getOpenCashSession(UUID storeId);
    
    // Mobile Session operations
    MobileSession openMobileSession(UUID storeId, String userId, Money initialAmount);
    MobileSession closeMobileSession(UUID sessionId, Money realClosingAmount, String note);
    MobileSession getMobileSession(UUID sessionId);
    MobileSession getOpenMobileSession(UUID storeId);
    
    // Other Session operations
    OtherSession openOtherSession(UUID storeId, String userId, Money initialAmount);
    OtherSession closeOtherSession(UUID sessionId, Money realClosingAmount, String note);
    OtherSession getOtherSession(UUID sessionId);
    OtherSession getOpenOtherSession(UUID storeId);
    
    // Movement operations (generic)
    SessionMovement recordMovement(String sessionId, String sessionType, MovementType type, 
                                   MovementReason reason, Money amount, String reference, 
                                   String referenceType, String createdBy, String sourceOfflineId);
    
    // Query operations
    List<SessionMovement> getMovementsBySession(String sessionId, String sessionType);
    List<CashSession> getCashSessionsByStore(UUID storeId);
    List<MobileSession> getMobileSessionsByStore(UUID storeId);
    List<OtherSession> getOtherSessionsByStore(UUID storeId);
}
