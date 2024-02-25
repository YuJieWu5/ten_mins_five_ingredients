import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  bool _isLoginStatus;
  CameraController? _cameraController;

  GlobalState(this._isLoginStatus);

  bool getLoginStatus(){
    return _isLoginStatus;
  }

  void setLoginStatus(bool status){
    _isLoginStatus = status;
    notifyListeners();
  }

  CameraController? getCameraController() {
    return _cameraController;
  }

  void setCameraController(CameraController? controller) {
    _cameraController = controller;
  }
}