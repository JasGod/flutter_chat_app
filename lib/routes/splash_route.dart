import 'package:flutter/material.dart';

class SplashRoute extends StatelessWidget {
  const SplashRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(
            fontSize: 28,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}
