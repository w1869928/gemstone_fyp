import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Widgets/app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title: 'Home',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gemstone Type', style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: gemstoneType,
                            onChanged: (value){
                              setState(() {
                                gemstoneType = value;
                              });
                            },
                            items: gemstoneTypes.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Enter gemstone type')
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Color', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedColor,
                          onChanged: (value){
                            setState(() {
                              selectedColor = value;
                            });
                          },
                          items: colors.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Select color')
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Carat', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 172, // Set a fixed width for the TextField
                          child: TextField(
                            controller: item2Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Carat(Weight)',
                            ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Clarity', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedClarity,
                          onChanged: (value){
                            setState(() {
                              selectedClarity = value;
                            });
                          },
                          items: clarity.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Select clarity')
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hardness', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: selectedHardness,
                          onChanged: (value){
                            setState(() {
                              selectedHardness = value;
                            });
                          },
                          items: hardness.map((option) {
                            return DropdownMenuItem<int>(
                              value: option,
                              child: Text("$option"),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Select hardness')
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Shape', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedCut,
                          onChanged: (value){
                            setState(() {
                              selectedCut = value;
                            });
                          },
                          items: cuts.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Select Shape')
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Treatment', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedTreatment,
                          onChanged: (value){
                            setState(() {
                              selectedTreatment = value;
                            });
                          },
                          items: treatment.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Select treatment')
                          ),
                        ),
                      ],
                    ),
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
              )

            ],
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
    });
  }

  Future<void> _predictPrice() async {
    if (gemstoneType == null || selectedColor == null || selectedClarity == null ||
        selectedCut == null || selectedTreatment == null || selectedHardness == null ||
        item2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all fields"))
      );
      return;
    }

    Map<String, dynamic> gemstoneData = {
      "Type": gemstoneType,
      "Color": selectedColor,
      "Clarity": selectedClarity,
      "Cut": selectedCut,
      "Treatment": selectedTreatment,
      "Hardness": selectedHardness,
      "Carat": double.tryParse(item2Controller.text) ?? 0.0,
    };
    addGemstoneDetails(gemstoneData);
    double? price = await getPredictedPrice(gemstoneData);


    if(price != null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Predicted Price: \$${price.toStringAsFixed(2)}"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get prediction")),
      );
    }
  }
  Future<double?> getPredictedPrice(Map<String, dynamic> gemstoneData) async {
    final url = Uri.parse("http://192.168.8.129:5002/predict"); // Use your server IP
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
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
        "price": 5000.25
      });
      print("successfully added");
    } catch (e) {
      print("Getting error $e");
    }
  }
}