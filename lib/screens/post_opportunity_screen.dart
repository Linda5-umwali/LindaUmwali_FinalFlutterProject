import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/startup.dart';

class PostOpportunityScreen extends StatefulWidget {
  final Startup startup;

  const PostOpportunityScreen({super.key, required this.startup});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();
  final _requirementsController = TextEditingController();

  static const List<String> _categories = [
    'Software Development',
    'Design',
    'Marketing',
    'Research',
    'Business',
    'Content Creation',
    'Community Management',
  ];
  static const List<String> _types = [
    'Internship',
    'Part-time',
    'Volunteer',
    'Event',
  ];

  String _selectedCategory = _categories.first;
  String _selectedType = _types.first;
  DateTime? _deadline;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a deadline')));
      return;
    }

    setState(() => _isSubmitting = true);

    final requirements = _requirementsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    try {
      await FirebaseFirestore.instance.collection('opportunities').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'startupId': widget.startup.id,
        'startupName': widget.startup.startupName,
        'category': _selectedCategory,
        'type': _selectedType,
        'duration': _durationController.text.trim(),
        'location': _locationController.text.trim(),
        'requirements': requirements,
        'deadline': Timestamp.fromDate(_deadline!),
        'postedBy': widget.startup.founder,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opportunity posted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to post: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Opportunity')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),

              const Text('Type', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 16),

              const Text(
                'Duration',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g. 3 months',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Requirements (comma-separated)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Flutter, Firebase, Git',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Deadline',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: _pickDeadline,
                icon: const Icon(Icons.event_outlined),
                label: Text(
                  _deadline == null
                      ? 'Select date'
                      : '${_deadline!.month}/${_deadline!.day}/${_deadline!.year}',
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Post Opportunity'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
