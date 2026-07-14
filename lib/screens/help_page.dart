import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I apply to an opportunity?',
      answer:
          'Tap any opportunity card on the Home screen to open its details, then tap "Apply Now." '
          'Fill in your name, email, phone, resume, and a short cover letter, then submit. '
          'You\'ll see a confirmation screen once it\'s sent.',
    ),
    _FaqItem(
      question: 'How do I check my application status?',
      answer:
          'Application status updates in real time as the startup reviews it. '
          'You can see the current status (Pending, Accepted, or Rejected) from your applications list.',
    ),
    _FaqItem(
      question: 'How does a startup get verified?',
      answer:
          'Startup accounts are reviewed and verified by the ALU Catalyst team before their opportunities '
          'become visible to students. This helps ensure only genuine, recognized ALU startups can post.',
    ),
    _FaqItem(
      question: 'How do I post an opportunity as a startup?',
      answer:
          'From your Startup Dashboard, tap "Post Opportunity" under Quick Actions and fill in the role '
          'details, requirements, location, and deadline.',
    ),
    _FaqItem(
      question: 'What are the skill-match badges?',
      answer:
          'Each opportunity is compared against your profile skills to show how many required skills you '
          'already have, so you can quickly judge fit before applying.',
    ),
    _FaqItem(
      question: 'How do I update my profile or skills?',
      answer:
          'Go to Profile > Account Settings to edit your name, bio, and skill tags.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            color: theme.colorScheme.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children:
                  _faqs
                      .map((faq) => _FaqTile(faq: faq))
                      .expand((tile) => [tile, const Divider(height: 1)])
                      .toList()
                    ..removeLast(), // drop the trailing divider after the last tile
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Still need help?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            color: theme.colorScheme.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.email_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Contact Support'),
                  subtitle: const Text('support@alucatalyst.com'),
                  // TODO: wire up url_launcher to open a mailto: link
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('About ALU Catalyst'),
                  subtitle: const Text('Version 1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}

class _FaqTile extends StatelessWidget {
  final _FaqItem faq;

  const _FaqTile({required this.faq});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      title: Text(
        faq.question,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
          fontSize: 15,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            faq.answer,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
