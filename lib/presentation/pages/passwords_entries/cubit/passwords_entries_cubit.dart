import 'package:custos/core/utils/app_icons.dart';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'passwords_entries_cubit.freezed.dart';
part 'passwords_entries_state.dart';

class PasswordsEntriesCubit extends Cubit<PasswordsEntriesState> {
  PasswordsEntriesCubit()
    : super(
        PasswordsEntriesState(
          passwordsEntries: BaseState.initial(),
          groups: BaseState.initial(),
        ),
      );

  static GroupEntity groupAll = GroupEntity(
    id: 'add',
    name: 'Todos',
    icon: AppIcons.groupOthers,
    color: null,
  );

  final PasswordEntryRepository passwordEntryRepository = di();
  final GroupRepository groupRepository = di();

  StreamSubscription<List<PasswordEntryEntity>>? _passwordsEntriesSubscription;
  StreamSubscription<List<GroupEntity>>? _groupEntitySubscription;

  List<PasswordEntryEntity> _allPasswordEntries = [];

  Future<void> watchPasswordsEntries() async {
    emit(state.copyWith(passwordsEntries: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _passwordsEntriesSubscription?.cancel();

    _passwordsEntriesSubscription = passwordEntryRepository
        .watchPasswordsEntries()
        .listen(
          (passwordsEntries) {
            _allPasswordEntries = passwordsEntries;
            emit(
              state.copyWith(
                passwordsEntries:
                    passwordsEntries.isEmpty
                        ? BaseState.empty()
                        : BaseState.data(passwordsEntries),
              ),
            );
          },
          onError: (e) {
            emit(
              state.copyWith(
                passwordsEntries: BaseState.error(
                  AppFailure(AppError.unknown, message: e.toString()),
                ),
              ),
            );
          },
        );
  }

  Future<void> watchGroups() async {
    emit(state.copyWith(groups: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _groupEntitySubscription?.cancel();

    _groupEntitySubscription = groupRepository.watchGroups().listen(
      (groups) {
        emit(
          state.copyWith(
            groups: groups.isEmpty ? BaseState.empty() : BaseState.data(groups),
          ),
        );

        watchPasswordsEntries();
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

  /// Filters the list of password entries based on a text query and/or selected group.
  /// Emits the new filtered list through the state.
  ///
  /// Parameters:
  /// - [query]: Optional search string to match against password entry names.
  /// - [group]: Optional group to filter password entries by.
  Future<void> filterPasswordEntries({
    String? query,
    GroupEntity? group,
  }) async {
    // Save current filter criteria in the state
    emit(state.copyWith(query: query, selectedGroup: group));

    // Start with the full list of entries
    List<PasswordEntryEntity> filteredList = _allPasswordEntries;

    // Apply text query filter if provided
    if (query.isNotNullAndNotEmpty) {
      final lowerQuery = query!.trimToLowerCase;
      filteredList =
          filteredList
              .where((entry) => entry.name.trimToLowerCase.contains(lowerQuery))
              .toList();
    }

    // Apply group filter if a specific group is selected
    if (group?.id != groupAll.id && group != null) {
      filteredList =
          filteredList.where((entry) => entry.group?.id == group.id).toList();
    }

    // Emit the filtered result
    emit(
      state.copyWith(
        passwordsEntries: BaseState.data(
          filteredList.isEmpty ? [] : filteredList,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _passwordsEntriesSubscription?.cancel();
    _groupEntitySubscription?.cancel();
    return super.close();
  }
}
