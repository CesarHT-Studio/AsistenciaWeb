import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class InformationContent extends StatelessWidget {
  InformationContent({super.key});
  final List<String> imagePaths = [
    'assets/sliderunfv.jpg',
    'assets/portadauno.jpg',
    'assets/slidernegro.jpg',
    'assets/portadauno.jpg',
  ];
  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;// MQ conocemos el ancho de la pantalla
     
    return Container(
      //color: Colors.pink,
      width: width,
      height: width/4,
      child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            viewportFraction: 1.0,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
          ),
          items: imagePaths.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                double containerWidth = MediaQuery.of(context).size.width;
                double imageHeight = containerWidth * 0.25;
                return Image.asset(
                    imagePath,
                    fit: BoxFit.fill,
                    width: containerWidth,
                    height: imageHeight,

                  );
              },
            );
          }).toList(),
        ),
        
    );
  }
}