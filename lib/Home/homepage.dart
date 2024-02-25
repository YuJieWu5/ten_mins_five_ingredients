import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'homepage_bottom_action_bar.dart';
import 'homepage_carousel_with_indicator.dart';
import '../global_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height - 150;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          '10mins5ingredients',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          context.watch<GlobalState>().getLoginStatus()
              ? _userAvatarButton()
              : _loginButton(),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      drawer: context.watch<GlobalState>().getLoginStatus() ? _userDrawer() : null,
      body: const SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: CarouselWithIndicator(),
            ),
            SizedBox(
              height: 40,
              child: BottomActionBar(),
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return IconButton(
      icon: const Icon(Icons.login),
      onPressed: () {
        GoRouter.of(context).push('/login');
      },
    );
  }

  Widget _userAvatarButton() {
    return IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: () {
        _scaffoldKey.currentState?.openDrawer();
      },
    );
  }

  Widget _userDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF4C2C2),
            ),
            child: Text('User Menu'),
          ),
          ListTile(
            title: const Text('Saved List'),
            onTap: () {
              GoRouter.of(context).push("/recipeList");
            },
          ),
          ListTile(
            title: const Text('Created List'),
            onTap: () {
              GoRouter.of(context).push("/recipeList");
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              context.read<GlobalState>().setLoginStatus(false);
              // GoRouter.of(context).push("/login ");
            },
          ),
        ],
      ),
    );
  }
}
