import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(alignment: Alignment.center, child: Text('Bezig met laden, even geduld...'));
  }
}