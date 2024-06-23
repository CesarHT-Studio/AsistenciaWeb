// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:paginaweb/content/dean_content_ce.dart';
import '../content/dean_content.dart';
import '../navigation_bar/nav_bar_secretary.dart';

class DeanContent extends StatelessWidget {
  const DeanContent({super.key});

  @override
  Widget build(BuildContext context) {
     final Map<String, dynamic> studentData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if(studentData!= null){
      final String name = studentData['name'] ?? '';
      final String urlFoto = studentData['urlfoto'] ?? '';
      final String token = studentData['token'] ?? '';
      String cargo = studentData['user_type'] ?? '';

    double width = MediaQuery.of(context).size.width;// MQ conocemos el ancho de la pantalla
    double maxWith = width > 1300 ? width : width;
    return  Scaffold(
      body: Center(
        child: Container(
          width: maxWith,
          child:  Column(
            children: [
              SingleChildScrollView(
                  child: Container(
                    height: 80,
                    color: const Color.fromARGB(255, 56, 57, 58),
                    child:  Padding(
                      padding: const EdgeInsets.all(20),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('CONTROL DE ASISTENCIAS', style: TextStyle(fontSize: width <= 800 ? 20 : 30, fontWeight: FontWeight.bold,color: Colors.white)),
                      ],
                    ),
                  ),
                  )
                ),
              NavBarSecretary(url: urlFoto,nombre: name,cargo: cargo,),
                Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, Constraints){
                           
                          if(Constraints.maxWidth <= 800){
                             return const DeanContentC();
                          }else{
                            return const DeanContentTable(); 
                          }
                        },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }else{
    return const Center(child: Text('No se proporcionaron argumentos'));
  }
  }
}