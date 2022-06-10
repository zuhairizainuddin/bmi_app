import 'package:flutter/material.dart';

import '../database/bmi_values.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI results')),
      body: ListView.builder(
        itemCount: bmiValues.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bmiValues[index].toString()),
            subtitle: const Text('My BMI'),
          );
        },
      ),
    );
  }
}
