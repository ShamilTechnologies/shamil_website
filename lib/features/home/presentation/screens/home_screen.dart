import 'package:flutter/material.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/widgets/language_switcher.dart';
import 'package:shamil_web/core/widgets/theme_switcher.dart';
import 'package:shamil_web/features/home/presentation/widgets/GetShamil.dart';
import 'package:shamil_web/features/home/presentation/widgets/app_preview_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/benefits_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/download_cta_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/features_highlight_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/hero_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/intro_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/testimonials_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/rocket_separator_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight;
    final double logoHeight = appBarHeight * 0.75;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          AppAssets.logo,
          height: logoHeight,
        ),
        centerTitle: false,
        actions: const [
          LanguageSwitcher(),
          ThemeSwitcher(),
          SizedBox(width: AppDimensions.paddingMedium),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const HeroSection(),
            const IntroSection(),
            RocketSeparatorSection(scrollController: _scrollController),
            FeaturesHighlightSection(scrollController: _scrollController),
            const GetShamilSection(),
            const AppPreviewSection(),
            const HowItWorksSection(),
            const TestimonialsSection(),
            const DownloadCtaSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
