import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:healthyfoodscan/resultpage.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//creo variables
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isGranted =
      false; //indica si se ha concedido el permiso para acceder a la camara
  late final Future<void>
      _future; //futura tarea que solicita permiso para la camara
  CameraController?
      _cameraController; //controlador de la camara que permite interactuar con la camara del dispositivo
  final textRecognizer =
      TextRecognizer(); //se utiliza para reconocer el texto en las imagenes capturadas por la camara

//este metodo se llama cuando se crea el estado de la pagina y añade un observador para los cambios en
//la aplicacion y se solicita el permiso para acceder a la camara
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCamera();
  }

//este metodo se llama cuando se elimina el estado de la pagina y
//se elimina el observador y detiene la camara y cierra el reconocedor de texto
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    stopCamera(); //para parar la camara
    textRecognizer.close();
    super.dispose();
  }

//se llama cuando cambia el estado de la aplicación(primer plano a segundo plano)
//se detiene y se reinicia la camara segun sea necesario
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    //app incactiva, para abrir y cerrar la camara
    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      startCamera();
    }
  }

//
  @override //construccion de la interfaz de la app
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Healthy Food Scan'), //titulo en el appbar
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications)) //boton de notificaciones
          ],
          backgroundColor:
              const Color.fromARGB(255, 5, 143, 206), //color del appbar
          leading: IconButton(
            onPressed: () {},
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu), //boton de menu
            ),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
        ),
        //para solicitar los permisos de acceder a la camara
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  if (_isGranted)
                    FutureBuilder<List<CameraDescription>>(
                      future: availableCameras(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _initCameraController(snapshot.data!);
                          return Center(
                              child: CameraPreview(_cameraController!));
                        } else {
                          return const LinearProgressIndicator();
                        }
                      },
                    ),
                  Container(
                      child: _isGranted
                          ? Column(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: MaterialButton(
                                      color: const Color.fromARGB(
                                          255, 90, 159, 216),
                                      onPressed: _scan,
                                      child: const Text(
                                          'Escanea'), //boton para poder escanear
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child: Text('Camera off'),
                            ))
                ],
              );
            }));
  }

//metodo que solicita el permiso para acceder a la camara y actualiza segun el resultado del permiso
  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    _isGranted = status == PermissionStatus.granted;
  }

//inicia la camara
  void startCamera() {
    if (_cameraController != null) {
      _selectedCamera(_cameraController!.description);
    }
  }

//detiene la camara
  void stopCamera() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
  }

//inicia el controlador
  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    CameraDescription? camera;
    for (var i = 0; 1 < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _selectedCamera(camera);
    }
  }

//seleccion de la camara
  Future<void> _selectedCamera(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

//metodo que se encarga de capturar la imagen de la camara para reconocer el texto
  Future<void> _scan() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final picture = await _cameraController!.takePicture();

      final file = File(picture.path);

      final inputImage = InputImage.fromFile(file);

      final recognizerText = await textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(
        builder: (context) => ResultPage(text: recognizerText.text),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
