import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/order_rating_response_model/order_rating_response_model.dart';
import '../../services/api/api_helper.dart';

part 'rate_mitra_state.dart';

class RateMitraCubit extends Cubit<RateMitraState> {
  RateMitraCubit() : super(RateMitraInitial());

  void rateMitra({
    required int orderId,
    required int rating,
    required String review,
  }) async {
    emit(RateMitraLoading());
    if (orderId == 0) {
      emit(const RateMitraError(message: 'Order tidak ada'));
      return;
    }
    if (rating == 0) {
      emit(const RateMitraError(message: 'Rating minimal 1 bintang'));
      return;
    }
    if (review.isEmpty) {
      emit(const RateMitraError(message: 'Review tidak boleh kosong'));
      return;
    }
    final response = await ApiHelper.postRating(
      orderId: orderId,
      rating: rating,
      review: review.trim(),
    );
    if (response is ApiErrorResponseModel) {
      var message = response.error?.error ?? response.error?.message;
      emit(RateMitraError(message: message.toString()));
    } else {
      emit(RateMitraSuccess(response: response));
    }
  }
}
