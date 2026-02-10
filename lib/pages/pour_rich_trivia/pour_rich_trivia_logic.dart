import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';
import 'package:pour_rich/utils/index.dart';
import 'package:pour_rich/utils/colors.dart';

class PourRichTriviaLogic extends GetxController {
  final _db = Get.find<PourRichDatabase>();
  final triviaList = <Map<String, String>>[].obs;
  final allTriviaData = <Trivia>[];
  final readTriviaIds = <int>{};
  @override
  void onInit() {
    super.onInit();
    _loadTriviaData();
  }

  Future<void> _loadTriviaData() async {
    try {
      final trivias = await _db.getAllTrivia();
      allTriviaData.clear();
      allTriviaData.addAll(trivias);
      final readCount = await _db.getReadTriviaCount();
      await _shuffleTrivia();
    } catch (e) {
      triviaList.clear();
    }
  }

  Future<void> onShuffleTap() async {
    try {
      await _shuffleTrivia();
    } catch (e) {}
  }

  Future<void> _shuffleTrivia() async {
    try {
      if (allTriviaData.isEmpty) {
        triviaList.clear();
        return;
      }
      final unreadTrivias = await _db.getUnreadTrivia();
      final List<Trivia> displayList = [];
      if (unreadTrivias.isNotEmpty) {
        displayList.addAll(unreadTrivias);
      } else {
        displayList.addAll(allTriviaData);
      }
      displayList.shuffle();
      triviaList.value = displayList
          .map(
            (trivia) => {
              'id': trivia.id.toString(),
              'icon': trivia.icon,
              'title': trivia.title,
              'content': trivia.content,
            },
          )
          .toList();
    } catch (e) {}
  }

  Future<void> onTriviaCardTap(Map<String, String> trivia) async {
    try {
      final triviaId = int.tryParse(trivia['id'] ?? '0');
      if (triviaId == null || triviaId <= 0) return;
      final result = await Get.dialog<bool>(
        _buildTriviaDetailDialog(trivia),
        barrierDismissible: true,
      );
      if (result == true) {
        await _db.markTriviaAsRead(triviaId);
        final totalReadCount = await _db.getReadTriviaCount();
        await _db.updateDailyTaskProgress('trivia_read_5', totalReadCount);
        successToast('Article marked as read! 📚');
      }
    } catch (e) {}
  }

  Widget _buildTriviaDetailDialog(Map<String, String> trivia) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PourRichColors.cardBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Text(trivia['icon'] ?? '', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      trivia['title'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: PourRichColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(result: false),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Text(
                  trivia['content'] ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: PourRichColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PourRichColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Mark as Read',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
