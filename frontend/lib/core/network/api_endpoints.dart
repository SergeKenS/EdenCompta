class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  
  // User endpoints
  static const String users = '/users';
  static const String userById = '/users/{id}';
  static const String userByUsername = '/users/username/{username}';
  
  // Store endpoints
  static const String stores = '/stores';
  static const String storeById = '/stores/{id}';
  
  // Product endpoints
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productSearch = '/products/search';
  static const String topSellers = '/products/top-sellers';
  static const String lowStock = '/products/low-stock';
  
  // Inventory endpoints
  static const String inventory = '/inventory';
  static const String inventoryByProduct = '/inventory/products';
  static const String inventoryVariants = '/inventory/variants';
  
  // Sales endpoints
  static const String receipts = '/sales/receipts';
  static const String receiptById = '/sales/receipts/{id}';
  static const String receiptLines = '/sales/receipts/{id}/lines';
  static const String finalizeReceipt = '/sales/receipts/{id}/finalize';
  
  // Returns endpoints
  static const String returns = '/returns';
  static const String returnById = '/returns/{id}';
  
  // Expenses endpoints
  static const String expenses = '/expenses';
  static const String expenseById = '/expenses/{id}';
  static const String expensesSummary = '/expenses/summary';
  static const String expensesByCategory = '/expenses/stats/by-category';
  
  // Cashflow endpoints
  static const String cashflow = '/cashflow';
  static const String cashflowSummary = '/cashflow/stores/{storeId}/summary';
  static const String cashMovements = '/cashflow/stores/{storeId}/movements';
  
  // Reporting endpoints
  static const String dailySummary = '/reporting/daily-summary';
  static const String zReport = '/reporting/z-report';
  static const String sessionTotals = '/reporting/session-totals';
  
  // Employee endpoints
  static const String employees = '/employees';
  static const String employeeById = '/employees/{id}';
  static const String attendance = '/employees/attendance';
  
  // Debts endpoints
  static const String debts = '/debts';
  static const String debtById = '/debts/{id}';
  static const String payDebt = '/debts/{id}/pay';
  
  // Sessions endpoints
  static const String cashSessions = '/sessions/cash';
  static const String mobileSessions = '/sessions/mobile';
  
  // Customer endpoints
  static const String customers = '/customers';
  static const String customerById = '/customers/{id}';
  
  // Helper method to replace path parameters
  static String replacePathParams(String path, Map<String, dynamic> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
