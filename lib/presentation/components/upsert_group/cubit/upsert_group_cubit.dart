import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_group_cubit.freezed.dart';
part 'upsert_group_state.dart';

class UpsertGroupCubit extends Cubit<UpsertGroupState> {
  UpsertGroupCubit()
    : super(UpsertGroupState(upsertGroupState: BaseState.initial()));

  final GroupRepository groupRepository = di();

  Future<void> upsertPasswordEntry({required GroupEntity group}) async {
    try {
      emit(state.copyWith(upsertGroupState: BaseState.loading()));

      await groupRepository.upsertGroup(group: group);

      emit(state.copyWith(upsertGroupState: BaseState.data(true)));
    } catch (e) {
      emit(
        state.copyWith(
          upsertGroupState: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }
}
