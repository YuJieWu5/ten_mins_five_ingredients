import 'package:flutter/material.dart';
import 'homepage_bottom_action_bar.dart';
import 'homepage_carousel_with_indicator.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '10mins5ingredients',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            // Use the CarouselWithIndicator widget
            child: CarouselWithIndicator(),
          ),
          BottomActionBar(),
        ],
      ),
    );
  }
}