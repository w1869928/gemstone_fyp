import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Screens/HomePage.dart';
import 'package:gemstone_fyp/Screens/signup_page.dart';
import 'package:gemstone_fyp/routes.dart';
import 'Screens/Layout_Page.dart';
import 'Screens/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter(); // Creating AppRouter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appRouter.onGenerateRoute, // Use AppRouter for navigation
      home: AuthWrapper(), // Wrapper to decide home screen
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const LayoutScreen(pageIndex: 0); // If user is logged in, go to home
        } else {
          return const LoginPage(); // If not, go to login page
        }
      },
    );
  }
}


