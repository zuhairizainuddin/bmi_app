import 'package:bmi_app/constants/box_names.dart';
import 'package:bmi_app/models/bmi_record.dart';
import 'package:bmi_app/providers/bmi_record_provider.dart';
import 'package:bmi_app/widgets/button.dart';
import 'package:bmi_app/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/profile_card.dart';
import '../widgets/record_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  changePage(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  void dispose() {
    Hive.box('bmiBox').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightController = TextEditingController();
    final weightController = TextEditingController();

    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Dismissing the keyboard when we tap any area on the screen rather than tapping the specific dismiss keyboard button
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // this setting hides the floating action button if the keyboard pops out
        appBar: AppBar(
          title: const Text('BMI TRACKER'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: selectedIndex == 0 ? const _Page1() : const _Page2(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Center(child: Text('Add BMI Record')),
                        content: SizedBox(
                          height: screenHeight * 0.6,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.monitor_weight,
                                      size: 100,
                                      color: Colors.purple,
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      controller: heightController,
                                      labelText: 'Height in cm',
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextField(
                                      controller: weightController,
                                      labelText: 'Weight in kg',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Consumer(
                                      builder: (context, ref, _) {
                                        return CustomButton(
                                          onPressed: () {
                                            final height = num.parse(
                                                heightController.text);
                                            final weight = num.parse(
                                                weightController.text);

                                            final bmiRecord = BmiRecord(
                                              heightInCm: height,
                                              weightInKg: weight,
                                            );

                                            // Adding the new data into the Hive box
                                            Hive.box<BmiRecord>(BoxNames.bmiBox)
                                                .add(bmiRecord);

                                            // Updating our provider to update the UI to display our latest BMI (so we do not have to use setState)
                                            ref
                                                .read(
                                                    latestRecordProvider.state)
                                                .state = bmiRecord;

                                            // Closes the current screen
                                            Navigator.pop(context);
                                          },
                                          buttonText: 'Calculate',
                                        );
                                      },
                                    ),
                                    CustomButton(
                                        backgroundColor: Colors.red,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonText: 'Cancel'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
            },
            child: const Icon(Icons.add)),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) => changePage(value),
          items: const [
            BottomNavigationBarItem(
              label: 'Statistics',
              icon: Icon(Icons.bar_chart),
            ),
            BottomNavigationBarItem(
              label: 'Records',
              icon: Icon(Icons.list_alt_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page1 extends StatelessWidget {
  const _Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const ProfileCard(),
        const SizedBox(
          height: 20,
        ),
        RecordCard(
          provider: latestRecordProvider,
        ),
      ],
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
        valueListenable: Hive.box<BmiRecord>(BoxNames.bmiBox).listenable(),
        builder: (context, Box<BmiRecord> box, _) {
          if (box.isEmpty) {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'No BMI data yet!\n\n Add one now?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final bmiRecords = box.values.toList();

            // We have to set a constraint for the list view because the parent widget is scrollable (i.e. SingLeChildScrollView is a parent)
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                itemCount: bmiRecords.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemBuilder: ((context, index) {
                  // Getting the values right and populate the list tile with them
                  final bmiRecord = bmiRecords[index];
                  final bmiValue = bmiRecord.bmi;
                  final bodyHeight = bmiRecord.heightInCm;
                  final bodyWeight = bmiRecord.weightInKg;
                  final bmiCategoryName = bmiRecord.bmiCategory.keys.first;
                  final bmiCategoryColor = bmiRecord.bmiCategory.values.first;

                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      'BMI: $bmiValue',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Height  : $bodyHeight cm'),
                        Text('Width   : $bodyWeight kg'),
                      ],
                    ),
                    trailing: SizedBox(
                      width: width * 0.35,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: bmiCategoryColor,
                              child: Center(
                                  child: Text(
                                bmiCategoryName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Deleting Record'),
                                        content: const Text(
                                            'Are you sure you want to delete this record?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              bmiRecord.delete();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }
        });
  }
}
