

import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

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

  late OnDeviceTranslator translator;
  String result = "Language Translation Result";
 
 

  @override
  void initState() {
    super.initState();
    initializeTranslator();
  }

  void initializeTranslator() {
    // Kaynak ve hedef dili tanımlıyoruz
    translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.turkish,
    );
    
  }


 void translate(String text) async {
    try {
      // ilk çalıştırmada gerekli çevrimdışı model inecektir ve bu biraz sürecektir.
      final translatedText = await translator.translateText(text);
      
      setState(() {
        result = translatedText;
      });
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
              'Language Translation',
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter text'),
              onSubmitted: (text) => translate(text),
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
    translator.close();
    super.dispose();
  }
}
