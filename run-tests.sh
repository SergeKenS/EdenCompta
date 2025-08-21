#!/bin/bash

echo "🧪 Lancement des tests complets pour l'Étape 1 - Module Receiving"
echo "=================================================================="

# Tests unitaires des repositories
echo "📊 Tests des repositories..."
mvn test -Dtest="*RepositoryTest"

# Tests unitaires des services
echo "🔧 Tests des services..."
mvn test -Dtest="*ServiceTest"

# Tests des contrôleurs
echo "🌐 Tests des contrôleurs..."
mvn test -Dtest="*ControllerTest"

# Tests d'intégration
echo "🔗 Tests d'intégration..."
mvn test -Dtest="*IntegrationTest"

# Test complet du contexte
echo "🚀 Test du contexte complet..."
mvn test -Dtest="PosApplicationTests"

echo "✅ Tous les tests terminés !"