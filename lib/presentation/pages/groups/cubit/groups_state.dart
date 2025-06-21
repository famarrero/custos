part of 'groups_cubit.dart';

@freezed
abstract class GroupsState with _$GroupsState {
  const GroupsState._();

  const factory GroupsState({
    required BaseState<List<GroupModel>> groups,
  }) = _GroupsState;
}
