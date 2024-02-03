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
      body: SingleChildScrollView(
        child:  SizedBox(
          height: 1000.0,
          child: CarouselWithIndicator(),
        ),
      ),
      // Column(
      //     children: <Widget>[
      //       Expanded(
      //         // Use the CarouselWithIndicator widget
      //         child: CarouselWithIndicator(),
      //       ),
      //     ],
      //   ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment:  OverflowBarAlignment.center,
            alignment: MainAxisAlignment.center,
            overflowSpacing: 5.0,
            children: [
              ElevatedButton(
                child: Text('Get Recipe'),
                onPressed: () {
                  // Placeholder to implement get function
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Placeholder to navigate to profile
                },
              ),
              ElevatedButton(
                child: Text('Create Recipe'),
                onPressed: () {
                  // Placeholder to implement create function
                },
              )
            ],
          )
        ),
      ),
    );
  }
}