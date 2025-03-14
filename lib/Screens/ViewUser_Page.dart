// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nummlk/blocs/Item/item_bloc.dart';
// import 'package:nummlk/theme/color_palette.dart';
// import 'package:nummlk/widgets/appbar.dart';
//
// import '../Themes/color_palette.dart';
//
// class ViewUser extends StatefulWidget {
//   final String? userId;
//   final bool? isUser;
//
//   const ViewUser({
//     this.userId,
//     this.isUser = false,
//     super.key,
//   });
//
//   @override
//   State<ViewUser> createState() => _ViewUserState();
// }
//
// class _ViewUserState extends State<ViewUser> {
//   @override
//   void initState() {
//     super.initState();
//     final itemBloc = BlocProvider.of<ItemBloc>(context);
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (widget.isUser != null && widget.isUser! && user != null) {
//       itemBloc.add(GetUserById(user.uid));
//     } else {
//       itemBloc.add(GetUserById(widget.userId ?? 'a'));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'User',
//         showBackButton: true,
//       ),
//       body: BlocBuilder<ItemBloc, ItemState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state.isError || state.user == null) {
//             return Center(
//               child: Text(
//                 state.message ?? 'Failed to load user details.',
//                 style: const TextStyle(color: Colors.red, fontSize: 14),
//               ),
//             );
//           }
//
//           final user = state.user!;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Email: ${user.email}',
//                   style: TextStyle(
//                       fontSize: 16, color: ColorPalette.mainGray[500]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Role: ${user.role}',
//                   style: TextStyle(
//                       fontSize: 16, color: ColorPalette.mainGray[500]),
//                 ),
//                 const Divider(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Items Processed: ${user.itemsProcessed}',
//                       style: TextStyle(
//                           fontSize: 16, color: ColorPalette.mainGray[500]),
//                     ),
//                     Text(
//                       'Order Deals: ${user.orderCount}',
//                       style: TextStyle(
//                           fontSize: 16, color: ColorPalette.mainGray[500]),
//                     ),
//                   ],
//                 ),
//                 const Divider(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Last Login: ${user.lastLogin.toString().split(' ')[0]} ${user.lastLogin.toString().split(' ')[1].split('.')[0]}',
//                       style: TextStyle(
//                           fontSize: 14, color: ColorPalette.mainGray[500]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Themes/color_palette.dart';
import '../Widgets/custom_toast.dart';
import '../Widgets/primary_button.dart';
import '../Widgets/primary_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loginWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _navigateToHome(userCredential.user!);
    } catch (e) {
      _showError("Login failed: $e");
    }
  }

  Future<void> _registerWithEmailPassword() async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email ?? '',
      });

      await _navigateToHome(userCredential.user!);
    } catch (e) {
      _showError("Registration failed: $e");
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      await _navigateToHome(userCredential.user!);
    } catch (e) {
      _showError("Google Sign-In failed: $e");
    }
  }

  Future<void> _navigateToHome(User user) async {
    final userDoc = _firestore.collection('Users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'id': user.uid,
        'email': user.email ?? '',
        'lastLogin': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    } else {
      await userDoc.update({
        'lastLogin': DateTime.now().toIso8601String(),
      });
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showError("Please enter your email address to reset your password.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      CustomToast.error(
        "Password reset email has been sent. Please check your inbox.",
        bgColor: Colors.green,
      );
    } catch (e) {
      _showError("Password reset failed: $e");
    }
  }

  void _showError(String message) {
    CustomToast.error(
      message,
      bgColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(
                height: 200,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: ColorPalette.primaryBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 80),
                                PrimaryTextfield(
                                  hintText: "Email",
                                  backgroundColor: ColorPalette.mainBlue[100]!,
                                  borderColor: ColorPalette.white,
                                  controller: _emailController,
                                ),
                                const SizedBox(height: 20),
                                PrimaryTextfield(
                                  hintText: "Password",
                                  backgroundColor: ColorPalette.mainBlue[100]!,
                                  borderColor: ColorPalette.white,
                                  controller: _passwordController,
                                  obscureText: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              children: [
                                PrimaryButton(
                                  text: "Log In",
                                  onPressed: _loginWithEmailPassword,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                  text: "Register",
                                  onPressed: _registerWithEmailPassword,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                  text: "Sign in with Google",
                                  icon: 'assets/icons/google.png',
                                  onPressed: _loginWithGoogle,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}


// class _FoodSummaryState extends State<FoodSummary> {
//   final firestore = FirebaseFirestore.instance;
//   final _auth2 = FirebaseAuth.instance;
//   List<FoodEntity> entities = [];
//
//   Future<void> getFoodHistory() async {
//     final QuerySnapshot result = await FirebaseFirestore
//         .instance // it perform operations on the documents returned by a query to a collection or sub collection.
//         .collection('FoodSummary')
//         .where('user', isEqualTo: _auth2.currentUser?.email)
//         .get();
//     final List<DocumentSnapshot> documents = result.docs;
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${documents.length}")));
//     // for(int i=0;i<documents.length;i++){
//     //
//     // }
//     documents.forEach((document) {
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("working1")));
//       Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
//       if (data != null) {
//         String date = data['date'];
//         String time = data['time'];
//         double carbs = data['carbs'].toDouble();
//         double protein = data['protein'].toDouble();
//         double fats = data['fats'].toDouble();
//         double fiber = data['fiber'].toDouble();
//         double bebgl = data['bebgl'].toDouble();
//         double afbgl =
//         double.parse(data['afbgl'].toDouble().toStringAsFixed(2));
//         double calories = data['calories'].toDouble();
//
//         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("working2")));
//         entities.add(FoodEntity(
//             time: time,
//             date: date,
//             carbs: carbs,
//             protein: protein,
//             fiber: fiber,
//             fats: fats,
//             calories: calories,
//             bglBefore: bebgl,
//             bglAfter: afbgl));
//         setState(() {});
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("working3")));
//       }
//
//       // Do something with the field value
//     });
//   }
//
//   void addFoods() {
//     firestore.collection("FoodSummary").add({
//       'afbgl': 100.8,
//       'bebgl': 90.7,
//       'carbs': 10.9,
//       'protein': 15.7,
//       'fats': 40,
//       'calories': 20,
//       'fiber': 80,
//       'date': "2023-08-09",
//       'time': "01:08",
//       'user': "kavee@gmail.com"
//     });
//   }
//
//   void getCurrentUser() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       //we are using authStateChanges bcs FireBaseauth.instance.currentUser doesnt availabe for immediately when sign in with google
//       //but FireBaseauth.instance.currentUser fine when sign in using email and password instead of google sign in
//       if (user != null) {
//         // In this code User is signed in, you can access the user object via `currentUser` or `user` parameter.
//         final user = _auth2.currentUser; //it will null if anyone not signed in
//         print(user!.email);
//         print('User is signed in!');
//       } else {
//         // User is signed out.
//         print('User is signed out!');
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     // addFoods();
//     getFoodHistory();
//   }

// firestore.collection("FoodSummary").add({
// 'afbgl': double.parse(predValue),
// 'bebgl': currentBGL,
// 'carbs': totalCarbAmount,
// 'protein': totalProteinAmount,
// 'fats': totalFatAmount,
// 'calories': totalCalorieAmount,
// 'fiber': totalFiberAmount,
// 'date': currentDate,
// 'time': currentTime,
// 'user': _auth2.currentUser?.email
// });