import 'package:flutter/material.dart';

class ConseilsScreen extends StatelessWidget {
  const ConseilsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conseils'),
      ),
      body: const Center(
        child: Text('Conseils agricoles'),
      ),
    );
  }
}