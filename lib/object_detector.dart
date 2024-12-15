import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';

// CAMERA paketini kullanırsan yüz algılama , görsel etiketleme , nesne algılama gibi özelliklerde canlı kamera ile stream kullanarak anlık veri yansıtabilirsin.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  late ObjectDetector objectDetector;
  String result = "Nesne algılama sonuçları burada görünecek.";

  @override
  void initState() {
    super.initState();
    objectDetector = ObjectDetector(options: ObjectDetectorOptions(mode: DetectionMode.single, classifyObjects: true, multipleObjects: true));
  }


  Future<void> pickImage() async{
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image = File(pickedImage.path);
      progressImage(image!);
    }

  }

  Future<void> progressImage(File img)async{
    try {
      InputImage inputImage = InputImage.fromFile(img);
      final objects = await objectDetector.processImage(inputImage);
      setState(() {
        if (objects.isEmpty) {
          result = "Nesne bulunamadı.";
        } else {
          result = "Algılanan nesneler:\n";
          for (DetectedObject detectedObject in objects) {
            result +=
                "- Nesne ID: ${detectedObject.trackingId ?? 'Yok'}\n";
            for (Label label in detectedObject.labels) {
              result +=
                  "  Etiket: ${label.text} (Güven: ${(label.confidence * 100).toStringAsFixed(2)}%)\n";
            }
          }
        }
      });
      
    } catch (e) {
      debugPrint("Object Detector Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Object Detector',
            ),
            Text(
              result,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    objectDetector.close();
    super.dispose();
  }
}
