import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/offer/offer_model.dart';
import '../../models/offer/offer_response_model.dart';
import '../../services/api/api_helper.dart';

part 'fetch_offer_event.dart';
part 'fetch_offer_state.dart';

class FetchOfferBloc extends Bloc<FetchOfferEvent, FetchOfferState> {
  List<OfferModel> offerList = [];

  FetchOfferBloc() : super(FetchOfferInitial()) {
    on<FetchOffer>(_onFetchOffer);

    on<FetchIsIdle>((event, emit) => emit(FetchOfferIdle()));
  }

  Future<void> _onFetchOffer(event, emit) async {
    emit(FetchOfferLoading());
    await emit.forEach(
      ApiHelper.getOfferFromMitra(event.orderId),
      onData: (response) {
        if (response is ApiErrorResponseModel) {
          final message = response.error?.error ?? response.error?.message;
          return FetchOfferError(message: message.toString());
        } else {
          return FetchOfferLoaded(data: response);
        }
      },
      onError: (error, stackTrace) {
        return FetchOfferError(message: error.toString());
      },
    );
  }
}
