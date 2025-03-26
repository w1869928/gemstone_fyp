import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Themes/color_palette.dart';
import 'package:gemstone_fyp/Widgets/custom_dropdown.dart';
import 'package:gemstone_fyp/Widgets/custom_toast.dart';
import 'package:gemstone_fyp/Widgets/home_custom_textField.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/app_bar.dart';
import '../Widgets/image_icon_builder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fireStoreInstance = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final TextEditingController item2Controller = TextEditingController();
  final List<String> gemstoneTypes  = ['Sapphire', 'Ruby', 'Tomalin', 'Chrysoberyl', 'Alexandrite', 'Spinel'];
  String? gemstoneType;
  final List<int> hardness = List.generate(10, (index) => index + 1);
  int? selectedHardness;
  final List<String> colors  = ['Blue', 'Red', 'Yellow', 'Brown', 'Teal', 'Orange', 'Green', 'Pink', 'Purple'];
  String? selectedColor;
  final List<String> cuts  = ['Octagon', 'Oval', 'Round', 'Square', 'Cushion'];
  String? selectedCut;
  final List<String> clarity  = ['VVS1', 'VVS2', 'VS1', 'VS2', 'SI'];
  String? selectedClarity;
  final List<String> treatment  = ['Heated', 'Not Heated'];
  String? selectedTreatment;
  String? predictedPrice;
  Map<String, dynamic>? data;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title: 'Home',
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomDropdownField(
                          label: 'Gemstone Type',
                          hint: 'Select type',
                          items: gemstoneTypes,
                          selectedValue: gemstoneType,
                          onChanged: (value) {
                            setState(() {
                              gemstoneType = value;
                            });
                          },
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CustomDropdownField(
                        label: 'Color',
                        hint: 'Select color',
                        items: colors,
                        selectedValue: selectedColor,
                        onChanged: (value) {
                          setState(() {
                            selectedColor = value;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomTextField(label: 'Carat', hint: 'Enter Carat', controller: item2Controller)
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CustomDropdownField(
                        label: 'Clarity',
                        hint: 'Select clarity',
                        items: clarity,
                        selectedValue: selectedClarity,
                        onChanged: (value) {
                          setState(() {
                            selectedClarity = value;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hardness', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              value: selectedHardness,
                              onChanged: (value){
                                setState(() {
                                  selectedHardness = value;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: ColorPalette.mainBlue[8]!,
                              ),
                              dropdownColor: ColorPalette.mainGray[6]!,
                              items: hardness.map((option) {
                                return DropdownMenuItem<int>(
                                  value: option,
                                  child: Text("$option", style: TextStyle(color: ColorPalette.mainBlue[8]!, fontWeight: FontWeight.bold)),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                  fillColor: ColorPalette.mainGray[8],
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:  BorderSide(color: ColorPalette.mainBlue[8]!,width: 2),
                                  ), focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: ColorPalette.mainBlue[7]!,width: 2),
                              ),
                                  label: Text('Select hardness', style: TextStyle(color: ColorPalette.mainBlue[8]!, fontWeight: FontWeight.bold, fontSize: 15),),
                                  prefixIcon: ImageIconBuilder(
                                    image: 'assets/icons/gem-outline.png',
                                    iconColor: ColorPalette.mainBlue[8]!,
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CustomDropdownField(
                        label: 'Shape',
                        hint: 'Select shape',
                        items: cuts,
                        selectedValue: selectedCut,
                        onChanged: (value) {
                          setState(() {
                            selectedCut = value;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomDropdownField(
                        label: 'Treatment',
                        hint: 'Select treatment',
                        items: treatment,
                        selectedValue: selectedTreatment,
                        onChanged: (value) {
                          setState(() {
                            selectedTreatment = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: _clearFields,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                          ),
                          child: const Text("Clear Fields", style: TextStyle(color: Colors.white),)
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _predictPrice,
                        child: const Text("Predict Price"),
                      ),
                    ],
                  ),
                  predictedPrice != null ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: ColorPalette.mainGray[8]!,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1)
                    ),
                    child: Text("Price in LKR: ${predictedPrice!}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPalette.mainBlue[8]!),
                    )
                  ) : SizedBox(),

                  predictedPrice != null ?
                  ElevatedButton(
                    onPressed: () => addGemstoneDetails(data!),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, color: Colors.white), // Heart Icon
                        const SizedBox(width: 8),
                        Text("Add to Favourites", style: TextStyle(color: Colors.white, fontSize: 20 ,fontWeight: FontWeight.bold)),
                      ],
                    )
                  ) : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _clearFields() {
    setState(() {
      gemstoneType = null;
      selectedColor = null;
      selectedCut = null;
      selectedClarity = null;
      selectedTreatment = null;
      selectedHardness = null;
      item2Controller.clear(); // Clears the Carat input field
      predictedPrice = null;
    });
  }

  Future<void> _predictPrice() async {
    if (gemstoneType == null || selectedColor == null || selectedClarity == null ||
        selectedCut == null || selectedTreatment == null || selectedHardness == null ||
        item2Controller.text.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text())
      // );
      CustomToast.error("Please fill in all fields");
      return;
    }
    setState(() {
      showSpinner = true;
    });
    Map<String, dynamic> gemstoneData = {
      "Type": gemstoneType,
      "Color": selectedColor,
      "Clarity": selectedClarity,
      "Cut": selectedCut,
      "Treatment": selectedTreatment,
      "Hardness": selectedHardness,
      "Carat": double.tryParse(item2Controller.text) ?? 0.0,
    };
    double? price = await getPredictedPrice(gemstoneData);

    setState(() {
      predictedPrice = price != null ? price.toStringAsFixed(2) : "Prediction Failed";
      data = gemstoneData;
      showSpinner = false;
    });

    // if(price != null){
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Predicted Price: \$${price.toStringAsFixed(2)}"))
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Failed to get prediction")),
    //   );
    // }
  }
  Future<double?> getPredictedPrice(Map<String, dynamic> gemstoneData) async {
    final url = Uri.parse("https://gemstone-model.onrender.com/predict"); // Use your server IP
    String key = "production";
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "FLASK_ENV" : key
        },
        body: jsonEncode(gemstoneData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["predicted_price"];
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  void addGemstoneDetails(Map<String, dynamic> gemstoneData){
    try {
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      fireStoreInstance.collection("Gemstone").add({
        "Type": gemstoneData["Type"],
        "Color": gemstoneData["Color"],
        "Clarity": gemstoneData["Clarity"],
        "Cut": gemstoneData["Cut"],
        "Treatment": gemstoneData["Treatment"],
        "Hardness": gemstoneData["Hardness"],
        "Carat": gemstoneData["Carat"],
        "date": currentDate,
        "user": auth.currentUser!.email,
        "price": double.tryParse(predictedPrice.toString())
      });
      CustomToast.success("successfully added");
      print("successfully added");
    } catch (e) {
      print("Getting error $e");
    }
  }
}