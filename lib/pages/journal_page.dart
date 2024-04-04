// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/journal_entry.dart';
import 'add_entry_page.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = [];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final all = await storage.readAll();
      final loadedEntries = all.entries.map((entry) {
        return JournalEntry.fromJson(json.decode(entry.value));
      }).whereType<JournalEntry>().toList();

      setState(() {
        entries = loadedEntries;
      });
    } catch (e) {
      _showError('Failed to load entries.');
    }
  }

  void _navigateToAddEntry(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEntryScreen()),
    );

    if (result == 'update') {
      _loadEntries();
    }
  }

  void _navigateToEditEntry(BuildContext context, JournalEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEntryScreen(entry: entry)),
    );

    if (result == 'update') {
      _loadEntries();
    }
  }

  void _deleteEntry(String id) async {
    try {
      await storage.delete(key: id);
      _loadEntries(); // Refresh the entries list
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entry deleted successfully")));
    } catch (e) {
      _showError('Failed to delete entry.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('My Journal'),
      backgroundColor: Colors.deepPurple, 
      shadowColor: Colors.white54,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadEntries,
        ),
      ],
    ),
      body: entries.isEmpty ? _buildEmptyState() : RefreshIndicator(
        onRefresh: _loadEntries,
        child: _buildEntriesList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEntry(context),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add Journal Entry', // Match the AppBar
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 48.0, color: Colors.grey[500]),
            const SizedBox(height: 20),
            Text(
              "Your journal is empty",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.grey[500]),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap the + button to add your first memory.",
              style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList() {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final entryDate = entry.date.toLocal();
        return Card(
          color: Colors.black12,
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.book, color: Colors.white),
            ),
            title: Text(
              entry.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${entryDate.year}-${entryDate.month.toString().padLeft(2,'0')}-${entryDate.day.toString().padLeft(2,'0')} | ${entry.type}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            onTap: () => _navigateToEditEntry(context, entry),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[300]),
              onPressed: () => _deleteEntry(entry.id),
            ),
          ),
        );
      },
    );
  }
}
