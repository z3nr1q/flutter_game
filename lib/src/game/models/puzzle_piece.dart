class PuzzlePiece {
  final int id;
  final int correctPosition;
  int currentPosition;
  bool isBlank;

  PuzzlePiece({
    required this.id,
    required this.correctPosition,
    required this.currentPosition,
    this.isBlank = false,
  });

  bool get isInCorrectPosition => correctPosition == currentPosition;
}
