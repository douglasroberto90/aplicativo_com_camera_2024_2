import 'dart:io';

import 'package:aplicativo_com_camera_2024_2/repositories/repositorio.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class PreviewPage extends StatelessWidget {
  PreviewPage({super.key, required XFile this.foto});

  XFile foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gostou da foto?",
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(foto.path),
              fit: BoxFit.cover,
              width: 250,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Repositorio.salvarFotoNaGaleria(foto);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HomePage(
                              foto: foto,
                            )),
                            (route) => false);
                  },
                  child: Text("Salvar foto")),
            )
          ],
        ),
      ),
    );
  }
}
