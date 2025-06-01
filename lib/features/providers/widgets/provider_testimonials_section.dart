
// // lib/features/provider/presentation/widgets/provider_cta_section.dart
// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:shamil_web/core/constants/app_strings.dart';
// import 'package:shamil_web/core/widgets/custom_button.dart';
// import 'package:shamil_web/core/utils/helpers.dart';
// import 'package:shamil_web/core/constants/app_dimensions.dart';
// import 'package:shamil_web/core/constants/app_colors.dart'; // For Shamil colors


// class _ProviderTestimonialsSectionState extends State<ProviderTestimonialsSection>
//     with TickerProviderStateMixin {
  
//   late PageController _pageController;
//   late AnimationController _autoScrollController;
//   late AnimationController _floatingController;
//   int _currentPage = 0;

//   final List<ProviderTestimonial> _testimonials = [
//     const ProviderTestimonial(
//       businessName: "Elite Beauty Salon",
//       businessType: "Beauty & Wellness",
//       testimonialText: "Shamil transformed our booking process completely. We've seen a 300% increase in online bookings and our no-show rate dropped by 80%. The platform is incredibly intuitive for both us and our clients.",
//       ownerName: "Sarah Johnson",
//       ownerTitle: "Founder & CEO",
//       logoAsset: "assets/images/salon_logo.png",
//       rating: 5.0,
//       metric1Label: "Revenue Growth",
//       metric1Value: "+245%",
//       metric2Label: "Time Saved",
//       metric2Value: "15hrs/week",
//     ),
//     const ProviderTestimonial(
//       businessName: "FitLife Gym",
//       businessType: "Fitness & Sports",
//       testimonialText: "The subscription management feature is a game-changer. We can now handle complex membership plans effortlessly. Our member retention improved by 60% since switching to Shamil.",
//       ownerName: "Mike Rodriguez",
//       ownerTitle: "Operations Manager",
//       logoAsset: "assets/images/gym_logo.png",
//       rating: 5.0,
//       metric1Label: "Member Retention",
//       metric1Value: "+60%",
//       metric2Label: "Admin Time",
//       metric2Value: "-70%",
//     ),
//     const ProviderTestimonial(
//       businessName: "Dental Care Plus",
//       businessType: "Healthcare",
//       testimonialText: "The analytics dashboard gives us insights we never had before. We can predict busy periods, optimize staff schedules, and provide better patient care. Absolutely recommended!",
//       ownerName: "Dr. Emily Chen",
//       ownerTitle: "Clinical Director",
//       logoAsset: "assets/images/dental_logo.png",
//       rating: 5.0,
//       metric1Label: "Patient Satisfaction",
//       metric1Value: "98%",
//       metric2Label: "Efficiency Gain",
//       metric2Value: "+85%",
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       viewportFraction: 0.85,
//       initialPage: _currentPage,
//     );

//     _autoScrollController = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     );

//     _floatingController = AnimationController(
//       duration: const Duration(seconds: 6),
//       vsync: this,
//     )..repeat(reverse: true);

//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _autoScrollController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _nextPage();
//         _autoScrollController.reset();
//         _autoScrollController.forward();
//       }
//     });
//     _autoScrollController.forward();
//   }

//   void _nextPage() {
//     final nextPage = (_currentPage + 1) % _testimonials.length;
//     _pageController.animateToPage(
//       nextPage,
//       duration: const Duration(milliseconds: 800),
//       curve: Curves.easeInOutCubic,
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _autoScrollController.dispose();
//     _floatingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: isMobile ? 60 : 100,
//         horizontal: AppDimensions.paddingPageHorizontal,
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: theme.brightness == Brightness.light
//               ? [
//                   AppColors.primary.withOpacity(0.05),
//                   theme.colorScheme.surface,
//                   AppColors.primaryGold.withOpacity(0.03),
//                 ]
//               : [
//                   AppColors.primary.withOpacity(0.08),
//                   theme.colorScheme.surface,
//                   AppColors.primaryGold.withOpacity(0.05),
//                 ],
//         ),
//       ),
//       child: Column(
//         children: [
//           _buildHeader(theme, isMobile),
//           SizedBox(height: isMobile ? 40 : 60),
//           _buildTestimonialsCarousel(theme, isMobile),
//           const SizedBox(height: 40),
//           _buildIndicators(theme),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(ThemeData theme, bool isMobile) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(
//               color: AppColors.primary.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           child: Text(
//             "⭐ Success Stories",
//             style: theme.textTheme.labelLarge?.copyWith(
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ).animate()
//          .fadeIn(delay: 200.ms)
//          .slideY(begin: -0.2),

//         const SizedBox(height: 24),

