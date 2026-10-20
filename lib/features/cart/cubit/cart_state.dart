import 'package:ecom/features/cart/models/cart_item.dart';
import 'package:equatable/equatable.dart';

/// State of the shopping cart holding items and computed summaries.
class CartState extends Equatable {
  const CartState({this.items = const [], this.isLoading = false});

  final List<CartItem> items;
  final bool isLoading;

  /// Total count of all product units in the cart.
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Combined monetary total in integer minor currency units (paise) to eliminate
  /// floating-point rounding errors during multi-item aggregation.
  int get subtotalInPaise =>
      items.fold(0, (sum, item) => sum + item.totalPriceInPaise);

  /// Combined monetary total of all items in the cart in INR.
  double get subtotal => subtotalInPaise / 100.0;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  /// Whether a specific product is currently in the cart.
  bool hasProduct(String productId) =>
      items.any((item) => item.product.id == productId);

  /// Quantity of a specific product currently in the cart.
  int quantityForProduct(String productId) {
    for (final item in items) {
      if (item.product.id == productId) {
        return item.quantity;
      }
    }
    return 0;
  }

  CartState copyWith({List<CartItem>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, isLoading];
}
