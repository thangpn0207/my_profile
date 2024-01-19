import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/constants.dart';
import 'package:my_profile/responsive.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        if (state.loadingState == LoadingState.loading) {
          return SizedBox.expand(
            child: Center(
              child: Gif(
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                autostart: Autostart.loop,
                placeholder: (context) =>
                    const Center(child: CircularProgressIndicator()),
                image: const AssetImage('assets/gifs/loading.gif'),
              ),
            ),
          );
        }
        if (state.loadingState == LoadingState.err) {
          return const Center(
            child: Text('Please try again'),
          );
        }
        return Scaffold(
          // We hide the appbar on desktop
          appBar: Responsive.isDesktop(context)
              ? null
              : AppBar(
                  backgroundColor: bgColor,
                  leading: Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                ),
          drawer: const SideMenu(),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: maxWidth),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      flex: 2,
                      child: SideMenu(),
                    ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...children,
                          // our footer
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
