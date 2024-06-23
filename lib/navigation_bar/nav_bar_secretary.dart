import 'package:flutter/material.dart';
import 'package:paginaweb/widget/responsive_widget.dart';

class NavBarSecretary extends ResponsiveWidget {
  final String url;
  final String nombre;
  final String cargo;
  const NavBarSecretary({
    Key? key,
    required this.url,
    required this.nombre,
    required this.cargo,
  }) : super(key: key);

  @override
  Widget buildDesktop(BuildContext context){
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 40,left: 40,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: 
              Image.network(
                url,
                height: 50,
                width: 50,
                scale: 1,
            ),
            ),
            
            const SizedBox(width: 10,),
            Text('$nombre - $cargo',style: const TextStyle(color: Colors.black87,fontSize: 14),),
            Expanded(child: Container()),
            Material(
                  child: InkWell(
                    splashColor: Colors.white60,
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/login',
                      arguments: cargo);
                    },
                    child: const Icon(
                      Icons.power_settings_new,
                      color: Colors.black87,
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
  @override
  Widget buildMobile(BuildContext context){
    return Container(
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                ClipOval(
              child: 
              Image.network(
                url,
                height: 50,
                width: 50,
                scale: 1,
                ),
                ),
                const SizedBox(width: 10,),
                Text('$nombre - $cargo',style: const TextStyle(color: Colors.black87,fontSize: 14)),
                Expanded(child: Container()),
                Material(
                  child: InkWell(
                    splashColor: Colors.white60,
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/login',
                      arguments: cargo);
                    },
                    child: const Icon(
                      Icons.power_settings_new,
                      color: Colors.black87,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }
}