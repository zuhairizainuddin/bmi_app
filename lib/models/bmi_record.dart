import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'bmi_record.g.dart';

@HiveType(typeId: 1)
class BmiRecord extends HiveObject {
  BmiRecord({
    required this.heightInCm,
    required this.weightInKg,
  });

  @HiveField(0)
  num heightInCm;

  @HiveField(1)
  num weightInKg;

  String get bmi {
    try {
      final heightInMetres = heightInCm / 100;
      final result = weightInKg / (heightInMetres * heightInMetres);
      return result.toStringAsFixed(2);
    } catch (e) {
      return 'No Data';
    }
  }

  Map<String, Color> get bmiCategory {
    try {
      final bmiValue = num.parse(bmi);
      if (bmiValue < 18.5) {
        return {'underweight': Colors.red};
      } else if (bmiValue >= 18.5 && bmiValue < 25) {
        return {'normal': Colors.blue};
      } else if (bmiValue >= 25 && bmiValue < 30) {
        return {'overweight': Colors.orange};
      } else if (bmiValue >= 30) {
        return {'obese': Colors.red};
      }
      return {'': Colors.transparent};
    } catch (e) {
      return {'': Colors.transparent};
    }
  }
}
