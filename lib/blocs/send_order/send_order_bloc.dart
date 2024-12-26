import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/order_request_model.dart';
import '../../models/category_problem/problem_model.dart';
import '../../models/order/order_response_model/order.dart';
import '../../services/api/api_helper.dart';
import '../../utils/image_picker_util.dart';

part 'send_order_event.dart';
part 'send_order_state.dart';

class SendOrderBloc extends Bloc<SendOrderEvent, SendOrderState> {
  final ImagePickerUtil imagePickerUtil;

  late ProblemModel? selectedProblem;
  late String? selectedSolution;
  late double? lat;
  late double? long;
  List<XFile?> problemPictures = [];

  SendOrderBloc({required this.imagePickerUtil}) : super(OrderInitial()) {
    on<FetchProblems>(_onFetchProblems);

    on<ProblemSelected>(
      (event, emit) => selectedProblem = event.selectedProblem,
    );

    on<SolutionSelected>(
      (event, emit) => selectedSolution = event.selectedSolution,
    );

    on<OrderIsIdle>((event, emit) => emit(OrderIdle()));

    on<ProblemsPop>((event, emit) {
      selectedProblem = null;
      selectedSolution = null;
      problemPictures.clear();
      lat = null;
      long = null;
      emit(OrderInitial());
    });

    on<ResetAddPage>((event, emit) {
      problemPictures.clear();
      selectedSolution = null;
      emit(OrderIdle());
    });

    on<CameraCapture>(_onCameraCapture);

    on<GalleryImagePicker>(_onGalleryImagePicker);

    on<DeleteImage>(_onDeleteImage);

    on<OrderSubmitted>(_orderSubmitted);

    on<ShareLocation>((event, emit) {
      lat = event.lat;
      long = event.long;
    });
  }

  FutureOr<void> _onDeleteImage(event, emit) {
    problemPictures.removeAt(event.imageIndex);
    emit(ImageDeleted(imageIndex: event.imageIndex));
  }

  Future<void> _onGalleryImagePicker(event, emit) async {
    XFile? imagePicked = await imagePickerUtil.imageFromGallery();
    if (imagePicked != null) {
      problemPictures.add(imagePicked);
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(OrderIdle());
    }
  }

  Future<void> _onCameraCapture(event, emit) async {
    XFile? imagePicked = await imagePickerUtil.cameraCapture();
    if (imagePicked != null) {
      problemPictures.add(imagePicked);
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(OrderIdle());
    }
  }

  _orderSubmitted(event, emit) async {
    emit(OrderLoading());
    if (selectedProblem == null ||
        (event as OrderSubmitted).problem.toLowerCase().contains('serabutan')) {
      emit(const SendOrderError(
        message:
            'Terjadi kesalahan pada aplikasi, pilih kembali kategori masalah di halaman home',
      ));
      return;
    }
    if (selectedSolution == null || selectedSolution!.isEmpty) {
      emit(const SendOrderError(message: 'Sertakan detail masalahnya!'));
      return;
    }
    if (lat == null && long == null) {
      emit(const SendOrderError(message: 'Kamu belum ngasih lokasi kamu!'));
      return;
    }
    List<MultipartFile> images = [];
    if (problemPictures.isNotEmpty) {
      for (XFile? file in problemPictures) {
        if (file != null) {
          images.add(
            await MultipartFile.fromFile(
              file.path,
              filename: file.name.split('/').last,
              contentType: MediaType.parse(
                lookupMimeType(file.path) ?? 'application/octet-stream',
              ),
            ),
          );
        }
      }
    }
    int? id;
    selectedProblem != null ? id = selectedProblem?.id : null;
    final orderRequest = OrderRequestModel(
      problemId: id,
      description: selectedSolution,
      attachments: images,
      lat: lat!,
      long: long!,
    );
    final formData = FormData.fromMap({
      if (id != null) 'problem_id': id,
      'description': orderRequest.description,
      'latitude': orderRequest.lat,
      'longitude': orderRequest.long,
      if (images.isNotEmpty) 'attachments[]': orderRequest.attachments,
    });
    final response = await ApiHelper.postOrder(formData);
    if (response is ApiErrorResponseModel) {
      var message = response.error?.error ?? response.error?.message;
      message ??=
          '${response.error?.attachment0}, ${response.error?.attachment1}';
      emit(SendOrderError(message: message.toString()));
    } else {
      emit(
        OrderUploaded(message: response.message, order: response.order),
      );
    }
  }

  _onFetchProblems(
    FetchProblems event,
    Emitter<SendOrderState> emit,
  ) async {
    emit(OrderLoading());
    final response = await ApiHelper.getProblems(event.problemName);
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      emit(OrderError(errorMessage: message.toString()));
    } else {
      emit(ProblemsLoaded(problems: response));
    }
  }
}
