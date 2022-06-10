import 'package:bmi_app/models/bmi_record.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod/riverpod.dart';

import '../constants/box_names.dart';

final latestRecordProvider = StateProvider<BmiRecord?>((ref) {
  try {
    return Hive.box<BmiRecord>(BoxNames.bmiBox).values.last;
  } catch (e) {
    return null;
  }
});
