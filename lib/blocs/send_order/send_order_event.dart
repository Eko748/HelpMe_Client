part of 'send_order_bloc.dart';

sealed class SendOrderEvent extends Equatable {
  const SendOrderEvent();

  @override
  List<Object> get props => [];
}

class FetchProblems extends SendOrderEvent {
  final String problemName;

  const FetchProblems({required this.problemName});

  @override
  List<Object> get props => [problemName];
}

class ProblemSelected extends SendOrderEvent {
  final ProblemModel selectedProblem;

  const ProblemSelected(this.selectedProblem);

  @override
  List<Object> get props => [selectedProblem];
}

class SolutionSelected extends SendOrderEvent {
  final String selectedSolution;

  const SolutionSelected(this.selectedSolution);

  @override
  List<Object> get props => [selectedSolution];
}

class DeleteImage extends SendOrderEvent {
  final int imageIndex;

  const DeleteImage({required this.imageIndex});

  @override
  List<Object> get props => [imageIndex];
}

class ProblemsPop extends SendOrderEvent {}

class ResetAddPage extends SendOrderEvent {}

class CameraCapture extends SendOrderEvent {}

class GalleryImagePicker extends SendOrderEvent {}

class ShareLocation extends SendOrderEvent {
  final double lat;
  final double long;

  const ShareLocation({required this.lat, required this.long});

  @override
  List<Object> get props => [lat, long];
}

class OrderIsIdle extends SendOrderEvent {}

class OrderSubmitted extends SendOrderEvent {
  final String problem;

  const OrderSubmitted(this.problem);

  @override
  List<Object> get props => [problem];
}
