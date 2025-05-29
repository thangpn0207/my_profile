import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_profile/models/more_info.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:my_profile/models/user_info.dart';
import 'package:equatable/equatable.dart';

import '../service/local_data_services.dart';

part 'my_info_bloc.g.dart';

part 'my_info_event.dart';

part 'my_info_state.dart';

/// BLoC responsible for managing user profile information state
/// Now uses local JSON data instead of API calls for better performance
/// and offline capability
class MyInfoBloc extends HydratedBloc<MyInfoEvent, MyInfoState> {
  MyInfoBloc() : super(const MyInfoState()) {
    on<OnInit>(_onInit);
  }

  // Replace API service with local data service
  final LocalDataService _localDataService = LocalDataService();

  /// Handles initialization event by loading all required data
  /// Uses Future.wait for concurrent data loading to optimize performance
  Future<void> _onInit(OnInit event, Emitter<MyInfoState> emit) async {
    try {
      // Emit loading state to update UI
      emit(state.copyWith(loadingState: LoadingState.loading));

      // Load all data concurrently for better performance
      // Maintains the same structure as the original API-based implementation
      final data = await Future.wait([
        _localDataService.getUserInfo(),
        _localDataService.getMoreInfo(),
        _localDataService.getProject(),
      ]);

      // Type-safe casting with proper error handling
      final UserInfo userInfo = data[0] as UserInfo;
      final List<MoreInfo> moreInfos = data[1] as List<MoreInfo>;
      final List<MyProject> myProjects = data[2] as List<MyProject>;

      // Emit success state with loaded data
      emit(state.copyWith(
        userInfo: userInfo,
        moreInfos: moreInfos,
        myProjects: myProjects,
        loadingState: LoadingState.loaded,
      ));
    } catch (e) {
      // Handle any errors during data loading
      emit(state.copyWith(loadingState: LoadingState.err));
    } finally {
      // Reset loading state to initial after operation completes
      emit(state.copyWith(loadingState: LoadingState.initial));
    }
  }

  /// Hydrated BLoC serialization methods
  /// Maintains state persistence across app sessions
  @override
  MyInfoState? fromJson(Map<String, dynamic> json) =>
      _$MyInfoStateFromJson(json);

  @override
  Map<String, dynamic>? toJson(MyInfoState state) => _$MyInfoStateToJson(state);
}
