import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tech_initiator/src/blocs/posts/posts_bloc.dart';
import 'package:social_tech_initiator/src/utils/app_strings.dart';
import 'package:social_tech_initiator/src/utils/shared_prefs_utils.dart';

import 'routes.dart';
import 'src/blocs/auth/auth_cubit.dart';
import 'src/repositories/posts_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SharedPrefsUtils.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => PostBloc()),
      ],
      child: MaterialApp(
        title: 'App Title',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,scaffoldBackgroundColor: Colors.grey[200]
        ),
        initialRoute: AppRoutes.splashScreen,
        onGenerateRoute:
            AppRoutes.generateRoute,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final bool isLoggedIn = await SharedPrefsUtils.getBoolAsync('isLoggedIn');
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.postsScreen : AppRoutes.authScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
