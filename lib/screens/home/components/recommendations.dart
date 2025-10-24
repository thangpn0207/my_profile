import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';
import 'recommendation_card.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({
    super.key,
  });

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  bool _showAllRecommendations = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: AppDimensions.animationNormal),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleRecommendations() {
    setState(() {
      _showAllRecommendations = !_showAllRecommendations;
    });
    if (_showAllRecommendations) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: AppDimensions.iconL,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Text(
                    "ABOUT ME",
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            BlocBuilder<MyInfoBloc, MyInfoState>(
              builder: (context, state) {
                if (state.moreInfos.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingXL),
                      child: Text(
                        'No information available',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                final displayRecommendations = _showAllRecommendations
                    ? state.moreInfos
                    : state.moreInfos.take(2).toList();
                final hasMoreRecommendations = state.moreInfos.length > 2;

                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          displayRecommendations.length,
                          (index) => Padding(
                            padding:
                                EdgeInsets.only(right: AppDimensions.paddingM),
                            child: RecommendationCard(
                              moreInfo: displayRecommendations[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (hasMoreRecommendations) ...[
                      SizedBox(height: AppDimensions.paddingL),
                      Center(
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value * 3.14159,
                              child: ElevatedButton(
                                onPressed: _toggleRecommendations,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingXL,
                                    vertical: AppDimensions.paddingM,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusL),
                                  ),
                                  elevation: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.surfaceDark,
                                      size: AppDimensions.iconM,
                                    ),
                                    SizedBox(width: AppDimensions.paddingS),
                                    Flexible(
                                      child: Text(
                                        _showAllRecommendations
                                            ? "Show Less"
                                            : "See More",
                                        style:
                                            AppTextStyles.labelMedium.copyWith(
                                          color: AppColors.surfaceDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
