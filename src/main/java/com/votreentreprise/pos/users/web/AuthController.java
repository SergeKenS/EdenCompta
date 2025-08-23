package com.votreentreprise.pos.users.web;

import com.votreentreprise.pos.security.JwtTokenProvider;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.service.UserService;
import com.votreentreprise.pos.users.web.dto.UserDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthController(UserService userService, AuthenticationManager authenticationManager, JwtTokenProvider jwtTokenProvider) {
        this.userService = userService;
        this.authenticationManager = authenticationManager;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        try {
            // Authenticate with Spring Security
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.username(), request.password())
            );
            
            // Get user details
            User user = userService.getUserByUsername(request.username());
            
            // Generate JWT token
            String token = jwtTokenProvider.generateToken(user.getUsername(), user.getRole().name(), user.getStore().getId());
            
            return ResponseEntity.ok(new LoginResponse(
                true,
                "Connexion réussie",
                UserDto.fromEntity(user),
                token
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new LoginResponse(false, e.getMessage(), null, null));
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<ApiResponse> changePassword(@RequestBody ChangePasswordRequest request) {
        try {
            userService.changePassword(request.userId(), request.currentPassword(), request.newPassword());
            return ResponseEntity.ok(new ApiResponse(true, "Mot de passe modifié avec succès"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse> resetPassword(@RequestBody ResetPasswordRequest request) {
        try {
            userService.resetPassword(request.userId(), request.newPassword(), request.resetBy());
            return ResponseEntity.ok(new ApiResponse(true, "Mot de passe réinitialisé avec succès"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PostMapping("/unlock-account/{userId}")
    public ResponseEntity<ApiResponse> unlockAccount(@PathVariable UUID userId) {
        try {
            userService.unlockAccount(userId);
            return ResponseEntity.ok(new ApiResponse(true, "Compte déverrouillé avec succès"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, e.getMessage()));
        }
    }

    // Request/Response DTOs
    public record LoginRequest(String username, String password) {}
    
    public record LoginResponse(boolean success, String message, UserDto user, String token) {}
    
    public record ChangePasswordRequest(UUID userId, String currentPassword, String newPassword) {}
    
    public record ResetPasswordRequest(UUID userId, String newPassword, String resetBy) {}
    
    public record ApiResponse(boolean success, String message) {}
}

