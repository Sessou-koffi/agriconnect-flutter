import 'package:flutter/material.dart';

import '../models/activite.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activite,
    this.onDelete,
  });

  final Activite activite;
  final VoidCallback? onDelete;

  IconData _getIcon() {
    switch (activite.type.toLowerCase()) {
      case 'arrosage':
        return Icons.water_drop_outlined;
      case 'fertilisation':
        return Icons.grass_outlined;
      case 'désherbage':
        return Icons.cleaning_services_outlined;
      case 'récolte':
        return Icons.agriculture_outlined;
      default:
        return Icons.task_alt_outlined;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(_getIcon()),
        ),
        title: Text(
          activite.type,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${_formatDate(activite.date)}\n${activite.description}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Supprimer',
        ),
      ),
    );
  }
}