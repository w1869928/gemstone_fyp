import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Entity/gemstone_card.dart';
import 'package:gemstone_fyp/Entity/gemstone_entity.dart';
import 'package:gemstone_fyp/Themes/color_palette.dart';
import 'package:gemstone_fyp/Widgets/app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => FavouritesPageState();
}


class FavouritesPageState extends State<FavouritesPage> {
   FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
   FirebaseAuth auth = FirebaseAuth.instance;
  List<GemstoneEntity> gemstones = [];
  bool showSpinner = false;

  @override
  void initState(){
    super.initState();
    getGemstones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favourites',
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorPalette.mainBlue[7]!, ColorPalette.mainBlue[8]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: ListView.builder(
            itemBuilder: (context, index){
              return GemstoneCard(
                entity: gemstones[index],
                onDelete: () => deleteGemstone(gemstones[index].id)
              );
            },
            itemCount: gemstones.length,
          ),
        ),
      ),
    );
  }

  Future<void> deleteGemstone(String id) async{
    await fireStoreInstance.collection('Gemstone').doc(id).delete();
    setState(() {
      gemstones.removeWhere((gemstone) => gemstone.id == id);
    });
  }

  Future<void> getGemstones() async{
    setState(() {
      showSpinner = true;
    });
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Gemstone')
        .where('user', isEqualTo: auth.currentUser!.email)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    documents.forEach((document){
      //Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      gemstones.add(
        GemstoneEntity(
          id: document.id,
          type: document["Type"],
          hardness: document["Hardness"],
          color: document["Color"],
          cut: document["Cut"],
          clarity: document["Clarity"],
          treatment: document["Treatment"],
          carat: document["Carat"],
          user: document["user"],
          date: document["date"],
          price: document["price"])
      );
    });

    gemstones.sort((a, b){
      DateTime dateA = DateTime.parse(a.date);
      DateTime dateB = DateTime.parse(b.date);

      int dateComparison = dateB.compareTo(dateA);
      if (dateComparison != 0) {
        return dateComparison;
      }

      return a.type.compareTo(b.type);// If dates are the same sort by type
    });

    setState(() {
      showSpinner = false;
    });


    print('size of the list is ${gemstones.length}');
  }
}
