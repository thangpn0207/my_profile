import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        return AspectRatio(
          aspectRatio: 1.23,
          child: Container(
            color: const Color(0xFF242430),
            child: Column(
              children: [
                const Spacer(flex: 2),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(state.userInfo?.avatarURl ?? ''),
                ),
                const Spacer(),
                Text(
                  state.userInfo?.name ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  state.userInfo?.role ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
