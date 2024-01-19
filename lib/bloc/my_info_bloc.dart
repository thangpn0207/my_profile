import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_profile/api/api.dart';
import 'package:my_profile/constants.dart';
import 'package:my_profile/models/more_info.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:my_profile/models/user_info.dart';
import 'package:equatable/equatable.dart';

part 'my_info_bloc.g.dart';
part 'my_info_event.dart';
part 'my_info_state.dart';

class MyInfoBloc extends HydratedBloc<MyInfoEvent, MyInfoState> {
  MyInfoBloc() : super(const MyInfoState()) {
    on<OnInit>(_onInit);
  }
  final MyAPI _api = MyAPI();
  Future<void> _onInit(event, emit) async {
    try {
      emit(state.copyWith(loadingState: LoadingState.loading));

      final data = await Future.wait(
          [_api.getUserInfo(), _api.getMoreInfo(), _api.getProject()]);
      final UserInfo userInfo = data[0] as UserInfo;
      final List<MoreInfo> moreInfos = data[1] as List<MoreInfo>;
      final List<MyProject> myProject = data[2] as List<MyProject>;
      emit(state.copyWith(
          userInfo: userInfo,
          moreInfos: moreInfos,
          myProjects: myProject,
          loadingState: LoadingState.loaded));
    } catch (e) {
      emit(state.copyWith(loadingState: LoadingState.err));
    } finally {
      emit(state.copyWith(loadingState: LoadingState.initial));
    }
  }

  @override
  MyInfoState? fromJson(Map<String, dynamic> json) =>
      _$MyInfoStateFromJson(json);

  @override
  Map<String, dynamic>? toJson(MyInfoState state) => _$MyInfoStateToJson(state);
}
