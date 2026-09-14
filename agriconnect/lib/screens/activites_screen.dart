import 'package:flutter/material.dart';

class ActivitesScreen extends StatelessWidget {
  const ActivitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités'),
      ),
      body: const Center(
        child: Text('Mes activités'),
      ),
    );
  }
}