import 'package:flutter/material.dart';
import '../game/models/puzzle_piece.dart';

class PuzzlePieceWidget extends StatelessWidget {
  final PuzzlePiece piece;
  final double size;
  final VoidCallback onTap;
  final int gridSize;

  const PuzzlePieceWidget({
    super.key,
    required this.piece,
    required this.size,
    required this.onTap,
    required this.gridSize,
  });

  @override
  Widget build(BuildContext context) {
    if (piece.isBlank) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: piece.isInCorrectPosition ? Colors.green.shade300 : Colors.blue.shade300,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${piece.id + 1}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
