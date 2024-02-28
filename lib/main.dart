import 'package:flutter/material.dart';
import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interlinearplus/auth/main_page.dart'; 
import 'package:interlinearplus/firebase_options.dart'; 

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
 
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform, 
  );  
  runApp(const MyApp()); 
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
