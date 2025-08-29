package com.votreentreprise.pos.security;

import com.votreentreprise.pos.rbac.service.AuthorizationService;
import com.votreentreprise.pos.users.domain.User;
import com.votreentreprise.pos.users.repository.UserRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;
    private final AuthorizationService authorizationService;

    public CustomUserDetailsService(UserRepository userRepository, AuthorizationService authorizationService) {
        this.userRepository = userRepository;
        this.authorizationService = authorizationService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));

        // Récupérer les permissions de l'utilisateur
        Set<String> permissions = authorizationService.getPermissionsForUser(user.getId());
        
        // Construire la liste des autorités (rôles + permissions)
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        
        // Ajouter le rôle principal (pour la compatibilité)
        authorities.add(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
        
        // Ajouter les permissions comme autorités
        for (String permission : permissions) {
            authorities.add(new SimpleGrantedAuthority(permission));
        }

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getUsername())
                .password(user.getPasswordHash())
                .authorities(authorities)
                .accountExpired(false)
                .accountLocked(user.isAccountLocked())
                .credentialsExpired(false)
                .disabled(!user.getStatus().isActive())
                .build();
    }
}
