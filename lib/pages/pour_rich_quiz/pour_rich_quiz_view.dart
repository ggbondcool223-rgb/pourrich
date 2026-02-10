import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_quiz_logic.dart';

class PourRichQuizView extends GetView<PourRichQuizLogic> {
  const PourRichQuizView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: PourRichColors.blue,
        elevation: 0,
        title: const Text(
          'Trivia Quiz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildStatsCard(),
              SizedBox(height: 20.h),
              _buildQuestionCard(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsCard() {
    return Obx(() {
      final total = controller.quizStats['total'] ?? 0;
      final correct = controller.quizStats['correct'] ?? 0;
      final accuracy = controller.accuracyRate;
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PourRichColors.blue,
              PourRichColors.blue.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.monetization_on,
              label: 'Coins',
              value: controller.totalCoins.value.toString(),
              iconColor: PourRichColors.gold,
            ),
            _buildStatItem(
              icon: Icons.quiz,
              label: 'Answered',
              value: total.toString(),
              iconColor: Colors.white,
            ),
            _buildStatItem(
              icon: Icons.check_circle,
              label: 'Accuracy',
              value: '${(accuracy * 100).toStringAsFixed(0)}%',
              iconColor: PourRichColors.primary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28.w),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Obx(() {
      final question = controller.currentQuestion.value;
      if (question == null) {
        return Container(
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(Icons.quiz, size: 64.w, color: PourRichColors.textSecondary),
              SizedBox(height: 16.h),
              Text(
                'No questions available',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: PourRichColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: PourRichColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                question.question,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: PourRichColors.textPrimary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            ...List.generate(4, (index) {
              final optionNumber = index + 1;
              final optionText = question.options[index];
              return Obx(
                () => _buildOptionButton(
                  optionNumber: optionNumber,
                  optionText: optionText,
                  question: question,
                ),
              );
            }),
            SizedBox(height: 24.h),
            Obx(() {
              if (controller.hasAnswered.value) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: controller.isCorrect.value
                            ? PourRichColors.primary.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.isCorrect.value
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: controller.isCorrect.value
                                ? PourRichColors.primary
                                : Colors.red,
                            size: 32.w,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.isCorrect.value
                                      ? 'Correct! 🎉'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: controller.isCorrect.value
                                        ? PourRichColors.primary
                                        : Colors.red,
                                  ),
                                ),
                                if (controller.isCorrect.value)
                                  Text(
                                    'You earned 10 coins!',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: PourRichColors.textSecondary,
                                    ),
                                  )
                                else
                                  Text(
                                    'Correct answer: ${question.correctAnswer}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: PourRichColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: controller.nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PourRichColors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next Question',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return ElevatedButton(
                onPressed: controller.selectedOption.value != null
                    ? controller.submitAnswer
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PourRichColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildOptionButton({
    required int optionNumber,
    required String optionText,
    required dynamic question,
  }) {
    final isSelected = controller.selectedOption.value == optionNumber;
    final hasAnswered = controller.hasAnswered.value;
    final isCorrectOption = optionNumber == question.correctOption;
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    if (hasAnswered) {
      if (isCorrectOption) {
        backgroundColor = PourRichColors.primary.withValues(alpha: 0.1);
        borderColor = PourRichColors.primary;
        textColor = PourRichColors.primary;
      } else if (isSelected) {
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        borderColor = Colors.red;
        textColor = Colors.red;
      } else {
        backgroundColor = Colors.white;
        borderColor = PourRichColors.textSecondary.withValues(alpha: 0.2);
        textColor = PourRichColors.textPrimary;
      }
    } else {
      if (isSelected) {
        backgroundColor = PourRichColors.blue.withValues(alpha: 0.1);
        borderColor = PourRichColors.blue;
        textColor = PourRichColors.blue;
      } else {
        backgroundColor = Colors.white;
        borderColor = PourRichColors.textSecondary.withValues(alpha: 0.2);
        textColor = PourRichColors.textPrimary;
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: hasAnswered ? null : () => controller.selectOption(optionNumber),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected || (hasAnswered && isCorrectOption)
                      ? borderColor
                      : Colors.transparent,
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(64 + optionNumber),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected || (hasAnswered && isCorrectOption)
                          ? Colors.white
                          : borderColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: textColor,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (hasAnswered && isCorrectOption)
                Icon(
                  Icons.check_circle,
                  color: PourRichColors.primary,
                  size: 24.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
