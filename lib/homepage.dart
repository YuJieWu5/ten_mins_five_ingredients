import 'package:flutter/material.dart';
import 'homepage_bottom_action_bar.dart';
import 'homepage_carousel_with_indicator.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height - 130;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '10mins5ingredients',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
              children: <Widget>[
                SizedBox(
                  height: maxHeight,
                  child: CarouselWithIndicator(),
                ),
                SizedBox(
                    height: 40,
                    child: BottomActionBar(),
                )
              ],
            ),
      ),
    );
  }
}
