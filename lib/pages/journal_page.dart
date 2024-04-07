// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
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
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEntryScreen(onSave: _loadEntries)),
    );
  }

  void _navigateToEditEntry(BuildContext context, JournalEntry entry) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEntryScreen(entry: entry, onSave: _loadEntries)),
    );
  }

  void _deleteEntry(String id) async {
    final bool confirmDelete = await _showDeleteConfirmationDialog();

    if (confirmDelete) {
      try {
        await storage.delete(key: id);
        _loadEntries(); // Refresh the entries list
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Entry deleted successfully")));
      } catch (e) {
        _showError('Failed to delete entry.');
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
                'Are you sure you want to delete this journal entry? This action cannot be undone.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        )) ??
        false; // Return false if dialog is dismissed
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEntries,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                _buildMotivationalBanner(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text(
                        "Journal Entries",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8), 
                      Text(
                        "Capture your thoughts and moments. Reflect, learn, and grow with each entry.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white38, 
                        ),
                      ),
                    ],
                  ),
                ),
                entries.isEmpty ? _buildEmptyState() : _buildEntriesList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEntry(context),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add Journal Entry',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildMotivationalBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), 
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade200.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Lottie.asset(
            'assets/animations/writing.json', 
            width: MediaQuery.of(context).size.width * 0.75, 
            fit: BoxFit.cover, 
          ),
          const Text(
            "Journal Your Journey",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12), 
          Text(
            "Explore, progress, and grow with every journal entry. Discover your path to well-being.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Icon(Icons.book, size: 48.0, color: Colors.grey.shade500),
            const SizedBox(height: 20),
            Text(
              "Your journal is empty",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap the + button to add your first memory.",
              style: TextStyle(fontSize: 14.0, color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final entryDate = entry.date.toLocal();
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
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
              '${entryDate.year}-${entryDate.month.toString().padLeft(2, '0')}-${entryDate.day.toString().padLeft(2, '0')} | ${entry.type}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            onTap: () => _navigateToEditEntry(context, entry),
            trailing: Container(
              width: MediaQuery.of(context).size.width * 0.1, // Adjust width as needed
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
                onPressed: () => _deleteEntry(entry.id),
              ),
            ),
            onLongPress: () => _deleteEntry(entry.id),
          ),
        );
      },
    );
  }
}
