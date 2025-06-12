
/// Data class representing a single service/value item for the showcase.
class ServiceItem {
  final String titleKey;
  final String imagePath; // FIX: Changed from gradientColors to imagePath

  const ServiceItem({
    required this.titleKey,
    required this.imagePath,
  });
}