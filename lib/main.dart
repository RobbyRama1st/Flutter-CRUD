import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/posts/post_bloc.dart';
import 'repository/auth_repository.dart';
import 'repository/post_repository.dart';
import 'service/api_service.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/post_form_page.dart';
import 'ui/pages/post_list_page.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    // Sediakan instance ApiService, Repositories, dan BLoCs ke widget tree
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ApiService()),
        RepositoryProvider(
          create: (context) => AuthRepository(
            apiService: context.read<ApiService>(),
            prefs: sharedPreferences,
          ),
        ),
        RepositoryProvider(
          create: (context) => PostRepository(
            apiService: context.read<ApiService>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                PostBloc(postRepository: context.read<PostRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Test BLoC CRUD',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // Tema UI Modern
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginPage(),
            '/posts': (context) => const PostListPage(),
            '/post-form': (context) => const PostFormPage(),
          },
        ),
      ),
    );
  }
}
