import 'package:bmi_app/models/bmi_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({
    Key? key,
    required this.provider,
    this.width,
  }) : super(key: key);

  final StateProvider<BmiRecord?> provider;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width,
      height: height * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Latest BMI',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                final latestRecord = ref.watch(provider);
                return Text(
                  latestRecord?.bmi ?? 'No Data',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 44),
                );
              },
            ),
            const Text('kg / m²'),
          ],
        ),
      ),
    );
  }
}
