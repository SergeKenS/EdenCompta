package com.votreentreprise.pos.users.web;

import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.domain.UserRole;
import com.votreentreprise.pos.users.domain.UserStatus;
import com.votreentreprise.pos.users.service.UserService;
import com.votreentreprise.pos.users.web.dto.UserDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // CRUD operations
    @PostMapping
    public ResponseEntity<UserDto> createUser(@RequestBody CreateUserRequest request) {
        UserRole role = UserRole.valueOf(request.role().toUpperCase());
        User user = userService.createUser(
            request.username(), request.email(), request.password(),
            request.firstName(), request.lastName(), role,
            request.storeId(), request.createdBy()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(UserDto.fromEntity(user));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<UserDto> getUserById(@PathVariable UUID userId) {
        User user = userService.getUserById(userId);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @GetMapping("/username/{username}")
    public ResponseEntity<UserDto> getUserByUsername(@PathVariable String username) {
        User user = userService.getUserByUsername(username);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<UserDto> getUserByEmail(@PathVariable String email) {
        User user = userService.getUserByEmail(email);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @PutMapping("/{userId}")
    public ResponseEntity<UserDto> updateUser(@PathVariable UUID userId, @RequestBody UpdateUserRequest request) {
        UserRole role = UserRole.valueOf(request.role().toUpperCase());
        User user = userService.updateUser(
            userId, request.firstName(), request.lastName(),
            request.email(), request.phone(), role, request.storeId()
        );
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<ApiResponse> deleteUser(@PathVariable UUID userId, @RequestParam String deletedBy) {
        userService.deleteUser(userId, deletedBy);
        return ResponseEntity.ok(new ApiResponse(true, "Utilisateur supprimé avec succès"));
    }

    // Status management
    @PostMapping("/{userId}/activate")
    public ResponseEntity<UserDto> activateUser(@PathVariable UUID userId, @RequestParam String activatedBy) {
        User user = userService.activateUser(userId, activatedBy);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @PostMapping("/{userId}/deactivate")
    public ResponseEntity<UserDto> deactivateUser(@PathVariable UUID userId, @RequestParam String deactivatedBy) {
        User user = userService.deactivateUser(userId, deactivatedBy);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @PostMapping("/{userId}/suspend")
    public ResponseEntity<UserDto> suspendUser(@PathVariable UUID userId, @RequestParam String reason, @RequestParam String suspendedBy) {
        User user = userService.suspendUser(userId, reason, suspendedBy);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    @PostMapping("/{userId}/unsuspend")
    public ResponseEntity<UserDto> unsuspendUser(@PathVariable UUID userId, @RequestParam String unsuspendedBy) {
        User user = userService.unsuspendUser(userId, unsuspendedBy);
        return ResponseEntity.ok(UserDto.fromEntity(user));
    }

    // Query methods
    @GetMapping("/store/{storeId}")
    public ResponseEntity<List<UserDto>> getUsersByStore(@PathVariable UUID storeId) {
        List<User> users = userService.getUsersByStore(storeId);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/store/{storeId}/page")
    public ResponseEntity<Page<UserDto>> getUsersByStorePageable(@PathVariable UUID storeId, Pageable pageable) {
        Page<User> users = userService.getUsersByStore(storeId, pageable);
        Page<UserDto> userDtos = users.map(UserDto::fromEntity);
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/role/{role}")
    public ResponseEntity<List<UserDto>> getUsersByRole(@PathVariable String role) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        List<User> users = userService.getUsersByRole(userRole);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/store/{storeId}/role/{role}")
    public ResponseEntity<List<UserDto>> getUsersByStoreAndRole(@PathVariable UUID storeId, @PathVariable String role) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        List<User> users = userService.getUsersByStoreAndRole(storeId, userRole);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<UserDto>> getUsersByStatus(@PathVariable String status) {
        UserStatus userStatus = UserStatus.valueOf(status.toUpperCase());
        List<User> users = userService.getUsersByStatus(userStatus);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/active")
    public ResponseEntity<List<UserDto>> getActiveUsers() {
        List<User> users = userService.getActiveUsers();
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/store/{storeId}/active")
    public ResponseEntity<List<UserDto>> getActiveUsersByStore(@PathVariable UUID storeId) {
        List<User> users = userService.getActiveUsersByStore(storeId);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/search")
    public ResponseEntity<List<UserDto>> searchUsers(@RequestParam String searchTerm) {
        List<User> users = userService.searchUsers(searchTerm);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/store/{storeId}/search")
    public ResponseEntity<List<UserDto>> searchUsersInStore(@PathVariable UUID storeId, @RequestParam String searchTerm) {
        List<User> users = userService.searchUsersInStore(storeId, searchTerm);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    // Statistics
    @GetMapping("/count/status/{status}")
    public ResponseEntity<Long> countUsersByStatus(@PathVariable String status) {
        UserStatus userStatus = UserStatus.valueOf(status.toUpperCase());
        long count = userService.countUsersByStatus(userStatus);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/count/store/{storeId}/status/{status}")
    public ResponseEntity<Long> countUsersByStoreAndStatus(@PathVariable UUID storeId, @PathVariable String status) {
        UserStatus userStatus = UserStatus.valueOf(status.toUpperCase());
        long count = userService.countUsersByStoreAndStatus(storeId, userStatus);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/count/role/{role}")
    public ResponseEntity<Long> countUsersByRole(@PathVariable String role) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        long count = userService.countUsersByRole(userRole);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/count/store/{storeId}/role/{role}")
    public ResponseEntity<Long> countUsersByStoreAndRole(@PathVariable UUID storeId, @PathVariable String role) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        long count = userService.countUsersByStoreAndRole(storeId, userRole);
        return ResponseEntity.ok(count);
    }

    // Security
    @GetMapping("/failed-logins")
    public ResponseEntity<List<UserDto>> getUsersWithFailedLogins(@RequestParam(defaultValue = "5") Integer threshold) {
        List<User> users = userService.getUsersWithFailedLogins(threshold);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    @GetMapping("/store/{storeId}/failed-logins")
    public ResponseEntity<List<UserDto>> getUsersWithFailedLoginsInStore(@PathVariable UUID storeId, @RequestParam(defaultValue = "5") Integer threshold) {
        List<User> users = userService.getUsersWithFailedLoginsInStore(storeId, threshold);
        List<UserDto> userDtos = users.stream()
            .map(UserDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(userDtos);
    }

    // Validation
    @GetMapping("/check/username/{username}")
    public ResponseEntity<Boolean> isUsernameAvailable(@PathVariable String username) {
        boolean available = userService.isUsernameAvailable(username);
        return ResponseEntity.ok(available);
    }

    @GetMapping("/check/email/{email}")
    public ResponseEntity<Boolean> isEmailAvailable(@PathVariable String email) {
        boolean available = userService.isEmailAvailable(email);
        return ResponseEntity.ok(available);
    }

    // Role-based access control
    @GetMapping("/{userId}/has-role/{role}")
    public ResponseEntity<Boolean> hasRole(@PathVariable UUID userId, @PathVariable String role) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        boolean hasRole = userService.hasRole(userId, userRole);
        return ResponseEntity.ok(hasRole);
    }

    @GetMapping("/{userId}/can-perform/{action}")
    public ResponseEntity<Boolean> canPerformAction(@PathVariable UUID userId, @PathVariable String action) {
        boolean canPerform = userService.canPerformAction(userId, action);
        return ResponseEntity.ok(canPerform);
    }

    // Store management
    @PostMapping("/{userId}/assign-store/{storeId}")
    public ResponseEntity<ApiResponse> assignUserToStore(@PathVariable UUID userId, @PathVariable UUID storeId) {
        userService.assignUserToStore(userId, storeId);
        return ResponseEntity.ok(new ApiResponse(true, "Utilisateur assigné au magasin avec succès"));
    }

    @PostMapping("/{userId}/remove-store")
    public ResponseEntity<ApiResponse> removeUserFromStore(@PathVariable UUID userId) {
        userService.removeUserFromStore(userId);
        return ResponseEntity.ok(new ApiResponse(true, "Utilisateur retiré du magasin avec succès"));
    }

    // Request/Response DTOs
    public record CreateUserRequest(
        String username, String email, String password,
        String firstName, String lastName, String role,
        UUID storeId, String createdBy
    ) {}

    public record UpdateUserRequest(
        String firstName, String lastName, String email,
        String phone, String role, UUID storeId
    ) {}

    public record ApiResponse(boolean success, String message) {}
}
