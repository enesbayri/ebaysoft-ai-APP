

import 'package:flutter/material.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

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

  late LanguageIdentifier languageIdentifier;
  String result = "Language identifier result";
 
 

  @override
  void initState() {
    super.initState();
    languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  }


 void langIdentifier(String text) async {
    try {
      final languages = await languageIdentifier.identifyPossibleLanguages(text);
      for (var language in languages) {
        result += "Algılanan dil sayısı: ${languages.length}";
        result += ("Language: ${language.languageTag}, Confidence: ${language.confidence} \n");
      }
      
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
              'Language identified',
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter text'),
              onSubmitted: (text) => langIdentifier(text),
            ),
            Text(
              result,
            ),
            
         
        ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    languageIdentifier.close();
    super.dispose();
  }
}
