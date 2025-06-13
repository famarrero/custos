import 'package:custos/core/utils/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

@freezed
class BaseState<T> with _$BaseState {
  const BaseState._();

  const factory BaseState.initial() = BaseStateInitial;

  const factory BaseState.loading() = BaseStateLoading;

  const factory BaseState.error(Failure failure) = BaseStateError;

  const factory BaseState.empty() = BaseStateEmpty;

  const factory BaseState.data(T data) = BaseStateData;

  /// Returns true if the object is of type [BaseStateLoading].
  bool get isLoading => this is BaseStateLoading;

  /// Returns true if the object is of type [BaseStateError].
  bool get isError => this is BaseStateError;

  /// Returns true if the object is of type [BaseStateEmpty].
  bool get isEmpty => this is BaseStateEmpty;

  /// Returns true if the object is of type [BaseStateData].
  bool get isData => this is BaseStateData;

  /// Returns the error information if the object is of type [BaseStateError].
  Failure get error {
    final error = this as BaseStateError;
    return error.failure;
  }

  /// Returns the data if the object is of type [BaseStateData].
  T get data {
    return (this as BaseStateData).data;
  }

  /// Returns the data if the object is of type [BaseStateData], otherwise returns null.
  T? get dataOrNull {
    if (this is BaseStateData) {
      return (this as BaseStateData).data;
    }
    return null;
  }
}
