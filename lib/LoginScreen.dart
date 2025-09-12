import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:showing_card/HomeScreen.dart';
import 'Buttonstyle.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Flutter Widgets initialisieren
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App starten
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karte anzeigen',
      home: const LoginScreen(),
    );
  }
}



//Register
Future<User?> registerWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  } on FirebaseAuthException catch (e) {
    print('Fehler bei Registrierung: ${e.message}');
    return null;
  }
}

// Login
Future<User?> loginWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    print('Fehler bei Login: ${e.message}');
    return null;
  }
}

// Logout
Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Passwort"),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await loginWithEmail(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Login fehlgeschlagen. Bitte überprüfe deine Daten.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Login"),
            ),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text('Create new Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameRegController = TextEditingController();
  final emailRegController = TextEditingController();
  final passwordRegController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(),
              decoration: const InputDecoration(labelText: "Choose your Name"),
            ),
            TextField(
              controller: emailRegController,
              decoration: const InputDecoration(
                labelText: "Enter your mail address Email",
              ),
            ),
            TextField(
              controller: passwordRegController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Choose a Password"),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await registerWithEmail(
                  emailRegController.text.trim(),
                  passwordRegController.text.trim(),
                );
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Bei der Registierug ist was schief gelaufen bitte überprüfe deine Eingabe',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Register with data"),
            ),
          ],
        ),
      ),
    );
  }
}
