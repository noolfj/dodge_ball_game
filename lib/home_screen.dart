import 'package:flutter/material.dart';
import 'package:dodge_ball/screens/game_screen.dart';
import 'package:flutter/services.dart';
import 'package:dodge_ball/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:dodge_ball/app_styles.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    Widget buildMenuButton(String text, VoidCallback onPressed) {
      return SizedBox(
        width: 220,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            text,
            style: AppStyles.getAppTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              context: context,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.locale.languageCode == 'ru' ? 'DODGE BALL' : 'Dodge Ball',
              style: AppStyles.getAppTextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w600,
                context: context,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 60),
            buildMenuButton(
              settings.locale.languageCode == 'ru' ? 'Играть' : 'Play',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            buildMenuButton(
              settings.locale.languageCode == 'ru' ? 'Настройки' : 'Settings',
              () {
                showDialog(
                  context: context,
                  builder: (context) => SettingsDialog(),
                );
              },
            ),
            const SizedBox(height: 20),
            buildMenuButton(
              settings.locale.languageCode == 'ru' ? 'Выйти' : 'Exit',
              () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
