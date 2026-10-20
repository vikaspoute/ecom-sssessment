import 'package:equatable/equatable.dart';

/// Available product categories in the catalog.
abstract final class ProductCategories {
  static const String all = 'All';
  static const String tShirts = 'T-shirts';
  static const String shirts = 'Shirts';
  static const String bottoms = 'Bottoms';
  static const String outerwear = 'Outerwear';
  static const String shoes = 'Shoes';

  static const List<String> categories = [
    all,
    tShirts,
    shirts,
    bottoms,
    outerwear,
    shoes,
  ];
}

/// An immutable representation of a product in the fashion catalog.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.originalPrice,
  }) : assert(price >= 0, 'Price must be non-negative');

  /// Unique stable identifier for the product.
  final String id;

  /// Display name of the product.
  final String name;

  /// Short editorial summary describing fabric and cut.
  final String description;

  /// Current selling price in INR.
  final double price;

  /// URL pointing to the product imagery.
  final String imageUrl;

  /// Category name (e.g., T-shirts, Shirts, Bottoms, Outerwear, Shoes).
  final String category;

  /// Optional original price in INR before discount.
  final double? originalPrice;

  /// Whether this product is currently discounted.
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Calculated discount percentage, rounded to the nearest integer.
  int? get discountPercentage {
    if (!hasDiscount) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    originalPrice,
  ];
}
