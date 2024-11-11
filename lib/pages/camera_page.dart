import 'package:aplicativo_com_camera_2024_2/pages/preview_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  bool _cameraTraseiraEstaSelecionada = true;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    availableCameras().then(
      (value) {
        cameras = value;
        iniciarCamera(cameras[0]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? CameraPreview(_controller)
              : Container(
                  color: Colors.black,
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                          _cameraTraseiraEstaSelecionada
                              ? CupertinoIcons.switch_camera
                              : CupertinoIcons.switch_camera_solid,
                          color: Colors.white,
                          size: 70),
                      onPressed: () {
                        _cameraTraseiraEstaSelecionada
                            ? _cameraTraseiraEstaSelecionada = false
                            : _cameraTraseiraEstaSelecionada = true;
                        iniciarCamera(
                            cameras[_cameraTraseiraEstaSelecionada ? 0 : 1]);
                      },
                    ),
                  ),
                  Expanded(
                      child: IconButton(
                    icon:
                        const Icon(Icons.circle, color: Colors.white, size: 70),
                    onPressed: () async {
                      XFile? foto = await tirarFoto();
                      if (foto != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewPage(
                                      foto: foto,
                                    )));
                      }
                    },
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> iniciarCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("Erro na camera $e");
    }
  }

  Future<XFile?> tirarFoto() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.setFlashMode(FlashMode.off);
      XFile foto = await _controller.takePicture();
      return foto;
    } on CameraException catch (e) {
      debugPrint('Ocorreu um erro ao tirar a foto: $e');
      return null;
    }
  }
}
