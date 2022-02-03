// ignore_for_file: sized_box_for_whitespace

import 'package:Fuligo/screens/cancel_tour.dart';
import 'package:Fuligo/screens/tour_another.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:Fuligo/widgets/custom_button.dart';
import 'package:Fuligo/widgets/image_detail.dart';
import 'package:Fuligo/widgets/subtxt.dart';

// import 'package:Fuligo/screens/tours.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  RouteScreenState createState() => RouteScreenState();
}

class RouteScreenState extends State<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Container(
      decoration: bgDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text('TEST'),
        // ),
        body: Stack(
          children: [
            Container(
                width: mq.width,
                height: mq.height,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: mq.height * 0.17,
                    ),
                    TextHeaderTest(
                      context,
                      "RouteScreen",
                      "Would you like to be taken there?",
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: CancelButtonTest(
                          context, const TourAnother(), "Show directions"),
                    )
                  ],
                )),
            ClearRoundButton(context, mq.width / 2 - 40),
          ],
        ),
      ),
    );
  }
}
