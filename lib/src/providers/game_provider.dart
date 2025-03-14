import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider extends ChangeNotifier {
  int _currentLevel = 1;
  int _score = 0;
  bool _isSoundEnabled = true;
  final SharedPreferences _prefs;

  GameProvider(this._prefs) {
    _loadGameState();
  }

  int get currentLevel => _currentLevel;
  int get score => _score;
  bool get isSoundEnabled => _isSoundEnabled;

  void _loadGameState() {
    _currentLevel = _prefs.getInt('currentLevel') ?? 1;
    _score = _prefs.getInt('score') ?? 0;
    _isSoundEnabled = _prefs.getBool('isSoundEnabled') ?? true;
    notifyListeners();
  }

  Future<void> updateScore(int points) async {
    _score += points;
    await _prefs.setInt('score', _score);
    notifyListeners();
  }

  Future<void> completeLevel() async {
    _currentLevel++;
    await _prefs.setInt('currentLevel', _currentLevel);
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    await _prefs.setBool('isSoundEnabled', _isSoundEnabled);
    notifyListeners();
  }
}
