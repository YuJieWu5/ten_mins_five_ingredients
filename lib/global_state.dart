import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  bool isLogin;

  GlobalState(): isLogin = false;
}