import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:comptab_pos/services/setup_service.dart';
import 'package:comptab_pos/widgets/loading_button.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _pinController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _deviceNameController = TextEditingController();
  
  final List<String> _availablePaymentMethods = [
    'Espèces',
    'Carte bancaire',
    'Chèque',
    'Virement',
    'Mobile Money',
    'Crypto-monnaie',
  ];
  
  final Set<String> _selectedPaymentMethods = {};

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pinController.dispose();
    _storeNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final setupInfo = await ref.read(setupServiceProvider).getSavedSetupInfo();
    final paymentMethods = await ref.read(setupServiceProvider).getSavedPaymentMethods();
    
    setState(() {
      _firstNameController.text = setupInfo['cashier_first_name'] ?? '';
      _lastNameController.text = setupInfo['cashier_last_name'] ?? '';
      _storeNameController.text = setupInfo['store_name'] ?? '';
      _addressController.text = setupInfo['store_address'] ?? '';
      _phoneController.text = setupInfo['store_phone'] ?? '';
      _emailController.text = setupInfo['store_email'] ?? '';
      _deviceNameController.text = setupInfo['device_name'] ?? 'Terminal POS';
      _selectedPaymentMethods.addAll(paymentMethods);
    });
  }

  Widget _buildStepIndicator() {
    final setupState = ref.watch(setupStateProvider);
    final currentStep = setupState.currentStep;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        
        return Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Colors.green 
                    : isActive 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            if (index < 3)
              Container(
                width: 60,
                height: 2,
                color: isCompleted ? Colors.green : Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }

  Widget _buildStepTitle() {
    final setupState = ref.watch(setupStateProvider);
    final currentStep = setupState.currentStep;
    
    final titles = [
      'Informations de la caissière',
      'Informations du magasin',
      'Moyens de paiement',
      'Enregistrement du terminal',
    ];
    
    return Text(
      titles[currentStep],
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildStepContent() {
    final setupState = ref.watch(setupStateProvider);
    final currentStep = setupState.currentStep;
    
    switch (currentStep) {
      case 0:
        return _buildCashierStep();
      case 1:
        return _buildStoreStep();
      case 2:
        return _buildPaymentMethodsStep();
      case 3:
        return _buildDeviceStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCashierStep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'Prénom',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir le prénom';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Nom',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir le nom';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pinController,
            decoration: const InputDecoration(
              labelText: 'Code PIN (4 chiffres)',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            validator: (value) {
              if (value == null || value.length != 4) {
                return 'Le code PIN doit contenir 4 chiffres';
              }
              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                return 'Le code PIN ne doit contenir que des chiffres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreStep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _storeNameController,
            decoration: const InputDecoration(
              labelText: 'Nom du magasin',
              prefixIcon: Icon(Icons.store),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir le nom du magasin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Adresse',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir l\'adresse';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Téléphone',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir le numéro de téléphone';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir l\'email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Veuillez saisir un email valide';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sélectionnez les moyens de paiement acceptés :',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        ...(_availablePaymentMethods.map((method) => CheckboxListTile(
          title: Text(method),
          value: _selectedPaymentMethods.contains(method),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedPaymentMethods.add(method);
              } else {
                _selectedPaymentMethods.remove(method);
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        )).toList()),
        if (_selectedPaymentMethods.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Veuillez sélectionner au moins un moyen de paiement',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceStep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _deviceNameController,
            decoration: const InputDecoration(
              labelText: 'Nom du terminal',
              prefixIcon: Icon(Icons.point_of_sale),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez saisir le nom du terminal';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations du terminal :',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('ID du terminal : ${DateTime.now().millisecondsSinceEpoch}'),
                  Text('Type : ${Theme.of(context).platform.name}'),
                  Text('Version : 1.0.0'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    final setupNotifier = ref.read(setupStateProvider.notifier);
    final currentStep = ref.read(setupStateProvider).currentStep;
    
    // Validation selon l'étape
    if (currentStep == 0 || currentStep == 1 || currentStep == 3) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    
    if (currentStep == 2) {
      if (_selectedPaymentMethods.isEmpty) {
        return;
      }
    }
    
    // Afficher l'indicateur de chargement
    await setupNotifier.nextStep();
    
    // Sauvegarder les données selon l'étape
    final setupService = ref.read(setupServiceProvider);
    bool success = true;
    
    // Petit délai pour simuler le traitement
    await Future.delayed(const Duration(milliseconds: 500));
    
    switch (currentStep) {
      case 0:
        success = await setupService.saveCashierInfo(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          pin: _pinController.text,
        );
        break;
      case 1:
        success = await setupService.saveStoreInfo(
          storeName: _storeNameController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );
        break;
      case 2:
        success = await setupService.savePaymentMethods(
          _selectedPaymentMethods.toList(),
        );
        break;
      case 3:
        success = await setupService.registerDevice(
          deviceName: _deviceNameController.text.trim(),
          deviceId: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        break;
    }
    
    if (success) {
      if (currentStep == 3) {
        // Dernière étape, finaliser la configuration
        await setupNotifier.completeSetup();
        
        // Afficher un message de succès et rediriger
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configuration terminée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          
          // La redirection sera gérée automatiquement par le routeur
        }
      }
    } else {
      // Revenir à l'étape précédente en cas d'erreur
      await setupNotifier.previousStep();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la sauvegarde des données'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(setupStateProvider);
    
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
                constraints: const BoxConstraints(maxWidth: 600),
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
                          'Assistant de configuration',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Indicateur d'étapes
                        _buildStepIndicator(),
                        const SizedBox(height: 32),
                        
                        // Titre de l'étape
                        _buildStepTitle(),
                        const SizedBox(height: 24),
                        
                        // Contenu de l'étape
                        _buildStepContent(),
                        const SizedBox(height: 32),
                        
                        // Boutons de navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (setupState.currentStep > 0)
                              TextButton(
                                onPressed: () => ref.read(setupStateProvider.notifier).previousStep(),
                                child: const Text('Précédent'),
                              )
                            else
                              const SizedBox.shrink(),
                            
                            LoadingButton(
                              onPressed: setupState.isLoading ? null : _handleNext,
                              isLoading: setupState.isLoading,
                              child: Text(
                                setupState.currentStep == 3 ? 'Terminer' : 'Suivant',
                              ),
                            ),
                          ],
                        ),
                        
                        if (setupState.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              setupState.error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
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
