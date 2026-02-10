class MonopolyGameProgress {
  final int? id;
  final int currentPosition;
  final int totalGrids;
  final int totalWins;
  final int bestRecord;
  final int currentGuessCount;
  final int currentAttemptCount;
  final bool hasShownGuide;
  final String updatedAt;
  const MonopolyGameProgress({
    this.id,
    required this.currentPosition,
    required this.totalGrids,
    required this.totalWins,
    required this.bestRecord,
    required this.currentGuessCount,
    required this.currentAttemptCount,
    required this.hasShownGuide,
    required this.updatedAt,
  });
  factory MonopolyGameProgress.fromMap(Map<String, dynamic> map) {
    return MonopolyGameProgress(
      id: map['id'] as int?,
      currentPosition: map['current_position'] as int,
      totalGrids: map['total_grids'] as int,
      totalWins: map['total_wins'] as int,
      bestRecord: map['best_record'] as int,
      currentGuessCount: map['current_guess_count'] as int,
      currentAttemptCount: map['current_attempt_count'] as int,
      hasShownGuide: map['has_shown_guide'] == 1,
      updatedAt: map['updated_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'current_position': currentPosition,
      'total_grids': totalGrids,
      'total_wins': totalWins,
      'best_record': bestRecord,
      'current_guess_count': currentGuessCount,
      'current_attempt_count': currentAttemptCount,
      'has_shown_guide': hasShownGuide ? 1 : 0,
      'updated_at': updatedAt,
    };
  }
}

class WaterChallengeProfile {
  final int? id;
  final int totalScore;
  final int level;
  final int highestScore;
  final int consecutiveWins;
  final int totalChallenges;
  final int totalSuccess;
  final String updatedAt;
  const WaterChallengeProfile({
    this.id,
    required this.totalScore,
    required this.level,
    required this.highestScore,
    required this.consecutiveWins,
    required this.totalChallenges,
    required this.totalSuccess,
    required this.updatedAt,
  });
  factory WaterChallengeProfile.fromMap(Map<String, dynamic> map) {
    return WaterChallengeProfile(
      id: map['id'] as int?,
      totalScore: map['total_score'] as int,
      level: map['level'] as int,
      highestScore: map['highest_score'] as int,
      consecutiveWins: map['consecutive_wins'] as int,
      totalChallenges: map['total_challenges'] as int,
      totalSuccess: map['total_success'] as int,
      updatedAt: map['updated_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'total_score': totalScore,
      'level': level,
      'highest_score': highestScore,
      'consecutive_wins': consecutiveWins,
      'total_challenges': totalChallenges,
      'total_success': totalSuccess,
      'updated_at': updatedAt,
    };
  }
}

class WaterChallengeHistory {
  final int? id;
  final int targetAmount;
  final int actualAmount;
  final int errorAmount;
  final int score;
  final bool isSuccess;
  final String createdAt;
  const WaterChallengeHistory({
    this.id,
    required this.targetAmount,
    required this.actualAmount,
    required this.errorAmount,
    required this.score,
    required this.isSuccess,
    required this.createdAt,
  });
  factory WaterChallengeHistory.fromMap(Map<String, dynamic> map) {
    return WaterChallengeHistory(
      id: map['id'] as int?,
      targetAmount: map['target_amount'] as int,
      actualAmount: map['actual_amount'] as int,
      errorAmount: map['error_amount'] as int,
      score: map['score'] as int,
      isSuccess: map['is_success'] == 1,
      createdAt: map['created_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'target_amount': targetAmount,
      'actual_amount': actualAmount,
      'error_amount': errorAmount,
      'score': score,
      'is_success': isSuccess ? 1 : 0,
      'created_at': createdAt,
    };
  }
}

class WaterChallengeAchievement {
  final int? id;
  final String achievementKey;
  final String name;
  final String description;
  final bool isAchieved;
  final String? achievedAt;
  const WaterChallengeAchievement({
    this.id,
    required this.achievementKey,
    required this.name,
    required this.description,
    required this.isAchieved,
    this.achievedAt,
  });
  factory WaterChallengeAchievement.fromMap(Map<String, dynamic> map) {
    return WaterChallengeAchievement(
      id: map['id'] as int?,
      achievementKey: map['achievement_key'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      isAchieved: map['is_achieved'] == 1,
      achievedAt: map['achieved_at'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'achievement_key': achievementKey,
      'name': name,
      'description': description,
      'is_achieved': isAchieved ? 1 : 0,
      'achieved_at': achievedAt,
    };
  }
}

class Trivia {
  final int? id;
  final String icon;
  final String title;
  final String content;
  final String category;
  final int sortOrder;
  const Trivia({
    this.id,
    required this.icon,
    required this.title,
    required this.content,
    required this.category,
    required this.sortOrder,
  });
  factory Trivia.fromMap(Map<String, dynamic> map) {
    return Trivia(
      id: map['id'] as int?,
      icon: map['icon'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      sortOrder: map['sort_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'icon': icon,
      'title': title,
      'content': content,
      'category': category,
      'sort_order': sortOrder,
    };
  }
}

class TriviaReadHistory {
  final int? id;
  final int triviaId;
  final String readAt;
  const TriviaReadHistory({
    this.id,
    required this.triviaId,
    required this.readAt,
  });
  factory TriviaReadHistory.fromMap(Map<String, dynamic> map) {
    return TriviaReadHistory(
      id: map['id'] as int?,
      triviaId: map['trivia_id'] as int,
      readAt: map['read_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'trivia_id': triviaId, 'read_at': readAt};
  }
}

class TriviaFavorite {
  final int? id;
  final int triviaId;
  final String favoritedAt;
  const TriviaFavorite({
    this.id,
    required this.triviaId,
    required this.favoritedAt,
  });
  factory TriviaFavorite.fromMap(Map<String, dynamic> map) {
    return TriviaFavorite(
      id: map['id'] as int?,
      triviaId: map['trivia_id'] as int,
      favoritedAt: map['favorited_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'trivia_id': triviaId,
      'favorited_at': favoritedAt,
    };
  }
}

class FinancialGuide {
  final int? id;
  final String stage;
  final String ageRange;
  final String icon;
  final String borderColor;
  final String description;
  final String advice;
  final int sortOrder;
  const FinancialGuide({
    this.id,
    required this.stage,
    required this.ageRange,
    required this.icon,
    required this.borderColor,
    required this.description,
    required this.advice,
    required this.sortOrder,
  });
  factory FinancialGuide.fromMap(Map<String, dynamic> map) {
    return FinancialGuide(
      id: map['id'] as int?,
      stage: map['stage'] as String,
      ageRange: map['age_range'] as String,
      icon: map['icon'] as String,
      borderColor: map['border_color'] as String,
      description: map['description'] as String,
      advice: map['advice'] as String,
      sortOrder: map['sort_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'stage': stage,
      'age_range': ageRange,
      'icon': icon,
      'border_color': borderColor,
      'description': description,
      'advice': advice,
      'sort_order': sortOrder,
    };
  }
}

class FinancialGuideAllocation {
  final int? id;
  final int guideId;
  final String investmentType;
  final int percentage;
  final int sortOrder;
  const FinancialGuideAllocation({
    this.id,
    required this.guideId,
    required this.investmentType,
    required this.percentage,
    required this.sortOrder,
  });
  factory FinancialGuideAllocation.fromMap(Map<String, dynamic> map) {
    return FinancialGuideAllocation(
      id: map['id'] as int?,
      guideId: map['guide_id'] as int,
      investmentType: map['investment_type'] as String,
      percentage: map['percentage'] as int,
      sortOrder: map['sort_order'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'guide_id': guideId,
      'investment_type': investmentType,
      'percentage': percentage,
      'sort_order': sortOrder,
    };
  }
}

class DailyTask {
  final int? id;
  final String taskKey;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final int rewardCoins;
  final bool isCompleted;
  final String taskDate;
  final String createdAt;
  const DailyTask({
    this.id,
    required this.taskKey,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.rewardCoins,
    required this.isCompleted,
    required this.taskDate,
    required this.createdAt,
  });
  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      id: map['id'] as int?,
      taskKey: map['task_key'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      targetValue: map['target_value'] as int,
      currentValue: map['current_value'] as int,
      rewardCoins: map['reward_coins'] as int,
      isCompleted: map['is_completed'] == 1,
      taskDate: map['task_date'] as String,
      createdAt: map['created_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'task_key': taskKey,
      'title': title,
      'description': description,
      'target_value': targetValue,
      'current_value': currentValue,
      'reward_coins': rewardCoins,
      'is_completed': isCompleted ? 1 : 0,
      'task_date': taskDate,
      'created_at': createdAt,
    };
  }
}

class SavingsGoal {
  final int? id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String? description;
  final String? deadline;
  final bool isCompleted;
  final String createdAt;
  final String? completedAt;
  const SavingsGoal({
    this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.description,
    this.deadline,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });
  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'] as int?,
      name: map['name'] as String,
      targetAmount: map['target_amount'] as double,
      currentAmount: map['current_amount'] as double,
      description: map['description'] as String?,
      deadline: map['deadline'] as String?,
      isCompleted: map['is_completed'] == 1,
      createdAt: map['created_at'] as String,
      completedAt: map['completed_at'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'description': description,
      'deadline': deadline,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
      'completed_at': completedAt,
    };
  }

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount) : 0;
}

class SavingsRecord {
  final int? id;
  final int goalId;
  final double amount;
  final String type;
  final String? note;
  final String createdAt;
  const SavingsRecord({
    this.id,
    required this.goalId,
    required this.amount,
    required this.type,
    this.note,
    required this.createdAt,
  });
  factory SavingsRecord.fromMap(Map<String, dynamic> map) {
    return SavingsRecord(
      id: map['id'] as int?,
      goalId: map['goal_id'] as int,
      amount: map['amount'] as double,
      type: map['type'] as String,
      note: map['note'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'goal_id': goalId,
      'amount': amount,
      'type': type,
      'note': note,
      'created_at': createdAt,
    };
  }
}

class TriviaQuestion {
  final int? id;
  final int triviaId;
  final String question;
  final String correctAnswer;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final int correctOption;
  const TriviaQuestion({
    this.id,
    required this.triviaId,
    required this.question,
    required this.correctAnswer,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctOption,
  });
  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    return TriviaQuestion(
      id: map['id'] as int?,
      triviaId: map['trivia_id'] as int,
      question: map['question'] as String,
      correctAnswer: map['correct_answer'] as String,
      option1: map['option1'] as String,
      option2: map['option2'] as String,
      option3: map['option3'] as String,
      option4: map['option4'] as String,
      correctOption: map['correct_option'] as int,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'trivia_id': triviaId,
      'question': question,
      'correct_answer': correctAnswer,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'correct_option': correctOption,
    };
  }

  List<String> get options => [option1, option2, option3, option4];
}

class QuizHistory {
  final int? id;
  final int questionId;
  final int selectedOption;
  final bool isCorrect;
  final int coinsEarned;
  final String createdAt;
  const QuizHistory({
    this.id,
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.coinsEarned,
    required this.createdAt,
  });
  factory QuizHistory.fromMap(Map<String, dynamic> map) {
    return QuizHistory(
      id: map['id'] as int?,
      questionId: map['question_id'] as int,
      selectedOption: map['selected_option'] as int,
      isCorrect: map['is_correct'] == 1,
      coinsEarned: map['coins_earned'] as int,
      createdAt: map['created_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'question_id': questionId,
      'selected_option': selectedOption,
      'is_correct': isCorrect ? 1 : 0,
      'coins_earned': coinsEarned,
      'created_at': createdAt,
    };
  }
}

class CoinsRecord {
  final int? id;
  final int amount;
  final String source;
  final String? description;
  final String createdAt;
  const CoinsRecord({
    this.id,
    required this.amount,
    required this.source,
    this.description,
    required this.createdAt,
  });
  factory CoinsRecord.fromMap(Map<String, dynamic> map) {
    return CoinsRecord(
      id: map['id'] as int?,
      amount: map['amount'] as int,
      source: map['source'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'source': source,
      'description': description,
      'created_at': createdAt,
    };
  }
}

class GlobalAchievement {
  final int? id;
  final String achievementKey;
  final String name;
  final String description;
  final String category;
  final String rarity;
  final int rewardCoins;
  final bool isAchieved;
  final String? achievedAt;
  const GlobalAchievement({
    this.id,
    required this.achievementKey,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.rewardCoins,
    required this.isAchieved,
    this.achievedAt,
  });
  factory GlobalAchievement.fromMap(Map<String, dynamic> map) {
    return GlobalAchievement(
      id: map['id'] as int?,
      achievementKey: map['achievement_key'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      rarity: map['rarity'] as String,
      rewardCoins: map['reward_coins'] as int,
      isAchieved: map['is_achieved'] == 1,
      achievedAt: map['achieved_at'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'achievement_key': achievementKey,
      'name': name,
      'description': description,
      'category': category,
      'rarity': rarity,
      'reward_coins': rewardCoins,
      'is_achieved': isAchieved ? 1 : 0,
      'achieved_at': achievedAt,
    };
  }
}
