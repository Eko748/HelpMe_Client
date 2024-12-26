import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/manage_order/manage_order_bloc.dart';
import '../../../blocs/fetch_offer/fetch_offer_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../models/offer/offer_model.dart';
import '../../../services/location_service.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/gradient_card.dart';

class SelectMitraPage extends StatefulWidget {
  final int? orderId;
  final String? orderStatus;

  const SelectMitraPage({
    super.key,
    required this.orderId,
    required this.orderStatus,
  });

  @override
  State<SelectMitraPage> createState() => _SelectMitraPageState();
}

class _SelectMitraPageState extends State<SelectMitraPage> {
  @override
  void initState() {
    super.initState();
    LocationService.fetchLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context, textTheme),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.only(
            left: 2,
            right: 2,
            bottom: 2,
          ),
          child: LinearProgressIndicator(),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              height: screenHeight / 5,
              child: Container(
                color: Colors.black,
                child: _detailHeadline(textTheme),
              ),
            ),
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight / 1.43,
              child: BlocConsumer<ManageOrderBloc, ManageOrderState>(
                listener: (context, state) {
                  if (state is SnapTokenError) {
                    CustomDialog.showAlertDialog(
                      context,
                      'Peringatan!',
                      state.message,
                      null,
                    );
                    context.read<ManageOrderBloc>().add(WaitingPayment());
                  } else if (state is SelectMitraError) {
                    CustomDialog.showAlertDialog(
                      context,
                      'Peringatan!',
                      state.message,
                      null,
                    );
                    context.read<ManageOrderBloc>().add(ManageOrderIsIdle());
                    if (state.message
                            .trim()
                            .toLowerCase()
                            .contains('sudah dipilih') &&
                        context.read<ManageOrderBloc>().snapToken == null) {
                      context
                          .read<ManageOrderBloc>()
                          .add(RequestSnapToken(orderId: widget.orderId!));
                    }
                  } else if (state is SelectMitraSuccess) {
                    context.pop();
                    if (context.canPop()) context.pop();
                  }
                },
                builder: (context, state) {
                  if (state is ManageOrderInitial) {
                    if (widget.orderStatus!
                            .trim()
                            .toLowerCase()
                            .contains('booked') &&
                        context.read<ManageOrderBloc>().snapToken == null) {
                      context
                          .read<ManageOrderBloc>()
                          .add(RequestSnapToken(orderId: widget.orderId!));
                    }
                  }
                  if (state is ManageOrderLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: BlocProvider(
                        create: (context) => FetchOfferBloc(),
                        child: _fetchOfferConsumer(textTheme),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocConsumer<FetchOfferBloc, FetchOfferState> _fetchOfferConsumer(
      TextTheme textTheme) {
    return BlocConsumer<FetchOfferBloc, FetchOfferState>(
      listener: (context, state) {
        if (state is FetchOfferError) {
          _stateError(context, state.message);
          context.read<FetchOfferBloc>().add(FetchIsIdle());
        } else if (state is FetchOfferLoaded) {
          context.read<FetchOfferBloc>().offerList =
              state.data.data ?? <OfferModel>[];
        }
      },
      builder: (context, state) {
        if (state is FetchOfferInitial) {
          if (widget.orderId != null) {
            context
                .read<FetchOfferBloc>()
                .add(FetchOffer(orderId: widget.orderId!));
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              CustomDialog.showAlertDialog(
                context,
                'Peringatan!',
                'Kamu tidak ada order yang aktif saat ini, jika kamu punya order aktif dan tetap mendapat pesan ini coba untuk refresh di home atau close aplikasi dan masuk lagi',
                null,
              );
              context.pop();
              context.canPop() ? context.pop() : context.goNamed('homePage');
            });
          }
        }
        if (state is FetchOfferLoading) {
          return const SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (context.read<FetchOfferBloc>().offerList.isNotEmpty) {
          return _offerCardBuilder(context, textTheme);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _offerCardBuilder(BuildContext context, TextTheme textTheme) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: context.read<FetchOfferBloc>().offerList.length,
      itemBuilder: (BuildContext context, int index) {
        final data = context.read<FetchOfferBloc>().offerList[index];
        final distance = Geolocator.distanceBetween(
          LocationService.lat!,
          LocationService.long!,
          data.latitude!,
          data.longitude!,
        ).truncateToDouble();
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GradientCard(
            width: 400,
            height: 200,
            cardColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _offerCardInfoSection(
                    data,
                    distance,
                    textTheme,
                  ),
                  _offerCardImageSection(data),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container _offerCardImageSection(OfferModel? offer) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 40),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: AppColors.surface,
        child: CircleAvatar(
          radius: 16,
          backgroundImage: offer != null
              ? CachedNetworkImageProvider(
                  offer.mitraProfile ??
                      'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                )
              : const AssetImage('assets/images/girl1.png'),
        ),
      ),
    );
  }

  Column _offerCardInfoSection(
    OfferModel? offer,
    double distance,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 310,
          child: Text(
            offer != null
                ? offer.mitraName.toString()
                : 'Gagal memproses data, refresh untuk lanjut',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LimitedBox(
            maxWidth: 310,
            child: Text(
              offer != null ? '${distance / 1000}km' : 'N/A',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.aquamarine,
              ),
            )),
        Text(
          offer != null ? 'Rp${offer.price}' : 'N/A',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (offer != null) {
              _selectMitraConfirmation(offer, textTheme);
            } else {
              CustomDialog.showAlertDialog(
                context,
                'Gagal!',
                'Terdapat kesalahan, silahkan pilih penawaran lain atau coba lagi',
                null,
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              AppColors.primary,
            ),
            textStyle: WidgetStatePropertyAll(
              textTheme.bodyMedium?.copyWith(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.lightTextColor,
            size: 20,
          ),
          iconAlignment: IconAlignment.end,
          label: const Text('Panggil Abangnya'),
        )
      ],
    );
  }

  void _selectMitraConfirmation(OfferModel offer, TextTheme textTheme) {
    CustomDialog.showAlertDialog(
      context,
      'Konfirmasi',
      'Panggil abang yang ini?',
      OutlinedButton(
        onPressed: () {
          context.pop();
          context.read<ManageOrderBloc>().add(
                SelectMitraSubmitted(
                  offerId: offer.offerId!,
                ),
              );
        },
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.lightTextColor,
            ),
          ),
        ),
        child: Text(
          'Yakin',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
          ),
        ),
      ),
    );
  }

  void _stateError(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomDialog.showAlertDialog(
        context,
        'Error!',
        message,
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.refresh_outlined),
        ),
      );
    });
  }

  Padding _detailHeadline(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BlocBuilder<FetchOfferBloc, FetchOfferState>(
        builder: (context, state) {
          List<OfferModel> offerList =
              context.watch<FetchOfferBloc>().offerList;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Berikut solusi dari\nHelpMe!',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.darkTextColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                ),
                child: LimitedBox(
                  maxHeight: 36,
                  child: _avatarBuilder(offerList),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListView _avatarBuilder(List<OfferModel> offerList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: offerList.length,
      itemBuilder: (BuildContext context, int index) {
        final offer = offerList[index];
        return CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.surface,
          child: CircleAvatar(
            radius: 17,
            backgroundImage: CachedNetworkImageProvider(
              offer.mitraProfile ??
                  'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
              maxWidth: 36,
              maxHeight: 36,
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'Help Me!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
