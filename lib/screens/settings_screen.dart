import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../services/transaction_service.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CurrencyService _currencyService = CurrencyService.instance;
  final TransactionService _transactionService = TransactionService();
  final ThemeService _themeService = ThemeService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            context,
            'Preferences',
            [
              _buildSettingsTile(
                context,
                icon: _themeService.themeIcon,
                title: 'Theme',
                subtitle: '${_themeService.themeName} Mode',
                onTap: () => _showThemeDialog(context),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.attach_money,
                title: 'Currency',
                subtitle:
                    '${_currencyService.currencyCode} (${_currencyService.currencySymbol})',
                onTap: () => _showCurrencyDialog(context),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Enabled',
                onTap: () => _showNotificationSettings(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            'Data',
            [
              _buildSettingsTile(
                context,
                icon: Icons.backup,
                title: 'Backup & Restore',
                subtitle: 'Export your data',
                onTap: () => _showBackupDialog(context),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.delete_forever,
                title: 'Clear All Data',
                subtitle: 'Reset the app',
                onTap: () => _showClearDataDialog(context),
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            'About',
            [
              _buildSettingsTile(
                context,
                icon: Icons.info,
                title: 'App Version',
                subtitle: 'Finance Tracker v1.0.0',
                onTap: () => _showAboutDialog(context),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: () => _showPrivacyPolicy(context),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help using the app',
                onTap: () => _showHelpDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isDestructive ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themeService.availableThemes.map((theme) {
            return RadioListTile<AppThemeMode>(
              title: Row(
                children: [
                  Icon(theme.icon, size: 20),
                  const SizedBox(width: 8),
                  Text('${theme.name} Mode'),
                ],
              ),
              value: theme,
              groupValue: _themeService.currentTheme,
              onChanged: (AppThemeMode? value) {
                if (value != null) {
                  _themeService.setTheme(value);
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Theme changed to ${value.name} mode'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Currency.values.map((currency) {
            return RadioListTile<Currency>(
              title: Text('${currency.name} (${currency.symbol})'),
              subtitle: Text(currency.code),
              value: currency,
              groupValue: _currencyService.currentCurrency,
              onChanged: (Currency? value) {
                if (value != null) {
                  _currencyService.setCurrency(value);
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Currency changed to ${value.name}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: const Text('Notification settings coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Restore'),
        content: const Text('Backup functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your transactions and data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _transactionService.clearAllTransactions();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Finance Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.account_balance_wallet, size: 48),
      children: [
        const Text('A simple and elegant personal finance tracking app.'),
        const SizedBox(height: 16),
        const Text('Built with Flutter for cross-platform compatibility.'),
      ],
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. This app stores all data locally on your device and does not collect or share any personal information.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Help documentation coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
