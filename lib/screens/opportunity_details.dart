import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import 'application_form.dart';

class OpportunityDetailsScreen extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailsScreen({super.key, required this.opportunity});

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Opportunity details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              opportunity.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              opportunity.startupName,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _infoChip(
                  context,
                  Icons.location_on_outlined,
                  opportunity.location,
                ),
                _infoChip(
                  context,
                  Icons.schedule_outlined,
                  opportunity.duration,
                ),
                _infoChip(
                  context,
                  Icons.event_outlined,
                  'Due ${opportunity.formattedDeadline}',
                ),
              ],
            ),

            const SizedBox(height: 28),
            _sectionLabel(context, 'DESCRIPTION'),
            const SizedBox(height: 8),
            Text(
              opportunity.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 24),
            _sectionLabel(context, 'REQUIREMENTS'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: opportunity.requirements
                  .map(
                    (req) => Chip(
                      label: Text(req),
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 24),
            _sectionLabel(context, 'CATEGORY'),
            const SizedBox(height: 8),
            Text(opportunity.category, style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ApplicationFormScreen(opportunity: opportunity),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
