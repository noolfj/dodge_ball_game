import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:dodge_ball/screens/logic_game.dart';
import 'package:provider/provider.dart';
import 'package:dodge_ball/settings/settings.dart';
import 'package:dodge_ball/app_styles.dart';
import 'dart:ui';

void drawBackground(Canvas canvas, Vector2 size, Color backgroundColor) {
  canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = backgroundColor);
}

void drawSpikes(Canvas canvas, Vector2 size, Set<String> spikes) {
  final spikePaint = Paint()..color = Colors.red;
  const spikeWidth = 20.0;
  const spikeHeight = 10.0;

  if (spikes.contains('top')) {
    for (double x = 0; x < size.x; x += spikeWidth) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + spikeWidth / 2, spikeHeight)
        ..lineTo(x + spikeWidth, 0)
        ..close();
      canvas.drawPath(path, spikePaint);
    }
  }
  if (spikes.contains('bottom')) {
    for (double x = 0; x < size.x; x += spikeWidth) {
      final path = Path()
        ..moveTo(x, size.y)
        ..lineTo(x + spikeWidth / 2, size.y - spikeHeight)
        ..lineTo(x + spikeWidth, size.y)
        ..close();
      canvas.drawPath(path, spikePaint);
    }
  }
  if (spikes.contains('left')) {
    for (double y = 0; y < size.y; y += spikeWidth) {
      final path = Path()
        ..moveTo(0, y)
        ..lineTo(spikeHeight, y + spikeWidth / 2)
        ..lineTo(0, y + spikeWidth)
        ..close();
      canvas.drawPath(path, spikePaint);
    }
  }
  if (spikes.contains('right')) {
    for (double y = 0; y < size.y; y += spikeWidth) {
      final path = Path()
        ..moveTo(size.x, y)
        ..lineTo(size.x - spikeHeight, y + spikeWidth / 2)
        ..lineTo(size.x, y + spikeWidth)
        ..close();
      canvas.drawPath(path, spikePaint);
    }
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BounceDodgeGame _game;
  int _score = 0;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _game = BounceDodgeGame()
      ..onScoreUpdate = (score) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _score = score;
            });
          }
        });
      }
      ..onGameOver = (gameOver) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _gameOver = gameOver;
            });
          }
        });
      };
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    final isRussian = settings.locale.languageCode == 'ru';
    final theme = Theme.of(context); 

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GameWidget(
                game: _game
                  ..theme = theme,
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              child: Text(
                isRussian ? 'Счет: $_score' : 'Score: $_score',
                style: AppStyles.getAppTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  context: context,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
            if (_gameOver)
              Center(
                child: GestureDetector(
                  onTap: () {
                    _game.restart();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.surface.withOpacity(0.8),
                              theme.colorScheme.surfaceVariant.withOpacity(0.8),
                            ],
                          ),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isRussian ? 'Игра окончена' : 'Game Over',
                              style: AppStyles.getAppTextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                context: context,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isRussian
                                  ? 'Нажмите, чтобы начать заново'
                                  : 'Tap to restart',
                              style: AppStyles.getAppTextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                context: context,
                                color: theme.colorScheme.onSurface.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}