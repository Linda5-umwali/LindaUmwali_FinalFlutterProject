import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/startup.dart';
import '../models/opportunity.dart';
import '../models/application.dart';
import 'package:alu_connect/screens/post_opportunity_screen.dart';

class StartupDashboardScreen extends StatefulWidget {
  const StartupDashboardScreen({super.key});

  @override
  State<StartupDashboardScreen> createState() => _StartupDashboardScreenState();
}

class _StartupDashboardScreenState extends State<StartupDashboardScreen> {
  Startup? _startup;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStartup();
  }

  Future<void> _loadStartup() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }
    // Assumes one startup per founder account, matched by uid.
    final query = await FirebaseFirestore.instance
        .collection('startups')
        .where('founder', isEqualTo: uid)
        .limit(1)
        .get();

    setState(() {
      _startup = query.docs.isNotEmpty
          ? Startup.fromFirestore(query.docs.first)
          : null;
      _isLoading = false;
    });
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature - coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_startup == null) {
      return const Scaffold(
        body: Center(child: Text('No startup profile found for this account.')),
      );
    }

    final startup = _startup!;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Welcome section
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  backgroundImage: startup.logo.isNotEmpty
                      ? NetworkImage(startup.logo)
                      : null,
                  child: startup.logo.isEmpty
                      ? const Icon(Icons.rocket_launch_outlined)
                      : null,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      startup.startupName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('opportunities')
                  .where('startupId', isEqualTo: startup.id)
                  .snapshots(),
              builder: (context, oppSnapshot) {
                final opportunities =
                    oppSnapshot.data?.docs
                        .map(Opportunity.fromFirestore)
                        .toList() ??
                    [];
                final activeCount = opportunities
                    .where((o) => o.deadline.isAfter(DateTime.now()))
                    .length;

                final eventsCount = opportunities
                    .where((o) => o.type == 'Event')
                    .length;

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where('startupId', isEqualTo: startup.id)
                      .orderBy('appliedAt', descending: true)
                      .snapshots(),
                  builder: (context, appSnapshot) {
                    final applications =
                        appSnapshot.data?.docs
                            .map(Application.fromFirestore)
                            .toList() ??
                        [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummary(
                          context,
                          activeCount,
                          applications.length,
                          eventsCount,
                        ),
                        const SizedBox(height: 28),
                        _buildQuickActions(context, startup),
                        const SizedBox(height: 28),
                        _buildRecentApplications(
                          context,
                          applications.take(5).toList(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    int active,
    int applications,
    int events,
  ) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(label: 'Active Opportunities', value: '$active'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            label: 'Applications Received',
            value: '$applications',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(label: 'Events Posted', value: '$events'),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, Startup startup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: Icons.add,
          label: 'Post Opportunity',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostOpportunityScreen(startup: startup),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _ActionButton(
          icon: Icons.list_alt_outlined,
          label: 'Manage Opportunities',
          onTap: () => _comingSoon(context, 'Manage Opportunities'),
        ),
        const SizedBox(height: 10),
        _ActionButton(
          icon: Icons.people_outline,
          label: 'View Applications',
          onTap: () => _comingSoon(context, 'View Applications'),
        ),
        const SizedBox(height: 10),
        _ActionButton(
          icon: Icons.edit_outlined,
          label: 'Edit Startup Profile',
          onTap: () => _comingSoon(context, 'Edit Startup Profile'),
        ),
      ],
    );
  }

  Widget _buildRecentApplications(
    BuildContext context,
    List<Application> applications,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Applications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (applications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No applications yet.',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          )
        else
          ...applications.map(
            (app) => _ApplicationTile(
              application: app,
              onView: () => _comingSoon(context, 'Application details'),
            ),
          ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: theme.colorScheme.primary),
        label: Align(alignment: Alignment.centerLeft, child: Text(label)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  final Application application;
  final VoidCallback onView;

  const _ApplicationTile({required this.application, required this.onView});

  Color _statusColor(BuildContext context) {
    switch (application.status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        title: Text(
          application.studentName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(application.opportunityTitle),
            const SizedBox(height: 4),
            Text(
              'Status: ${application.statusLabel}',
              style: TextStyle(
                color: _statusColor(context),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: TextButton(onPressed: onView, child: const Text('View')),
      ),
    );
  }
}
