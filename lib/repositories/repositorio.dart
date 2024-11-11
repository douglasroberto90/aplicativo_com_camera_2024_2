import 'package:camera/camera.dart';
import 'package:gal/gal.dart';

class Repositorio{

  static Future<void> salvarFotoNaGaleria(XFile foto) async {
    await Gal.putImage(foto.path);
  }
}