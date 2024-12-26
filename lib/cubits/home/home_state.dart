part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeDisposed extends HomeState {}

final class CategoryLoaded extends HomeState {
  final List<CategoryModel> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CategoryError extends HomeState {
  final String errorMessage;

  const CategoryError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class OrderHistoryLoaded extends HomeState {
  final List<OrderHistoryModel> history;

  const OrderHistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

final class OrderHistoryError extends HomeState {
  final String errorMessage;

  const OrderHistoryError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class HomeIdle extends HomeState {}
