import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Screens/auth.dart';
import 'package:gemstone_fyp/Widgets/app_bar.dart';
import 'package:gemstone_fyp/Widgets/custom_alert.dart';
import 'package:gemstone_fyp/Widgets/select_card.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'More',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              SelectCard(
                  title: 'Profile',
                  isBordered: true,
                  icon: 'assets/icons/user.png',
                  onTap: (){}),
              SizedBox(
                height: 15,
              ),
              SelectCard(
                  title: 'Logout',
                  isBordered: true,
                  icon: 'assets/icons/logout.png',
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return CustomAlert(
                          title: 'Confirm Logout',
                          iconPath: 'assets/icons/logout.png',
                          message: 'Are you sure you want to log out? You will need to sign in again to access your account.',
                          onConfirm: (){
                            Auth().signOut(context);
                          }
                        );
                      }
                    );
                  }),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
