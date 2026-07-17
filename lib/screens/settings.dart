import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme_controller.dart';
import 'login_screen.dart';
import 'help_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;
  bool emailNotifications = true;

  String selectedLanguage = "English";
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = AppThemeController.instance.themeMode == ThemeMode.dark;
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showLanguagePicker() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final languages = ["English", "French", "Kinyarwanda"];

        return ListView(
          shrinkWrap: true,
          children: languages.map((language) {
            return ListTile(
              title: Text(
                language,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              trailing: selectedLanguage == language
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                setState(() {
                  selectedLanguage = language;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showVersionDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "App Information",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          "ALU Intercampus Connect\nVersion 1.0.0",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Logout",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;

                        return SlideTransition(
                          position: animation.drive(
                            Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: child,
                        );
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        trailing:
            trailing ??
            Icon(Icons.chevron_right, color: theme.colorScheme.primary),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        title: Text(
          "Settings",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSectionTitle(context, "ACCOUNT"),

          buildSectionTitle(context, "NOTIFICATIONS"),

          buildTile(
            context: context,
            icon: Icons.notifications_outlined,
            title: "Push Notifications",
            trailing: Switch(
              activeThumbColor: theme.colorScheme.primary,
              value: pushNotifications,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
          ),

          buildTile(
            context: context,
            icon: Icons.email_outlined,
            title: "Email Notifications",
            trailing: Switch(
              activeThumbColor: theme.colorScheme.primary,
              value: emailNotifications,
              onChanged: (value) {
                setState(() {
                  emailNotifications = value;
                });
              },
            ),
          ),

          buildSectionTitle(context, "PRIVACY"),

          buildSectionTitle(context, "APP"),

          buildTile(
            context: context,
            icon: Icons.dark_mode_outlined,
            title: "Dark Mode",
            trailing: Switch(
              activeThumbColor: theme.colorScheme.primary,
              value: _isDarkMode,
              onChanged: (value) async {
                setState(() {
                  _isDarkMode = value;
                });
                await AppThemeController.instance.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),

          buildTile(
            context: context,
            icon: Icons.language,
            title: "Language",
            trailing: Text(
              selectedLanguage,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            onTap: _showLanguagePicker,
          ),

          buildSectionTitle(context, "SUPPORT"),

          buildTile(
            context: context,
            icon: Icons.info_outline,
            title: "Help & Support",
            onTap: () => _navigateToPage(context, const HelpPage()),
          ),

          buildSectionTitle(context, "ABOUT"),
          buildTile(
            context: context,
            icon: Icons.info_outline,
            title: "Version",
            trailing: Text(
              "1.0.0",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            onTap: _showVersionDialog,
          ),

          const SizedBox(height: 10),

          buildTile(
            context: context,
            icon: Icons.logout,
            title: "Logout",
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
