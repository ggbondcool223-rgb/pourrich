import 'dart:convert';
import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';

class PourRichFinancialGuideLogic extends GetxController {
  final _db = Get.find<PourRichDatabase>();
  final guides = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    _loadFinancialGuides();
  }

  Future<void> _loadFinancialGuides() async {
    try {
      final guideList = await _db.getAllFinancialGuides();
      final List<Map<String, dynamic>> displayGuides = [];
      for (final guide in guideList) {
        final allocations = await _db.getFinancialGuideAllocations(guide.id!);
        List<String> adviceList = [];
        try {
          final decoded = jsonDecode(guide.advice);
          if (decoded is List) {
            adviceList = decoded.cast<String>();
          }
        } catch (e) {
          print('Error parsing advice JSON: $e');
        }
        final allocationList = allocations
            .map(
              (a) => {
                'type': a.investmentType,
                'percentage': '${a.percentage}%',
              },
            )
            .toList();
        int borderColor = 0xFF2196F3;
        int bgColor = 0xFFE3F2FD;
        switch (guide.borderColor.toLowerCase()) {
          case 'pink':
            borderColor = 0xFFE91E63;
            bgColor = 0xFFFCE4EC;
            break;
          case 'blue':
            borderColor = 0xFF2196F3;
            bgColor = 0xFFE3F2FD;
            break;
          case 'green':
            borderColor = 0xFF4CAF50;
            bgColor = 0xFFE8F5E9;
            break;
          case 'yellow':
            borderColor = 0xFFFBC02D;
            bgColor = 0xFFFFF9C4;
            break;
        }
        displayGuides.add({
          'stage': guide.stage,
          'age': '${guide.ageRange} years',
          'icon': guide.icon,
          'borderColor': borderColor,
          'bgColor': bgColor,
          'description': guide.description,
          'advice': adviceList,
          'allocation': allocationList,
        });
      }
      guides.value = displayGuides;
      print('Loaded ${guides.length} financial guides from database');
    } catch (e) {
      print('Error loading financial guides: $e');
      _loadDefaultGuides();
    }
  }

  void _loadDefaultGuides() {
    guides.value = [
      {
        'stage': 'Youth',
        'age': '0-18 years',
        'icon': '👶',
        'borderColor': 0xFFE91E63,
        'bgColor': 0xFFFCE4EC,
        'description':
            'Cultivate correct financial awareness, learn basic financial knowledge, and lay a good foundation for the future.',
        'advice': [
          'Cultivate savings habits and establish the concept of pocket money management',
          'Learn basic financial knowledge',
          'Participate in family financial decision-making discussions',
          'Understand basic investment concepts',
        ],
        'allocation': [
          {'type': 'Savings', 'percentage': '80%'},
          {'type': 'Education Fund', 'percentage': '20%'},
        ],
      },
      {
        'stage': 'Young Adult',
        'age': '18-35 years',
        'icon': '👨',
        'borderColor': 0xFF2196F3,
        'bgColor': 0xFFE3F2FD,
        'description':
            'Career start-up stage, focus on income accumulation and risk protection, start diversified investment.',
        'advice': [
          'Establish emergency reserve fund (6 months expenses)',
          'Configure accident, medical and other basic insurance',
          'Start fund investment, cultivate investment habits',
          'Plan career development, improve income ability',
          'Prepare down payment for house purchase, pay attention to mortgage policy',
        ],
        'allocation': [
          {'type': 'Savings', 'percentage': '30%'},
          {'type': 'Insurance', 'percentage': '20%'},
          {'type': 'Fund Investment', 'percentage': '40%'},
          {'type': 'Other Investment', 'percentage': '10%'},
        ],
      },
      {
        'stage': 'Middle Age',
        'age': '35-60 years',
        'icon': '👨‍💼',
        'borderColor': 0xFF4CAF50,
        'bgColor': 0xFFE8F5E9,
        'description':
            'Career rising period, relatively stable income, need to balance family expenses and investment financing.',
        'advice': [
          'Improve family security system, configure critical illness insurance',
          'Plan children\'s education fund',
          'Increase investment asset allocation',
          'Consider pension plan',
          'Moderately configure real estate investment',
        ],
        'allocation': [
          {'type': 'Stable Wealth Management', 'percentage': '40%'},
          {'type': 'Insurance', 'percentage': '15%'},
          {'type': 'Stock Fund', 'percentage': '25%'},
          {'type': 'Real Estate', 'percentage': '20%'},
        ],
      },
      {
        'stage': 'Elderly',
        'age': '60+ years',
        'icon': '👴',
        'borderColor': 0xFFFBC02D,
        'bgColor': 0xFFFFF9C4,
        'description':
            'Retirement stage, focus on asset preservation and stable income, reasonable planning of pension withdrawal.',
        'advice': [
          'Configure pension annuity insurance',
          'Reasonably arrange pension collection plan',
          'Reduce investment risk, ensure fund safety',
          'Plan inheritance transfer plan',
          'Pay attention to medical and health expenses',
        ],
        'allocation': [
          {'type': 'Fixed Income', 'percentage': '60%'},
          {'type': 'Pension Insurance', 'percentage': '20%'},
          {'type': 'Stable Fund', 'percentage': '15%'},
          {'type': 'Cash Reserve', 'percentage': '5%'},
        ],
      },
    ];
  }
}
