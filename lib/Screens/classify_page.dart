import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Widgets/app_bar.dart';
import 'package:gemstone_fyp/Widgets/custom_toast.dart';
import 'package:image_picker/image_picker.dart';

import '../Themes/color_palette.dart';
import '../Widgets/primary_button.dart';

class ClassifyPage extends StatefulWidget {
  const ClassifyPage({super.key});

  @override
  State<ClassifyPage> createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> {
  File? _selectedImage;

  Future<void> _pickImageFromGallery() async{
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      CustomToast.success("Photo uploaded successfully");
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      CustomToast.success("Photo uploaded successfully");
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Classify",),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorPalette.mainBlue[7]!, ColorPalette.mainBlue[8]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text("Upload your gemstone to \n identify the type",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 20),
              _selectedImage != null ?
                  Image.file(_selectedImage!, width: 200, height: 200, fit: BoxFit.cover,)
              :  Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 2)
                ),
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              _selectedImage == null ?
              Column(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    icon: Icon(Icons.photo, color: Colors.white),
                    label: Text(
                      "Choose from Gallery",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "or",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextButton.icon(
                    onPressed: () {
                      _captureImageFromCamera();
                    },
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    label: Text(
                      "Capture from Camera",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.white),)
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: (){
                      CustomToast.success("This feature coming soon");
                    },
                    child: const Text("classify Gem"),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
