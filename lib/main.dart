import 'package:analysis_app/screens/login_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const DimenScan());
}

class DimenScan extends StatelessWidget {
  const DimenScan({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorSchemes.lightGray(),
        radius: 0.5,
      ),
      title: 'DimenScan',
      home: const LoginScreen(),
    );
  }
}
