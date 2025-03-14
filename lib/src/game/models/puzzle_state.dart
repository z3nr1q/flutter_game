import 'dart:math' as math;
import 'puzzle_piece.dart';

class PuzzleState {
  final int size;
  final List<PuzzlePiece> pieces;
  int moves = 0;
  final DateTime startTime;
  
  PuzzleState({required this.size})
      : pieces = [],
        startTime = DateTime.now() {
    _initializePuzzle();
  }

  void _initializePuzzle() {
    // Criar peças em ordem
    for (int i = 0; i < size * size; i++) {
      pieces.add(
        PuzzlePiece(
          id: i,
          correctPosition: i,
          currentPosition: i,
          isBlank: i == size * size - 1,
        ),
      );
    }
    // Embaralhar peças
    shuffle();
  }

  void shuffle() {
    final random = math.Random();
    for (int i = pieces.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      // Trocar posições
      final currentPosI = pieces[i].currentPosition;
      pieces[i].currentPosition = pieces[j].currentPosition;
      pieces[j].currentPosition = currentPosI;
      // Trocar peças na lista
      final temp = pieces[i];
      pieces[i] = pieces[j];
      pieces[j] = temp;
    }
  }

  bool canMovePiece(int position) {
    final blankPiece = pieces.firstWhere((piece) => piece.isBlank);
    final blankPos = blankPiece.currentPosition;
    
    // Verificar se a peça está adjacente ao espaço em branco
    return (position == blankPos - 1 && position ~/ size == blankPos ~/ size) || // Esquerda
           (position == blankPos + 1 && position ~/ size == blankPos ~/ size) || // Direita
           (position == blankPos - size) || // Acima
           (position == blankPos + size);   // Abaixo
  }

  void movePiece(int position) {
    if (!canMovePiece(position)) return;

    final blankPiece = pieces.firstWhere((piece) => piece.isBlank);
    final movingPiece = pieces.firstWhere((piece) => piece.currentPosition == position);
    
    // Trocar posições
    final tempPosition = blankPiece.currentPosition;
    blankPiece.currentPosition = movingPiece.currentPosition;
    movingPiece.currentPosition = tempPosition;
    
    moves++;
  }

  bool isComplete() {
    return pieces.every((piece) => piece.isInCorrectPosition);
  }

  Duration get elapsedTime => DateTime.now().difference(startTime);
}
