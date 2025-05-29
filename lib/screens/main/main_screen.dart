import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_text_styles.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        if (state.loadingState == LoadingState.loading) {
          return _buildLoadingScreen();
        }
        if (state.loadingState == LoadingState.err) {
          return _buildErrorScreen();
        }
        return _buildMainContent(context);
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gif(
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                autostart: Autostart.loop,
                placeholder: (context) => CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
                image: const AssetImage('assets/gifs/loading.gif'),
              ),
              SizedBox(height: AppDimensions.paddingL),
              Text(
                'Loading...',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              SizedBox(height: AppDimensions.paddingL),
              Text(
                'Oops! Something went wrong',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingM),
              Text(
                'Please try again later',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingXL),
              ElevatedButton(
                onPressed: () {
                  // You can add retry logic here if needed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                    vertical: AppDimensions.paddingM,
                  ),
                ),
                child: Text(
                  'Retry',
                  style: AppTextStyles.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Hide the appbar on desktop
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.textPrimary,
                    size: AppDimensions.iconM,
                  ),
                ),
              ),
            ),
      drawer: const SideMenu(),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppDimensions.radiusM),
                        bottomRight: Radius.circular(AppDimensions.radiusM),
                      ),
                    ),
                    child: const SideMenu(),
                  ),
                ),
              if (isDesktop) SizedBox(width: AppDimensions.paddingM),
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingL,
                  ),
                  child: Column(
                    children: [
                      ...children,
                      SizedBox(height: AppDimensions.paddingXXL),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
              if (isDesktop) SizedBox(width: AppDimensions.paddingM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Text(
            '© 2024 Pham Ngoc Thang. All rights reserved.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            'Built with Flutter 💙',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
