part of 'my_info_bloc.dart';

@JsonSerializable()
class MyInfoState extends Equatable {
  final UserInfo? userInfo;
  final List<MoreInfo> moreInfos;
  final List<MyProject> myProjects;
  final LoadingState loadingState;

  const MyInfoState(
      {this.userInfo,
      this.loadingState = LoadingState.initial,
      this.moreInfos = const [],
      this.myProjects = const []});

  MyInfoState copyWith({
    UserInfo? userInfo,
    List<MoreInfo>? moreInfos,
    List<MyProject>? myProjects,
    LoadingState? loadingState,
  }) {
    return MyInfoState(
      userInfo: userInfo ?? this.userInfo,
      moreInfos: moreInfos ?? this.moreInfos,
      myProjects: myProjects ?? this.myProjects,
      loadingState: loadingState ?? this.loadingState,
    );
  }

  @override
  List<Object?> get props => [
        userInfo,
        moreInfos,
        myProjects,
        loadingState,
      ];
}
