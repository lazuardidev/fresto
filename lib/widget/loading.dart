import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotties/loading.json',
        width: 160,
        height: 160,
      ),
    );
  }
}
