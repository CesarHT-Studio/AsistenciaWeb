// ignore_for_file: avoid_unnecessary_containers

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paginaweb/login.dart';
import 'package:paginaweb/opcionesbotones.dart';
import 'package:paginaweb/visualize.dart';
import 'package:paginaweb/widget/my_web_page.dart';
import 'package:url_strategy/url_strategy.dart';
import 'asistencia_content/dean.dart';
import 'asistencia_content/profesor.dart';
import 'asistencia_content/secretary.dart';

void main() {
  setPathUrlStrategy();
  runApp(
     ProviderScope(
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: "Web Page",
        initialRoute: '/mywebpage',
        routes: {
        '/mywebpage':(context) => const MyWebPage(),
        '/login':(context) =>  const Login(),
        '/opcionesboton':(context) =>  const opcionesBoton(),
        '/visualize':(context) =>  const Visualize(),
        '/SecretaryContent':(context) => const SecretaryContent(),
        '/DeanContent':(context) => const DeanContent(),
        '/docente':(context) => const ProfesorContent(),
      },
      ),
    ),
  );
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}



