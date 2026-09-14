import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/culture.dart';
import '../providers/culture_provider.dart';

class CultureFormScreen extends StatefulWidget {
  const CultureFormScreen({
    super.key,
    this.culture,
  });

  final Culture? culture;

  @override
  State<CultureFormScreen> createState() => _CultureFormScreenState();
}

class _CultureFormScreenState extends State<CultureFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _typeController = TextEditingController();
  final _parcelleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _datePlantation;
  DateTime? _dateRecoltePrevue;
  String _statut = 'En croissance';
  bool _isSaving = false;

  bool get isEditing => widget.culture != null;

  @override
  void initState() {
    super.initState();

    final culture = widget.culture;

    if (culture != null) {
      _nomController.text = culture.nom;
      _typeController.text = culture.type;
      _parcelleController.text = culture.parcelle;
      _descriptionController.text = culture.description;
      _datePlantation = culture.datePlantation;
      _dateRecoltePrevue = culture.dateRecoltePrevue;
      _statut = culture.statut;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _typeController.dispose();
    _parcelleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({
    required bool plantation,
  }) async {
    final initialDate = plantation
        ? (_datePlantation ?? DateTime.now())
        : (_dateRecoltePrevue ??
            _datePlantation?.add(const Duration(days: 90)) ??
            DateTime.now());

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      if (plantation) {
        _datePlantation = selectedDate;
      } else {
        _dateRecoltePrevue = selectedDate;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Sélectionner une date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_datePlantation == null || _dateRecoltePrevue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner les deux dates.'),
        ),
      );
      return;
    }

    if (_dateRecoltePrevue!.isBefore(_datePlantation!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La date de récolte doit être après la date de plantation.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final culture = Culture(
      id: widget.culture?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      nom: _nomController.text.trim(),
      type: _typeController.text.trim(),
      parcelle: _parcelleController.text.trim(),
      datePlantation: _datePlantation!,
      dateRecoltePrevue: _dateRecoltePrevue!,
      statut: _statut,
      description: _descriptionController.text.trim(),
    );

    final provider = context.read<CultureProvider>();

    final success = isEditing
        ? await provider.updateCulture(culture)
        : await provider.addCulture(culture);

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
        SnackBar(
          content: Text(
            provider.error ?? 'Une erreur est survenue.',
          ),
        ),
      );
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Modifier la culture' : 'Ajouter une culture',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom de la culture',
                hintText: 'Ex. Maïs',
                prefixIcon: Icon(Icons.eco_outlined),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Type',
                hintText: 'Ex. Céréale',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _parcelleController,
              decoration: const InputDecoration(
                labelText: 'Parcelle',
                hintText: 'Ex. Parcelle A1',
                prefixIcon: Icon(Icons.grid_view_outlined),
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date de plantation'),
              subtitle: Text(_formatDate(_datePlantation)),
              onTap: () => _selectDate(plantation: true),
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_available_outlined),
              title: const Text('Date de récolte prévue'),
              subtitle: Text(_formatDate(_dateRecoltePrevue)),
              onTap: () => _selectDate(plantation: false),
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _statut,
              decoration: const InputDecoration(
                labelText: 'Statut',
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'En croissance',
                  child: Text('En croissance'),
                ),
                DropdownMenuItem(
                  value: 'En attente',
                  child: Text('En attente'),
                ),
                DropdownMenuItem(
                  value: 'Récoltée',
                  child: Text('Récoltée'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _statut = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Ajoutez une description...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
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
                _isSaving
                    ? 'Enregistrement...'
                    : isEditing
                        ? 'Enregistrer les modifications'
                        : 'Ajouter la culture',
              ),
            ),
          ],
        ),
      ),
    );
  }
}