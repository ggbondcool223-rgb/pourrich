import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';

class PourRichQuizLogic extends GetxController {
  final PourRichDatabase _db = Get.find<PourRichDatabase>();
  final currentQuestion = Rx<TriviaQuestion?>(null);
  final selectedOption = Rx<int?>(null);
  final hasAnswered = false.obs;
  final isCorrect = false.obs;
  final totalCoins = 0.obs;
  final quizStats = {'total': 0, 'correct': 0}.obs;
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      totalCoins.value = await _db.getCoinsBalance();
      quizStats.value = await _db.getQuizStats();
      await loadQuestion();
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadQuestion() async {
    try {
      var question = await _db.getUnansweredQuestion();
      question ??= await _db.getRandomQuestion();
      currentQuestion.value = question;
      selectedOption.value = null;
      hasAnswered.value = false;
      isCorrect.value = false;
    } catch (e) {}
  }

  void selectOption(int option) {
    if (hasAnswered.value) return;
    selectedOption.value = option;
  }

  Future<void> submitAnswer() async {
    if (selectedOption.value == null || currentQuestion.value == null) return;
    if (hasAnswered.value) return;
    hasAnswered.value = true;
    final question = currentQuestion.value!;
    final correct = selectedOption.value == question.correctOption;
    isCorrect.value = correct;
    await _db.submitAnswer(question.id!, selectedOption.value!, correct);
    quizStats.value = await _db.getQuizStats();
    totalCoins.value = await _db.getCoinsBalance();
    if (correct) {
      final correctCount = quizStats['correct'] ?? 0;
      await _db.updateDailyTaskProgress('quiz_answer_3', correctCount);
    }
    await _db.checkAndUnlockAchievements();
  }

  Future<void> nextQuestion() async {
    await loadQuestion();
  }

  double get accuracyRate {
    final total = quizStats['total'] ?? 0;
    final correct = quizStats['correct'] ?? 0;
    if (total == 0) return 0;
    return correct / total;
  }
}
