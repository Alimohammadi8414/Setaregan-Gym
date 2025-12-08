import 'package:flutter/material.dart';
import 'package:setareggan/screens/Root/root.dart';
import 'package:setareggan/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late SharedPreferences sharedPreferences;
ValueNotifier<bool> isThemeDark = ValueNotifier(false);

const String userBoxName = 'userBox';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  isThemeDark.value = sharedPreferences.getBool('isDark') ?? false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isThemeDark,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          locale: const Locale('fa'),
          supportedLocales: [Locale('fa')],
          localizationsDelegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: isThemeDark.value ? ThemeMode.dark : ThemeMode.light,
          home: const RootScreen(),
        );
      },
    );
  }
}
