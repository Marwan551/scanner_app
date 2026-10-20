import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/providers/scanner_provider.dart';
import 'package:scanner_app/screens/scan_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScannerProvider(),
      child: MaterialApp(
        title: 'Multi-Scanner App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ScanScreen(),
      ),
    );
  }
}
