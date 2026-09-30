// In-Class Activity 06 — Drawing with Flutter
// Student: Maya Cockerham
// Date: September 26, 2026

import 'dart:math' show pi, Random;
import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

// Level 3: named face choices
enum FaceType {
  classic,
  sleepy,
  surprised,
}

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

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  // Drawing "state" — changing these + setState() triggers shouldRepaint
  double mood = 0.8; // 0.0 sad → 1.0 happy
  FaceType selectedFace = FaceType.classic;

  // Level 4: used to randomize the mood
  final Random random = Random();

  String get faceName {
    switch (selectedFace) {
      case FaceType.classic:
        return 'Classic';
      case FaceType.sleepy:
        return 'Sleepy';
      case FaceType.surprised:
        return 'Surprised';
    }
  }

  void showMessage(String message) {
    // Clear the old SnackBar before showing the new one
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  // Level 4: tapping the drawing cycles through the faces
  void cycleFace() {
    setState(() {
      if (selectedFace == FaceType.classic) {
        selectedFace = FaceType.sleepy;
      } else if (selectedFace == FaceType.sleepy) {
        selectedFace = FaceType.surprised;
      } else {
        selectedFace = FaceType.classic;
      }
    });

    showMessage('Face changed to $faceName');
  }

  // Level 4: long press randomizes mood and face color
  void randomizeMood() {
    setState(() {
      mood = random.nextDouble();
    });

    showMessage(
      'Mood randomized to ${mood.toStringAsFixed(2)}',
    );
  }

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
              // Level 4: GestureDetector adds touch interaction
              child: GestureDetector(
                onTap: cycleFace,
                onLongPress: randomizeMood,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: SmileyPainter(
                    mood: mood,
                    faceType: selectedFace,
                  ),
                ),
              ),
            ),
          ),

          // Level 3: buttons switch between three named faces
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFace = FaceType.classic;
                    });
                    showMessage('Face changed to Classic');
                  },
                  child: const Text('Classic'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFace = FaceType.sleepy;
                    });
                    showMessage('Face changed to Sleepy');
                  },
                  child: const Text('Sleepy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFace = FaceType.surprised;
                    });
                    showMessage('Face changed to Surprised');
                  },
                  child: const Text('Surprised'),
                ),
              ],
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
                  onChanged: (double value) {
                    setState(() {
                      mood = value;
                    });
                  },
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
    // Modules 2–3: add eyes and mouth here.
    // Base every position on size, center, or radius.
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.4;

    // Level 2: face color changes with mood
    Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue.shade300;
    } else if (mood <= 0.70) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange.shade300;
    }

    // 1) Face
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // 2) Face border
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * 0.35;
    final eyeRadius = radius * 0.10;

    // 3) Eyes
    if (faceType == FaceType.sleepy) {
      // Sleepy face: closed eyes
      canvas.drawLine(
        Offset(
          center.dx - eyeDx - radius * 0.10,
          eyeY,
        ),
        Offset(
          center.dx - eyeDx + radius * 0.10,
          eyeY,
        ),
        linePaint,
      );

      canvas.drawLine(
        Offset(
          center.dx + eyeDx - radius * 0.10,
          eyeY,
        ),
        Offset(
          center.dx + eyeDx + radius * 0.10,
          eyeY,
        ),
        linePaint,
      );
    } else if (faceType == FaceType.surprised) {
      // Surprised face: larger round eyes
      canvas.drawCircle(
        Offset(center.dx - eyeDx, eyeY),
        eyeRadius * 1.5,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDx, eyeY),
        eyeRadius * 1.5,
        eyePaint,
      );
    } else {
      // Classic face: normal round eyes
      canvas.drawCircle(
        Offset(center.dx - eyeDx, eyeY),
        eyeRadius,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDx, eyeY),
        eyeRadius,
        eyePaint,
      );
    }

    // 4) Mouth
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (faceType == FaceType.surprised) {
      // Surprised face: round open mouth
      final surprisedMouthPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          center.dx,
          center.dy + radius * 0.35,
        ),
        radius * 0.18,
        surprisedMouthPaint,
      );
    } else if (faceType == FaceType.sleepy) {
      // Sleepy face: smaller soft smile
      final sleepyMouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.25,
        ),
        width: radius * 0.65,
        height: radius * 0.30,
      );

      canvas.drawArc(
        sleepyMouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    } else {
      // Classic face: mouth changes with mood
      final mouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.15,
        ),
        width: radius * 1.0,
        height: radius * (0.4 + mood * 0.5),
      );

      if (mood >= 0.5) {
        // Happy smile
        canvas.drawArc(
          mouthRect,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      } else {
        // Sad frown
        final frownRect = mouthRect.translate(
          0,
          radius * 0.25,
        );

        canvas.drawArc(
          frownRect,
          1.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      }
    }

    // 5) Hat
    // Drawn last so it appears on top of the face.
    final hatPaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    final hatRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy - radius * 0.90,
      ),
      width: radius * 1.2,
      height: radius * 0.35,
    );

    canvas.drawRect(
      hatRect,
      hatPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}