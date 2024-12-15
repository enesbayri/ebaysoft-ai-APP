
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

// CAMERA paketini kullanırsan yüz algılama , görsel etiketleme , nesne algılama gibi özelliklerde canlı kamera ile stream kullanarak anlık veri yansıtabilirsin.
// Döküman tarayıcı sadece androidde çalışır


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
  late DocumentScanner documentScanner;
  DocumentScanningResult? result;
 

  @override
  void initState() {
    super.initState();
    documentScanner = DocumentScanner(options: DocumentScannerOptions());
  }


 void startScan() async {
    try {
      result = null;
      setState(() {});
      documentScanner.close();
      documentScanner = DocumentScanner(
        options: DocumentScannerOptions(
          documentFormat: DocumentFormat.jpeg,
          mode: ScannerMode.full,
          isGalleryImport: false,
          pageLimit: 1,
        ),
      );
      result = await documentScanner.scanDocument();
      debugPrint('result: $result');
      setState(() {});
    } catch (e) {
      debugPrint('Error: $e');
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
              'Document Scanner',
            ),
            if (result?.pdf != null) ...[
              const Padding(
                padding: EdgeInsets.only(
                    top: 16, bottom: 8, right: 8, left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('PDF Document:')),
              ),
              SizedBox(
                height: 300,
                child: PDFView(
                  filePath: result!.pdf!.uri,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                ),
              ),
            ],
            if (result?.images.isNotEmpty == true) ...[
              const Padding(
                padding: EdgeInsets.only(
                    top: 16, bottom: 8, right: 8, left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Images [0]:')),
              ),
              SizedBox(
                  height: 400, child: Image.file(File(result!.images.first))),
          ],
        ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    documentScanner.close();
    super.dispose();
  }
}
