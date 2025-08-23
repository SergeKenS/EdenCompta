package com.votreentreprise.pos.sessions.web;

import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.sessions.web.dto.CashSessionDto;
import com.votreentreprise.pos.sessions.web.dto.SessionMovementDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sessions/cash")
public class CashSessionController {

    private final SessionService sessionService;

    public CashSessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    @PostMapping("/open")
    public ResponseEntity<CashSessionDto> openSession(@RequestBody OpenSessionRequest request) {
        CashSession session = sessionService.openCashSession(
                request.storeId(),
                request.userId(),
                Money.of(request.initialAmount())
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(CashSessionDto.fromEntity(session));
    }

    @PostMapping("/{sessionId}/close")
    public ResponseEntity<CashSessionDto> closeSession(
            @PathVariable UUID sessionId,
            @RequestBody CloseSessionRequest request) {
        CashSession session = sessionService.closeCashSession(
                sessionId,
                Money.of(request.realClosingAmount()),
                request.note()
        );
        return ResponseEntity.ok(CashSessionDto.fromEntity(session));
    }

    @GetMapping("/open")
    public ResponseEntity<CashSessionDto> getOpenSession(@RequestParam UUID storeId) {
        CashSession session = sessionService.getOpenCashSession(storeId);
        if (session == null) {
            throw new ResourceNotFoundException("Aucune session espèces ouverte trouvée");
        }
        return ResponseEntity.ok(CashSessionDto.fromEntity(session));
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<CashSessionDto> getSession(@PathVariable UUID sessionId) {
        CashSession session = sessionService.getCashSession(sessionId);
        return ResponseEntity.ok(CashSessionDto.fromEntity(session));
    }

    @GetMapping
    public ResponseEntity<List<CashSessionDto>> getSessionsByStore(@RequestParam UUID storeId) {
        List<CashSession> sessions = sessionService.getCashSessionsByStore(storeId);
        List<CashSessionDto> dtos = sessions.stream()
                .map(CashSessionDto::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }

    @PostMapping("/{sessionId}/movements")
    public ResponseEntity<SessionMovementDto> recordMovement(
            @PathVariable UUID sessionId,
            @RequestBody RecordMovementRequest request) {
        SessionMovement movement = sessionService.recordMovement(
                sessionId.toString(),
                "CASH",
                MovementType.valueOf(request.type()),
                MovementReason.valueOf(request.reason()),
                Money.of(request.amount()),
                request.reference(),
                request.referenceType(),
                request.createdBy(),
                request.sourceOfflineId()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(SessionMovementDto.fromEntity(movement));
    }

    @GetMapping("/{sessionId}/movements")
    public ResponseEntity<List<SessionMovementDto>> getMovements(@PathVariable UUID sessionId) {
        List<SessionMovement> movements = sessionService.getMovementsBySession(sessionId.toString(), "CASH");
        List<SessionMovementDto> dtos = movements.stream()
                .map(SessionMovementDto::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }

    // Request DTOs
    public record OpenSessionRequest(UUID storeId, String userId, BigDecimal initialAmount) {}
    
    public record CloseSessionRequest(BigDecimal realClosingAmount, String note) {}
    
    public record RecordMovementRequest(
            String type,
            String reason,
            BigDecimal amount,
            String reference,
            String referenceType,
            String createdBy,
            String sourceOfflineId
    ) {}
}