//         Text(
//           "Trusted by Thousands of Providers",
//           style: (isMobile 
//               ? theme.textTheme.headlineMedium 
//               : theme.textTheme.displaySmall)?.copyWith(
//             fontWeight: FontWeight.w900,
//             color: theme.colorScheme.onSurface,
//           ),
//           textAlign: TextAlign.center,
//         ).animate()
//          .fadeIn(delay: 400.ms)
//          .slideY(begin: 0.2),

//         const SizedBox(height: 16),

//         Text(
//           "See how businesses like yours are thriving with Shamil",
//           style: theme.textTheme.titleLarge?.copyWith(
//             color: theme.colorScheme.onSurface.withOpacity(0.7),
//           ),
//           textAlign: TextAlign.center,
//         ).animate()
//          .fadeIn(delay: 600.ms),
//       ],
//     );
//   }

//   Widget _buildTestimonialsCarousel(ThemeData theme, bool isMobile) {
//     return SizedBox(
//       height: isMobile ? 500 : 400,
//       child: PageView.builder(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() => _currentPage = index);
//           _autoScrollController.reset();
//           _autoScrollController.forward();
//         },
//         itemCount: _testimonials.length,
//         itemBuilder: (context, index) {
//           final testimonial = _testimonials[index];
//           final isActive = index == _currentPage;

//           return AnimatedBuilder(
//             animation: _floatingController,
//             builder: (context, child) {
//               final floatOffset = isActive 
//                   ? _floatingController.value * 8 
//                   : 0.0;

//               return Transform.translate(
//                 offset: Offset(0, floatOffset),
//                 child: Transform.scale(
//                   scale: isActive ? 1.0 : 0.9,
//                   child: _buildTestimonialCard(theme, testimonial, isActive),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTestimonialCard(ThemeData theme, ProviderTestimonial testimonial, bool isActive) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(32),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             theme.colorScheme.surface,
//             theme.colorScheme.surface.withOpacity(0.95),
//           ],
//         ),
//         border: Border.all(
//           color: isActive 
//               ? AppColors.primary.withOpacity(0.3)
//               : theme.colorScheme.outline.withOpacity(0.1),
//           width: isActive ? 2 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: isActive
//                 ? AppColors.primary.withOpacity(0.15)
//                 : Colors.black.withOpacity(0.05),
//             blurRadius: isActive ? 30 : 20,
//             spreadRadius: isActive ? 5 : 0,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(32),
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header with logo and business info
//                 Row(
//                   children: [
//                     Container(
//                       width: 60,
//                       height: 60,
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: AppColors.primary.withOpacity(0.2),
//                           width: 1,
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.business,
//                         color: AppColors.primary,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             testimonial.businessName,
//                             style: theme.textTheme.titleLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: theme.colorScheme.onSurface,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             testimonial.businessType,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: AppColors.primaryGold,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Rating
//                     Row(
//                       children: List.generate(
//                         5,
//                         (index) => Icon(
//                           Icons.star_rounded,
//                           size: 20,
//                           color: AppColors.primaryGold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Testimonial text
//                 Text(
//                   '"${testimonial.testimonialText}"',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     height: 1.6,
//                     fontSize: 16,
//                     color: theme.colorScheme.onSurface.withOpacity(0.9),
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),

//                 const Spacer(),

//                 // Metrics
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildMetric(
//                         theme,
//                         testimonial.metric1Label,
//                         testimonial.metric1Value,
//                         AppColors.primary,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _buildMetric(
//                         theme,
//                         testimonial.metric2Label,
//                         testimonial.metric2Value,
//                         AppColors.primaryGold,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Owner info
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundColor: AppColors.primary.withOpacity(0.1),
//                       child: Text(
//                         testimonial.ownerName.split(' ').map((e) => e[0]).join(),
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           testimonial.ownerName,
//                           style: theme.textTheme.titleSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           testimonial.ownerTitle,
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: theme.colorScheme.onSurface.withOpacity(0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMetric(ThemeData theme, String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             value,
//             style: theme.textTheme.headlineSmall?.copyWith(
//               color: color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: theme.colorScheme.onSurface.withOpacity(0.7),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIndicators(ThemeData theme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         _testimonials.length,
//         (index) => Container(
//           width: _currentPage == index ? 40 : 12,
//           height: 12,
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//             color: _currentPage == index
//                 ? AppColors.primary
//                 : theme.colorScheme.outline.withOpacity(0.3),
//           ),
//         ).animate(target: _currentPage == index ? 1 : 0)
//         //  .scale(end: _currentPage == index ? 1.2 : 1.0),
//       ),
//     );
//   }
// }