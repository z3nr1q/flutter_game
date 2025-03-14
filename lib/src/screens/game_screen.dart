import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/puzzle_game.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GameProvider>(
          builder: (context, gameProvider, _) => Text(
            'Nível ${gameProvider.currentLevel} - Pontos: ${gameProvider.score}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        actions: [
          IconButton(
            icon: Consumer<GameProvider>(
              builder: (context, gameProvider, _) => Icon(
                gameProvider.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
              ),
            ),
            onPressed: () => context.read<GameProvider>().toggleSound(),
          ),
        ],
      ),
      body: GameWidget(
        game: PuzzleGame(),
      ),
    );
  }
}
