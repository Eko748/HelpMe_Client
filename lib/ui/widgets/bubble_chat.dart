import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';

class BubbleChat extends StatelessWidget {
  final int userId;
  final int senderId;
  final String? message;
  final DateTime sendTime;

  const BubbleChat({
    super.key,
    required this.userId,
    required this.senderId,
    this.message,
    required this.sendTime,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.strokeColor),
                borderRadius: BorderRadius.circular(10),
                color:
                    senderId == userId ? AppColors.primary : AppColors.surface,
              ),
              width: screenWidth / 2,
              child: !message!.startsWith('http')
                  ? Text(
                      message.toString(),
                      softWrap: true,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.lightTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: message.toString(),
                      placeholder: (context, error) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              bottom: 3,
              right: 3,
              child: Text(
                '${sendTime.hour}:${sendTime.minute}:${sendTime.second}',
                style: textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextColor,
                    fontWeight: FontWeight.w500,
                    backgroundColor: AppColors.lightGray),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
