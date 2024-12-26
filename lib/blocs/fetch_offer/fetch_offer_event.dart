part of 'fetch_offer_bloc.dart';

sealed class FetchOfferEvent extends Equatable {
  const FetchOfferEvent();

  @override
  List<Object> get props => [];
}

final class FetchOffer extends FetchOfferEvent {
  final int orderId;

  const FetchOffer({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

final class FetchIsIdle extends FetchOfferEvent {}
