import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/manage_order/manage_order_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../models/order/history/order_history_model.dart';
import '../../widgets/custom_dialog.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/gradient_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is OrderHistoryLoaded) {
              context.read<HomeCubit>().orderHistory = state.history;
              context.read<HomeCubit>().lastHistory = state.history.last;
              if (state.history.any((history) =>
                  history.orderStatus?.trim().toLowerCase() == 'pending' ||
                  history.orderStatus?.trim().toLowerCase() == 'booked' ||
                  history.orderStatus?.trim().toLowerCase() == 'paid' ||
                  history.orderStatus?.trim().toLowerCase() == 'otw' ||
                  history.orderStatus?.trim().toLowerCase() == 'is_progress' ||
                  history.orderStatus?.trim().toLowerCase() == 'arrived')) {
                context.read<ManageOrderBloc>().haveActiveOrder = true;
              } else {
                context.read<ManageOrderBloc>().haveActiveOrder = false;
              }
            }
            if (state is OrderHistoryError) {
              _onOrderHistoryError(context, state);
            } else {
              return;
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeCubit>().fetchHistory();
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  _historySliverAppBar(context, textTheme),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  _allHistoryHeader(textTheme),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  if (context.read<HomeCubit>().orderHistory.isNotEmpty) ...[
                    _allHistoryBuilder(textTheme, context)
                  ] else ...[
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Anda belum memesan',
                          style: textTheme.headlineMedium,
                        ),
                      ),
                    )
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onOrderHistoryError(BuildContext context, OrderHistoryError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error fetching order history',
      state.errorMessage,
      state.errorMessage.toString().trim().toLowerCase().contains('invalid') ||
              state.errorMessage
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains('unauthorized')
          ? OutlinedButton.icon(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ManageAuthToken.deleteToken();
                  context.read<AuthBloc>().add(AuthIsIdle());
                  context.goNamed('signInPage');
                });
              },
              label: const Text('Sign In ulang'),
              icon: const Icon(Icons.arrow_forward_ios),
              iconAlignment: IconAlignment.end,
            )
          : IconButton.outlined(
              onPressed: () {
                context.pop();
                context.read<HomeCubit>().fetchHistory();
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
    );
    context.read<HomeCubit>().homeIdle();
  }

  SliverList _allHistoryBuilder(TextTheme textTheme, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: context.read<HomeCubit>().orderHistory.length,
        (context, index) {
          final history = context.read<HomeCubit>().orderHistory[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _orderHistoryCard(
              history,
              textTheme,
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _allHistoryHeader(TextTheme textTheme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          'Riwayat Masalah',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  GradientCard _orderHistoryCard(
    OrderHistoryModel? history,
    TextTheme textTheme,
  ) {
    return GradientCard(
      width: 400,
      height: 240,
      cardColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _orderCardHistoryInfoSection(history, textTheme,
                history?.orderStatus?.trim().toLowerCase() == 'complete'),
            _orderCardHistoryImageSection(history),
          ],
        ),
      ),
    );
  }

  Column _orderCardHistoryInfoSection(
    OrderHistoryModel? history,
    TextTheme textTheme,
    bool isDone,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 310,
          child: Text(
            history != null
                ? history.category?.replaceFirst(
                      history.category.toString()[0],
                      history.category.toString()[0].toUpperCase(),
                    ) ??
                    'Belum milih mitra'
                : 'Kamu belum minta bantuan sama sekali',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LimitedBox(
            maxWidth: 310,
            child: Text(
              history != null
                  ? '${history.description}'
                  : 'Jangan lupa cari bantuan di HelpMe!',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.aquamarine,
              ),
            )),
        Text(
          history != null ? 'Rp${history.price}' : 'N/A',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  'detailOrderPage',
                  queryParameters: {'orderId': history?.orderId.toString()},
                );
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
              label: const Text('Lihat Detail'),
            ),
            const SizedBox(width: 10),
            Icon(
              isDone ? Icons.done : Icons.pending,
              color: isDone ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ],
        )
      ],
    );
  }

  Stack _orderCardHistoryImageSection(OrderHistoryModel? history) {
    return Stack(
      children: [
        Container(
          height: 162,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned(
          top: 10,
          right: 0,
          left: 0,
          child: CircleAvatar(
            backgroundImage: history != null
                ? CachedNetworkImageProvider(
                    history.userProfile ??
                        'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                  )
                : const AssetImage('assets/images/girl1.png'),
          ),
        ),
      ],
    );
  }

  SliverAppBar _historySliverAppBar(BuildContext context, TextTheme textTheme) {
    return SliverAppBar(
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
