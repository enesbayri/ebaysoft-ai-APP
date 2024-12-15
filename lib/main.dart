import 'package:ebaysoftai/tools/ui_helpers/screen_sizes.dart';
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
    return Builder(builder: (context) {
      ScreenSizes.init(context);
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
    });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenSizes.width,
        height: ScreenSizes.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg/2.jpg"),
              fit: BoxFit.cover
              )
            ),
      ),
    );
  }
}
