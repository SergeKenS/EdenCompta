import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comptab_pos/widgets/loading_button.dart';
import 'package:comptab_pos/services/auth_service.dart';

class PinLoginScreen extends ConsumerStatefulWidget {
  const PinLoginScreen({super.key});

  @override
  ConsumerState<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends ConsumerState<PinLoginScreen> {
  final List<String> _pinDigits = [];
  final int _pinLength = 4;
  bool _isLoading = false;
  String? _errorMessage;
  String? _cashierName;

  @override
  void initState() {
    super.initState();
    _loadCashierInfo();
  }

  Future<void> _loadCashierInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('cashier_first_name') ?? '';
    final lastName = prefs.getString('cashier_last_name') ?? '';
    setState(() {
      _cashierName = '$firstName $lastName'.trim();
    });
  }

  void _addDigit(String digit) {
    if (_pinDigits.length < _pinLength) {
      setState(() {
        _pinDigits.add(digit);
        _errorMessage = null;
      });
      
      // Vérifier le PIN si 4 chiffres sont saisis
      if (_pinDigits.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  void _removeDigit() {
    if (_pinDigits.isNotEmpty) {
      setState(() {
        _pinDigits.removeLast();
        _errorMessage = null;
      });
    }
  }

  Future<void> _verifyPin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final enteredPin = _pinDigits.join();
      
      // Utiliser le service d'authentification
      await ref.read(authStateProvider.notifier).loginWithPin(enteredPin);
      
      final authState = ref.read(authStateProvider);
      
      if (authState.isAuthenticated) {
        // Connexion réussie, l'état sera mis à jour automatiquement
        // et la navigation sera gérée par le routeur
      } else {
        setState(() {
          _errorMessage = authState.error ?? 'Code PIN incorrect';
          _pinDigits.clear();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la vérification';
        _pinDigits.clear();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (index) {
        final hasDigit = index < _pinDigits.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: hasDigit ? Theme.of(context).colorScheme.primary : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: hasDigit
              ? Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 16,
                )
              : null,
        );
      }),
    );
  }

  Widget _buildNumericKeypad() {
    return Column(
      children: [
        // Rangée 1-3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map((digit) => _buildKeypadButton(digit)).toList(),
        ),
        const SizedBox(height: 16),
        // Rangée 4-6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((digit) => _buildKeypadButton(digit)).toList(),
        ),
        const SizedBox(height: 16),
        // Rangée 7-9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((digit) => _buildKeypadButton(digit)).toList(),
        ),
        const SizedBox(height: 16),
        // Rangée 0 et effacer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('0'),
            const SizedBox(width: 80), // Espace vide
            _buildKeypadButton('', isDelete: true),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit, {bool isDelete = false}) {
    return GestureDetector(
      onTap: _isLoading ? null : () {
        if (isDelete) {
          _removeDigit();
        } else {
          _addDigit(digit);
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isDelete
              ? Icon(
                  Icons.backspace_outlined,
                  size: 32,
                  color: Colors.grey[600],
                )
              : Text(
                  digit,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo et titre
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.point_of_sale,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'COMPTAB POS',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connexion caissier',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_cashierName != null && _cashierName!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Bienvenue, $_cashierName',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),

                        // Affichage du PIN
                        _buildPinDisplay(),
                        const SizedBox(height: 24),

                        // Message d'erreur
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        // Clavier numérique
                        _buildNumericKeypad(),
                        const SizedBox(height: 32),

                        // Bouton de chargement
                        if (_isLoading)
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
