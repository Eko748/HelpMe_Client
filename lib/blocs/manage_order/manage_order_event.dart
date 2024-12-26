part of 'manage_order_bloc.dart';

sealed class ManageOrderEvent extends Equatable {
  const ManageOrderEvent();

  @override
  List<Object> get props => [];
}

final class ManageOrderIsIdle extends ManageOrderEvent {}

final class SelectMitraSubmitted extends ManageOrderEvent {
  final int offerId;

  const SelectMitraSubmitted({required this.offerId});

  @override
  List<Object> get props => [offerId];
}

final class RequestSnapToken extends ManageOrderEvent {
  final int orderId;

  const RequestSnapToken({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

final class WaitingPayment extends ManageOrderEvent {}

final class CompletingPayment extends ManageOrderEvent {}

final class LastOrderNotPending extends ManageOrderEvent {}
