import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: BabsimApp()));
}

class BabsimApp extends StatelessWidget {
  const BabsimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BABSIM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
