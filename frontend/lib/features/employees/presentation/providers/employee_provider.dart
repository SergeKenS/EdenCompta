import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/employee_model.dart';
import '../../data/services/dev_employee_service.dart';

// Provider pour le service des employés
final employeeServiceProvider = Provider<DevEmployeeService>((ref) {
  return DevEmployeeService();
});

// Provider pour la liste des employés
final employeeListProvider = StateNotifierProvider<EmployeeListNotifier, AsyncValue<List<EmployeeModel>>>((ref) {
  final service = ref.read(employeeServiceProvider);
  return EmployeeListNotifier(service);
});

// Notifier pour gérer l'état de la liste des employés
class EmployeeListNotifier extends StateNotifier<AsyncValue<List<EmployeeModel>>> {
  final DevEmployeeService _service;
  List<EmployeeModel> _allEmployees = [];

  EmployeeListNotifier(this._service) : super(const AsyncValue.loading());

  /// Charge tous les employés
  Future<void> loadEmployees() async {
    state = const AsyncValue.loading();
    
    try {
      await _service.initialize();
      _allEmployees = await _service.getAllEmployees();
      state = AsyncValue.data(_allEmployees);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Recherche des employés
  Future<void> searchEmployees(String query) async {
    if (query.isEmpty) {
      state = AsyncValue.data(_allEmployees);
      return;
    }

    try {
      final results = await _service.searchEmployees(query);
      state = AsyncValue.data(results);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Ajoute un nouvel employé
  Future<void> addEmployee(EmployeeModel employee) async {
    try {
      final newEmployee = await _service.createEmployee(employee);
      _allEmployees.add(newEmployee);
      state = AsyncValue.data(_allEmployees);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Met à jour un employé
  Future<void> updateEmployee(EmployeeModel employee) async {
    try {
      final updatedEmployee = await _service.updateEmployee(employee);
      final index = _allEmployees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        _allEmployees[index] = updatedEmployee;
        state = AsyncValue.data(_allEmployees);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Supprime un employé
  Future<void> deleteEmployee(String id) async {
    try {
      await _service.deleteEmployee(id);
      _allEmployees.removeWhere((e) => e.id == id);
      state = AsyncValue.data(_allEmployees);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Rafraîchit la liste
  Future<void> refresh() async {
    await loadEmployees();
  }
}
