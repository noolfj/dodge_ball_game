import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:dodge_ball/screens/game_screen.dart';

class BounceDodgeGame extends FlameGame with TapDetector {
  late Paint ballPaint;
  Vector2 ballPosition = Vector2(100, 100);
  Vector2 ballVelocity = Vector2(200, 150);
  final double ballRadius = 20;
  final Random random = Random();
  final Set<String> spikes = {};
  bool gameOver = false;
  int score = 0;
  ThemeData? theme;

  final List<Vector2> trail = [];
  final int maxTrailLength = 10;
  final double trailFadeStep = 0.1;

  void Function(int)? onScoreUpdate;
  void Function(bool)? onGameOver;

  @override
  Future<void> onLoad() async {
    ballPaint = Paint()..color = getRandomColor();
    ballPosition = size / 2;
    spawnSpikes();
  }

  @override
  void update(double dt) {
    if (gameOver) {
      return;
    }

    ballPosition += ballVelocity * dt;

    trail.add(ballPosition.clone());
    if (trail.length > maxTrailLength) {
      trail.removeAt(0);
    }

    if (ballPosition.x <= ballRadius && spikes.contains('left') ||
        ballPosition.x >= size.x - ballRadius && spikes.contains('right') ||
        ballPosition.y <= ballRadius && spikes.contains('top') ||
        ballPosition.y >= size.y - ballRadius && spikes.contains('bottom')) {
      gameOver = true;
      ballPaint.color = Colors.red;
      trail.clear();
      onGameOver?.call(true);
      return;
    }

    bool bounced = false;
    if (ballPosition.x <= ballRadius || ballPosition.x >= size.x - ballRadius) {
      ballVelocity.x *= -1;
      bounced = true;
    }
    if (ballPosition.y <= ballRadius || ballPosition.y >= size.y - ballRadius) {
      ballVelocity.y *= -1;
      bounced = true;
    }

    if (bounced) {
      score++;
      onScoreUpdate?.call(score);
      ballPaint.color = getRandomColor();
      ballVelocity *= 1.05;
      spawnSpikes();
    }
  }

  @override
  void render(Canvas canvas) {
    drawBackground(canvas, size, theme?.colorScheme.background ?? Colors.black);
    drawSpikes(canvas, size, spikes);

    if (!gameOver) {
      for (int i = 0; i < trail.length; i++) {
        final opacity = 0.7 - (trail.length - 1 - i) * trailFadeStep;
        final trailPaint = Paint()
          ..color = ballPaint.color.withOpacity(opacity.clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
        canvas.drawCircle(trail[i].toOffset(), ballRadius * (0.8 + i * 0.02), trailPaint);
      }
    }

    canvas.drawCircle(ballPosition.toOffset(), ballRadius, ballPaint);
  }

  @override
  void onTap() {
    if (gameOver) {
      restart();
    } else {
      ballVelocity = Vector2(-ballVelocity.x, -ballVelocity.y);
    }
  }

  void restart() {
    ballPosition = size / 2;
    ballVelocity = Vector2(200, 150);
    ballPaint.color = getRandomColor();
    gameOver = false;
    score = 0;
    trail.clear(); 
    onScoreUpdate?.call(score);
    onGameOver?.call(false);
    spawnSpikes();
  }

  void spawnSpikes() {
    spikes.clear();
    final sideGroups = [
      ['top', 'bottom'],
      ['left', 'right'],
    ];

    for (var group in sideGroups) {
      final hasSpike = random.nextBool();
      if (hasSpike) {
        spikes.add(group[random.nextInt(2)]);
      }
    }
  }

  Color getRandomColor() {
    final List<Color> brightColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.cyan,
      Colors.orange,
      const Color(0xFFFF4081),
      const Color(0xFF00E676),
      const Color(0xFF3F51B5),
    ];
    return brightColors[random.nextInt(brightColors.length)];
  }
}