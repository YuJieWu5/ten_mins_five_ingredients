import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/views/User/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ten_mins_five_ingredients/views/User/log_in.dart';

main(){
  testWidgets('Test Sign Up if confirm password incorrect', (WidgetTester tester)async {
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp(
          home: SignUpPage(),
        )));

    
    await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), "test@icloud.com");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), "test");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), "123456");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), "1234567");
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('Test Sign Up if missing user name', (WidgetTester tester)async {
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp(
          home: SignUpPage(),
        )));

    await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), "test@icloud.com");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), "");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), "123456");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), "1234567");
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter a username.'), findsOneWidget);
  });

  testWidgets('Test Sign Up successfully', (WidgetTester tester)async {
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, MockFirebaseAuth());
   
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpPage();
          },
        ),
      ],
    );
   
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
     child: MaterialApp.router(
          routerConfig: _router,
        )));


    await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), "test@icloud.com");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), "abc");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), "123456");
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), "123456");
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(globalState.getLoginStatus(), true);
  });
}