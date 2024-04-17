
import 'package:crud/add_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyApgmHeCodDIwrJKBGcg61J_d1vLTZQNE8",
          appId: "1:249618576219:android:15078bd649b9c5935c207e",
          messagingSenderId: "249618576219",
          projectId: "crud-35bda")
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const AddPostScreen(),
    );
  }
}

