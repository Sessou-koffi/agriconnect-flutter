import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activite.dart';
import '../providers/activite_provider.dart';
import '../providers/culture_provider.dart';

class ActiviteFormScreen extends StatefulWidget {
  const ActiviteFormScreen({super.key});

  @override
  State<ActiviteFormScreen> createState() => _ActiviteFormScreenState();
}

class _ActiviteFormScreenState extends State<ActiviteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();

  String? _cultureId;
  String _type = 'Arrosage';
  DateTime _date = DateTime.now();
  bool _isSaving = false;

  final List<String> _types = const [
    'Arrosage',
    'Fertilisation',
    'Désherbage',
    'Récolte',
    'Autre',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        _date = selected;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_cultureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une culture.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final activite = Activite(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cultureId: _cultureId!,
      type: _type,
      date: _date,
      description: _descriptionController.text.trim(),
    );

    final success = await context
        .read<ActiviteProvider>()
        .addActivite(activite);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’ajouter l’activité.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cultures = context.watch<CultureProvider>().cultures;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une activité'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Culture',
                prefixIcon: Icon(Icons.eco_outlined),
              ),
              items: cultures.map((culture) {
                return DropdownMenuItem(
                  value: culture.id,
                  child: Text(culture.nom),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _cultureId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Sélectionnez une culture';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type d’activité',
                prefixIcon: Icon(Icons.task_alt_outlined),
              ),
              items: _types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _type = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date'),
              subtitle: Text(_formatDate(_date)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Décrivez l’activité réalisée...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La description est obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _isSaving ? 'Enregistrement...' : 'Ajouter l’activité',
              ),
            ),
          ],
        ),
      ),
    );
  }
}