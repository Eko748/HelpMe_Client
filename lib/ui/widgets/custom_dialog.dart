import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../../configs/app_colors.dart';
import '../../cubits/rate_mitra/rate_mitra_cubit.dart';

class CustomDialog {
  static showAlertDialog(
    BuildContext context,
    String title,
    String? content,
    Widget? action,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: [
          if (action != null) action,
        ],
      ),
    );
  }

  static ratingDialog(
    BuildContext context, {
    required TextTheme textTheme,
    required int orderId,
  }) {
    final reviewInputController = TextEditingController();
    int ratingMitra = 3;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: 382,
            height: 574,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BlocProvider(
              create: (context) => RateMitraCubit(),
              child: BlocBuilder<RateMitraCubit, RateMitraState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: BackButton(
                              onPressed: () => context.pop(),
                              style: const ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(20, 20),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Rating',
                              style: textTheme.titleLarge?.copyWith(
                                color: AppColors.slateGray,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Rating Abangnya',
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bantu abangnya dengan\nkasih rating terbaik kamu',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.aluminumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RatingBar.builder(
                        initialRating: 3,
                        itemCount: 5,
                        glowColor: AppColors.goldenYellow,
                        unratedColor: AppColors.gray,
                        maxRating: 5,
                        minRating: 1,
                        tapOnlyMode: true,
                        wrapAlignment: WrapAlignment.spaceEvenly,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppColors.goldenYellow,
                          size: 35,
                        ),
                        onRatingUpdate: (rating) {
                          if (context.mounted) {
                            if ((rating % 1) == 0 &&
                                int.tryParse(rating.toStringAsFixed(0)) !=
                                    null) {
                              ratingMitra = rating.toInt();
                            } else {
                              ratingMitra = rating.round();
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: reviewInputController,
                        keyboardType: TextInputType.text,
                        scrollPhysics: const ClampingScrollPhysics(),
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGray,
                          prefixIcon: const Icon(Icons.create_outlined),
                          prefixIconColor: AppColors.hintTextColor,
                          border: InputBorder.none,
                          hintText: 'Ceritakan pengalamanmu juga',
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            color: AppColors.hintTextColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                      state is RateMitraLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 71,
                              child: TextButton(
                                onPressed: () {
                                  state is! RateMitraSuccess
                                      ? context
                                          .read<RateMitraCubit>()
                                          .rateMitra(
                                            orderId: orderId,
                                            rating: ratingMitra,
                                            review: reviewInputController.text,
                                          )
                                      : null;
                                },
                                style: ButtonStyle(
                                  backgroundColor: state is! RateMitraSuccess
                                      ? const WidgetStatePropertyAll(
                                          AppColors.gray,
                                        )
                                      : const WidgetStatePropertyAll(
                                          AppColors.primary,
                                        ),
                                ),
                                child: Text(
                                  'Kirim Rating',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.lightTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: state is! RateMitraSuccess
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      if (state is RateMitraError)
                        Text(
                          state.message,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.redAccent),
                        )
                      else if (state is RateMitraSuccess)
                        Text(
                          state.response.message!,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.greenAccent),
                        )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
