part of 'database_version_cubit.dart';

@freezed
abstract class DatabaseVersionState with _$DatabaseVersionState {
  const DatabaseVersionState._();

  const factory DatabaseVersionState({
    required BaseState<int> versionState,
  }) = _DatabaseVersionState;
}
