import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/screens/main/main_screen.dart';

import '../../core/app_dimensions.dart';
import 'components/highlights.dart';
import 'components/home_banner.dart';
import 'components/my_projects.dart';
import 'components/recommendations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger data loading when screen initializes
    context.read<MyInfoBloc>().add(OnInit());
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      children: [
        const HomeBanner(),
        const HighLightsInfo(),
        SizedBox(height: AppDimensions.paddingM),
        const MyProjects(),
        SizedBox(height: AppDimensions.paddingM),
        const AboutMe(),
      ],
    );
  }
}
