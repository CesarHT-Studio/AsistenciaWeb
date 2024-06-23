import 'package:flutter/material.dart';
import 'package:paginaweb/widget/responsive_widget.dart';

import 'opcionesbotones.dart';

class Visualize extends ResponsiveWidget {
  const Visualize({super.key});
  @override
  Widget buildDesktop(BuildContext context){
    // TODO: implement buildDesktop
    return DesktopVisualize();
  }
  @override
  Widget buildMobile(BuildContext context){
    // TODO: implement buildMobile
    return MobilieVisualize();
  }
}
class DesktopVisualize extends StatelessWidget{
  late dynamic token;
    @override
     Widget build(BuildContext context){
      token = ModalRoute.of(context)!.settings.arguments;
      return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              SideMenu(),
               Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const opcionesBoton(),
                      Text(token.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
class MobilieVisualize extends StatelessWidget{
    @override
     Widget build(BuildContext context){
      return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              SideMenu(),
                 const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: const Color.fromARGB(255, 56, 57, 58),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Registros de Asistencias', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white)),
        ],
      ),
    ),
    );
  }
}