// lib/features/home/data/models/testimonial_model.dart

// A simple class to represent a testimonial.
class TestimonialModel {
  final String companyLogoAsset; // Path to the company logo (e.g., assets/images/company_a_logo.png)
  final String companyNameKey;   // Localization key for the company name
  final String testimonialTextKey; // Localization key for the testimonial text
  final String userAvatarAsset;    // Path to the user's avatar image (e.g., assets/images/user_a_avatar.png)
  final String userNameKey;        // Localization key for the user's name
  final String userTitleKey;       // Localization key for the user's title

  const TestimonialModel({
    required this.companyLogoAsset,
    required this.companyNameKey,
    required this.testimonialTextKey,
    required this.userAvatarAsset,
    required this.userNameKey,
    required this.userTitleKey,
  });
}
