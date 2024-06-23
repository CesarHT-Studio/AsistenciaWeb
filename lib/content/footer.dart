import 'package:flutter/material.dart';

class FooterContent extends StatelessWidget {
  const FooterContent({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      width: width,
      height: 50,
      color: Colors.black,
      child: const Center(
        child:  Text('2023',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
      ),
    );
  }
}