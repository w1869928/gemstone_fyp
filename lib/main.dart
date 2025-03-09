import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/HomePage.dart';
import 'package:gemstone_fyp/login_page.dart';
import 'package:gemstone_fyp/signup_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>( //Listens to the Firebase authentication state in real time.
        stream: FirebaseAuth.instance.authStateChanges(),//real-time stream of the authentication state.
        builder: (context,snapshot){
          if(snapshot.hasData){//checks if a user is logged in.
            return SignupPage();
          }else{
            return LoginPage();
          }
        },
      ),
    );
  }
}


