import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class PuzzleGameScreen extends StatefulWidget {
  final int gridSize;

  const PuzzleGameScreen({super.key, required this.gridSize});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late List<int> tiles;
  int moves = 0;
  late Timer timer;
  int seconds = 0;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    _initGame();
    _startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _initGame() {
    tiles = List.generate(widget.gridSize * widget.gridSize, (index) => index);
    _shuffleTiles();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void _shuffleTiles() {
    final random = math.Random();
    for (int i = tiles.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = tiles[i];
      tiles[i] = tiles[j];
      tiles[j] = temp;
    }
    if (!_isSolvable()) {
      final lastIndex = tiles.length - 1;
      if (tiles[0] != 0 && tiles[1] != 0) {
        final temp = tiles[0];
        tiles[0] = tiles[1];
        tiles[1] = temp;
      } else {
        final temp = tiles[lastIndex];
        tiles[lastIndex] = tiles[lastIndex - 1];
        tiles[lastIndex - 1] = temp;
      }
    }
  }

  bool _isSolvable() {
    int inversions = 0;
    int emptyRow = 0;
    
    final emptyIndex = tiles.indexOf(0);
    emptyRow = widget.gridSize - (emptyIndex ~/ widget.gridSize);

    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] == 0) continue;
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[j] == 0) continue;
        if (tiles[i] > tiles[j]) {
          inversions++;
        }
      }
    }

    if (widget.gridSize % 2 == 1) {
      return inversions % 2 == 0;
    }
    return (inversions % 2 == 0 && emptyRow % 2 == 1) ||
           (inversions % 2 == 1 && emptyRow % 2 == 0);
  }

  void _moveTile(int index) {
    if (isComplete) return;

    final emptyIndex = tiles.indexOf(0);
    if (_canMoveTile(index, emptyIndex)) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
        moves++;
        _checkWin();
      });
    }
  }

  bool _canMoveTile(int index, int emptyIndex) {
    final row = index ~/ widget.gridSize;
    final emptyRow = emptyIndex ~/ widget.gridSize;
    final col = index % widget.gridSize;
    final emptyCol = emptyIndex % widget.gridSize;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
           (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  void _checkWin() {
    bool won = true;
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) {
        won = false;
        break;
      }
    }
    if (won && tiles.last == 0) {
      setState(() {
        isComplete = true;
        timer.cancel();
      });
      _showWinDialog();
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
            Text('Tempo: ${_formatTime()}'),
            Text('Movimentos: $moves'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initGame();
                moves = 0;
                seconds = 0;
                isComplete = false;
                _startTimer();
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

  String _formatTime() {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaPadding = MediaQuery.of(context).padding;
    final availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;
    final puzzleSize = math.min(screenWidth - 40, availableHeight * 0.7);

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard('Tempo', _formatTime()),
                      _buildInfoCard('Movimentos', moves.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: puzzleSize,
                      height: puzzleSize,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.gridSize,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemCount: tiles.length,
                        itemBuilder: (context, index) {
                          final number = tiles[index];
                          final isCorrect = number == index + 1 || (number == 0 && index == tiles.length - 1);
                          
                          if (number == 0) {
                            return const SizedBox();
                          }

                          return GestureDetector(
                            onTap: () => _moveTile(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isCorrect ? Colors.green.shade300 : Colors.blue.shade300,
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
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      number.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initGame();
                        moves = 0;
                        seconds = 0;
                        isComplete = false;
                        timer.cancel();
                        _startTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Reiniciar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
