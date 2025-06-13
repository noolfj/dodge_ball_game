import 'package:flutter/material.dart';
import 'package:dodge_ball/app_styles.dart';
import 'package:provider/provider.dart';

class AppSettings extends ChangeNotifier {
  Locale _locale = const Locale('ru');
  ThemeMode _themeMode = ThemeMode.dark;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  void setThemeMode(ThemeMode newThemeMode) {
    _themeMode = newThemeMode;
    notifyListeners();
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    final isDark = settings.themeMode == ThemeMode.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.locale.languageCode == 'ru' ? 'Настройки' : 'Settings',
              style: AppStyles.getAppTextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                context: context,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(
                settings.locale.languageCode == 'ru' ? 'Язык' : 'Language',
                style: AppStyles.getAppTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  context: context,
                ),
              ),
              trailing: DropdownButton<Locale>(
                value: settings.locale,
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    settings.setLocale(newLocale);
                  }
                },
                items: const [
                  DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
                  DropdownMenuItem(value: Locale('en'), child: Text('English')),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(
                settings.locale.languageCode == 'ru' ? 'Тёмная тема' : 'Dark Theme',
                style: AppStyles.getAppTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  context: context,
                ),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (bool value) {
                  settings.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: Text(
                  settings.locale.languageCode == 'ru' ? 'Закрыть' : 'Close',
                  style: AppStyles.getAppTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    context: context,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
