import 'package:flutter/material.dart';
import 'package:paginaweb/content/advertising_content.dart';
import 'package:paginaweb/navigation_bar/nav_bar.dart';
import '../content/advertising_content_c.dart';
import '../content/footer.dart';
import '../content/information_content copy.dart';

class MyWebPage extends StatelessWidget {
  const MyWebPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;// MQ conocemos el ancho de la pantalla
    double maxWith = width > 1300 ? width : width;
    return Scaffold(
      body: Center(
        child: Container(
          width: maxWith,
          child:  Column(
            children:<Widget> [
              SingleChildScrollView(
                  child: Container(
                    height: 50,
                    color: Colors.orange,
                  ),
                ),
              const NavBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InformationContent(),
                      LayoutBuilder(
                        builder: (context, Constraints){
                           
                          if(Constraints.maxWidth <= 800){
                             return const AdvertisingContentC();
                          }else{
                            return const AdvertisingContent(); 
                          }
                        },
                        ),
                      const FooterContent(),
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