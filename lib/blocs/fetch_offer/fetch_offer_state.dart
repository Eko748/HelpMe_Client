part of 'fetch_offer_bloc.dart';

sealed class FetchOfferState extends Equatable {
  const FetchOfferState();

  @override
  List<Object> get props => [];
}

final class FetchOfferInitial extends FetchOfferState {}

final class FetchOfferLoading extends FetchOfferState {}

final class FetchOfferIdle extends FetchOfferState {}

final class FetchOfferLoaded extends FetchOfferState {
  final OfferResponseModel data;

  const FetchOfferLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class FetchOfferError extends FetchOfferState {
  final String message;

  const FetchOfferError({required this.message});

  @override
  List<Object> get props => [message];
}
