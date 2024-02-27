import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../global_state.dart';
import 'package:firebase_database/firebase_database.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref();
  String? invalidUser;

  void _onLoginPressed() async{
    if(_formKey.currentState?.validate() ?? false) {
      //TODO: verify account info

      final snapshot = await ref.child('users/').get();
      if (snapshot.exists) {
        String dataString = jsonEncode(snapshot.value);
        print("Data String: $dataString");
        Map dataMap = jsonDecode(dataString);
        bool hasUser = _containsUser(dataMap, _userNameController.text, int.parse(_passwordController.text));
        if(hasUser){
          GoRouter.of(context).push('/');
          context.read<GlobalState>().setLoginStatus(true);
        }else{
         setState(() {
           invalidUser = "User name not found or Incorrect password";
         });
        }
      } else {
        print('No data available.');
      }
    }
  }

  bool _containsUser(Map data, String name, int password) {
    // Iterate through all values in the data map
    for (var user in data.values) {
      // Check if any user matches the name and password
      if (user['name'] == name && user['password'] == password) {
        return true; // Match found
      }
    }
    return false; // No match found
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
              onTap: (){
                GoRouter.of(context).pop();
              }
          ),
          title: Center(
              child: Text('Log In', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Center(
                              child: SizedBox(
                                  width: 400.0,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Username'
                                    ),
                                    controller: _userNameController,
                                    validator: (newValue) {
                                      if(newValue == null || newValue.isEmpty) {
                                        return 'Username must not be blank.';
                                      }
                                      return null;
                                    },
                                  )
                              )
                          )
                      ),
                      SizedBox(
                        width: 400.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password'
                          ),
                          controller: _passwordController,
                          validator: (newValue) {
                            if(newValue == null || newValue.isEmpty) {
                              return 'Password must not be blank.';
                            }
                            return null;
                          },
                        ),
                      ),
                      invalidUser != null
                          ? Text(invalidUser!, style: const TextStyle(color: Colors.red, fontSize: 12))
                          : Container(),
                      Container(
                          margin: const EdgeInsets.only(top:20.0),
                          child: ElevatedButton(
                            // Note: we are not calling _onSavePressed! We are passing it
                            // like an object to this other widget as a constructor arg.
                              onPressed: _onLoginPressed,
                              child: const Text('Log In')
                          )
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: ()=> GoRouter.of(context).push('/signup'),
                        child: const Text('Create Account'),
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}
