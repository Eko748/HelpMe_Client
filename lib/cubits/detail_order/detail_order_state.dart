part of 'detail_order_cubit.dart';

sealed class DetailOrderState extends Equatable {
  const DetailOrderState();

  @override
  List<Object> get props => [];
}

final class DetailOrderInitial extends DetailOrderState {}

final class DetailOrderIdle extends DetailOrderState {}

final class DetailOrderLoading extends DetailOrderState {}

final class DetailOrderLoaded extends DetailOrderState {
  final DetailOrderModel data;

  const DetailOrderLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class DetailOrderError extends DetailOrderState {
  final String message;

  const DetailOrderError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ListeningOrderStatus extends DetailOrderState {}

final class ListeningOrderStatusError extends DetailOrderState {
  final String message;

  const ListeningOrderStatusError({required this.message});

  @override
  List<Object> get props => [message];
}

final class OpenWhatsApp extends DetailOrderState {}

final class OpenWhatsAppError extends DetailOrderState {
  final String message;

  const OpenWhatsAppError({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateChatRoomSuccess extends DetailOrderState {
  final String roomCode;

  const CreateChatRoomSuccess({required this.roomCode});

  @override
  List<Object> get props => [roomCode];
}

final class ConnectedToChat extends DetailOrderState {}

final class DisconnectedFromChat extends DetailOrderState {}

final class ReconnectingToChat extends DetailOrderState {}

final class FailedReconnectToChat extends DetailOrderState {}

final class ErrorChat extends DetailOrderState {
  final String message;

  const ErrorChat({required this.message});

  @override
  List<Object> get props => [message];
}

final class ReceiveChat extends DetailOrderState {
  final ChatResponseModel response;

  const ReceiveChat({required this.response});

  @override
  List<Object> get props => [response];
}

final class ImageSelected extends DetailOrderState {
  final XFile image;

  const ImageSelected({required this.image});

  @override
  List<Object> get props => [image];
}

final class MessagesLoaded extends DetailOrderState {
  final List<ChatResponseModel> messages;

  const MessagesLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

final class SendMessageSuccess extends DetailOrderState {
  final SendChatMessageResponseModel response;

  const SendMessageSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class ChatLoading extends DetailOrderState {}
