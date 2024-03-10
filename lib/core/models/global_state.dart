import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  bool _isLoginStatus;
  CameraController? _cameraController;
  String? _userId;
  List<dynamic>? _saveList;
  bool _loading = false;
  bool get loading => _loading;
  FirebaseStorage storage;
  FirebaseDatabase database;

  set loading(bool newValue) {
    _loading = newValue;
    notifyListeners();
  }

  GlobalState(this._isLoginStatus, this.storage, this.database);

  bool getLoginStatus(){
    return _isLoginStatus;
  }

  void setLoginStatus(bool status){
    _isLoginStatus = status;
    if(!status){
      setSaveList([]);
      setUserId("");
    }
    notifyListeners();
  }

  List<dynamic>? getSaveList(){
    return _saveList??[];
  }

  void setSaveList(List<dynamic> ls){
    _saveList = ls;
    notifyListeners();
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