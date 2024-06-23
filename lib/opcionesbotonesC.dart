import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:paginaweb/service/downloadexel.dart';

class OpcionesBotonesCel extends StatefulWidget {
  const OpcionesBotonesCel({super.key});

  @override
  State<OpcionesBotonesCel> createState() => _OpcionesBotonesCelState();
}


class _OpcionesBotonesCelState extends State<OpcionesBotonesCel> {
  List<String> cursos = [];
  List<Map<String, dynamic>>  cursoTotal = [];
  String? codigoCursoSeleccionado;
  String? selectedCurso;
  String? dropdownValueCurso;
  List<Map<String, dynamic>> asistenciasFinalesMostrar = [];
  List<Map<String, dynamic>>  alumnosfinal = [];
  List<Map<String, dynamic>>  registroFinal = [];
  bool showDataTable = false;
  Widget? dataTableWidget;
  Widget? dataTableWidget2;
  Widget? dataTableWidget3;
  Widget? dataTableWidget4;
  List<DateTime>? fechaRango;
  @override
  void initState() {
    super.initState();
    cursosTotal();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:   Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                width: 290,
                child: DropdownButtonFormField(
                items: cursos.map((e){
                  return DropdownMenuItem(
                    value: e,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    dropdownValueCurso = newvalue;
                    selectedCurso = newvalue;
                    print('Selected curso: $selectedCurso');
                    final cursoInfo = cursoTotal.firstWhere((curso) => curso['nombre_curso'] == newvalue, orElse: () =>{'codigo_curso': null});
                    print('cursoInfo: $cursoInfo');
                    if (cursoInfo != null) {
                      codigoCursoSeleccionado = cursoInfo['codigo_curso'];
                    } else {
                      codigoCursoSeleccionado = null;
                    }
                  });
                },
                itemHeight: 50,
                isDense: true,
                isExpanded: true,
                decoration: InputDecoration(
                    labelText: 'SELECCIONAR CURSO',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true, // Rellenar el fondo
                    fillColor: const Color.fromARGB(255, 223, 227, 230),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black), // Color de la línea cuando el campo está enfocado
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black), // Color de la línea siempre
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
              ),
              ),
              const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(10.0),
                    fixedSize: const Size(110,55),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Ajusta el radio del borde
       
                  ),
                  ),
                onPressed:
                  codigoCursoSeleccionado==null 
                  ?(){print('No selecciono curso');}:
                  ()async{
                    String fechaI = '2023-06-12';
                    await fetchData(codigoCursoSeleccionado!);
                    await fetchAsistencias(codigoCursoSeleccionado!,fechaI);
                    buildDataTableWidget1(registroFinal);
                    buildDataTableWidget2(registroFinal);
                    buildDataTableWidget3(registroFinal);
                    buildDataTableWidget4(registroFinal);
                    setState(() {
                      showDataTable = true; // Mostrar el DataTable cuando se haga clic
                    });
                    print('registroFinal: $registroFinal');
                    print('codigoCursoSeleccionado: $codigoCursoSeleccionado');
                    print('asistenciasFinalesMostrar: $asistenciasFinalesMostrar');
                                  
                  }, 
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("BUSCAR"),
                    SizedBox(width: 8),
                    Icon(Icons.search, color: Colors.white,),
                  ],
                )
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(10.0),
                    fixedSize: const Size(170,55),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Ajusta el radio del borde
       
                  ),
                ),
                onPressed: () {
                  downloadExcel(registroFinal);
                },
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/filexlsx.png', // Ruta de la imagen en tus activos
                        height: 35,
                      ),
                      const SizedBox(width: 8), // Espacio entre la imagen y el texto
                      const Text('Descargar Excel', style: TextStyle(color: Colors.white)), // Estilo de texto
                    ],
                  ),
              ),
              ],
            ),
            const SizedBox(height: 30),
          Container(
              
              color: Colors.white,
              //padding: const EdgeInsets.only(left: 10, right: 10),
              child: showDataTable 
              ? 
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: dataTableWidget,
                  ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: dataTableWidget2,
                  ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: dataTableWidget3,
                  ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: dataTableWidget4,
                  ),
                  ),
                ],
                ),
              ) : Container(),
            
          ),
          ],
        ),
      ),
    );
  }
   Future<void> cursosTotal() async {
    const apiUrl = 'http://3.22.217.187:80/api/v2/cursos/';
    const token = 'd4ae05cada6fb009c9fc5197d6b7c84a5d3c54b5';
    final headers = {
    'Authorization': 'Token $token',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final cursosData = json.decode(response.body);
        final List<Map<String, dynamic>> mapList = cursosData.map<Map<String, dynamic>>((dynamic map) {
                      return Map<String, dynamic>.from(map);
                      }).toList();
        print("Total de Curos: $mapList");
        final List<String> cursosList2 = [];
        for (var curso in cursosData) {
          if (curso['nombre_curso'] != null) {
            print('Cursos Enviados: ${curso['nombre_curso'].toString()}');
            cursosList2.add(curso['nombre_curso'].toString());
          }
        }
        print("cursos de lista final: $cursosList2");

        setState(() {
          cursos = cursosList2; //solo cursos
          cursoTotal = mapList; // Actualiza la lista de cursos en el estado del widget, lista de mapas
        });
      } else {
        print('Respuesta de la API con error - status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener los datos de la API: $error');
    }
}
Future<void> fetchData(String codigoCurso) async {
    final String codigoCursoInteresado = codigoCurso;
    const token = 'd4ae05cada6fb009c9fc5197d6b7c84a5d3c54b5';
    const  baseUrl = "http://3.22.217.187:80/api/v2/curso/";
    final  url = "$baseUrl$codigoCursoInteresado/matriculas";
    final headers = {'Authorization': 'Token $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> usuarios = json.decode(response.body);
        List<Map<String, dynamic>> usuariosMap = usuarios.map((usuario) {
        return {
          "name": usuario["name"],
          "codigo": usuario["codigo"],
        };
        }).toList();
        // Print names and codes of users
        print("Usuarios matriculados en el curso con código $codigoCursoInteresado:");
        print("Nombre: $usuarios");
        setState(() {
        alumnosfinal = usuariosMap; // Actualiza la lista de cursos en el estado del widget
        print('cursosend: $cursos');
        print('Alumnosfinal: $alumnosfinal');
      });
      } else {
        print("Error al obtener datos: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
  void buildDataTableWidget2(List<Map<String, dynamic>> data) {
  dataTableWidget2 =  DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 209, 213, 216),
      ),
      columns: [
      ...data[0].keys.where((key) => key != 'codigo' && key != 'name'&& key != 'Total' && key != '% Asisitencia').map((key) {
        return DataColumn(label: Text(key));
      }).toList(),
    ],
      rows: data.map((asistencia) {
        return DataRow(
          cells: [
            ...asistencia.keys.where((key) => key != 'codigo' && key != 'name' && key != 'Total' && key != '% Asisitencia').map((key) {
              return DataCell(Text(asistencia[key]));
            }).toList(),
          ],
        );
      }).toList(),
    );
}
  void buildDataTableWidget1(List<Map<String, dynamic>> data) {
  dataTableWidget =  DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 209, 213, 216),
      ),
      columns: const [
      DataColumn(label: Text('Código')),
      DataColumn(label: Text('Nombre')),
    ],
      rows: data.map((asistencia) {
        return DataRow(
          cells: [
             DataCell(Text(asistencia['codigo'] ?? 'No')),
            DataCell(Text(asistencia['name'] ?? 'No')),
          ],
        );
      }).toList(),
    );
}
void buildDataTableWidget3(List<Map<String, dynamic>> data) {
  dataTableWidget3 =  DataTable(
    headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 194, 194, 194),
      ),
      columns: const [
      DataColumn(label: Text('Total Asist')),
    ],
      rows: data.map((asistencia) {
        return DataRow(
          color: MaterialStateProperty.all(const Color.fromARGB(255, 194, 194, 194)),
          cells: [
            DataCell(Text(asistencia['Total'])),
          ],
        );
      }).toList(),
    );
}
void buildDataTableWidget4(List<Map<String, dynamic>> data) {
  dataTableWidget4 =  DataTable(
    headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 139, 139, 139),
      ),
      columns: const [
      DataColumn(label: Text('% Asist.')),
    ],
      rows: data.map((asistencia) {
        return DataRow(
          color: MaterialStateProperty.all(const Color.fromARGB(255, 139, 139, 139)),
          cells: [
            DataCell(Text('${asistencia['% Asisitencia']}%')),
          ],
        );
      }).toList(),
    );
}
Future<void> fetchAsistencias(String codigo,String fechaI) async {
  final codigoCurso = codigo;
  final fechaInicio = fechaI;
  String fechaFin;
  List<DateTime> fechasRango = [];
   DateTime now = DateTime.now();
  String fechaF = DateFormat('yyyy-MM-dd').format(now); // Formato de fecha sin hora
    
    DateTime fechaFinDateTime = DateTime.parse(fechaF);
    fechaFinDateTime = fechaFinDateTime.add(const Duration(days: 1));
    fechaFin = fechaFinDateTime.toLocal().toString().split(' ')[0];
  // Si fechaI y fechaF son iguales, sumar un día a fechaF
  
    DateTime fechaIn = DateTime.parse(fechaInicio);
    DateTime fechaFinal = DateTime.parse(fechaFin);
    for (var i = fechaIn; i.isBefore(fechaFinal) || i.isAtSameMomentAs(fechaFinal); i = i.add(const Duration(days: 1))) {
      if (i.weekday == 1 || i.weekday == 3) {
        fechasRango.add(i);
      }
    }
    if(fechaFinal.weekday == 1 || fechaFinal.weekday == 3 ){
      fechasRango.removeLast();
    }
    Duration duracion = fechaFinal.difference(fechaIn);
    int diasEnRango = duracion.inDays;
  
  print('FechaFinal: $fechaFin');
  print('FechaRango: $fechasRango');

  print('Días en el rango de fechas: $diasEnRango');

 
  final url = 'http://3.22.217.187:80/api/v2/asistencias/$codigoCurso/$fechaInicio/$fechaFin/';
  const token = 'd4ae05cada6fb009c9fc5197d6b7c84a5d3c54b5';
  
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Token $token'},
  );
  
  if (response.statusCode == 200) {
    final asistencias = json.decode(response.body);
    print("asistenciasGenerales: $asistencias");
    List<Map<String, dynamic>> asistenciasFinalesMostrar1 = [];
    for (var asistencia in asistencias) {
      asistenciasFinalesMostrar1.add(asistencia);
    }
    setState(() {
      asistenciasFinalesMostrar = asistenciasFinalesMostrar1;
    });


    // Crear una lista para almacenar los registros completos
    List<Map<String, dynamic>> registrosCompletos = [];

    for (var alumno in alumnosfinal) {
    Map<String, dynamic> registro = {
      'name': alumno['name'],
      'codigo': alumno['codigo'],
    };

    int totalAsistencias = 0;
    int totalfechas = 0;
    for (var fecha in fechasRango) {
      String fechaFor = fecha.toLocal().toString().split(' ')[0];
      totalfechas++;
      final matchingAsistencia = asistencias.firstWhere(
        (asistencia) {
          DateTime asistenciaDate = DateTime(
            int.parse(asistencia['fecha_hora_asistencia'].split('-')[0]),
            int.parse(asistencia['fecha_hora_asistencia'].split('-')[1]),
            int.parse(asistencia['fecha_hora_asistencia'].split('-')[2].split(' ')[0]),
          ).toLocal();

          return asistencia['nombre_usuario'] == alumno['name'] &&
                 asistenciaDate.year == fecha.year &&
                 asistenciaDate.month == fecha.month &&
                 asistenciaDate.day == fecha.day;
        },
        orElse: () => null,
      );

      if (matchingAsistencia != null) {
        registro[fechaFor] = '1'; // Asistió
        totalAsistencias++;
      } else {
        registro[fechaFor] = '0'; // No asistió
      }
    }
    double porcentaje = (totalAsistencias/totalfechas)*100;
    registro['Total'] = totalAsistencias.toString();
    registro['% Asisitencia'] = porcentaje.toInt().toString();
    registrosCompletos.add(registro);
  }
    setState(() {
      registroFinal = registrosCompletos;
    });
    print('registrosCompletos: $registrosCompletos');
    

    // Build the DataTable widget with updated data for all alumnos
    buildDataTableWidget1(registroFinal);
    setState(() {
      showDataTable = true; // Show the DataTable
    });
  } else {
    print("Error en la solicitud: ${response.statusCode}");
  }
}
}