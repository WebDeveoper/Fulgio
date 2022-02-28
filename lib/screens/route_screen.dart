// ignore_for_file: sized_box_for_whitespace

import 'package:Fuligo/screens/tours/tour_another.dart';
import 'package:Fuligo/widgets/clear_button.dart';
import 'package:flutter/material.dart';

import 'package:Fuligo/utils/common_colors.dart';
import 'package:Fuligo/widgets/text_header.dart';
import 'package:Fuligo/widgets/custom_button.dart';

// import 'package:Fuligo/screens/tours.dart';

class RouteScreen extends StatefulWidget {
  Map infodata;
  RouteScreen({Key? key, required this.infodata}) : super(key: key);

  @override
  RouteScreenState createState() => RouteScreenState();
}

class RouteScreenState extends State<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    Map infodata = widget.infodata;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(infodata["image"]), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text('TEST'),
        // ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(color: aboveColor.withOpacity(0.8)),
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
                    PageHeader(
                      context,
                      "Route",
                      "Would you like to be taken there?",
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: CancelButton(
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
