import 'package:alu_connect/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alu_connect/screens/settings.dart';
import 'package:alu_connect/screens/help_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile? currentProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => isLoading = false);
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    setState(() {
      currentProfile = doc.exists ? Profile.fromFirestore(doc) : null;
      isLoading = false;
    });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isStudent = currentProfile?.isStudent ?? true;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateToPage(context, const SettingsPage()),
            icon: Icon(Icons.settings, color: theme.colorScheme.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar - swap for NetworkImage once you add a photo field/upload flow
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 3),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.15,
                ),
                child: const Icon(Icons.person, size: 55),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              currentProfile?.name ?? "Unknown User",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 6),

            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isStudent ? "Student" : "Startup Founder",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            if ((currentProfile?.bio ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  currentProfile!.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Skill chips - only meaningful for students, hide entirely otherwise
            if (isStudent && (currentProfile?.skills.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: currentProfile!.skills
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: theme.colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ProfileMenuTile(
                      icon: Icons.article_outlined,
                      title: isStudent ? "My Applications" : "My Postings",
                    ),
                    const Divider(height: 1),
                    const ProfileMenuTile(
                      icon: Icons.bookmark_outline,
                      title: "Saved",
                    ),
                    const Divider(height: 1),
                    const ProfileMenuTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                    ),
                    const Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: "Account Settings",
                      onTap: () =>
                          _navigateToPage(context, const SettingsPage()),
                    ),
                    const Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      onTap: () => _navigateToPage(context, const HelpPage()),
                    ),
                    const Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
      onTap: onTap,
    );
  }
}
