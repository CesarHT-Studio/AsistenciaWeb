// ignore_for_file: use_build_context_synchronously, override_on_non_overriding_member
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  @override
  late String tipo;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    tipo = ModalRoute.of(context)!.settings.arguments as String;
    return  WillPopScope(
      onWillPop: () async {
        // Navegar a la pantalla de inicio al presionar el botón de retroceso
        Navigator.pushReplacementNamed(context, '/mywebpage');
        return false; // Evita que el usuario navegue hacia atrás en esta pantalla
      },
      child: Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          width: 300, // Ancho del formulario
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // Color de fondo anaranjado
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
          ),
          child: Form(
            key: _formKey,
            child: Column( 
              children: <Widget>[
                Center(
                  child: Padding(padding: const EdgeInsets.only(top: 70),
                child: Image.asset('assets/logounf.jpg',width: 200,),),
                ),
                const SizedBox(height: 10),
                Center(
                child:  Text(tipo, 
                style:const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black
                  )),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Ingresar usuario para continuar.';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                    labelText: 'Usuario',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 216, 239, 250), // Color de fondo del TextField
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // Borde transparente
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none, // Borde transparente al enfocar
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Ingresar contraseña para continuar.';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Contraseña',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 216, 239, 250), // Color de fondo del TextField
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // Borde transparente
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none, // Borde transparente al enfocar
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20), backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                    width: 1, // thickness
                                    color: Colors.transparent// color
                            ),
                            // border radius
                            borderRadius: BorderRadius.circular(100) 
                    ),
                  ),
                  onPressed: ()async{loginHelp(tipo);},
                  child: const Text('INICIAR SESIÓN',
                  style: TextStyle(fontSize: 16),),
                ),
              ],
            ),
          ),
    )
      ),
    )
    );  
    
  }

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> loginHelp(String tipo) async {
    if(!_formKey.currentState!.validate()) return;
    try{
      String ruta = '';
      String tipo1 = '';
      if(tipo == 'Secretaria'){
        tipo1 = 'secretary';
        ruta = '/SecretaryContent';
      }else if(tipo == 'Decano'){
        tipo1 = 'decan';
        ruta = '/DeanContent';
      }else if(tipo == 'Docente'){
        tipo1 = 'teacher';
        ruta = '/docente';
      }
      final urllogin = Uri.parse("http://3.22.217.187:80/api/v1/dj-rest-auth/login/");
      
      final datosdelposibleusuario = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };
    print(datosdelposibleusuario);
    final response = await http.post(urllogin,
        body: datosdelposibleusuario);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = Map.from(json.decode(response.body));
      print("Respuesta de la API: $jsonResponse");
      final tokens = jsonResponse["key"].toString();

      final apiUrl = Uri.parse("http://3.22.217.187:80/api/v2/estudiante/${_usernameController.text}/");
      const token = "1da87ade3af5fecbfc5365487d29a0a82268fb71";
      final headers = {
        "Authorization": "Token $token",
      };
      try {
        final response = await http.get(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          print("Nombre del estudiante: $jsonData");
          final userType = jsonData['user_type'];
          if(userType == tipo1){
            Navigator.pushNamed(context,ruta, 
           arguments: {
            'token': token, 
            'username': _usernameController.text,
            'urlfoto': jsonData['urlfoto'], 
            'name': jsonData['name'],
            'user_type': tipo});
          }else {
            showSnackbar("Usuario o contraseña inválida de $tipo");
          }
        } else {
          print("Error: ${response.statusCode} - ${response.body}");
        }
      } catch (e) {
        print("Error with API request: $e");
      }
    } else {
      print("Error en el inicio de sesión: ${response.body}");
      showSnackbar("Usuario o contraseña inválida");
      
    }
    }catch(e){
      showSnackbar("Error con el servidor al realizar la solicitud");
      print("Error con el servidor al realizar la solicitud");
    }
  }

}