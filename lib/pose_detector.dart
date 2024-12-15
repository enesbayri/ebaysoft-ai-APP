import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
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
  late PoseDetector poseDetector;
  String result = "Poz algılama sonuçları burada görünecek.";

  @override
  void initState() {
    super.initState();
    poseDetector = PoseDetector(options: PoseDetectorOptions(mode: PoseDetectionMode.single));
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
      final poses = await poseDetector.processImage(inputImage);
      setState(() {
        if (poses.isEmpty) {
          result = ('Poz bulunamadı.');
        } else {
          result = "Algilanan pozlar : \n";
          for (Pose pose in poses) {
            for (PoseLandmark landmark in pose.landmarks.values) {
              final type = landmark.type.name; // Poz işaretinin tipi
              
              result += ("Poz işareti: $type, Pozisyon: (${landmark.x}, ${landmark.y}, ${landmark.z}) \n");
            }
          }
        }
      });
      
      
    } catch (e) {
      debugPrint("Pose Detector Error: $e");
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
              'Pose Detector',
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
    poseDetector.close();
    super.dispose();
  }
}
