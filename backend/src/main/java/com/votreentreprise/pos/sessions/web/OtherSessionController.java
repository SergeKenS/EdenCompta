package com.votreentreprise.pos.sessions.web;

import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.sessions.web.dto.OtherSessionDto;
import com.votreentreprise.pos.sessions.web.dto.SessionMovementDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sessions/other")
public class OtherSessionController {

    private final SessionService sessionService;

    public OtherSessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    @PostMapping("/open")
    public ResponseEntity<OtherSessionDto> openSession(@RequestBody OpenSessionRequest request) {
        OtherSession session = sessionService.openOtherSession(
                request.storeId(),
                request.userId(),
                Money.of(request.initialAmount())
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(OtherSessionDto.fromEntity(session));
    }

    @PostMapping("/{sessionId}/close")
    public ResponseEntity<OtherSessionDto> closeSession(
            @PathVariable UUID sessionId,
            @RequestBody CloseSessionRequest request) {
        OtherSession session = sessionService.closeOtherSession(
                sessionId,
                Money.of(request.realClosingAmount()),
                request.note()
        );
        return ResponseEntity.ok(OtherSessionDto.fromEntity(session));
    }

    @GetMapping("/open")
    public ResponseEntity<OtherSessionDto> getOpenSession(@RequestParam UUID storeId) {
        OtherSession session = sessionService.getOpenOtherSession(storeId);
        if (session == null) {
            throw new ResourceNotFoundException("Aucune session autre ouverte trouvée");
        }
        return ResponseEntity.ok(OtherSessionDto.fromEntity(session));
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<OtherSessionDto> getSession(@PathVariable UUID sessionId) {
        OtherSession session = sessionService.getOtherSession(sessionId);
        return ResponseEntity.ok(OtherSessionDto.fromEntity(session));
    }

    @GetMapping
    public ResponseEntity<List<OtherSessionDto>> getSessionsByStore(@RequestParam UUID storeId) {
        List<OtherSession> sessions = sessionService.getOtherSessionsByStore(storeId);
        List<OtherSessionDto> dtos = sessions.stream()
                .map(OtherSessionDto::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }

    @PostMapping("/{sessionId}/movements")
    public ResponseEntity<SessionMovementDto> recordMovement(
            @PathVariable UUID sessionId,
            @RequestBody RecordMovementRequest request) {
        SessionMovement movement = sessionService.recordMovement(
                sessionId.toString(),
                "OTHER",
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
        List<SessionMovement> movements = sessionService.getMovementsBySession(sessionId.toString(), "OTHER");
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

