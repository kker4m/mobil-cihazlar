import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vize_proje/firebase_options.dart';
import 'package:vize_proje/pages/kitap_ekle.dart';
import 'pages/kitap_listele.dart';
import 'pages/kitap_ekle.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KitapListesiSayfasi()
    );
  }
}