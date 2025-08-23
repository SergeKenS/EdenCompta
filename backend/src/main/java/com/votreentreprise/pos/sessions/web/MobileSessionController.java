package com.votreentreprise.pos.sessions.web;

import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import com.votreentreprise.pos.sessions.domain.SessionMovement;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.sessions.web.dto.MobileSessionDto;
import com.votreentreprise.pos.sessions.web.dto.SessionMovementDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sessions/mobile")
public class MobileSessionController {

    private final SessionService sessionService;

    public MobileSessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    @PostMapping("/open")
    public ResponseEntity<MobileSessionDto> openSession(@RequestBody OpenSessionRequest request) {
        MobileSession session = sessionService.openMobileSession(
                request.storeId(),
                request.userId(),
                Money.of(request.initialAmount())
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(MobileSessionDto.fromEntity(session));
    }

    @PostMapping("/{sessionId}/close")
    public ResponseEntity<MobileSessionDto> closeSession(
            @PathVariable UUID sessionId,
            @RequestBody CloseSessionRequest request) {
        MobileSession session = sessionService.closeMobileSession(
                sessionId,
                Money.of(request.realClosingAmount()),
                request.note()
        );
        return ResponseEntity.ok(MobileSessionDto.fromEntity(session));
    }

    @GetMapping("/open")
    public ResponseEntity<MobileSessionDto> getOpenSession(@RequestParam UUID storeId) {
        MobileSession session = sessionService.getOpenMobileSession(storeId);
        if (session == null) {
            throw new ResourceNotFoundException("Aucune session mobile ouverte trouvée");
        }
        return ResponseEntity.ok(MobileSessionDto.fromEntity(session));
    }

    @GetMapping("/{sessionId}")
    public ResponseEntity<MobileSessionDto> getSession(@PathVariable UUID sessionId) {
        MobileSession session = sessionService.getMobileSession(sessionId);
        return ResponseEntity.ok(MobileSessionDto.fromEntity(session));
    }

    @GetMapping
    public ResponseEntity<List<MobileSessionDto>> getSessionsByStore(@RequestParam UUID storeId) {
        List<MobileSession> sessions = sessionService.getMobileSessionsByStore(storeId);
        List<MobileSessionDto> dtos = sessions.stream()
                .map(MobileSessionDto::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }

    @PostMapping("/{sessionId}/movements")
    public ResponseEntity<SessionMovementDto> recordMovement(
            @PathVariable UUID sessionId,
            @RequestBody RecordMovementRequest request) {
        SessionMovement movement = sessionService.recordMovement(
                sessionId.toString(),
                "MOBILE",
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
        List<SessionMovement> movements = sessionService.getMovementsBySession(sessionId.toString(), "MOBILE");
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

