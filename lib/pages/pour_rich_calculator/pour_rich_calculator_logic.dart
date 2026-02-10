import 'dart:math';
import 'package:get/get.dart';

class PourRichCalculatorLogic extends GetxController {
  final selectedCalculator = 'compound'.obs;
  final principalController = ''.obs;
  final annualRateController = ''.obs;
  final yearsController = ''.obs;
  final compoundFrequency = 12.obs;
  final compoundResult = 0.0.obs;
  final compoundInterest = 0.0.obs;
  final loanAmountController = ''.obs;
  final loanRateController = ''.obs;
  final loanYearsController = ''.obs;
  final monthlyPayment = 0.0.obs;
  final totalPayment = 0.0.obs;
  final totalInterest = 0.0.obs;
  final currentAgeController = ''.obs;
  final retirementAgeController = ''.obs;
  final monthlyExpenseController = ''.obs;
  final yearsInRetirement = 20.obs;
  final retirementNeeded = 0.0.obs;
  final goalAmountController = ''.obs;
  final monthlyContributionController = ''.obs;
  final expectedReturnController = ''.obs;
  final monthsNeeded = 0.0.obs;
  final yearsNeeded = 0.0.obs;
  void selectCalculator(String calculator) {
    selectedCalculator.value = calculator;
  }

  void calculateCompoundInterest() {
    try {
      final principal = double.parse(principalController.value);
      final rate = double.parse(annualRateController.value) / 100;
      final years = int.parse(yearsController.value);
      final n = compoundFrequency.value;
      final amount = principal * pow(1 + rate / n, n * years);
      compoundResult.value = amount;
      compoundInterest.value = amount - principal;
    } catch (e) {
      print('Error calculating compound interest: $e');
    }
  }

  void calculateMortgage() {
    try {
      final loan = double.parse(loanAmountController.value);
      final annualRate = double.parse(loanRateController.value) / 100;
      final years = int.parse(loanYearsController.value);
      final monthlyRate = annualRate / 12;
      final numPayments = years * 12;
      final monthly =
          loan *
          (monthlyRate * pow(1 + monthlyRate, numPayments)) /
          (pow(1 + monthlyRate, numPayments) - 1);
      monthlyPayment.value = monthly;
      totalPayment.value = monthly * numPayments;
      totalInterest.value = totalPayment.value - loan;
    } catch (e) {
      print('Error calculating mortgage: $e');
    }
  }

  void calculateRetirement() {
    try {
      final currentAge = int.parse(currentAgeController.value);
      final retirementAge = int.parse(retirementAgeController.value);
      final monthlyExpense = double.parse(monthlyExpenseController.value);
      final annualExpense = monthlyExpense * 12;
      final totalNeeded = annualExpense * yearsInRetirement.value;
      retirementNeeded.value = totalNeeded;
    } catch (e) {
      print('Error calculating retirement: $e');
    }
  }

  void calculateGoal() {
    try {
      final goal = double.parse(goalAmountController.value);
      final monthly = double.parse(monthlyContributionController.value);
      final annualReturn = double.parse(expectedReturnController.value) / 100;
      final monthlyReturn = annualReturn / 12;
      if (monthlyReturn == 0) {
        monthsNeeded.value = goal / monthly;
      } else {
        final n =
            log(goal * monthlyReturn / monthly + 1) / log(1 + monthlyReturn);
        monthsNeeded.value = n;
      }
      yearsNeeded.value = monthsNeeded.value / 12;
    } catch (e) {
      print('Error calculating goal: $e');
    }
  }
}
