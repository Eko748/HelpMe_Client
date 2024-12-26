part of 'rate_mitra_cubit.dart';

sealed class RateMitraState extends Equatable {
  const RateMitraState();

  @override
  List<Object> get props => [];
}

final class RateMitraInitial extends RateMitraState {}

final class RateMitraLoading extends RateMitraState {}

final class RateMitraSuccess extends RateMitraState {
  final OrderRatingResponseModel response;

  const RateMitraSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class RateMitraError extends RateMitraState {
  final String message;

  const RateMitraError({required this.message});

  @override
  List<Object> get props => [message];
}

