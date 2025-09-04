import 'package:flutter_riverpod/flutter_riverpod.dart';

// Type simple pour les items du panier pendant la phase test
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({String? id, String? name, double? price, int? quantity}) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  void addItem({
    required String id,
    required String name,
    required double price,
  }) {
    final index = state.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final existing = state[index];
      final updated = existing.copyWith(quantity: existing.quantity + 1);
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    } else {
      state = [
        ...state,
        CartItem(id: id, name: name, price: price, quantity: 1),
      ];
    }
  }

  void updateItem(String id, {double? price, int? quantity}) {
    final index = state.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final existing = state[index];
    final newQuantity = quantity ?? existing.quantity;
    final newPrice = price ?? existing.price;
    if (newQuantity <= 0) return; // garder une quantité valide
    final updated = existing.copyWith(price: newPrice, quantity: newQuantity);
    state = [
      ...state.sublist(0, index),
      updated,
      ...state.sublist(index + 1),
    ];
  }

  void updatePrice(String id, double newPrice) {
    final index = state.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final existing = state[index];
    final updated = existing.copyWith(price: newPrice);
    state = [
      ...state.sublist(0, index),
      updated,
      ...state.sublist(index + 1),
    ];
  }

  void removeOne(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final existing = state[index];
    if (existing.quantity > 1) {
      final updated = existing.copyWith(quantity: existing.quantity - 1);
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    } else {
      removeAll(id);
    }
  }

  void removeAll(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clear() {
    state = const [];
  }

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);

  double get total => state.fold(0.0, (sum, item) => sum + item.price * item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
