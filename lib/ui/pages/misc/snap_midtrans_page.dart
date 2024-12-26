import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';

class SnapMidtransPage extends StatelessWidget {
  final String token;
  const SnapMidtransPage({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    MidtransResponse? midtransResponse;
    String? urlResponse;
    bool willPop = true;

    return PopScope(
      canPop: willPop,
      onPopInvokedWithResult: (didPop, result) {
        result = midtransResponse ?? urlResponse;
        if (result != null) {
          if (result is String && !result.startsWith('http')) {
            willPop = false;
            didPop = willPop;
          }
        }
      },
      child: SafeArea(
        child: MidtransSnap(
          mode: kReleaseMode
              ? MidtransEnvironment.production
              : MidtransEnvironment.sandbox,
          token: token,
          // TODO: Move the client key to safe place somewhere before production
          midtransClientKey: 'SB-Mid-client-Dq1J9Sr45BhVF9WQ',
          onResponse: (result) {
            midtransResponse = result;
            if (midtransResponse != null) {
              context.pop(midtransResponse);
            }
          },
          onPageFinished: (url) {
            urlResponse = url;
            if (urlResponse != null &&
                urlResponse!.trim().toLowerCase().contains('status_code')) {
              context.pop(urlResponse);
            }
          },
        ),
      ),
    );
  }
}
