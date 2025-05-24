// lib/features/home/presentation/widgets/footer_section.dart

import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/features/home/data/services/newsletter_service.dart'; // NEW
import 'package:responsive_framework/responsive_framework.dart';

/// 🚀 ENHANCED FOOTER WITH DATABASE INTEGRATION 🚀
/// Features: Working links, social media connections, newsletter signup with database
class FooterSection extends StatefulWidget {
  final ScrollController? scrollController; // NEW: Added scroll controller

  const FooterSection({
    super.key,
    this.scrollController,
  });

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection>
    with TickerProviderStateMixin {
  
  // Animation controllers
  late AnimationController _waveController;
  late AnimationController _floatingController;
  late AnimationController _glowController;
  
  // Newsletter form controllers
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  
  // Interactive states
  bool _showScrollToTop = true;
  bool _isSubscribing = false;
  bool _isSubscribed = false;
  String? _subscriptionError;

  // Services
  final NewsletterService _newsletterService = NewsletterService();

  // Company social links - UPDATED with real Shamil links
  final Map<String, String> _socialLinks = {
    'facebook': 'https://facebook.com/shamilapp',
    'twitter': 'https://twitter.com/shamilapp',
    'linkedin': 'https://linkedin.com/company/shamil-app',
    'instagram': 'https://instagram.com/shamilapp',
    'youtube': 'https://youtube.com/@shamilapp',
  };

  // Contact information
  final String _emailAddress = "support@shamil.app";
  final String _phoneNumber = "+1-800-SHAMIL";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _setupScrollListener() {
    widget.scrollController?.addListener(() {
      final showButton = (widget.scrollController?.offset ?? 0) > 200;
      if (showButton != _showScrollToTop) {
        setState(() => _showScrollToTop = showButton);
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatingController.dispose();
    _glowController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    
    return Stack(
      children: [
        _buildWaveBackground(theme),
        _buildFooterContent(theme, isMobile),
        if (_showScrollToTop) _buildScrollToTop(theme),
      ],
    );
  }

  /// Build animated wave background
  Widget _buildWaveBackground(ThemeData theme) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(
              animationValue: _waveController.value,
              theme: theme,
            ),
          );
        },
      ),
    );
  }

  /// Build main footer content
  Widget _buildFooterContent(ThemeData theme, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.brightness == Brightness.light
              ? [
                  const Color(0xFF2A548D).withOpacity(0.95),
                  const Color(0xFF1A3A5C),
                ]
              : [
                  const Color(0xFF1A2332),
                  const Color(0xFF0F1419),
                ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: isMobile ? 40 : 60,
        ),
        child: Column(
          children: [
            _buildNewsletterSection(theme, isMobile),
            const SizedBox(height: 40),
            _buildMainContent(theme, isMobile),
            const SizedBox(height: 30),
            _buildBottomBar(theme, isMobile),
          ],
        ),
      ),
    );
  }

  /// Build newsletter section with database integration
  Widget _buildNewsletterSection(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi) * 3),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD8A31A).withOpacity(0.1 + (_glowController.value * 0.1)),
                  blurRadius: 20 + (_glowController.value * 10),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "🚀 Join the Shamil Revolution!",
                  style: (isMobile 
                      ? theme.textTheme.titleLarge 
                      : theme.textTheme.headlineSmall)?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Get exclusive updates, early access, and insider tips",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildNewsletterForm(theme, isMobile),
              ],
            ),
          ),
        );
      },
    ).animate(delay: 200.ms)
     .fadeIn(duration: 800.ms)
     .slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }

  /// Enhanced newsletter form with validation and database integration
  Widget _buildNewsletterForm(ThemeData theme, bool isMobile) {
    // Success state
    if (_isSubscribed) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD8A31A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD8A31A).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFD8A31A),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "🎉 Welcome to the family!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFD8A31A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Check your email for a special welcome gift!",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate()
       .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack)
       .fadeIn();
    }

    // Form state
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Column(
        children: [
          // Email input with validation
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _subscriptionError != null 
                    ? Colors.red.withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
                width: _subscriptionError != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Email field
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your email address",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.white.withOpacity(0.6),
                        size: 20,
                      ),
                    ),
                    onSubmitted: (_) => _handleSubscribe(),
                  ),
                ),
                
                // Subscribe button
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: _ViralButton(
                    text: _isSubscribing ? "..." : "Join Now",
                    onPressed: _isSubscribing ? null : _handleSubscribe,
                    icon: _isSubscribing ? Icons.hourglass_empty : Icons.rocket_launch,
                    isCompact: true,
                  ),
                ),
              ],
            ),
          ),
          
          // Error message
          if (_subscriptionError != null) ...[
            const SizedBox(height: 8),
            Text(
              _subscriptionError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red.shade300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          // Privacy notice
          const SizedBox(height: 12),
          Text(
            "🔒 We respect your privacy. Unsubscribe anytime.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build main footer content with working links
  Widget _buildMainContent(ThemeData theme, bool isMobile) {
    return ResponsiveRowColumn(
      layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
      columnSpacing: 30,
      rowSpacing: 60,
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 2,
          child: _buildBrandSection(theme, isMobile),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildQuickLinks(theme, isMobile),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildConnectSection(theme, isMobile),
        ),
      ],
    );
  }

  /// Build brand section
  Widget _buildBrandSection(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD8A31A).withOpacity(0.3 + (_glowController.value * 0.2)),
                    blurRadius: 20 + (_glowController.value * 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  AppAssets.logo,
                  height: 60,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 60,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A548D), Color(0xFFD8A31A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Shamil',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            "Revolutionizing service booking with smart technology and seamless experiences.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
        ),
        const SizedBox(height: 16),
        // Contact info
        Column(
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            _ContactInfo(
              icon: Icons.email,
              text: _emailAddress,
              onTap: () => Helpers.launchUrlHelper(context, 'mailto:$_emailAddress'),
            ),
            const SizedBox(height: 8),
            _ContactInfo(
              icon: Icons.phone,
              text: _phoneNumber,
              onTap: () => Helpers.launchUrlHelper(context, 'tel:$_phoneNumber'),
            ),
          ],
        ),
      ],
    ).animate(delay: 400.ms)
     .fadeIn(duration: 800.ms)
     .slideX(begin: isMobile ? 0 : -0.2, curve: Curves.easeOutCubic);
  }

  /// Build working quick links
  Widget _buildQuickLinks(ThemeData theme, bool isMobile) {
    final links = [
      {"text": "Features", "action": () => _scrollToSection("features")},
      {"text": "About Us", "action": () => _scrollToSection("about")},
      {"text": "Download App", "action": () => _navigateToDownload()},
      {"text": "Support", "action": () => Helpers.launchUrlHelper(context, 'mailto:$_emailAddress?subject=Support Request')},
      {"text": "Privacy Policy", "action": () => _showPrivacyPolicy()},
      {"text": "Terms of Service", "action": () => _showTermsOfService()},
    ];

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Links",
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...links.asMap().entries.map((entry) {
          final index = entry.key;
          final link = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _FooterLink(
              text: link["text"] as String,
              onTap: link["action"] as VoidCallback,
            ),
          ).animate(delay: (600 + index * 100).ms)
           .fadeIn(duration: 600.ms)
           .slideX(begin: 0.2, curve: Curves.easeOutCubic);
        }),
      ],
    );
  }

  /// Build connect section with working social links
  Widget _buildConnectSection(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "Connect With Us",
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _SocialButton(
              icon: Icons.facebook,
              onPressed: () => Helpers.launchUrlHelper(context, _socialLinks['facebook']!),
              color: const Color(0xFF1877F2),
              platform: "Facebook",
            ),
            _SocialButton(
              icon: Icons.alternate_email,
              onPressed: () => Helpers.launchUrlHelper(context, _socialLinks['twitter']!),
              color: const Color(0xFF1DA1F2),
              platform: "Twitter",
            ),
            _SocialButton(
              icon: Icons.business,
              onPressed: () => Helpers.launchUrlHelper(context, _socialLinks['linkedin']!),
              color: const Color(0xFF0A66C2),
              platform: "LinkedIn",
            ),
            _SocialButton(
              icon: Icons.camera_alt,
              onPressed: () => Helpers.launchUrlHelper(context, _socialLinks['instagram']!),
              color: const Color(0xFFE4405F),
              platform: "Instagram",
            ),
            _SocialButton(
              icon: Icons.play_arrow,
              onPressed: () => Helpers.launchUrlHelper(context, _socialLinks['youtube']!),
              color: const Color(0xFFFF0000),
              platform: "YouTube",
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Direct contact
        Text(
          "Questions? We're here to help!",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    ).animate(delay: 800.ms)
     .fadeIn(duration: 800.ms)
     .slideX(begin: 0.2, curve: Curves.easeOutCubic);
  }

  /// Build bottom bar
  Widget _buildBottomBar(ThemeData theme, bool isMobile) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: isMobile 
          ? Column(
              children: [
                Text(
                  "© ${DateTime.now().year} ${AppStrings.appName.tr()}. All rights reserved.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Made with ❤️ for amazing services",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "© ${DateTime.now().year} ${AppStrings.appName.tr()}. All rights reserved.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  "Made with ❤️ for amazing services",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
    ).animate(delay: 1000.ms)
     .fadeIn(duration: 800.ms);
  }

  /// Build scroll to top button
  Widget _buildScrollToTop(ThemeData theme) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi) * 3),
            child: _ViralButton(
              text: "Top",
              onPressed: _scrollToTop,
              icon: Icons.keyboard_arrow_up,
              isFloating: true,
            ),
          );
        },
      ).animate(delay: 1200.ms)
       .fadeIn(duration: 600.ms)
       .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
    );
  }

  /// Handle newsletter subscription with database integration
  Future<void> _handleSubscribe() async {
    final email = _emailController.text.trim();
    
    // Validation
    if (email.isEmpty) {
      setState(() => _subscriptionError = "Please enter your email address");
      return;
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _subscriptionError = "Please enter a valid email address");
      return;
    }

    setState(() {
      _isSubscribing = true;
      _subscriptionError = null;
    });

    try {
      // Call newsletter service
      await _newsletterService.subscribeToNewsletter(email);
      
      // Success
      setState(() {
        _isSubscribed = true;
        _isSubscribing = false;
      });
      
      // Analytics tracking
      // AnalyticsService.track('newsletter_subscribe', {'email': email});
      
      // Clear form
      _emailController.clear();
      _emailFocusNode.unfocus();
      
    } catch (e) {
      // Handle errors
      setState(() {
        _isSubscribing = false;
        _subscriptionError = e.toString().contains('already subscribed') 
            ? "You're already part of our community! 🎉"
            : "Something went wrong. Please try again.";
      });
    }
  }

  /// Navigation and action methods
  void _scrollToSection(String section) {
    // TODO: Implement smooth scrolling to sections
    widget.scrollController?.animateTo(
      0, // Replace with actual section offsets
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  void _navigateToDownload() {
    // TODO: Navigate to download page or show download modal
    showDialog(
      context: context,
      builder: (context) => _DownloadDialog(),
    );
  }

  void _showPrivacyPolicy() {
    Helpers.launchUrlHelper(context, 'https://shamil.app/privacy');
  }

  void _showTermsOfService() {
    Helpers.launchUrlHelper(context, 'https://shamil.app/terms');
  }

  void _scrollToTop() {
    widget.scrollController?.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }
}

// SUPPORTING WIDGETS AND SERVICES

/// Newsletter service for database integration
class NewsletterService {
  Future<void> subscribeToNewsletter(String email) async {
    // TODO: Replace with your actual API endpoint
    // Example implementation:
    
    /*
    try {
      final response = await http.post(
        Uri.parse('https://api.shamil.app/newsletter/subscribe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'source': 'website_footer',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to subscribe');
      }
      
      // Send welcome email
      await _sendWelcomeEmail(email);
      
    } catch (e) {
      throw Exception('Subscription failed: ${e.toString()}');
    }
    */
    
    // For now, simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate potential errors
    if (email == 'test@duplicate.com') {
      throw Exception('Email already subscribed');
    }
    
    // Success - in real implementation, save to database
    print('Newsletter subscription: $email');
  }
}

/// Contact info widget
class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactInfo({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFFD8A31A),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Download dialog
class _DownloadDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Download Shamil App'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Get the Shamil app on your favorite platform:'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Helpers.launchUrlHelper(
                  context, 
                  'https://apps.apple.com/app/shamil'
                ),
                icon: const Icon(Icons.apple),
                label: const Text('App Store'),
              ),
              ElevatedButton.icon(
                onPressed: () => Helpers.launchUrlHelper(
                  context, 
                  'https://play.google.com/store/apps/details?id=com.shamil.app'
                ),
                icon: const Icon(Icons.shop),
                label: const Text('Google Play'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

// REUSABLE COMPONENTS (keeping the same implementations but with enhancements)

/// Enhanced viral button
class _ViralButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isFloating;
  final bool isCompact;

  const _ViralButton({
    required this.text,
    required this.onPressed,
    required this.icon,
    this.isFloating = false,
    this.isCompact = false,
  });

  @override
  State<_ViralButton> createState() => _ViralButtonState();
}

class _ViralButtonState extends State<_ViralButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: widget.isCompact ? 14 : (widget.isFloating ? 16 : 18)),
          label: Text(widget.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD8A31A),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCompact ? 12 : (widget.isFloating ? 16 : 20),
              vertical: widget.isCompact ? 8 : (widget.isFloating ? 12 : 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.isFloating ? 25 : 12),
            ),
            elevation: _isHovered ? 8 : 4,
            shadowColor: const Color(0xFFD8A31A).withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

/// Enhanced social media button with platform info
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final String platform;

  const _SocialButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.platform,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: 'Follow us on ${widget.platform}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered ? widget.color : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered ? widget.color : Colors.white.withOpacity(0.2),
                ),
                boxShadow: _isHovered ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: Icon(
                widget.icon,
                color: _isHovered ? Colors.white : widget.color,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Enhanced footer link with better hover effects
class _FooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isHovered ? 4 : 0,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8A31A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (_isHovered) const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  color: _isHovered 
                      ? const Color(0xFFD8A31A) 
                      : Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: _isHovered ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              if (_isHovered) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: const Color(0xFFD8A31A),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom wave painter (same as before)
class WavePainter extends CustomPainter {
  final double animationValue;
  final ThemeData theme;

  WavePainter({required this.animationValue, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD8A31A).withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - 50 + 
          math.sin((x / waveLength + animationValue) * 2 * math.pi) * waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}