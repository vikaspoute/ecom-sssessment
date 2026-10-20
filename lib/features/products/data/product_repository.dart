import 'package:ecom/features/products/models/product.dart';

/// Contract for retrieving products.
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

/// Static in-memory product repository with realistic clothing items.
class LocalProductRepository implements ProductRepository {
  const LocalProductRepository({this.delay = Duration.zero});

  /// Configurable delay to simulate network latency in tests or previews.
  final Duration delay;

  /// Default mock catalog containing at least eight realistic fashion items.
  static const List<Product> defaultProducts = [
    Product(
      id: 'prod_classic_cotton_tee',
      name: 'Classic Cotton T-Shirt',
      description: 'Breathable everyday crew neck crafted from 100% combed organic cotton.',
      price: 899.00,
      originalPrice: 1199.00,
      imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.tShirts,
    ),
    Product(
      id: 'prod_oversized_heavyweight_tee',
      name: 'Oversized Heavyweight T-Shirt',
      description: 'Relaxed streetwear silhouette featuring dropped shoulders and a dense knit.',
      price: 1299.00,
      originalPrice: 1599.00,
      imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.tShirts,
    ),
    Product(
      id: 'prod_casual_linen_shirt',
      name: 'Casual Linen Shirt',
      description: 'Lightweight spread-collar button-down woven from pure European flax.',
      price: 2499.00,
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.shirts,
    ),
    Product(
      id: 'prod_selvedge_denim_jeans',
      name: 'Selvedge Denim Jeans',
      description: 'Straight-leg raw indigo jeans crafted from 13.5oz Japanese shuttle-loom denim.',
      price: 3999.00,
      originalPrice: 4999.00,
      imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.bottoms,
    ),
    Product(
      id: 'prod_tailored_slim_chinos',
      name: 'Tailored Slim Chinos',
      description: 'Refined stretch-twill trousers cut for modern versatility from office to evening.',
      price: 2199.00,
      imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.bottoms,
    ),
    Product(
      id: 'prod_brushed_fleece_hoodie',
      name: 'Brushed Fleece Hoodie',
      description: 'Plush 450gsm heavyweight hoodie featuring a double-layer hood and ribbed trims.',
      price: 2799.00,
      originalPrice: 3299.00,
      imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.outerwear,
    ),
    Product(
      id: 'prod_casual_worker_jacket',
      name: 'Casual Worker Jacket',
      description: 'Structured utilitarian jacket in durable cotton duck canvas with horn buttons.',
      price: 4499.00,
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.outerwear,
    ),
    Product(
      id: 'prod_leather_sneakers',
      name: 'Low-Top Leather Sneakers',
      description: 'Minimalist Italian nappa leather sneakers with stitched cupsole and padded insole.',
      price: 3499.00,
      originalPrice: 4299.00,
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=800&auto=format&fit=crop&q=80',
      category: ProductCategories.shoes,
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return List<Product>.unmodifiable(defaultProducts);
  }
}
