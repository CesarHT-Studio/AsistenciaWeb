import 'package:flutter/material.dart';

abstract class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({super.key});

  //funciones abstractas
  Widget buildMobile(BuildContext context);//diseno para celular
  Widget buildDesktop(BuildContext context);//diseno para compu

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, Constraints){
        if(Constraints.maxWidth <= 800){
          return buildMobile(context);
        }else{
          return buildDesktop(context);
        }
      },
      );
  }
}