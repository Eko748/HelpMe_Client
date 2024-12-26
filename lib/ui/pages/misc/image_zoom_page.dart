import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../configs/app_colors.dart';

class ImageZoomPage extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> imageNames;

  const ImageZoomPage({
    super.key,
    required this.imagePaths,
    required this.imageNames,
  });

  @override
  State<ImageZoomPage> createState() => _ImageZoomPageState();
}

class _ImageZoomPageState extends State<ImageZoomPage> {
  late List<String> imagePaths;
  late List<String> imageNames;
  late String selectedImage;
  late String selectedName;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    imagePaths = widget.imagePaths;
    imageNames = widget.imageNames;
    selectedImage = imagePaths.first;
    selectedName = imageNames.first;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.pop(),
      child: Scaffold(
        appBar: _appBar(context, textTheme, selectedName),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: AppColors.strokeColor,
                        ),
                      ),
                      child: Image.file(
                        File(imagePaths[index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    height: 400,
                    viewportFraction: 1,
                  ),
                ),
              ),
              if (imagePaths.length > 1 && imageNames.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton.outlined(
                        iconSize: 35,
                        onPressed: () {
                          _carouselController.previousPage();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        style: const ButtonStyle(
                          iconColor: WidgetStatePropertyAll(AppColors.primary),
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        iconSize: 35,
                        onPressed: () {
                          _carouselController.nextPage();
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                        style: const ButtonStyle(
                          iconColor: WidgetStatePropertyAll(AppColors.primary),
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme, String title) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
