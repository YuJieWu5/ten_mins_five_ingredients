import 'package:flutter_test/flutter_test.dart';
import 'package:ten_mins_five_ingredients/views/User/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ten_mins_five_ingredients/views/User/log_in.dart';

main(){
  testWidgets('Test Sign Up if confirm password incorrect', (WidgetTester tester)async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Material(child: SignUpPage()
            )
        )
    );
    
    await tester.enterText(find.byKey(const Key('Username')), "Vivian");
    await tester.pump();
    await tester.enterText(find.byKey(const Key('Password')), "123");
    await tester.pump();
    await tester.enterText(find.byKey(const Key('ConfirmPassword')), "333");
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Passwords must be same.'), findsOneWidget);
  });

  testWidgets('Test Sign Up if missing user name', (WidgetTester tester)async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Material(child: SignUpPage()
            )
        )
    );

    await tester.enterText(find.byKey(const Key('Password')), "123");
    await tester.pump();
    await tester.enterText(find.byKey(const Key('ConfirmPassword')), "123");
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Username must not be blank.'), findsOneWidget);
  });

  testWidgets('Test Sign Up if missing password', (WidgetTester tester)async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Material(child: SignUpPage()
            )
        )
    );

    await tester.enterText(find.byKey(const Key('Username')), "Vivian");
    await tester.pump();
    await tester.enterText(find.byKey(const Key('ConfirmPassword')), "123");
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Password must not be blank.'), findsOneWidget);
  });

  testWidgets("Test navigate to Log In", (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => SignUpPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => LogInPage(),
        )
      ],
    );
    await tester.pumpWidget(
        MaterialApp.router(
            routerConfig: router
        )
    );
    
    await tester.tap(find.byType(TextButton));
    expect(find.text('Log In'), findsAny);

  });
}