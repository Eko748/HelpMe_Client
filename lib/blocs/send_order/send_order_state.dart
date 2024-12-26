part of 'send_order_bloc.dart';

sealed class SendOrderState extends Equatable {
  const SendOrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends SendOrderState {}

final class OrderLoading extends SendOrderState {}

final class OrderIdle extends SendOrderState {}

final class OrderError extends SendOrderState {
  final String errorMessage;

  const OrderError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ProblemsLoaded extends SendOrderState {
  final List<ProblemModel> problems;

  const ProblemsLoaded({required this.problems});

  @override
  List<Object> get props => [problems];
}

final class LocationShared extends SendOrderState {}

final class ImagePicked extends SendOrderState {
  final XFile? pickedImage;

  const ImagePicked({required this.pickedImage});

  @override
  List<Object?> get props => [pickedImage];
}

final class ImageDeleted extends SendOrderState {
  final int imageIndex;

  const ImageDeleted({required this.imageIndex});

  @override
  List<Object?> get props => [imageIndex];
}

final class OrderUploaded extends SendOrderState {
  final String message;
  final Order order;

  const OrderUploaded({
    required this.message,
    required this.order,
  });

  @override
  List<Object?> get props => [message, order];
}

final class SendOrderError extends SendOrderState {
  final String message;

  const SendOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
