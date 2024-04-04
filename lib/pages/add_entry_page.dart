// ignore_for_file: use_build_context_synchronously, unused_field, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/journal_entry.dart';

class AddEntryScreen extends StatefulWidget {
  final JournalEntry? entry;

  const AddEntryScreen({super.key, this.entry});

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _type = 'Regular';
  final storage = const FlutterSecureStorage();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _type = widget.entry?.type ?? 'Regular';

    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  void _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final entry = JournalEntry(
        id: widget.entry?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        content: _contentController.text,
        date: DateTime.now(),
        type: _type,
      );

      try {
        final entryJson = json.encode(entry.toJson());
        await storage.write(key: entry.id, value: entryJson);
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry saved successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save entry.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.entry == null ? 'New Journal Entry' : 'Edit Journal Entry';
    String helperText = _type == 'Gratitude'
        ? "Gratitude journaling fosters appreciation and positivity."
        : "Regular journaling aids in self-reflection and stress relief.";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Give a title to your entry',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.title),
                ),
                validator: (value) => value!.trim().isEmpty ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'What’s on your mind?',
                  border: const OutlineInputBorder(),
                  icon: const Icon(Icons.text_fields),
                  helperText: helperText,
                ),
                validator: (value) => value!.trim().isEmpty ? 'Content cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _type,
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
                items: <String>['Regular', 'Gratitude'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Entry Type',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.swap_vert),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: const Icon(Icons.save),
                label: const Text('Save Entry'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
