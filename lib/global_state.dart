import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  bool _isLoginStatus;

  GlobalState(this._isLoginStatus);

  bool getLoginStatus(){
    return _isLoginStatus;
  }

  void setLoginStatus(bool status){
    _isLoginStatus = status;
    notifyListeners();
  }
}