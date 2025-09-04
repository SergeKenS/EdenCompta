import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/employee_model.dart';

class DevEmployeeService {
  static const String _employeeBox = 'employee_box';
  
  /// Initialise le service avec des données de test
  Future<void> initialize() async {
    final box = Hive.box(_employeeBox);
    if (box.isEmpty) {
      await _createSampleEmployees();
    }
  }
  
  /// Crée des employés de test
  Future<void> _createSampleEmployees() async {
    final employees = [
      EmployeeModel(
        id: 'emp-001',
        employeeNumber: 'EMP001',
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean.dupont@edencompta.com',
        phone: '+33 1 23 45 67 89',
        address: '123 Rue de la Paix, Paris',
        position: 'Gérant',
        department: 'Direction',
        status: 'ACTIVE',
        hireDate: DateTime(2020, 1, 15),
        salary: 3500.0,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EmployeeModel(
        id: 'emp-002',
        employeeNumber: 'EMP002',
        firstName: 'Marie',
        lastName: 'Martin',
        email: 'marie.martin@edencompta.com',
        phone: '+33 1 98 76 54 32',
        address: '456 Avenue des Champs, Lyon',
        position: 'Vendeur',
        department: 'Ventes',
        status: 'ACTIVE',
        hireDate: DateTime(2021, 3, 20),
        salary: 2200.0,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EmployeeModel(
        id: 'emp-003',
        employeeNumber: 'EMP003',
        firstName: 'Pierre',
        lastName: 'Bernard',
        email: 'pierre.bernard@edencompta.com',
        phone: '+33 1 55 44 33 22',
        address: '789 Boulevard Central, Marseille',
        position: 'Caissier',
        department: 'Caisse',
        status: 'ACTIVE',
        hireDate: DateTime(2021, 6, 10),
        salary: 2000.0,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    final box = Hive.box(_employeeBox);
    for (final employee in employees) {
      await box.put(employee.id, employee.toJson());
    }
  }
  
  /// Récupère tous les employés
  Future<List<EmployeeModel>> getAllEmployees() async {
    final box = Hive.box(_employeeBox);
    final employees = <EmployeeModel>[];
    
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        employees.add(EmployeeModel.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    
    return employees;
  }
  
  /// Récupère un employé par ID
  Future<EmployeeModel?> getEmployeeById(String id) async {
    final box = Hive.box(_employeeBox);
    final data = box.get(id);
    
    if (data != null) {
      return EmployeeModel.fromJson(Map<String, dynamic>.from(data));
    }
    
    return null;
  }
  
  /// Crée un nouvel employé
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    final box = Hive.box(_employeeBox);
    final newEmployee = employee.copyWith(
      id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await box.put(newEmployee.id, newEmployee.toJson());
    return newEmployee;
  }
  
  /// Met à jour un employé
  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    final box = Hive.box(_employeeBox);
    final updatedEmployee = employee.copyWith(
      updatedAt: DateTime.now(),
    );
    
    await box.put(updatedEmployee.id, updatedEmployee.toJson());
    return updatedEmployee;
  }
  
  /// Supprime un employé
  Future<void> deleteEmployee(String id) async {
    final box = Hive.box(_employeeBox);
    await box.delete(id);
  }
  
  /// Recherche des employés
  Future<List<EmployeeModel>> searchEmployees(String query) async {
    final allEmployees = await getAllEmployees();
    final lowercaseQuery = query.toLowerCase();
    
    return allEmployees.where((employee) {
      return employee.firstName.toLowerCase().contains(lowercaseQuery) ||
             employee.lastName.toLowerCase().contains(lowercaseQuery) ||
             employee.employeeNumber.toLowerCase().contains(lowercaseQuery) ||
             employee.position.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
