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
    controller = CameraController(widget.cameras[0], ResolutionPreset.low);
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
    controller =
        CameraController(widget.cameras[newCameraIndex], ResolutionPreset.max);

    await controller.initialize();
    setState(() {});
  }

  List<ResolutionPreset> resolutionPresets = [
    ResolutionPreset.max,
    ResolutionPreset.ultraHigh,
    ResolutionPreset.high,
    ResolutionPreset.veryHigh,
    ResolutionPreset.medium,
    ResolutionPreset.low,
  ];
  int currentResolutionIndex = 0;

  Future<void> _changeAspectRatio() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await controller.dispose();

      // Introduce a small delay to allow time for disposal
      await Future.delayed(Duration(milliseconds: 500));

      // Get the next resolution preset
      ResolutionPreset nextPreset = resolutionPresets[currentResolutionIndex];

      // Update the index for the next tap
      currentResolutionIndex =
          (currentResolutionIndex + 1) % resolutionPresets.length;

      controller = CameraController(
        widget.cameras[0],
        nextPreset,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      setState(() {});
    } catch (e) {
      // Handle errors if needed
      print("Error: $e");
    } finally {
      // Close the loading indicator
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constranits) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
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
            ),
            Positioned.fill(
              top: 50,
              child: Container(
                constraints: const BoxConstraints.expand(),
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
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
        );
      })),
    );
  }

  Future<void> _showCameraSettingPopup(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String currentResolution = controller.resolutionPreset.name;
        String low = "low";
        String medium = "medium";
        String high = "high";
        String veryHigh = "veryHigh";
        String ultraHigh = "ultraHigh";
        String max = "max";

        String getRatioText() {
          if (currentResolution == low) {
            return "4:3";
          } else if (currentResolution == medium) {
            return "4:3";
          } else if (currentResolution == high) {
            return "16:9";
          } else if (currentResolution == veryHigh) {
            return "16:9";
          } else if (currentResolution == ultraHigh) {
            return "16:9";
          } else if (currentResolution == max) {
            return "16:9";
          } else {
            return "";
          }
        }

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
                          print("Preset: ${controller.resolutionPreset.name}");
                        },
                        child: Container(
                          child: Column(
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
                                child: Text(
                                    "Ratio(${getRatioText()}, 2.07MP)"),
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
