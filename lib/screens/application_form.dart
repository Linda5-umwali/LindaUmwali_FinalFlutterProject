import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../models/application.dart';

class ApplicationFormScreen extends StatefulWidget {
  final Opportunity opportunity;

  const ApplicationFormScreen({super.key, required this.opportunity});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _coverLetterController = TextEditingController();

  String? _resumeFileName;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _pickResume() async {
    // TODO: wire up file_picker to select a PDF, then upload it via
    // firebase_storage and store the resulting download URL.
    // Example once file_picker is added to pubspec.yaml:
    //   final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    //   if (result != null) { setState(() => _resumeFileName = result.files.single.name); }
    setState(() => _resumeFileName = 'resume.pdf');
  }

  Future<String> _uploadResume() async {
    // TODO: replace with real firebase_storage upload once wired up.
    // final ref = FirebaseStorage.instance.ref('resumes/${DateTime.now().millisecondsSinceEpoch}.pdf');
    // await ref.putFile(file);
    // return await ref.getDownloadURL();
    return _resumeFileName ?? '';
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final resumeUrl = await _uploadResume();

    final application = Application(
      id: '',
      opportunityId: widget.opportunity.id,
      studentId: uid,
      startupId: widget.opportunity.startupId,
      studentName: _nameController.text.trim(),
      studentEmail: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      resumeUrl: resumeUrl,
      coverLetter: _coverLetterController.text.trim(),
      status: 'pending',
      appliedAt: DateTime.now(),
      opportunityTitle: widget.opportunity.title,
      startupName: widget.opportunity.startupName,
    );

    await FirebaseFirestore.instance
        .collection('applications')
        .add(application.toMap());

    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
  }

  void _backToOpportunities() {
    // Pops everything back to the Home screen at the bottom of the stack,
    // skipping past Opportunity Details.
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_submitted) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 72,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Application submitted!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your application has been sent to ${widget.opportunity.startupName}.',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _backToOpportunities,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Back to Opportunities'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Apply for ${widget.opportunity.title}')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Phone',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Resume',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: _pickResume,
                icon: const Icon(Icons.upload_file),
                label: Text(_resumeFileName ?? 'Upload Resume'),
              ),
              const SizedBox(height: 16),

              const Text(
                'Cover Letter',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _coverLetterController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tell the startup why you\'re a good fit...',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApplication,
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
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
