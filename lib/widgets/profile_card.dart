import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: SizedBox(
        width: double.infinity,
        height: height * 0.2,
        child: Card(
            color: Colors.purple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⭐⭐⭐⭐⭐'),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Zuhairi Zainuddin',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Premium User',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.yellow),
                ),
              ],
            )),
      ),
    );
  }
}
