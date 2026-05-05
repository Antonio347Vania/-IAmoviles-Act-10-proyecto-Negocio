import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAReAiTm7nGUDlQfVNlFpy5fJPto1YpS3k',
      authDomain: 'dbsoriana.firebaseapp.com',
      projectId: 'dbsoriana',
      storageBucket: 'dbsoriana.firebasestorage.app',
      messagingSenderId: '721230522050',
      appId: '1:721230522050:web:3627bd90b47bf0dc7ebd5b',
      measurementId: 'G-B2RGBBEDYM',
    ),
  );
  runApp(const AntigravityApp());
}

class AntigravityApp extends StatelessWidget {
  const AntigravityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soriana Vania',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF7C02F),
        scaffoldBackgroundColor: const Color(0xFFFFF9EB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFFF7C02F),
        ),
        useMaterial3: true,
      ),
      // StreamBuilder para detectar estado de autenticación en tiempo real
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Cargando…
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Si hay sesión activa → Dashboard (área admin)
          if (snapshot.hasData && snapshot.data != null) {
            return const Inicio();
          }
          // Sin sesión → Login
          return const LoginPage();
        },
      ),
    );
  }
}
