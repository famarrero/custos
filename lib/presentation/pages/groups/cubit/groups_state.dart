part of 'groups_cubit.dart';

@freezed
abstract class GroupsState with _$GroupsState {
  const GroupsState._();

  const factory GroupsState({
    required BaseState<List<GroupEntity>> groups,
  }) = _GroupsState;
}
