import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'auth.dart';
import 'login_page.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final _formKey=GlobalKey<FormState>();//it checks all the form elements
  late String email;
  late String password;
  bool showSpinner=false;

  Future<void> signUpWithEmailAndPassword(context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()){
      setState(() {
        showSpinner = true;
      });
      try {
        await Auth().createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user!= null) {
            _navigateToHome(user);
          }
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${e.message}")
        ));
      }
      setState(() {
        showSpinner=false;
      });
    }

  }

  Future<void> _navigateToHome(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'name': usernameController.text.trim(),
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;//the width of the screen
    double h=MediaQuery.of(context).size.height;//the height of the screen
    return Scaffold(
      backgroundColor: Color(0xFFC9EEFF),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: w,
              height: h*0.1,
              decoration: BoxDecoration(
                  color:  Color(0xFFC9EEFF),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35)
                  ),
                  image: DecorationImage(
                      image: AssetImage(
                          "img/dia_pic2.jpg"
                      ),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20,top:20,right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign Up",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w400),
                  ),
                  Text("Let’s create a new account!",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  SizedBox(height: 40,),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8,right: 8,top: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(207, 0, 26, 95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color.fromARGB(255, 32, 104, 134),width: 8)
              ),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Container(//text fields container
                    margin: EdgeInsets.only(left: 20,top:20,right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 3),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 185, 243, 252),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(255, 185, 243, 252).withOpacity(0.5),
                                )
                              ],
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Enter a valid username";
                                } else if (value != null && value.length < 3) {
                                  return "Username should be at least 5 characters";
                                }
                              },
                              controller: usernameController, // Create a controller for username
                              cursorColor: Colors.white,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color.fromARGB(252, 2, 1, 91),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(252, 2, 1, 91),
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(252, 2, 1, 91),
                                    width: 1,
                                  ),
                                ),
                                labelText: "Enter Your Username",
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(252, 2, 1, 91),
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 185, 243, 252),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          Text("Email",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(height: 3,),
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 185, 243, 252),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow:[
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    offset: Offset(1,1),
                                    color: Color.fromARGB(255, 185, 243, 252).withOpacity(0.5),
                                  )
                                ]
                            ),
                            child: TextFormField(
                              validator: (value){
                                if(value!= null && (!EmailValidator.validate(value) || value.isEmpty)){
                                  return "enter valid email";
                                }
                              },
                              cursorColor: Colors.white,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color.fromARGB(252, 2, 1, 91),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Color.fromARGB(252, 2, 1, 91),width: 2)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Color.fromARGB(252, 2, 1, 91),width: 1)
                                  ),

                                  labelText: "Enter Your Email",
                                  labelStyle: TextStyle(color:  Color.fromARGB(252, 2, 1, 91),fontWeight: FontWeight.w500),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 185, 243, 252)
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Password",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(height: 3,),
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 185, 243, 252),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow:[
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 7,
                                    offset: Offset(1,1),
                                    color: Color.fromARGB(255, 185, 243, 252).withOpacity(0.5),
                                  )
                                ]
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value){
                                if(value!=null && value.isEmpty){
                                  return "enter valid password";
                                }
                                else if(value!=null && value.length<6){
                                  return "password should be more than 6 characters";
                                }
                              },
                              controller: passwordController,
                              cursorColor: Colors.white,
                              obscureText: true,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Color.fromARGB(252, 2, 1, 91),width: 2)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Color.fromARGB(252, 2, 1, 91),width: 1)
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(252, 2, 1, 91),
                                  ),
                                  labelText: "Enter Your Password",
                                  labelStyle: TextStyle(color: Color.fromARGB(252, 2, 1, 91),fontWeight: FontWeight.w500),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 185, 243, 252)

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 50,),
                        ElevatedButton(
                            onPressed: () {
                              signUpWithEmailAndPassword(context);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color.fromARGB(252, 2, 1, 91),Color.fromARGB(255, 87, 169, 182)],begin: Alignment.topLeft),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                width: 250,
                                height: 43,
                                alignment: Alignment.center,
                                child: const Text('Sign up',
                                  style: const TextStyle(fontSize: 24, color: Colors.white),
                                ),
                              ),
                            )
                        ),
                        SizedBox(height:10),
                        SizedBox(height:10),
                        SizedBox(height: 45,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.white),
                            ),
                            InkWell(
                              child: Text("Sign in",style: TextStyle(color: Color.fromARGB(255, 87, 169, 182)),),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                              focusColor: Color.fromARGB(255, 87, 169, 182),

                            )

                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            )


          ],
        ),
      ),

    );
  }
}
