import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_mins_five_ingredients/core/models/global_state.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<GlobalState>().auth;
      setState(() => _isLoading = true);
      try {
        final credential =
            await auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        final userId = auth.currentUser!.uid.toString();
        context.read<GlobalState>().setUserId(userId);
        context.read<GlobalState>().setLoginStatus(true);

        final database = context.read<GlobalState>().database;
        final snapshot = await database.ref().child('users/').get();
        if (snapshot.exists) {
          String dataString = jsonEncode(snapshot.value);
          Map dataMap = jsonDecode(dataString);

          for (var user in dataMap.entries) {
            // Check if any user matches the name and password
            var id = user.key;
            var info = user.value;
            if (id == userId) {
              context.read<GlobalState>().setSaveList(info['favorite']);
            }
          }
        }
        context.go('/');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'invalid-credential') {
          _errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Invalid email address.';
        }
        setState(() => _isLoading = false);
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(
                constraints:
                    BoxConstraints(maxWidth: 600), // Max width for the form
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                        onSaved: (value) => _email = value!,
                        onChanged: (value) => _email = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                        onSaved: (value) => _password = value!,
                        onChanged: (value) => _password = value,
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_errorMessage,
                              style: TextStyle(color: Colors.red)),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () => _signInWithEmailAndPassword(context),
                          child: Text('Sign In'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/signup'),
                        child: Text('Don\'t have an account? Sign up.'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
