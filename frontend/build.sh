#!/bin/bash

# Script de build pour COMPTAB POS
# Usage: ./build.sh [android|ios|web|all]

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_message() {
    echo -e "${GREEN}[COMPTAB POS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVERTISSEMENT]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Vérifier que Flutter est installé
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter n'est pas installé ou n'est pas dans le PATH"
        exit 1
    fi
    
    print_info "Flutter version: $(flutter --version | head -n 1)"
}

# Nettoyer le projet
clean_project() {
    print_message "Nettoyage du projet..."
    flutter clean
    flutter pub get
}

# Générer les fichiers de code
generate_code() {
    print_message "Génération des fichiers de code..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
}

# Build pour Android
build_android() {
    print_message "Build pour Android..."
    
    # Vérifier que Android est configuré
    if ! flutter doctor | grep -q "Android toolchain"; then
        print_warning "Android toolchain non configuré, tentative de configuration..."
        flutter doctor --android-licenses
    fi
    
    # Build APK
    print_info "Création de l'APK..."
    flutter build apk --release --target-platform android-arm64
    
    # Build App Bundle
    print_info "Création de l'App Bundle..."
    flutter build appbundle --release --target-platform android-arm64
    
    print_message "Build Android terminé avec succès !"
    print_info "APK: build/app/outputs/flutter-apk/app-release.apk"
    print_info "App Bundle: build/app/outputs/bundle/release/app-release.aab"
}

# Build pour iOS
build_ios() {
    print_message "Build pour iOS..."
    
    # Vérifier que iOS est configuré
    if ! flutter doctor | grep -q "iOS toolchain"; then
        print_error "iOS toolchain non configuré. Veuillez configurer Xcode."
        exit 1
    fi
    
    # Build iOS
    flutter build ios --release --no-codesign
    
    print_message "Build iOS terminé avec succès !"
    print_info "App: build/ios/archive/Runner.xcarchive"
}

# Build pour Web
build_web() {
    print_message "Build pour Web..."
    
    # Build Web
    flutter build web --release
    
    print_message "Build Web terminé avec succès !"
    print_info "Dossier: build/web/"
}

# Build pour toutes les plateformes
build_all() {
    print_message "Build pour toutes les plateformes..."
    
    build_android
    build_ios
    build_web
    
    print_message "Tous les builds sont terminés !"
}

# Tests
run_tests() {
    print_message "Exécution des tests..."
    
    # Tests unitaires
    print_info "Tests unitaires..."
    flutter test test/unit/ || true
    
    # Tests de widgets
    print_info "Tests de widgets..."
    flutter test test/widget/ || true
    
    print_message "Tests terminés !"
}

# Analyse du code
analyze_code() {
    print_message "Analyse du code..."
    flutter analyze
    
    print_message "Analyse terminée !"
}

# Vérification de la qualité
check_quality() {
    print_message "Vérification de la qualité du code..."
    
    # Analyse
    flutter analyze
    
    # Tests
    flutter test
    
    # Formatage
    flutter format --set-exit-if-changed lib/
    
    print_message "Vérification de la qualité terminée !"
}

# Afficher l'aide
show_help() {
    echo "Script de build pour COMPTAB POS"
    echo ""
    echo "Usage: $0 [COMMANDE]"
    echo ""
    echo "Commandes:"
    echo "  android     Build pour Android (APK + App Bundle)"
    echo "  ios         Build pour iOS"
    echo "  web         Build pour Web"
    echo "  all         Build pour toutes les plateformes"
    echo "  test        Exécuter les tests"
    echo "  analyze     Analyser le code"
    echo "  quality     Vérification complète de la qualité"
    echo "  clean       Nettoyer le projet"
    echo "  generate    Générer les fichiers de code"
    echo "  help        Afficher cette aide"
    echo ""
    echo "Exemples:"
    echo "  $0 android          # Build Android uniquement"
    echo "  $0 all             # Build toutes les plateformes"
    echo "  $0 quality         # Vérification complète"
}

# Script principal
main() {
    print_message "Démarrage du script de build..."
    
    # Vérifier Flutter
    check_flutter
    
    # Traiter les arguments
    case "${1:-help}" in
        android)
            clean_project
            generate_code
            build_android
            ;;
        ios)
            clean_project
            generate_code
            build_ios
            ;;
        web)
            clean_project
            generate_code
            build_web
            ;;
        all)
            clean_project
            generate_code
            build_all
            ;;
        test)
            run_tests
            ;;
        analyze)
            analyze_code
            ;;
        quality)
            check_quality
            ;;
        clean)
            clean_project
            ;;
        generate)
            generate_code
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Commande inconnue: $1"
            show_help
            exit 1
            ;;
    esac
    
    print_message "Script terminé avec succès !"
}

# Exécuter le script principal
main "$@"
