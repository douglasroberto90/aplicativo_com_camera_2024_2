import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.foto});

  XFile? foto;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? fotinha = null;

  @override
  void initState() {
    fotinha=widget.foto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tire sua foto!",
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: fotinha == null
                ? Icon(
                    Icons.camera_alt,
                    size: 150,
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 80 / 100,
                    child: Image.file(File(fotinha!.path))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraPage(),
                        ));
                  },
                  child: Text("Tirar foto")),
              ElevatedButton(
                  onPressed: () {
                    metodoGaleria().then(
                      (value) {
                        setState(() {
                          fotinha = value;
                        });
                      },
                    );
                  },
                  child: Text("Galeria")),
              ElevatedButton(
                  onPressed: () {
                    if (fotinha != null) {
                      metodoEditarFoto(fotinha!).then(
                        (value) {
                          setState(() {
                            fotinha = value;
                          });
                        },
                      );
                    } else {
                      const snack = SnackBar(
                        content: Text(
                            "Para editar uma foto é necessário primeiro carregar uma imagem da galeria ou tirar uma foto"),
                        duration: Duration(seconds: 7),
                      );
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    }
                  },
                  child: Text("Editar foto"))
            ],
          )
        ],
      ),
    );
  }

  Future<XFile?> metodoGaleria() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    return imagem;
  }

  Future<XFile> metodoEditarFoto(XFile foto) async {
    CroppedFile? imagemEditada = await ImageCropper().cropImage(
      sourcePath: foto.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
    );
    return XFile(imagemEditada!.path);
  }
}
