import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/utils/index.dart';

class PourRichSettingsLogic extends GetxController {
  final version = 'v1.0.0'.obs;
  final _db = Get.find<PourRichDatabase>();
  void showDeleteConfirmDialog() {
    Get.defaultDialog(
      title: 'Confirm Delete',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: '',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'After deletion, all game data will be cleared, including:',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 12),
          Text(
            '• Water Monopoly game progress',
            style: TextStyle(fontSize: 13),
          ),
          Text(
            '• Water Challenge scores and levels',
            style: TextStyle(fontSize: 13),
          ),
          Text('• All local records', style: TextStyle(fontSize: 13)),
          SizedBox(height: 12),
          Text(
            'This operation cannot be undone, are you sure?',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFE53935),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Confirm Delete',
      confirmTextColor: const Color(0xFFFFFFFF),
      buttonColor: const Color(0xFFE53935),
      cancelTextColor: const Color(0xFF757575),
      onConfirm: () {
        Get.back();
        _deleteAllData();
      },
    );
  }

  Future<void> _deleteAllData() async {
    try {
      await _db.deleteAllData();
      successToast('All data deleted successfully');
    } catch (e) {
      errorToast('Failed to delete data, please try again');
    }
  }
}
