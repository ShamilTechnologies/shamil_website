import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/widgets/animated_fade_in.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart';

class DownloadCtaSection extends StatelessWidget {
  const DownloadCtaSection({super.key});

  final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
  final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      decoration: _buildGradientBackground(theme),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical * 1.2,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildMainContent(context, theme),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.primary.withOpacity(0.8),
          theme.colorScheme.secondary.withOpacity(0.6),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Phone icon with simple animation
        _buildPhoneIcon(theme),
        
        const SizedBox(height: AppDimensions.spacingLarge),
        
        // Title section
        _buildTitleSection(theme),
        
        const SizedBox(height: AppDimensions.spacingMedium),
        
        // Subtitle section
        _buildSubtitleSection(theme),
        
        const SizedBox(height: AppDimensions.spacingLarge),
        
        // Feature badges
        _buildFeatureBadges(theme),
        
        const SizedBox(height: AppDimensions.spacingExtraLarge),
        
        // Download buttons
        _buildDownloadButtons(context, theme),
        
        const SizedBox(height: AppDimensions.spacingLarge),
        
        // Social proof
        _buildSocialProof(theme),
      ],
    );
  }

  Widget _buildPhoneIcon(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.smartphone_rounded,
        size: 40,
        color: Colors.white,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          end: 1.1,
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Column(
      children: [
        Text(
          "🚀 ${AppStrings.downloadNow.tr().toUpperCase()}",
          style: theme.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 12),
        
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white.withOpacity(0.8),
          ),
        )
            .animate()
            .scaleX(delay: 300.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildSubtitleSection(ThemeData theme) {
    return Text(
      "getStartedWithShamil".tr(),
      style: theme.textTheme.titleLarge?.copyWith(
        color: Colors.white.withOpacity(0.9),
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildFeatureBadges(ThemeData theme) {
    final features = [
      {"icon": "⚡", "text": "Fast"},
      {"icon": "🔒", "text": "Secure"},
      {"icon": "✨", "text": "Smart"},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                feature["icon"]!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                feature["text"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 400 + (index * 100)))
            .scale(begin: const Offset(0.8, 0.8));
      }).toList(),
    );
  }

  Widget _buildDownloadButtons(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Primary download button
        _buildPrimaryButton(context, theme),
        
        const SizedBox(height: 24),
        
        // Store buttons
        _buildStoreButtons(context, theme),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _showDownloadModal(context, theme),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "DOWNLOAD FREE",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          end: 1.02,
          duration: 2000.ms,
          curve: Curves.easeInOut,
        )
        .animate()
        .fadeIn(delay: 700.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildStoreButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStoreButton(
          onTap: () => Helpers.launchUrlHelper(context, _appStoreUrl),
          child: SvgPicture.asset(AppAssets.appStoreBadge, height: 45),
          delay: 800.ms,
        ),
        const SizedBox(width: 20),
        _buildStoreButton(
          onTap: () => Helpers.launchUrlHelper(context, _playStoreUrl),
          child: Image.asset(AppAssets.googlePlayBadge, height: 45),
          delay: 900.ms,
        ),
      ],
    );
  }

  Widget _buildStoreButton({
    required VoidCallback onTap,
    required Widget child,
    required Duration delay,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildSocialProof(ThemeData theme) {
    final stats = [
      {"number": "1M+", "label": "Downloads"},
      {"number": "4.8★", "label": "Rating"},
      {"number": "50K+", "label": "Reviews"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        
        return Column(
          children: [
            Text(
              stat["number"]!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat["label"]!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 1000 + (index * 100)))
            .slideY(begin: 0.2, end: 0);
      }).toList(),
    );
  }

  void _showDownloadModal(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Choose Your Platform",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildModalButton(
                      "App Store",
                      Icons.apple,
                      () {
                        Navigator.pop(context);
                        Helpers.launchUrlHelper(context, _appStoreUrl);
                      },
                      theme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModalButton(
                      "Google Play",
                      Icons.android,
                      () {
                        Navigator.pop(context);
                        Helpers.launchUrlHelper(context, _playStoreUrl);
                      },
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalButton(String title, IconData icon, VoidCallback onTap, ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}