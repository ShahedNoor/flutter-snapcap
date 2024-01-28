import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Function for turn on/off the flash
  bool isFlashOn = false;
  void turnFlashOnOff() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  // Function for switching camera
  Future<void> _switchCamera() async {
    int currentCameraIndex = widget.cameras.indexOf(controller.description);
    int newCameraIndex = (currentCameraIndex + 1) % widget.cameras.length;

    await controller.dispose();
    controller = CameraController(widget.cameras[newCameraIndex], ResolutionPreset.max);

    await controller.initialize();
    setState(() {});
  }

  Future<void> _changeAspectRatio() async {
    await controller.dispose();

    controller = CameraController(
      widget.cameras[0], // You may need to update this to use the selected camera
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await controller.initialize();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu_open,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      turnFlashOnOff();
                      setState(() {
                        if (isFlashOn) {
                          controller.setFlashMode(FlashMode.torch);
                        } else {
                          controller.setFlashMode(FlashMode.off);
                        }
                      });
                    },
                    icon: isFlashOn
                        ? const Icon(
                            Icons.flash_on,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.flash_off,
                            color: Colors.white,
                          ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.document_scanner,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _switchCamera();
                    },
                    icon: const Icon(
                      Icons.switch_camera_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showCameraSettingPopup(context);
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.4,
              width: MediaQuery.sizeOf(context).width,
              child: CameraPreview(controller)
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.black),
                // Main row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image preview container
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Map button
                    Container(
                      child: Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                      ),
                    ),
                    // Capture button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 68,
                                width: 68,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Folder button
                    Container(
                      child: Icon(
                        Icons.folder_copy_outlined,
                        color: Colors.white,
                      ),
                    ),
                    // Grid button
                    Container(
                      child: Icon(
                        Icons.grid_view_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCameraSettingPopup(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              color: Colors.black,
              width: MediaQuery.sizeOf(context).width,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _changeAspectRatio();
                          print(_changeAspectRatio());
                        },
                        child: Container(
                          child: const Column(
                            children: [
                              Icon(
                                Icons.aspect_ratio,
                                color: Colors.white,
                              ),
                              DefaultTextStyle(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                child: Text("Ratio(16:09, 2.07MP)"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.filter_center_focus,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("Focus Manual"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.light_mode_outlined,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("White Balance"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.numbers,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("None"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.tab_sharp,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("Mirror Off"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.party_mode,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("Scene Mode"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("Timer Off"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.music_off,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("Sound Off"),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              child: Text("Camera Level"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
