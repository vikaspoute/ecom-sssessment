import 'package:ecom/features/cart/cubit/cart_state.dart';
import 'package:ecom/features/cart/models/cart_item.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing in-memory cart state for the session.
class CartCubit extends Cubit<CartState> {
  CartCubit({List<CartItem> initialItems = const [], bool isLoading = false})
    : super(CartState(items: initialItems, isLoading: isLoading));

  /// Updates loading state for the cart.
  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  /// Adds [product] to the cart. If the product is already in the cart,
  /// its quantity is incremented by [quantity].
  void addProduct(Product product, {int quantity = 1}) {
    if (quantity <= 0) return;

    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      final current = updated[existingIndex];
      updated[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
      emit(state.copyWith(items: List.unmodifiable(updated)));
    } else {
      final updated = [
        ...state.items,
        CartItem(product: product, quantity: quantity),
      ];
      emit(state.copyWith(items: List.unmodifiable(updated)));
    }
  }

  /// Removes all units of [productId] from the cart.
  void removeProduct(String productId) {
    final updated = state.items
        .where((item) => item.product.id != productId)
        .toList();
    emit(state.copyWith(items: List.unmodifiable(updated)));
  }

  /// Updates quantity for [productId]. If [quantity] <= 0, the item is removed.
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: quantity,
      );
      emit(state.copyWith(items: List.unmodifiable(updated)));
    }
  }

  /// Decrements the quantity of [productId] by 1.
  /// If the quantity reaches 0 or less, the product is removed from the cart.
  void decrementProduct(String productId) {
    final currentQty = state.quantityForProduct(productId);
    if (currentQty <= 1) {
      removeProduct(productId);
    } else {
      updateQuantity(productId, currentQty - 1);
    }
  }

  /// Resets the cart to an empty state.
  void clearCart() {
    emit(const CartState());
  }
}
