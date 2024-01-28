import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:snapcap/pages/camera_page.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(SnapCap(cameras: _cameras,));
}

class SnapCap extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SnapCap({super.key, required this.cameras});

  @override
  State<SnapCap> createState() => _SnapCapState();
}

class _SnapCapState extends State<SnapCap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(cameras: widget.cameras,)
    );
  }
}