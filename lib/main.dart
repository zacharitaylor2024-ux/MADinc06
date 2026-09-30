// In-Class Activity 06 — Drawing with Flutter
// Student: Zachari Taylor
// Date: September 26, 2026

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

enum FaceType {
  classic,
  sleepy,
  surprised,
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  FaceType selectedFace = FaceType.classic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: SmileyPainter(
                  mood: mood,
                  faceType: selectedFace,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Mood: ${mood.toStringAsFixed(2)}'),

                Slider(
                  value: mood,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (double v) {
                    setState(() {
                      mood = v;
                    });
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFace = FaceType.classic;
                    });
                  },
                  child: const Text("Classic"),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFace = FaceType.sleepy;
                    });
                  },
                  child: const Text("Sleepy"),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFace = FaceType.surprised;
                    });
                  },
                  child: const Text("Surprised"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceType,
  });

  final double mood;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(
      size.width / 2,
      size.height / 2,
    );

    final r = size.shortestSide * 0.40;

    final faceColor = Color.lerp(
      Colors.red,
      Colors.yellow,
      mood,
    )!;

    // Face
    canvas.drawCircle(
      c,
      r,
      Paint()..color = faceColor,
    );

    // Face border
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Choose which face to draw
    switch (faceType) {
      case FaceType.classic:
        drawClassicFace(canvas, c, r);
        break;

      case FaceType.sleepy:
        drawSleepyFace(canvas, c, r);
        break;

      case FaceType.surprised:
        drawSurprisedFace(canvas, c, r);
        break;
    }
  }

  void drawClassicFace(
    Canvas canvas,
    Offset c,
    double r,
  ) {
    // Eyes
    final eyePaint = Paint()..color = Colors.black87;

    final eyeY = c.dy - r * 0.18;
    final eyeDx = r * 0.35;
    final eyeRadius = r * 0.10;

    canvas.drawCircle(
      Offset(c.dx - eyeDx, eyeY),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(c.dx + eyeDx, eyeY),
      eyeRadius,
      eyePaint,
    );

    // Mouth
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthY = c.dy + r * 0.25;
    final mouthWidth = r * 0.9;

    // Neutral
    if ((mood - 0.5).abs() < 0.05) {
      canvas.drawLine(
        Offset(c.dx - mouthWidth / 2, mouthY),
        Offset(c.dx + mouthWidth / 2, mouthY),
        mouthPaint,
      );
    }

    // Happy
    else if (mood > 0.5) {
      final happiness = (mood - 0.5) * 2;

      final mouthRect = Rect.fromCenter(
        center: Offset(
          c.dx,
          mouthY - r * 0.15,
        ),
        width: mouthWidth,
        height: r * 0.5 * happiness,
      );

      canvas.drawArc(
        mouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }

    // Sad
    else {
      final sadness = (0.5 - mood) * 2;

      final mouthRect = Rect.fromCenter(
        center: Offset(
          c.dx,
          mouthY + r * 0.15,
        ),
        width: mouthWidth,
        height: r * 0.5 * sadness,
      );

      canvas.drawArc(
        mouthRect,
        1.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }
  }

  void drawSleepyFace(
    Canvas canvas,
    Offset c,
    double r,
  ) {
    final linePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = c.dy - r * 0.18;
    final eyeDx = r * 0.35;
    final eyeWidth = r * 0.18;

    // Left closed eye
    canvas.drawLine(
      Offset(
        c.dx - eyeDx - eyeWidth,
        eyeY,
      ),
      Offset(
        c.dx - eyeDx + eyeWidth,
        eyeY,
      ),
      linePaint,
    );

    // Right closed eye
    canvas.drawLine(
      Offset(
        c.dx + eyeDx - eyeWidth,
        eyeY,
      ),
      Offset(
        c.dx + eyeDx + eyeWidth,
        eyeY,
      ),
      linePaint,
    );

    // Soft sleepy mouth
    final mouthRect = Rect.fromCenter(
      center: Offset(
        c.dx,
        c.dy + r * 0.30,
      ),
      width: r * 0.45,
      height: r * 0.20,
    );

    canvas.drawArc(
      mouthRect,
      0,
      pi,
      false,
      linePaint,
    );
  }

  void drawSurprisedFace(
    Canvas canvas,
    Offset c,
    double r,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87;

    final eyeY = c.dy - r * 0.18;
    final eyeDx = r * 0.35;

    // Bigger eyes
    final eyeRadius = r * 0.14;

    canvas.drawCircle(
      Offset(c.dx - eyeDx, eyeY),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(c.dx + eyeDx, eyeY),
      eyeRadius,
      eyePaint,
    );

    // Open mouth
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        c.dx,
        c.dy + r * 0.30,
      ),
      width: r * 0.35,
      height: r * 0.45,
    );

    canvas.drawOval(
      mouthRect,
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant SmileyPainter oldDelegate,
  ) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}