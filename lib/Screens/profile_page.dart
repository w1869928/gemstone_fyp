import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Screens/auth.dart';
import 'package:gemstone_fyp/Themes/color_palette.dart';
import 'package:gemstone_fyp/Widgets/app_bar.dart';
import 'package:gemstone_fyp/Widgets/custom_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isFetching = true;
    });
    User? user = firebaseAuth.currentUser;
    if (user != null){
      DocumentSnapshot userDoc = await fireStore.collection('Users').doc(user.uid).get();
      if (userDoc.exists){
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    }
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorPalette.mainBlue[400]!,
              ColorPalette.mainBlue[300]!,
              ColorPalette.mainBlue[200]!,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft
          )
        ),
        child: userData == null
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(label: 'Name', value: '${userData!['name']}', fontSize: 20, fontFamily: 'Pacifico',),
              SizedBox(height: 10),
              CustomText(label: 'Email', value: '${userData!['email']}', fontSize: 20, fontFamily: 'Pacifico',),
              SizedBox(height: 10),
              CustomText(label: 'Last Login', value: '${userData!['lastLogin']}', fontSize: 20, fontFamily: 'Pacifico',),
              SizedBox(height: 10),
              CustomText(label: 'Created At', value: '${userData!['createdAt']}', fontSize: 20, fontFamily: 'Pacifico',),
            ],
          ),
        ),
      ),
    );
  }
}
