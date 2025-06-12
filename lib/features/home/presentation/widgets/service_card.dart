import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/features/home/data/models/service_item_model.dart';

/// A clean and simple service card that showcases a service with an image.
/// Features a subtle scale and shadow animation on hover.
class ServiceCard extends StatefulWidget {
  final ServiceItem service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        // Use a subtle scale for the hover effect
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            // Use a simple, clean shadow that changes on hover
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  _buildBackgroundImage(),
                  
                  // Gradient Overlay for Text Readability
                  _buildGradientOverlay(),
                  
                  // Card Content (Title and Button)
                  _buildCardContent(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the background image with a smooth scaling effect on hover.
  Widget _buildBackgroundImage() {
    return AnimatedScale(
      duration: const Duration(milliseconds: 400),
      scale: _isHovered ? 1.05 : 1.0,
      curve: Curves.easeOut,
      child: Image.asset(
        widget.service.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // A simple fallback in case the image fails to load.
          return Container(color: Colors.grey.shade200);
        },
      ),
    );
  }

  /// Builds a simple gradient overlay to ensure text is always readable.
  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.transparent,
            Colors.black.withOpacity(0.5),
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
    );
  }

  /// Builds the content of the card (title and button).
  Widget _buildCardContent(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () { /* Handle Card Tap */ },
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.service.titleKey.tr(),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(blurRadius: 6, color: Colors.black54),
                  ],
                ),
              ),
              // Learn More Button
              _buildLearnMoreButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the "Learn More" button with a simple color change on hover.
  Widget _buildLearnMoreButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        // The button's background color now smoothly transitions on hover.
        color: _isHovered
            ? AppColors.primary
            : Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.learnMore.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}
