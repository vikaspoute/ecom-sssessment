import 'package:equatable/equatable.dart';

/// Data model representing an individual slide within the onboarding experience.
class OnboardingItem extends Equatable {
  const OnboardingItem({
    required this.tag,
    required this.badge,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.highlights = const [],
  });

  final String tag;
  final String badge;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> highlights;

  /// Default curated fashion slides.
  static const List<OnboardingItem> items = [
    OnboardingItem(
      tag: 'SPRING / SUMMER 2026',
      badge: 'TIMELESS LUXURY',
      title: 'Curated Elegance,\nCrafted to Endure',
      description: 'Discover premium organic fabrics, relaxed tailoring, and understated essentials designed for modern living.',
      imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=900&auto=format&fit=crop&q=80',
      highlights: ['100% Organic Cotton', 'Artisanal Tailoring', 'Zero Waste'],
    ),
    OnboardingItem(
      tag: 'DYNAMIC SELECTION',
      badge: 'LIVE WARDROBE',
      title: 'Effortless Styling,\nSeamless Bag Sync',
      description: 'Manage your wardrobe in real time with interactive in-card adjustments, dynamic totals, and zero checkout friction.',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=900&auto=format&fit=crop&q=80',
      highlights: ['In-Card Stepper', 'Real-Time Totals', 'Transparent INR'],
    ),
    OnboardingItem(
      tag: 'COMPLIMENTARY SHIPPING',
      badge: 'EXPRESS DISPATCH',
      title: 'Atelier to Doorstep,\nDelivered with Care',
      description: 'Enjoy express priority dispatch on every order with transparent INR pricing, complimentary delivery, and effortless returns.',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=900&auto=format&fit=crop&q=80',
      highlights: ['Express Courier', 'Eco Packaging', '30-Day Returns'],
    ),
  ];

  @override
  List<Object?> get props => [
    tag,
    badge,
    title,
    description,
    imageUrl,
    highlights,
  ];
}
