import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../navigation_bar/nav_bar_button.dart';
import '../service/downloadexel.dart';

class DeanContentTable extends StatefulWidget {
  const DeanContentTable({super.key});

  @override
  State<DeanContentTable> createState() => _DeanContentTableState();
}

class _DeanContentTableState extends State<DeanContentTable> {
  List<String> cursos = [];
  List<Map<String, dynamic>>  cursoTotal = [];
  String? codigoCursoSeleccionado;
  String? selectedCurso;
  String? dropdownValueCurso;
  List<Map<String, dynamic>> asistenciasFinalesMostrar = [];
  List<Map<String, dynamic>>  alumnosfinal = [];
  List<Map<String, dynamic>>  registroFinal = [];
  List<Map<String, dynamic>>  registroFinal2 = [];
  bool showDataTable = false;
  Widget? dataTableWidget;
  Widget? dataTableWidgetTabla2;
  List<DateTime>? fechaRango;
  String table = 'tabla 1';

  int currentSortColumn = 2;
  bool isAscending = true;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                width: 250,
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

              const SizedBox(width: 10),

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
              SizedBox(width: MediaQuery.of(context).size.width/3,),

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
                  downloadExcel(table == 'tabla 1'?registroFinal:registroFinal2);
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
            const SizedBox(height: 20),
            Container(
              child: showDataTable?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: table == 'tabla 1'? const Color.fromARGB(255, 194, 194, 194):Colors.transparent,
                    child: NavBarButton(onTap: (){
                    setState(() {
                      table = 'tabla 1'; // Mostrar el DataTable cuando se haga clic
                    });
                    }, text: 'Tabla 1'),
                  ),
                  Container(
                    color: table == 'tabla 2'? const Color.fromARGB(255, 194, 194, 194):Colors.transparent,
                    child: NavBarButton(onTap: (){
                    setState(() {
                      table = 'tabla 2'; // Mostrar el DataTable cuando se haga clic
                    });
                    }, text: 'Tabla 2'),
                  )
                ],
              ):Container(),
            ),
            Container(
              color: Colors.white,
              //padding: const EdgeInsets.only(left: 10, right: 10),
              child: showDataTable 
              ? 
              table == 'tabla 1'?
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: 
                  Container(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: dataTableWidget,
                  ),
                  ),
              ):SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: dataTableWidgetTabla2,
                      ),
                      ),
              )
              : Container(),
          ),

          ],
        ),
      ),)
;
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
void buildDataTableWidget(List<Map<String, dynamic>> data) {
  dataTableWidget =  DataTable(
    headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 209, 213, 216),
      ),
      columns: const [
      DataColumn(label: Text('Cant. Alumnos')),
      DataColumn(label: Text('Fecha I')),
      DataColumn(label: Text('Fecha F')),
      DataColumn(label: Text('Asistencia')),
      DataColumn(label: Text('Falta')),

    ],
      rows: data.map((asistencia) {
        return DataRow(
          cells: [
            DataCell(Text('${asistencia['Cant. Alumnos']}')),
            DataCell(Text('${asistencia['Fecha I']}')),
            DataCell(Text('${asistencia['Fecha F']}')),
            DataCell(Text('${asistencia['Asisitencia']}')),
            DataCell(Text('${asistencia['Falta']}')),
          ],
        );
      }).toList(),
    );
}

