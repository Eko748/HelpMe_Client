part of 'manage_order_bloc.dart';

sealed class ManageOrderState extends Equatable {
  const ManageOrderState();

  @override
  List<Object> get props => [];
}

final class ManageOrderInitial extends ManageOrderState {}

final class ManageOrderIdle extends ManageOrderState {}

final class ManageOrderLoading extends ManageOrderState {}

final class SelectMitraSuccess extends ManageOrderState {
  final SelectMitraResponseModel data;

  const SelectMitraSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class SelectMitraError extends ManageOrderState {
  final String message;

  const SelectMitraError({required this.message});

  @override
  List<Object> get props => [message];
}

final class SnapTokenRequested extends ManageOrderState {
  final String code;

  const SnapTokenRequested({required this.code});

  @override
  List<Object> get props => [code];
}

final class SnapTokenError extends ManageOrderState {
  final String message;

  const SnapTokenError({required this.message});

  @override
  List<Object> get props => [message];
}

final class PaymentPending extends ManageOrderState {}

final class PaymentDone extends ManageOrderState {}
