import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
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
  late ImageLabeler imageLabeler;
  String result = "Resim etiketleme sonuçları burada görünecek.";

  @override
  void initState() {
    super.initState();
    imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6));
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
      final labels = await imageLabeler.processImage(inputImage);
      setState(() {
        result = "Etiketler:\n";
        for (ImageLabel label in labels) {
          result +=
              "- ${label.label} (Güven: ${(label.confidence * 100).toStringAsFixed(2)}%)\n";
        }
      });
      
    } catch (e) {
      debugPrint("Image Labeling Error: $e");
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
              'Image Labeling',
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
    imageLabeler.close();
    super.dispose();
  }
}
