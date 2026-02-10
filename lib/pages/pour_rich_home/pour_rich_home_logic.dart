import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';
import 'package:pour_rich/utils/index.dart';

enum GameInputState { inputting, showingResult, readyForNext }

class PourRichHomeLogic extends GetxController
    with GetTickerProviderStateMixin {
  final _db = Get.find<PourRichDatabase>();
  final currentPosition = 1.obs;
  final totalTiles = 25.obs;
  final currentWaterAmount = 0.obs;
  final guessInput = ''.obs;
  final currentAttempts = 0.obs;
  final totalWins = 0.obs;
  final bestRecord = 0.obs;
  final currentGuessCount = 0.obs;
  final hasShownGuide = false.obs;
  final feedbackMessage = ''.obs;
  final showFeedback = false.obs;
  final isGuessCorrect = true.obs;
  final gameInputState = GameInputState.inputting.obs;
  final showKeyboard = true.obs;
  final isAnimating = false.obs;
  final animatingPosition = 1.obs;
  final highlightedTile = 0.obs;
  late AnimationController moveAnimationController;
  late AnimationController tileEffectController;
  MonopolyGameProgress? _progress;
  @override
  void onInit() {
    super.onInit();
    moveAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    tileEffectController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    moveAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        moveAnimationController.reset();
      }
    });
    _loadGameProgress();
  }

  @override
  void onClose() {
    moveAnimationController.dispose();
    tileEffectController.dispose();
    super.onClose();
  }

  Future<void> _loadGameProgress() async {
    try {
      _progress = await _db.getMonopolyGameProgress();
      if (_progress != null) {
        currentPosition.value = _progress!.currentPosition;
        totalTiles.value = _progress!.totalGrids;
        totalWins.value = _progress!.totalWins;
        bestRecord.value = _progress!.bestRecord;
        currentGuessCount.value = _progress!.currentGuessCount;
        currentAttempts.value = _progress!.currentAttemptCount;
        hasShownGuide.value = _progress!.hasShownGuide;
        if (!hasShownGuide.value) {
          _showGuideDialog();
        }
      }
      _generateNewWaterAmount();
    } catch (e) {
      errorToast('Failed to load game progress');
    }
  }

  void _showGuideDialog() {
    Future.delayed(Duration(milliseconds: 500), () {
      Get.dialog(_buildGuideDialog(), barrierDismissible: false);
    });
  }

  Widget _buildGuideDialog() {
    return AlertDialog(
      title: Text('Welcome to Water Monopoly!'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Rules:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Guess the water amount (0-1000ml)'),
            Text('2. The more accurate, the more steps you move forward'),
            Text('3. Reach the finish line to win!'),
            SizedBox(height: 16),
            Text('Tile Types:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('🏠 Start - Game begins here'),
            Text('🏁 Finish - Reach here to win'),
            Text('💰 Forward - Move extra steps'),
            Text('❓ Mystery - Random event'),
            Text('🏢 Empty - No special effect'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            _markGuideAsShown();
          },
          child: Text('Start Game'),
        ),
      ],
    );
  }

  Future<void> _markGuideAsShown() async {
    try {
      if (_progress != null) {
        final updated = MonopolyGameProgress(
          id: _progress!.id,
          currentPosition: _progress!.currentPosition,
          totalGrids: _progress!.totalGrids,
          totalWins: _progress!.totalWins,
          bestRecord: _progress!.bestRecord,
          currentGuessCount: _progress!.currentGuessCount,
          currentAttemptCount: _progress!.currentAttemptCount,
          hasShownGuide: true,
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _db.updateMonopolyGameProgress(updated);
        hasShownGuide.value = true;
        _progress = updated;
      }
    } catch (e) {}
  }

  void _generateNewWaterAmount() {
    final random = Random();
    currentWaterAmount.value = random.nextInt(1001);
  }

  void updateGuess(String value) {
    guessInput.value = value;
  }

  void onKeyboardNumberTap(String number) {
    if (guessInput.value.length < 4) {
      guessInput.value += number;
    }
  }

  void onKeyboardDeleteTap() {
    if (guessInput.value.isNotEmpty) {
      guessInput.value = guessInput.value.substring(
        0,
        guessInput.value.length - 1,
      );
    }
  }

  Future<void> onKeyboardConfirmTap() async {
    await onSubmitGuess();
  }

  Future<void> onSubmitGuess() async {
    if (guessInput.value.isEmpty) {
      errorToast('Please enter water amount');
      return;
    }
    final guess = int.tryParse(guessInput.value);
    if (guess == null) {
      errorToast('Invalid input');
      return;
    }
    if (guess < 0 || guess > 1000) {
      errorToast('Please enter a value between 0-1000');
      return;
    }
    try {
      currentAttempts.value++;
      final error = (guess - currentWaterAmount.value).abs();
      showKeyboard.value = false;
      gameInputState.value = GameInputState.showingResult;
      if (error == 0) {
        await _onGuessCorrect();
      } else {
        _onGuessWrong(guess);
      }
      await _saveProgress();
    } catch (e) {
      errorToast('Failed to process guess');
    }
  }

  Future<void> _onGuessCorrect() async {
    currentGuessCount.value++;
    final steps = Random().nextInt(6) + 1;
    isGuessCorrect.value = true;
    feedbackMessage.value = 'Correct! Moving forward $steps steps';
    showFeedback.value = true;
    try {
      await _db.updateDailyTaskProgress(
        'monopoly_guess_5',
        currentGuessCount.value,
      );
    } catch (e) {}
    await _moveForwardWithAnimation(steps);
    guessInput.value = '';
    _generateNewWaterAmount();
    currentAttempts.value = 0;
  }

  void _onGuessWrong(int guess) {
    final hint = guess > currentWaterAmount.value ? 'Too high!' : 'Too low!';
    isGuessCorrect.value = false;
    feedbackMessage.value = 'Sorry, $hint Attempt #${currentAttempts.value}';
    showFeedback.value = true;
  }

  Future<void> _moveForwardWithAnimation(int steps) async {
    isAnimating.value = true;
    for (int i = 0; i < steps; i++) {
      int nextPos = currentPosition.value + 1;
      if (nextPos > totalTiles.value) {
        nextPos = totalTiles.value;
      }
      animatingPosition.value = nextPos;
      await moveAnimationController.forward();
      currentPosition.value = nextPos;
      moveAnimationController.reset();
      if (nextPos >= totalTiles.value) {
        isAnimating.value = false;
        await _onReachFinish();
        return;
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
    isAnimating.value = false;
    await _triggerTileEffectWithAnimation(currentPosition.value);
  }

  Future<void> _triggerTileEffectWithAnimation(int position) async {
    final tiles = _getTileTypes();
    if (position >= 1 && position <= tiles.length) {
      highlightedTile.value = position;
      await tileEffectController.forward();
      tileEffectController.reset();
      highlightedTile.value = 0;
      await _triggerTileEffect(position);
    }
  }

  Future<void> _moveForward(int steps) async {
    int newPosition = currentPosition.value + steps;
    if (newPosition >= totalTiles.value) {
      currentPosition.value = totalTiles.value;
      await _onReachFinish();
      return;
    }
    currentPosition.value = newPosition;
    await _triggerTileEffect(newPosition);
  }

  Future<void> _triggerTileEffect(int position) async {
    final tiles = _getTileTypes();
    if (position >= 1 && position <= tiles.length) {
      final tileType = tiles[position - 1]['type'];
      switch (tileType) {
        case 'forward':
          final extraSteps = Random().nextInt(3) + 1;
          successToast('Forward tile! Move $extraSteps more steps!');
          await Future.delayed(Duration(seconds: 1));
          await _moveForward(extraSteps);
          break;
        case 'question':
          await _triggerMysteryEvent();
          break;
        default:
          break;
      }
    }
  }

  Future<void> _triggerMysteryEvent() async {
    final random = Random();
    final event = random.nextInt(100);
    if (event < 50) {
      final steps = random.nextInt(3) + 2;
      successToast('Mystery! Move forward $steps steps!');
      await Future.delayed(Duration(seconds: 1));
      await _moveForward(steps);
    } else if (event < 80) {
      final steps = random.nextInt(3) + 1;
      final newPos = (currentPosition.value - steps).clamp(1, totalTiles.value);
      currentPosition.value = newPos;
      errorToast('Mystery! Move back $steps steps!');
    } else {
      successToast('Mystery! Skip next turn (just kidding, you can continue!)');
    }
  }

  Future<void> _onReachFinish() async {
    try {
      totalWins.value++;
      bool isNewRecord = false;
      if (bestRecord.value == 0 || currentGuessCount.value < bestRecord.value) {
        bestRecord.value = currentGuessCount.value;
        isNewRecord = true;
      }
      await _saveProgress();
      Get.dialog(_buildVictoryDialog(isNewRecord), barrierDismissible: false);
    } catch (e) {
      errorToast('Failed to save victory');
    }
  }

  Widget _buildVictoryDialog(bool isNewRecord) {
    return AlertDialog(
      title: Text('🎉 Congratulations! 🎉'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNewRecord) ...[
            Text(
              '✨ NEW RECORD! ✨',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
          ],
          Text('Total Wins: ${totalWins.value}'),
          Text('Guesses: ${currentGuessCount.value}'),
          Text('Attempts: ${currentAttempts.value}'),
          Text('Best Record: ${bestRecord.value} guesses'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            onRestartGame();
          },
          child: Text('Play Again'),
        ),
      ],
    );
  }

  void onChangeQuestion() {
    _generateNewWaterAmount();
    currentAttempts.value = 0;
    showFeedback.value = false;
    guessInput.value = '';
    gameInputState.value = GameInputState.inputting;
    showKeyboard.value = true;
    successToast('New question generated!');
  }

  void toggleKeyboardResult() {
    if (gameInputState.value == GameInputState.inputting) {
      final willShowKeyboard = !showKeyboard.value;
      showKeyboard.value = willShowKeyboard;
      if (willShowKeyboard) {
        guessInput.value = '';
      }
    } else if (gameInputState.value == GameInputState.showingResult) {
      gameInputState.value = GameInputState.inputting;
      showKeyboard.value = true;
      guessInput.value = '';
    }
  }

  Future<void> onRestartGame() async {
    try {
      await _db.resetMonopolyGameProgress();
      currentPosition.value = 1;
      currentGuessCount.value = 0;
      currentAttempts.value = 0;
      guessInput.value = '';
      showFeedback.value = false;
      _generateNewWaterAmount();
      await _loadGameProgress();
      successToast('Game restarted!');
    } catch (e) {
      errorToast('Failed to restart game');
    }
  }

  Future<void> _saveProgress() async {
    try {
      if (_progress != null) {
        final updated = MonopolyGameProgress(
          id: _progress!.id,
          currentPosition: currentPosition.value,
          totalGrids: totalTiles.value,
          totalWins: totalWins.value,
          bestRecord: bestRecord.value,
          currentGuessCount: currentGuessCount.value,
          currentAttemptCount: currentAttempts.value,
          hasShownGuide: hasShownGuide.value,
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _db.updateMonopolyGameProgress(updated);
        _progress = updated;
      }
    } catch (e) {}
  }

  void showHelp() {
    Get.dialog(_buildHelpDialog());
  }

  Widget _buildHelpDialog() {
    return AlertDialog(
      title: Text('Game Help'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Objective:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Reach the finish line by guessing water amounts correctly.'),
            SizedBox(height: 16),
            Text('Rules:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Guess the exact water amount (0-1000ml)'),
            Text('• Must match exactly to move forward'),
            Text('• Correct guess: Move forward 1-6 steps randomly'),
            Text('• Incorrect guess: Get hint (too high/low) and try again'),
            SizedBox(height: 16),
            Text(
              'Tile Effects:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('💰 Forward: Extra 1-3 steps'),
            Text('❓ Mystery: Random event (forward/back)'),
            Text('🏢 Empty: No effect'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () => Get.back(), child: Text('Got it!')),
      ],
    );
  }

  List<Map<String, dynamic>> _getTileTypes() {
    return [
      {'type': 'start', 'number': 1},
      {'type': 'normal', 'number': 2},
      {'type': 'question', 'number': 3},
      {'type': 'normal', 'number': 4},
      {'type': 'empty', 'number': 5},
      {'type': 'forward', 'number': 6},
      {'type': 'question', 'number': 7},
      {'type': 'empty', 'number': 8},
      {'type': 'question', 'number': 9},
      {'type': 'normal', 'number': 10},
      {'type': 'empty', 'number': 11},
      {'type': 'normal', 'number': 12},
      {'type': 'normal', 'number': 13},
      {'type': 'normal', 'number': 14},
      {'type': 'normal', 'number': 15},
      {'type': 'normal', 'number': 16},
      {'type': 'normal', 'number': 17},
      {'type': 'forward', 'number': 18},
      {'type': 'empty', 'number': 19},
      {'type': 'forward', 'number': 20},
      {'type': 'forward', 'number': 21},
      {'type': 'forward', 'number': 22},
      {'type': 'question', 'number': 23},
      {'type': 'question', 'number': 24},
      {'type': 'finish', 'number': 25},
    ];
  }
}
