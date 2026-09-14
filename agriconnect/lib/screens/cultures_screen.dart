import 'package:flutter/material.dart';

class CulturesScreen extends StatelessWidget {
  const CulturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes cultures'),
      ),
      body: const Center(
        child: Text('Mes cultures'),
      ),
    );
  }
}