import 'package:flame/game.dart';

class FlutterGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Aqui vamos adicionar os componentes iniciais do jogo
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Aqui vamos atualizar a lógica do jogo
  }
}
