import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class GetShamilSection extends StatefulWidget {
  const GetShamilSection({super.key});

  @override
  State<GetShamilSection> createState() => _GetShamilSectionState();
}

class _GetShamilSectionState extends State<GetShamilSection> with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<Offset> _textAnimation;

  late AnimationController _videoAnimController;
  late Animation<Offset> _videoAnimation;

  late VideoPlayerController _videoController;

  final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
  final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _videoAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _videoAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _videoAnimController, curve: Curves.easeOut));

    _textController.forward();
    _videoAnimController.forward();

    _videoController = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _textController.dispose();
    _videoAnimController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: isMobile
          ? Column(
              children: [
                SlideTransition(position: _textAnimation, child: _buildTextContent()),
                const Gap(20),
                SlideTransition(position: _videoAnimation, child: _buildVideoContainer()),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SlideTransition(position: _textAnimation, child: _buildTextContent())),
                const Gap(40),
                Expanded(child: SlideTransition(position: _videoAnimation, child: _buildVideoContainer())),
              ],
            ),
    );
  }

  Widget _buildTextContent() {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get Shamil',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(40),
        const Text(
          'Whatever you’re on — Windows, macOS, Android — it just works seamlessly!',
          style: TextStyle(fontSize: 20),
        ),
        const Gap(60),
        ResponsiveRowColumn(
          layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.start,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          rowSpacing: AppDimensions.spacingMedium,
          columnSpacing: AppDimensions.spacingMedium,
          children: [
            ResponsiveRowColumnItem(
              child: CustomButton(
                text: AppStrings.downloadApp.tr(),
                onPressed: () => Helpers.launchUrlHelper(context, _appStoreUrl),
                icon: const Icon(Icons.apple),
              ),
            ),
            ResponsiveRowColumnItem(
              child: CustomButton(
                text: "Google Play",
                onPressed: () => Helpers.launchUrlHelper(context, _playStoreUrl),
                icon: const Icon(Icons.shop),
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),
      ],
    );
  }

  Widget _buildVideoContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
        ),
        clipBehavior: Clip.antiAlias,
        child: _videoController.value.isInitialized
            ? VideoPlayer(_videoController)
            : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

