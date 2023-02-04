import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Screens/login_screen/login_page.dart';

void main() async {
  runApp(Quds());
}

Locale locale = Locale("ar", "AE");

bool cur = false;
String scanBarcode = '';

class Quds extends StatefulWidget {
  const Quds({Key? key}) : super(key: key);

  @override
  State<Quds> createState() => _QudsState();
  static _QudsState? of(BuildContext context) =>
      context.findAncestorStateOfType<_QudsState>();
}

class _QudsState extends State<Quds> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar", "AE"),
          Locale("en", ""),
        ],
        locale: locale,
        theme: ThemeData(
            primaryColor: Color(0xff34568B),
            accentColor: Color(0xff34568B),
            textTheme:
                GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme)),
        debugShowCheckedModeBanner: false,
        title: 'Quds',
        home: LoginScreen(),
      );
    });
  }
}
