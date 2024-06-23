import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paginaweb/navigation_bar/nav_bar_button.dart';
import 'package:paginaweb/widget/responsive_widget.dart';

class NavBar extends ResponsiveWidget {
  const NavBar({super.key});

  @override
  Widget buildDesktop(BuildContext context){
    // TODO: implement buildDesktop
    return DesktopNavBar();
  }
  @override
  Widget buildMobile(BuildContext context){
    // TODO: implement buildMobile
    return MobileNavBar();
  }
}
class DesktopNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 40,right: 40),
        child: Row(
          
          children: <Widget>[
            Image.asset(
              'assets/logounfvv.png',
              height: 100,
            ),
            Expanded(child: Container()),
            NavBarButton(onTap: (){
              Navigator.pushNamed(context, '/login',arguments: 'Docente');
            }, text: 'Docente'),
            const SizedBox(width: 20),
            NavBarButton(onTap: (){
              Navigator.pushNamed(context, '/login',arguments: 'Secretaria');
            }, text: 'Secretaria'),
            const SizedBox(width: 20),
            NavBarButton(onTap: (){
              Navigator.pushNamed(context, '/login', arguments: 'Decano');
            }, text: 'Decano'),
          ],
        ),
      ),
    );
  }
}

class MobileNavBar extends HookConsumerWidget{
  @override
  Widget build(BuildContext context,WidgetRef ref){
    final containerHeight = useState<double>(0.0);
    
    return Stack(
      children: [
        AnimatedContainer(
          margin: const EdgeInsets.only(top: 80.0),
          curve: Curves.ease,
          duration: const Duration(milliseconds: 350),
          height: containerHeight.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                NavBarButton(onTap: (){
                  Navigator.pushNamed(context, '/login',arguments: 'Docente');
                }, text: 'Docente'),
                NavBarButton(onTap: (){
                  Navigator.pushNamed(context, '/login', arguments: 'Secretaria');
                }, text: 'Secretaria'),
                NavBarButton(onTap: (){
                  Navigator.pushNamed(context, '/login', arguments: 'Decano');
                }, text: 'Decano'),
              ],
            ),
          ),
        ),
        Container(
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/logounfvv.png',
                  height: 60,
                ),
                Expanded(child: Container()),
                Material(
                  child: InkWell(
                    splashColor: Colors.white60,
                    onTap: (){
                      final height = containerHeight.value > 0 ? 0.0 : 170.0;
                      containerHeight.value = height;
                    },
                    child: const Icon(
                      Icons.menu,
                      color: Colors.black87,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}