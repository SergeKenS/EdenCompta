import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/permissions/page_protection_mixin.dart';
import '../../data/models/employee_model.dart';
import '../../data/services/dev_employee_service.dart';
import '../providers/employee_provider.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_search_bar.dart';

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> 
    with PageProtectionMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialiser le service et charger les employés
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeServiceProvider).initialize();
      ref.read(employeeListProvider.notifier).loadEmployees();
      
      // Vérifier les permissions après l'initialisation
      checkEmployeesAccess();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    ref.read(employeeListProvider.notifier).searchEmployees(query);
  }

  void _onAddEmployee() {
    // TODO: Naviguer vers l'écran d'ajout d'employé
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité d\'ajout à implémenter')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Employés'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddEmployee,
            tooltip: 'Ajouter un employé',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          EmployeeSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Rechercher un employé...',
          ),
          
          // Liste des employés
          Expanded(
            child: employeeState.when(
              data: (employees) {
                if (employees.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildEmployeeList(employees);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(List<EmployeeModel> employees) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(employeeListProvider.notifier).loadEmployees();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EmployeeCard(
              employee: employee,
              onTap: () => _onEmployeeTap(employee),
              onEdit: () => _onEmployeeEdit(employee),
              onDelete: () => _onEmployeeDelete(employee),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'Aucun employé trouvé' : 'Aucun résultat',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty 
              ? 'Commencez par ajouter votre premier employé'
              : 'Essayez de modifier vos critères de recherche',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onAddEmployee,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un employé'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur lors du chargement',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(employeeListProvider.notifier).loadEmployees();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _onEmployeeTap(EmployeeModel employee) {
    // TODO: Naviguer vers le détail de l'employé
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Détails de ${employee.firstName} ${employee.lastName}')),
    );
  }

  void _onEmployeeEdit(EmployeeModel employee) {
    // TODO: Naviguer vers l'écran d'édition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Éditer ${employee.firstName} ${employee.lastName}')),
    );
  }

  void _onEmployeeDelete(EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ${employee.firstName} ${employee.lastName} ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(employeeListProvider.notifier).deleteEmployee(employee.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
