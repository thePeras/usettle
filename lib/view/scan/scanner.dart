import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high);

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isCameraInitialized
              ? Stack(
                children: [
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _cameraController!.value.previewSize!.height,
                        height: _cameraController!.value.previewSize!.width,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed:
                              () => Navigator.popAndPushNamed(context, '/home'),
                          icon: PhosphorIcon(
                            color: Colors.black,
                            PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(12),
                      child: IconButton(
                        onPressed: () => {},
                        icon: PhosphorIcon(
                          color: Colors.white,
                          PhosphorIcons.scan(PhosphorIconsStyle.regular),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
