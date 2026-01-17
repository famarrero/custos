import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/data/repositories/version/version_repository.dart';
import 'package:custos/di_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'database_version_cubit.freezed.dart';
part 'database_version_state.dart';

class DatabaseVersionCubit extends Cubit<DatabaseVersionState> {
  DatabaseVersionCubit() : super(DatabaseVersionState(versionState: BaseState.initial()));

  final VersionRepository versionRepository = di();

  Future<void> getDatabaseVersion() async {
    emit(state.copyWith(versionState: BaseState.loading()));

    final version = await versionRepository.getVersion();

    emit(state.copyWith(versionState: BaseState.data(version)));
  }
}
