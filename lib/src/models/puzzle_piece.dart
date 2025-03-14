import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PuzzlePiece extends PositionComponent {
  final int correctPosition;
  final int currentPosition;
  final Size size;
  final Color color;

  PuzzlePiece({
    required this.correctPosition,
    required this.currentPosition,
    required this.size,
    required this.color,
    required Vector2 position,
  }) : super(position: position, size: Vector2(size.width, size.height));

  bool get isInCorrectPosition => correctPosition == currentPosition;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = color,
    );
  }
}
