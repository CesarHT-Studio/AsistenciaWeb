import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisingContent extends StatelessWidget {
  const AdvertisingContent({super.key});

  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
     double maxWith = width > 1000 ? 1000 : width;
    return Container(
      width: maxWith,
      padding: const EdgeInsets.only(left:20,right: 20,top: 20,bottom: 10),
      child: Column(
        
        children: [
          const Text('NOTICIAS',
          style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      
                    )),
          const SizedBox(height: 10),
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
            onTap: () {
              // Navegar a la URL cuando se hace clic en el texto
              launchURL('https://web.unfv.edu.pe/facultades/fiei/noticias/item/227-la-fiei-de-la-unfv-forma-parte-de-huawei-ict-academy');
            },
            child: Container(
              color: Colors.transparent,
              width: 300,
              height: 250,
              child: Column(
                children: [
                  Image.asset(
                    'assets/fieihuawei.png',
                    width: 300,
                    
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'La FIEI de la UNFV forma parte de “Huawei ICT Academy”',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              // Navegar a la URL cuando se hace clic en el texto
              launchURL('https://www.unfv.edu.pe/noticias/docentes-investigadores-villarrealinos-reciben-reconocimiento');
            },
            child: Container(
              color: Colors.transparent,
              width: 300,
              height: 250,
              child: Column(
                children: [
                  Image.asset(
                    'assets/docentes.JPG',
                    width: 300,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Docentes investigadores villarrealinos reciben reconocimiento',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              // Navegar a la URL cuando se hace clic en el texto
              launchURL('https://www.unfv.edu.pe/noticias/participamos-en-celebraciones-por-los-57-anos-de-la-universidad-del-callao');
            },
            child: Container(
              color: Colors.transparent,
              width: 300,
              height: 250,
              child: Column(
                children: [
                  Image.asset(
                    'assets/callao.jpg',
                    width: 300,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Participamos en celebraciones por los 57 años de la Universidad del Callao',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }
  void launchURL(String url) async {
    // Puedes usar una biblioteca como url_launcher para abrir enlaces web en el navegador
    // Asegúrate de agregar url_launcher como una dependencia en tu pubspec.yaml
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}