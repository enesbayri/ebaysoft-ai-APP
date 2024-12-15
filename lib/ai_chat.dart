

import 'package:ebaysoftai/models/gen_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// CAMERA paketini kullanırsan yüz algılama , görsel etiketleme , nesne algılama gibi özelliklerde canlı kamera ile stream kullanarak anlık veri yansıtabilirsin.
// https://github.com/flutter-ml/google_ml_kit_flutter/tree/master/packages/example  örnek projesinden bu özelliklerin canlı kamera vs özellikleriyle beraber kullanımı ve hangi alanda nasıl kullanılacağı verilmiştir.


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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
 
  late GenAi ai;
  String result = "Yapay zeka cevabı burada!";

  @override
  void initState() {
    super.initState();
    ai = GenAi();
    ai.startNewChat();
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
              'Ebaysoft Chat',
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter text'),
              onSubmitted: (text) async{
                result = (await ai.sendChatMessage(text)) ?? "Üzgünüm ne demek istediğinizi anlayamadım,lütfen tekrar deneyin!";
                setState(() {
                  
                });
              },
            ),
          const SizedBox(height: 15,),
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
    super.dispose();
  }
}
