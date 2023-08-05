import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  // Flutter 앱이 실향될 준비가 됬는지 확인
  WidgetsFlutterBinding.ensureInitialized();

  // 핸드폰에 있는 카메라들 가져오기
  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  // State<CameraApp> createState() {
  //   _CameraAppState();
  // }

  State<CameraApp> createState() => _CameraAppState();



}

class _CameraAppState extends State<CameraApp> {

  // 카메라를 제어 할 수 읐는 컨트롤러 선언
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();

    initializeCamera();
  }

  initializeCamera() async {
    try{
      // 가장 첫 번째 카메라로 카메라 설정하기
      cameraController = CameraController(_cameras[0], ResolutionPreset.max);

      // 카메라 초기화
      await cameraController.initialize();

      setState(() {});
    } catch (e) {

      //에러가 았을 때 출력
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors');
            break;
        }
      }

    }

  }

  @override
  void dispose() {
    // 컨트롤러 삭제
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라 초기화 상태 확인
    if(!cameraController.value.isInitialized) {
      return Container();

    }

    return MaterialApp(
      // 카메라 보여주기
      home: CameraPreview(cameraController),
    );

  }
}