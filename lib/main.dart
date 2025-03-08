import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:analysis_app/screens/home_screen.dart';
import 'package:analysis_app/screens/login_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DimenScan());
}

class DimenScan extends StatelessWidget {
  const DimenScan({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      title: 'DimenScan',
      theme: ThemeData(
        colorScheme: ColorSchemes.lightGray(),
        radius: 0.5,
      ),
      home: const AuthWrapper(), // Decides which screen to show
    );
  }
}

/// **AuthWrapper Widget** - Listens to Auth State and Redirects
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return  HomeScreen(); // If logged in, go to Home
        }
        return const LoginScreen(); // Otherwise, go to Login
      },
    );
  }
}
