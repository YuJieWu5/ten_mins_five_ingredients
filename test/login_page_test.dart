import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';
import 'package:ten_mins_five_ingredients/views/User/log_in.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

void main() {
  testWidgets('Login_page test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return LogInPage();
          },
        ),
      ],
    );

    final user = MockUser(
          isAnonymous: false,
          uid: 'someuid',
          email: 'bob@somedomain.com',
          displayName: 'Bob',
        );
    final auth = MockFirebaseAuth(mockUser: user);
    final globalState = GlobalState(
        false, MockFirebaseStorage(), MockFirebaseDatabase.instance, auth);
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => globalState),
        ],
        child: MaterialApp.router(
          routerConfig: _router,
        )));

    expect(find.text("Don't have an account? Sign up."), findsOneWidget);

    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);

    await tester.enterText(emailField, 'bob@somedomain.com');
    await tester.enterText(passwordField, '123456');

    await tester.pump();

    final loginButton = find.widgetWithText(ElevatedButton, 'Sign In');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);

    await tester.pump();

    expect(globalState.getLoginStatus(), true);
  });
}
