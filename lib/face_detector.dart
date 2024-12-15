import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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
  late FaceDetector faceDetector;
  String result = "Yüz algılama sonuçları burada görünecek.";

  @override
  void initState() {
    super.initState();
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      )
    );
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
      final faces = await faceDetector.processImage(inputImage);
      if(faces.isNotEmpty){
        setState(() {
            result = "Algılanan yüz sayısı: ${faces.length}\n";
          for (Face face in faces) {
            result += "BoundingBox: ${face.boundingBox}\n";
            result += "BoundingBox: ${face.contours.entries.first.key.name}\n";
            result += "BoundingBox: ${face.contours.entries.first.value!.type.name}\n";
            result += "BoundingBox: ${face.landmarks.entries.first.key.name}\n";
            result += "BoundingBox: ${face.leftEyeOpenProbability}\n";
            result += "BoundingBox: ${face.rightEyeOpenProbability}\n";
            if (face.smilingProbability != null) {
              result +=
                  "Gülümseme Olasılığı: ${(face.smilingProbability! * 100).toStringAsFixed(2)}%\n";
            }
          }
          });
      }
    } catch (e) {
      debugPrint("Face Detector Error: $e");
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
              'Face Detector',
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
    faceDetector.close();
    super.dispose();
  }
}