void buildDataTableWidgetTable2(List<Map<String, dynamic>> data) {
  dataTableWidgetTabla2 =  DataTable(
    sortColumnIndex: currentSortColumn,
    sortAscending: isAscending,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => const Color.fromARGB(255, 209, 213, 216),
      ),
      
      columns:   [
        const DataColumn(label: Text('Foto'),
        ),
        DataColumn(label: const Text('Codigo'),
          onSort: (columnIndex, _) {
        setState(() {
          if (currentSortColumn == columnIndex) {
            isAscending = !isAscending;
          } else {
            currentSortColumn = columnIndex;
            isAscending = true;
          }

          if (isAscending) {
            data.sort((a, b) => (a['codigo'] ?? '').compareTo(b['codigo'] ?? ''));
          } else {
            data.sort((a, b) => (b['codigo'] ?? '').compareTo(a['codigo'] ?? ''));
          }
        });
        print('Columna ordenada: $columnIndex, Orden ascendente: $isAscending');
        buildDataTableWidgetTable2(registroFinal2);
      },
        ),
        DataColumn(
      label: const Text('Nombre'),
      onSort: (columnIndex, _) {
        setState(() {
          if (currentSortColumn == columnIndex) {
            isAscending = !isAscending;
          } else {
            currentSortColumn = columnIndex;
            isAscending = true;
          }

          if (isAscending) {
            data.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
          } else {
            data.sort((a, b) => (b['name'] ?? '').compareTo(a['name'] ?? ''));
          }
        });
        print('Columna ordenada: $columnIndex, Orden ascendente: $isAscending');
        buildDataTableWidgetTable2(registroFinal2);
      },
      
       
    ),
        const DataColumn(label: Text('Asistio')),
        const DataColumn(label: Text('Coordenada X')),
        const DataColumn(label: Text('Coordenada Y')),
        DataColumn(label: const Text('fecha'),
          onSort: (columnIndex, _) {
        setState(() {
          if (currentSortColumn == columnIndex) {
            isAscending = !isAscending;
          } else {
            currentSortColumn = columnIndex;
            isAscending = true;
          }

          if (isAscending) {
            data.sort((a, b) => (a['fecha_hora_asistencia'] ?? '').compareTo(b['fecha_hora_asistencia'] ?? ''));
          } else {
            data.sort((a, b) => (b['fecha_hora_asistencia'] ?? '').compareTo(a['fecha_hora_asistencia'] ?? ''));
          }
        });
        print('Columna ordenada: $columnIndex, Orden ascendente: $isAscending');
        buildDataTableWidgetTable2(registroFinal2);
      },
          ),
      ],
      rows: data.map((asistencia) {
        return DataRow(
          cells: [
            DataCell(
              asistencia['urlfotoasistencia'] != null && Uri.parse(asistencia['urlfotoasistencia']).isAbsolute
                ? Image.network(asistencia['urlfotoasistencia'], scale: 1, width: 60)
                : const Text('x'),
            ),
            DataCell(Text(asistencia['codigo'])),
            DataCell(Text(asistencia['name'])),
            DataCell(Text(asistencia['asistencia'] ?? 'No')), // Puedes mostrar 'No' si el valor es nulo
            DataCell(Text(asistencia['coordenada_x'] ?? '-')),
            DataCell(Text(asistencia['coordenada_y'] ?? '-')),
            DataCell(Text(asistencia['fecha_hora_asistencia'] ?? '-')),
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
    if ((i.weekday == 1 || i.weekday == 3) && codigoCurso == '2023222') {
      fechasRango.add(i);
    }else if(i.weekday == 4 && codigoCurso == '0665482'){
      fechasRango.add(i);
    }
    }

    if(fechaFinal.weekday == 1 || fechaFinal.weekday == 3 || fechaFinal.weekday == 4){
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
    List<Map<String, dynamic>> registrosCompletos2 = [];
    int totalAlumnos = 0;
    int totalAsistencias = 0;
    int totalfechas = 0;
    String fechaFor = fechaI;
    Map<String, dynamic> registro = {
    };
    for (var alumno in alumnosfinal) {
      totalAlumnos++;
      totalfechas = 0;
    for (var fecha in fechasRango) {
      fechaFor = fecha.toLocal().toString().split(' ')[0];
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
        //registro[fechaFor] = '1'; // Asistió
        totalAsistencias++;
      } else {
        //registro[fechaFor] = '0'; // No asistió
      }
    }
  }
  for(var fecha in fechasRango){
    // Iterar a través de cada alumno en alumnosfinal
    for (var alumno in alumnosfinal) {
      Map<String, dynamic> registro2 = {};

      final matchingAsistencia = asistencias.firstWhere(
        (asistencia) {
        DateTime asistenciaDate = DateTime(
          int.parse(asistencia['fecha_hora_asistencia'].split('-')[0]), // Año
          int.parse(asistencia['fecha_hora_asistencia'].split('-')[1]), // Mes
          int.parse(asistencia['fecha_hora_asistencia'].split('-')[2].split(' ')[0]), // Día
        ).toLocal();
        
        DateTime fechaDate = fecha.toLocal();
        
        return asistencia['nombre_usuario'] == alumno['name'] &&
               asistenciaDate.year == fechaDate.year &&
               asistenciaDate.month == fechaDate.month &&
               asistenciaDate.day == fechaDate.day;
      },
      orElse: () => null,
    );
      String fechafor = fecha.toLocal().toString().split(' ')[0];
      if (matchingAsistencia != null) {
        // Alumno asistió
        registro2['codigo'] = alumno['codigo'];
        registro2['name'] = alumno['name'];
        registro2['asistencia'] = 'Asistió';
        registro2['coordenada_x'] = matchingAsistencia['coordenada_x'];
        registro2['coordenada_y'] = matchingAsistencia['coordenada_y'];
        registro2['fecha_hora_asistencia'] = matchingAsistencia['fecha_hora_asistencia'];
        registro2['urlfotoasistencia'] = matchingAsistencia['urlfotoasistencia'];
        print('AlumnoRecorrido12: $matchingAsistencia');
      } else {
        // Alumno no asistio
        registro2['codigo'] = alumno['codigo'];
        registro2['name'] = alumno['name'];
        registro2['asistencia'] = 'No asistió';
        registro2['coordenada_x'] = '---';
        registro2['coordenada_y'] = '---';
        registro2['fecha_hora_asistencia'] = fechafor;
        registro2['urlfotoasistencia'] = null;
      }
      registrosCompletos2.add(registro2);
    }
    }
  double porcentaje = (totalAsistencias/(totalfechas*totalAlumnos))*100;
  int restoPorcentaje = 100 - porcentaje.toInt();
    registro['Cant. Alumnos'] = totalAlumnos.toString();
    registro['Fecha I'] = fechaI;
    registro['Fecha F'] = fechaFor;
    //registro['Total'] = totalAsistencias.toString();
    registro['Asisitencia'] = '${porcentaje.toInt().toString()}%';
    registro['Falta'] = '${restoPorcentaje.toString()}%';
    registrosCompletos.add(registro);
    setState(() {
      registroFinal = registrosCompletos;
      registroFinal2 = registrosCompletos2;
    });

    // Build the DataTable widget with updated data for all alumnos
    buildDataTableWidgetTable2(registroFinal2);
    buildDataTableWidget(registroFinal);
    setState(() {
      showDataTable = true; // Show the DataTable
    });
  } else {
    print("Error en la solicitud: ${response.statusCode}");
  }
}
}