import 'package:flutter/material.dart';
import 'dart:async';
import '../game/models/puzzle_state.dart';
import '../widgets/puzzle_piece_widget.dart';

class PuzzleGameScreen extends StatefulWidget {
  final int gridSize;

  const PuzzleGameScreen({super.key, this.gridSize = 3});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late PuzzleState puzzleState;
  late Timer timer;
  String elapsedTime = '00:00';

  @override
  void initState() {
    super.initState();
    puzzleState = PuzzleState(size: widget.gridSize);
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final duration = puzzleState.elapsedTime;
      setState(() {
        elapsedTime =
            '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
  }

  void _handlePieceMove(int position) {
    if (puzzleState.canMovePiece(position)) {
      setState(() {
        puzzleState.movePiece(position);
        if (puzzleState.isComplete()) {
          timer.cancel();
          _showWinDialog();
        }
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Parabéns!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Você completou o puzzle!'),
            const SizedBox(height: 8),
            Text('Tempo: $elapsedTime'),
            Text('Movimentos: ${puzzleState.moves}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                puzzleState = PuzzleState(size: widget.gridSize);
                startTimer();
              });
            },
            child: const Text('Jogar Novamente'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Menu Principal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final puzzleSize = screenWidth * 0.8;
    final pieceSize = (puzzleSize / widget.gridSize) - 4;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard('Tempo', elapsedTime),
                  _buildInfoCard('Movimentos', '${puzzleState.moves}'),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: puzzleSize,
                  height: puzzleSize,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.gridSize,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: widget.gridSize * widget.gridSize,
                    itemBuilder: (context, index) {
                      final piece = puzzleState.pieces
                          .firstWhere((p) => p.currentPosition == index);
                      return PuzzlePieceWidget(
                        piece: piece,
                        size: pieceSize,
                        gridSize: widget.gridSize,
                        onTap: () => _handlePieceMove(index),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    puzzleState = PuzzleState(size: widget.gridSize);
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Reiniciar'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
