package com.votreentreprise.pos.sessions.service;

import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.sessions.repository.CashSessionRepository;
import com.votreentreprise.pos.sessions.repository.MobileSessionRepository;
import com.votreentreprise.pos.sessions.repository.OtherSessionRepository;
import com.votreentreprise.pos.sessions.repository.SessionMovementRepository;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class SessionServiceImpl implements SessionService {

    private final CashSessionRepository cashSessionRepository;
    private final MobileSessionRepository mobileSessionRepository;
    private final OtherSessionRepository otherSessionRepository;
    private final SessionMovementRepository sessionMovementRepository;
    private final StoreRepository storeRepository;

    public SessionServiceImpl(CashSessionRepository cashSessionRepository,
                             MobileSessionRepository mobileSessionRepository,
                             OtherSessionRepository otherSessionRepository,
                             SessionMovementRepository sessionMovementRepository,
                             StoreRepository storeRepository) {
        this.cashSessionRepository = cashSessionRepository;
        this.mobileSessionRepository = mobileSessionRepository;
        this.otherSessionRepository = otherSessionRepository;
        this.sessionMovementRepository = sessionMovementRepository;
        this.storeRepository = storeRepository;
    }

    // Cash Session operations
    @Override
    @Transactional
    public CashSession openCashSession(UUID storeId, String userId, Money initialAmount) {
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));

        // Check if there's already an open session
        if (getOpenCashSession(storeId) != null) {
            throw new BusinessException("Une session espèces est déjà ouverte pour ce magasin");
        }

        CashSession session = new CashSession(store, userId, initialAmount);
        return cashSessionRepository.save(session);
    }

    @Override
    @Transactional
    public CashSession closeCashSession(UUID sessionId, Money realClosingAmount, String note) {
        CashSession session = getCashSession(sessionId);
        session.closeSession(realClosingAmount, note);
        return cashSessionRepository.save(session);
    }

    @Override
    @Transactional(readOnly = true)
    public CashSession getCashSession(UUID sessionId) {
        return cashSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResourceNotFoundException("Session espèces non trouvée: " + sessionId));
    }

    @Override
    @Transactional(readOnly = true)
    public CashSession getOpenCashSession(UUID storeId) {
        return cashSessionRepository.findByStore_IdAndStatus(storeId, SessionStatus.OPEN).orElse(null);
    }

    // Mobile Session operations
    @Override
    @Transactional
    public MobileSession openMobileSession(UUID storeId, String userId, Money initialAmount) {
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));

        // Check if there's already an open session
        if (getOpenMobileSession(storeId) != null) {
            throw new BusinessException("Une session mobile est déjà ouverte pour ce magasin");
        }

        MobileSession session = new MobileSession(store, userId, initialAmount);
        return mobileSessionRepository.save(session);
    }

    @Override
    @Transactional
    public MobileSession closeMobileSession(UUID sessionId, Money realClosingAmount, String note) {
        MobileSession session = getMobileSession(sessionId);
        session.closeSession(realClosingAmount, note);
        return mobileSessionRepository.save(session);
    }

    @Override
    @Transactional(readOnly = true)
    public MobileSession getMobileSession(UUID sessionId) {
        return mobileSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResourceNotFoundException("Session mobile non trouvée: " + sessionId));
    }

    @Override
    @Transactional(readOnly = true)
    public MobileSession getOpenMobileSession(UUID storeId) {
        return mobileSessionRepository.findByStore_IdAndStatus(storeId, SessionStatus.OPEN).orElse(null);
    }

    // Other Session operations
    @Override
    @Transactional
    public OtherSession openOtherSession(UUID storeId, String userId, Money initialAmount) {
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));

        // Check if there's already an open session
        if (getOpenOtherSession(storeId) != null) {
            throw new BusinessException("Une session autre est déjà ouverte pour ce magasin");
        }

        OtherSession session = new OtherSession(store, userId, initialAmount);
        return otherSessionRepository.save(session);
    }

    @Override
    @Transactional
    public OtherSession closeOtherSession(UUID sessionId, Money realClosingAmount, String note) {
        OtherSession session = getOtherSession(sessionId);
        session.closeSession(realClosingAmount, note);
        return otherSessionRepository.save(session);
    }

    @Override
    @Transactional(readOnly = true)
    public OtherSession getOtherSession(UUID sessionId) {
        return otherSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResourceNotFoundException("Session autre non trouvée: " + sessionId));
    }

    @Override
    @Transactional(readOnly = true)
    public OtherSession getOpenOtherSession(UUID storeId) {
        return otherSessionRepository.findByStore_IdAndStatus(storeId, SessionStatus.OPEN).orElse(null);
    }

    // Movement operations
    @Override
    @Transactional
    public SessionMovement recordMovement(String sessionId, String sessionType, MovementType type,
                                         MovementReason reason, Money amount, String reference,
                                         String referenceType, String createdBy, String sourceOfflineId) {
        
        // Check if movement already exists (idempotence)
        if (sourceOfflineId != null) {
            // TODO: Add query to check if movement with sourceOfflineId already exists
        }

        SessionMovement movement = new SessionMovement(sessionId, sessionType, type, reason, 
                                                      amount, reference, referenceType, createdBy);
        movement.setSourceOfflineId(sourceOfflineId);

        // Add movement to appropriate session
        switch (sessionType.toUpperCase()) {
            case "CASH":
                CashSession cashSession = getCashSession(UUID.fromString(sessionId));
                movement.setCashSession(cashSession);
                cashSession.addMovement(movement);
                cashSessionRepository.save(cashSession);
                break;
            case "MOBILE":
                MobileSession mobileSession = getMobileSession(UUID.fromString(sessionId));
                movement.setMobileSession(mobileSession);
                mobileSession.addMovement(movement);
                mobileSessionRepository.save(mobileSession);
                break;
            case "OTHER":
                OtherSession otherSession = getOtherSession(UUID.fromString(sessionId));
                movement.setOtherSession(otherSession);
                otherSession.addMovement(movement);
                otherSessionRepository.save(otherSession);
                break;
            default:
                throw new BusinessException("Type de session invalide: " + sessionType);
        }

        return sessionMovementRepository.save(movement);
    }

    // Query operations
    @Override
    @Transactional(readOnly = true)
    public List<SessionMovement> getMovementsBySession(String sessionId, String sessionType) {
        // TODO: Implement query to get movements by session
        return List.of();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CashSession> getCashSessionsByStore(UUID storeId) {
        return cashSessionRepository.findAll().stream()
                .filter(session -> storeId.equals(session.getStore().getId()))
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<MobileSession> getMobileSessionsByStore(UUID storeId) {
        return mobileSessionRepository.findAll().stream()
                .filter(session -> storeId.equals(session.getStore().getId()))
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<OtherSession> getOtherSessionsByStore(UUID storeId) {
        return otherSessionRepository.findAll().stream()
                .filter(session -> storeId.equals(session.getStore().getId()))
                .toList();
    }
}
