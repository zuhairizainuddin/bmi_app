import 'package:bmi_app/constants/box_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/bmi_record.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sets up the directory where we will save our data
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  // Initializating our persistent databasa (NoSQL) within the directory path
  await Hive.initFlutter(appDocumentDirectory.path);

  // Registering our adapter, so all our data in db can be mapped correctly into our model class
  Hive.registerAdapter(BmiRecordAdapter());

  // Opening the Hive box, allowing us to manipulate the data inside it
  await Hive.openBox<BmiRecord>(BoxNames.bmiBox);

  // Then, we run the app
  runApp(const ProviderScope(child: BmiApp()));
}

class BmiApp extends StatelessWidget {
  const BmiApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Mass Index',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.karla(
            fontSize: 12,
          ),
          bodyLarge: GoogleFonts.karla(fontSize: 14),
        ),
        primarySwatch: Colors.purple,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.heebo(
              color: Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            )),
      ),
      home: const HomeScreen(),
    );
  }
}
