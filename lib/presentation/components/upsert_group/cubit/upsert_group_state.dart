part of 'upsert_group_cubit.dart';

@freezed
abstract class UpsertGroupState with _$UpsertGroupState {
  const UpsertGroupState._();

  const factory UpsertGroupState({
    required BaseState<bool> upsertGroupState,
  }) = _UpsertGroupState;
}
