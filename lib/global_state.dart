import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  bool _isLoginStatus;
  CameraController? _cameraController;
  String? _userId;
  List<dynamic>? _saveList;

  GlobalState(this._isLoginStatus);

  bool getLoginStatus(){
    return _isLoginStatus;
  }

  void setLoginStatus(bool status){
    _isLoginStatus = status;
    notifyListeners();
  }

  List<dynamic>? getSaveList(){
    return _saveList??[];
  }

  void setSaveList(List<dynamic> ls){
    _saveList = ls;
  }

  String? getUserId(){
    return _userId ?? "";
  }

  void setUserId(String id){
    _userId = id;
    notifyListeners();
  }

  CameraController? getCameraController() {
    return _cameraController;
  }

  void setCameraController(CameraController? controller) {
    _cameraController = controller;
  }
}