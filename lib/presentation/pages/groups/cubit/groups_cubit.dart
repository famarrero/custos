import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups_cubit.freezed.dart';
part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsState(groups: BaseState.initial()));

  final GroupRepository groupRepository = di();

  StreamSubscription<List<GroupEntity>>? _groupsSubscription;

  Future<void> watchGroups() async {
    emit(state.copyWith(groups: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _groupsSubscription?.cancel();

    _groupsSubscription = groupRepository.watchGroups().listen(
      (groups) {
        emit(
          state.copyWith(
            groups: groups.isEmpty ? BaseState.empty() : BaseState.data(groups),
          ),
        );
      },
      onError: (e) {
        emit(
          state.copyWith(
            groups: BaseState.error(
              AppFailure(AppError.unknown, message: e.toString()),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }
}
