class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.description,
    required this.address,
    required this.cuisine,
    required this.imageUrl,
    required this.foodQualityScore,
    required this.serviceScore,
    required this.atmosphereScore,
    required this.priceQualityScore,
    this.isNew = false,
  });

  final String id;
  final String name;
  final double rating;
  final String description;
  final String address;
  final String cuisine;
  final String imageUrl;

  /// Scores out of 10 for the detail criteria bars.
  final int foodQualityScore;
  final int serviceScore;
  final int atmosphereScore;
  final int priceQualityScore;

  final bool isNew;
}
