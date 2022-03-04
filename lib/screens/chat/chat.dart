// ignore_for_file: sized_box_for_whitespace
import 'dart:typed_data';

import 'package:Fuligo/utils/loading.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:Fuligo/model/order_model.dart';
import 'package:Fuligo/model/user_model.dart';
import 'package:Fuligo/provider/auth_provider.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:Fuligo/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:Fuligo/widgets/custom_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  List<OrderModel> orders = [];
  List docList = [];
  List orderIds = [];
  bool loading = true;
  List<Uint8List> imageList = [];

  void initState() {
    getOrderData();
    super.initState();
  }

  Future<List<OrderModel>> getOrderData() async {
    // Get docs from collection reference
    List tempList = [];

    //Get language
    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('lang') ?? "";

    // CollectionReference _interestRef =
    //     FirebaseFirestore.instance.collection('order');
    UserModel _userInfo = AuthProvider.of(context).userModel;
    QuerySnapshot orderSnapshot =
        await FirebaseFirestore.instance.collection('order').get();
    // Get data from DocumentRefernce
    // DocumentReference docRef =
    //     FirebaseFirestore.instance.doc("city/xrIDkBvtxYjXUYLgDtnG");
    // docRef.get().then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     // print('Document exists on the database');
    //     // print(documentSnapshot.data());
    //   }
    // });

    // Get data from docs and convert map to List

    orderSnapshot.docs
        .map(
          (doc) => {
            print("11111111222222"),
            print(_userInfo.uid),
            if (doc.get('userId') ==
                "UVJ7ZRb12UVeL3YJvzAPXnA0Cem1") // UVJ7ZRb12UVeL3YJvzAPXnA0Cem1 is userInfo.uid //vVBdd7pUdjZY537PX6pT8FNCrA52
              {
                docList.add(doc.get('documents')),
                tempList.add(doc.get('city')), // refernce id
                orderIds.add(doc.reference.id),
              }
          },
        )
        .toList();

    if (tempList.isNotEmpty) {
      for (var i = 0; i < tempList.length; i++) {
        tempList[i].get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            print('Document exists on the database');
            //get image url from firebase storage
            Reference ref = FirebaseStorage.instance
                .ref()
                .child(documentSnapshot.get('image')[0]);
            String url = await ref.getDownloadURL();
            Uint8List uint8image =
                (await NetworkAssetBundle(Uri.parse(url)).load(""))
                    .buffer
                    .asUint8List();

            imageList.add(uint8image);

            String name = documentSnapshot.get('name')[lang];
            // String image = documentSnapshot.get('image')[0];
            DateTime datetime = documentSnapshot.get('updatedAt').toDate();

            Map temp = {
              "orderId": orderIds[i],
              "name": name,
              "image": url,
              "datetime": datetime,
            };
            OrderModel orderModel = OrderModel.fromJson(temp);

            orders.add(orderModel);
            setState(() {
              orders = orders;
              loading = false;
            });
          } else {}
        });
      }
    } else {
      loading = false;
    }

    // loading = false;
    setState(() {});
    return orders;
  }

  Future<String> getUrlFromFirebase(String firebaseURL) async {
    Reference ref = FirebaseStorage.instance.ref().child(firebaseURL);
    String url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    print("Start ChatItem");

    List<Widget> chatItems = [];
    for (var i = 0; i < orders.length; i++) {
      var element = orders[i];

      String date = DateFormat('MM-dd-yyyy').format(element.datetime);

      chatItems.add(
        ChatCard(context, imageList[i], element.name, date, element.orderId),
      );
    }

    var mq = MediaQuery.of(context).size;
    return Container(
      decoration: bgDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              width: mq.width,
              height: mq.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Logo,
                  PageHeader(
                    context,
                    "Chat",
                    "For which order do you need support?",
                  ),
                  !loading
                      ? chatItems.isNotEmpty
                          ? Container(
                              // decoration: BoxDecoration(color: whiteColor),
                              height: mq.height - 210,
                              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                              child: Scrollbar(
                                isAlwaysShown: true,
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  children: chatItems,
                                ),
                              ),
                            )
                          // Column(
                          //     children: chatItems,
                          //   )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mq.height * 0.2,
                                ),
                                Text(
                                  "No order data",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white30),
                                ),
                              ],
                            )
                      : Container(
                          margin: EdgeInsets.only(top: mq.height * 0.3),
                          child: kRingWidget(context),
                        )
                ],
              ),
            ),
            SecondaryButton(context),
          ],
        ),
      ),
    );
  }
}
