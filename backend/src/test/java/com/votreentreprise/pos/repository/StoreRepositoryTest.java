package com.votreentreprise.pos.repository;

import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class StoreRepositoryTest {

    @Autowired
    private StoreRepository storeRepository;

    @Test
    void shouldSaveAndFindStore() {
        // Given
        Store store = TestDataBuilder.createTestStore();

        // When
        Store saved = storeRepository.save(store);
        Optional<Store> found = storeRepository.findById(saved.getId());

        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("Magasin Test");
        assertThat(found.get().getAddress()).isEqualTo("123 Rue Test");
    }

    @Test
    void shouldFindByName() {
        // Given
        Store store = TestDataBuilder.createTestStore();
        storeRepository.save(store);

        // When
        Optional<Store> found = storeRepository.findByName("Magasin Test");

        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("Magasin Test");
    }

    @Test
    void shouldCheckExistsByName() {
        // Given
        Store store = TestDataBuilder.createTestStore();
        storeRepository.save(store);

        // When & Then
        assertThat(storeRepository.existsByName("Magasin Test")).isTrue();
        assertThat(storeRepository.existsByName("Magasin Inexistant")).isFalse();
    }
}