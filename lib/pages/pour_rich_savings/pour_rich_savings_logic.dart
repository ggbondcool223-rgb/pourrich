import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/components/text_field.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';
import 'package:pour_rich/utils/index.dart';

class PourRichSavingsLogic extends GetxController {
  final PourRichDatabase _db = Get.find<PourRichDatabase>();
  final goals = <SavingsGoal>[].obs;
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  Future<void> loadGoals() async {
    isLoading.value = true;
    try {
      goals.value = await _db.getAllSavingsGoals();
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGoal({
    required String name,
    required double targetAmount,
    String? description,
    DateTime? deadline,
  }) async {
    try {
      final goal = SavingsGoal(
        name: name,
        targetAmount: targetAmount,
        currentAmount: 0,
        description: description,
        deadline: deadline?.toIso8601String(),
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _db.createSavingsGoal(goal);
      await loadGoals();
      Get.back();
      Get.snackbar(
        'Success',
        'Savings goal created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create savings goal',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> depositToGoal(
    SavingsGoal goal,
    double amount,
    String? note,
  ) async {
    try {
      final success = await _db.depositToGoal(goal.id!, amount, note);
      if (success) {
        await loadGoals();
        final updatedGoal = goals.firstWhere((g) => g.id == goal.id);
        if (updatedGoal.isCompleted) {
          Get.snackbar(
            'Goal Achieved! 🎉',
            'Congratulations on completing "${updatedGoal.name}"!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          await _db.checkAndUnlockAchievements();
        } else {
          Get.snackbar(
            'Deposited',
            'Successfully added \$${amount.toStringAsFixed(2)} to "${goal.name}"',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to deposit',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showCreateGoalDialog() {
    final goalName = ''.obs;
    final targetAmount = ''.obs;
    final description = ''.obs;
    final deadline = Rx<DateTime?>(null);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: 340.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13ec37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.savings_outlined,
                        color: const Color(0xFF13ec37),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Create Savings Goal',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildLabel('Goal Name *'),
                SizedBox(height: 8.h),
                _buildInputContainer(
                  child: MyTextField(
                    value: goalName.value,
                    onChange: (v) => goalName.value = v,
                    hintText: 'e.g., New Phone',
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLabel('Target Amount *'),
                SizedBox(height: 8.h),
                _buildInputContainer(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Text(
                          '\$ ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: MyTextField(
                          value: targetAmount.value,
                          onChange: (v) => targetAmount.value = v,
                          hintText: 'e.g., 500.00',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          isNumber: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLabel('Description (Optional)'),
                SizedBox(height: 8.h),
                _buildInputContainer(
                  child: MyTextField(
                    value: description.value,
                    onChange: (v) => description.value = v,
                    hintText: 'Why are you saving?',
                    maxLines: 3,
                    minLines: 3,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLabel('Deadline (Optional)'),
                SizedBox(height: 8.h),
                Obx(
                  () => InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: DateTime.now().add(
                          const Duration(days: 30),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF13ec37),
                                onPrimary: Colors.white,
                                onSurface: Colors.black87,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        deadline.value = picked;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: deadline.value != null
                              ? const Color(0xFF13ec37)
                              : const Color(0xFFE0E0E0),
                          width: deadline.value != null ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20.sp,
                            color: deadline.value != null
                                ? const Color(0xFF13ec37)
                                : Colors.grey[600],
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              deadline.value == null
                                  ? 'Select a deadline'
                                  : getDateString(deadline.value!),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: deadline.value != null
                                    ? Colors.black87
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          if (deadline.value != null)
                            Icon(
                              Icons.check_circle,
                              size: 20.sp,
                              color: const Color(0xFF13ec37),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (goalName.value.isEmpty) {
                            errorToast('Please enter a goal name');
                            return;
                          }
                          if (targetAmount.value.isEmpty) {
                            errorToast('Please enter target amount');
                            return;
                          }
                          final amount = double.tryParse(targetAmount.value);
                          if (amount == null || amount <= 0) {
                            errorToast('Please enter a valid amount');
                            return;
                          }
                          createGoal(
                            name: goalName.value,
                            targetAmount: amount,
                            description: description.value.isEmpty
                                ? null
                                : description.value,
                            deadline: deadline.value,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13ec37),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Create Goal',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: child,
    );
  }

  void showDepositDialog(SavingsGoal goal) {
    final depositAmount = ''.obs;
    final note = ''.obs;
    final remainingAmount = goal.targetAmount - goal.currentAmount;
    final progressPercent = (goal.currentAmount / goal.targetAmount * 100)
        .clamp(0, 100)
        .toInt();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: 340.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13ec37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: const Color(0xFF13ec37),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deposit Funds',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            goal.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF13ec37).withOpacity(0.1),
                        const Color(0xFF13ec37).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFF13ec37).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '\$${goal.currentAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF13ec37),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '$progressPercent%',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Target',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '\$${goal.targetAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14.sp,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Remaining: \$${remainingAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _buildLabel('Deposit Amount *'),
                SizedBox(height: 8.h),
                _buildInputContainer(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Text(
                          '\$ ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: MyTextField(
                          value: depositAmount.value,
                          onChange: (v) => depositAmount.value = v,
                          hintText: 'e.g., 50.00',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          isNumber: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLabel('Note (Optional)'),
                SizedBox(height: 8.h),
                _buildInputContainer(
                  child: MyTextField(
                    value: note.value,
                    onChange: (v) => note.value = v,
                    hintText: 'e.g., Weekly savings',
                    maxLines: 2,
                    minLines: 2,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (depositAmount.value.isEmpty) {
                            errorToast('Please enter an amount');
                            return;
                          }
                          final amount = double.tryParse(depositAmount.value);
                          if (amount == null || amount <= 0) {
                            errorToast('Please enter a valid amount');
                            return;
                          }
                          Get.back();
                          depositToGoal(
                            goal,
                            amount,
                            note.value.isEmpty ? null : note.value,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13ec37),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Deposit',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double get totalSaved {
    return goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  double get totalTarget {
    return goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  }

  int get completedGoalsCount {
    return goals.where((g) => g.isCompleted).length;
  }
}
