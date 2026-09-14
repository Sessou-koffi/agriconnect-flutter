import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/culture_provider.dart';
import 'providers/activite_provider.dart';
import 'providers/conseil_provider.dart';

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CultureProvider()..loadCultures(),
        ),
        ChangeNotifierProvider(
          create: (_) => ActiviteProvider()..loadActivites(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConseilProvider()..loadConseils(),
        ),
      ],
      child: MaterialApp.router(
        title: 'AgriConnect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}