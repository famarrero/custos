part of 'custom_navigation_bar_cubit.dart';

@freezed
abstract class CustomNavigationBarState with _$CustomNavigationBarState {
  const factory CustomNavigationBarState({
    @Default((0, true)) (int, bool) currentPage,
  }) = _CustomNavigationBarState;
}
