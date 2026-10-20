import 'package:ecom/features/products/models/product.dart';
import 'package:equatable/equatable.dart';

/// Represents a product placed in the user's cart along with its chosen quantity.
class CartItem extends Equatable {
  const CartItem({required this.product, this.quantity = 1})
    : assert(quantity > 0, 'Cart item quantity must be positive');

  final Product product;
  final int quantity;

  /// Unit price in integer minor currency units (paise) to avoid
  /// floating-point representation and rounding drift.
  int get unitPriceInPaise => (product.price * 100).round();

  /// Total price in integer minor currency units (paise).
  int get totalPriceInPaise => unitPriceInPaise * quantity;

  /// Total price in standard currency units (INR).
  double get totalPrice => totalPriceInPaise / 100.0;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
