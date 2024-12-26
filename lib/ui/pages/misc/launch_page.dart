import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../configs/app_colors.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => context.goNamed('homePage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/helpMe!-logo-non-final.png',
            isAntiAlias: true,
          ),
          const CircularProgressIndicator(color: AppColors.primary),
        ],
      ),
    );
  }
}
