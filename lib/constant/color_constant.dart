import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final navKey = GlobalKey<NavigatorState>();
Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};
MaterialColor colorCustom = MaterialColor(0xffd10e48, color);
TextStyle supertitleStyle =
    GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w700);
TextStyle titleStyle =
    GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold);

TextStyle subtitleStyle =
    GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold);

TextStyle subtitleStyle2 =
    GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.normal);

TextStyle subtitleStyle2Small =
    GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.normal);
TextStyle landingsubtitleStyle =
    GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w300);
TextStyle subtitleStyle3 =
    GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w300);
