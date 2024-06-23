// ignore_for_file: camel_case_types
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paginaweb/service/downloadexel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class opcionesBoton extends StatefulWidget {
  const opcionesBoton({super.key});

  @override
  State<opcionesBoton> createState() => _opcionesBotonState();
}
List<Map<String, dynamic>>  alumnos = [];
List<Map<String, dynamic>>  alumnosfinal = [];
List<Map<String, dynamic>>  registroFinal = [];


class _opcionesBotonState extends State<opcionesBoton> {
  String? dropdownValueCurso;
  PickerDateRange? _pickedDateRange1;
  List<String> cursos = [];
  String? selectedCurso;
  String? codigoCursoSeleccionado;
  bool showDataTable = false;
  Widget? dataTableWidget;
  String? fechaI;
  String? fechaf;
  List<Map<String, dynamic>> asistenciasFinalesMostrar = [];
  
  @override
  void initState() {
    super.initState();
    cursosTotal();
  }

  Future<void> _showDatePickers11(BuildContext context) async {
     final PickerDateRange? picked = await showDialog(
        context: context,
        builder: (BuildContext builder) {
          return AlertDialog(
          content: Container(
            width: 300, // Ancho deseado
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 300, // Alto deseado
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.range,
                    headerHeight: 100,
                    showActionButtons: true,
                    showNavigationArrow: true,
                    onSubmit: (Object? val) {
                      Navigator.of(context).pop(val); // Devolver el rango seleccionado al cerrar el modal
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null && picked != _pickedDateRange1) {
      setState(() {
        _pickedDateRange1 = picked;
      });
    }
  }

  String _getSelectedDateRangeText() {
    if (_pickedDateRange1 == null) {
      return 'SELECCIONAR RANGO DE FECHAS';
    } else {
      setState(() {
        fechaI = _pickedDateRange1!.startDate!.toLocal().toString().split(' ')[0];
        fechaf = _pickedDateRange1!.endDate!.toLocal().toString().split(' ')[0];
      });
      return 'Del ${_pickedDateRange1!.startDate!.toLocal().toString().split(' ')[0]} a ${_pickedDateRange1!.endDate!.toLocal().toString().split(' ')[0]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container( 
      child: Padding(
        padding: const EdgeInsets.all(20),
      child:  Column(
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
                    final cursoInfo = alumnos.firstWhere((curso) => curso['nombre_curso'] == newvalue, orElse: () =>{'codigo_curso': null});
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

              Container(
                width: 310,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        fixedSize: const Size(310,55),
                        backgroundColor: const Color.fromARGB(255, 223, 227, 230),
                        side: const BorderSide(color: Colors.black),
                        ),
                  onPressed: () => _showDatePickers11(context),
                  child: Row(
                    children: [
                      Text(
                    _getSelectedDateRangeText(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Expanded(child: Text("")),
                  const Icon(Icons.calendar_month, color: Colors.black,),
                    ],
                  )
                ),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    fixedSize: const Size(110,55),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Ajusta el radio del borde
       
                  ),
                  ),
                onPressed:
                  codigoCursoSeleccionado==null && _getSelectedDateRangeText() == 'SELECCIONAR RANGO DE FECHAS' 
                  ?(){print('Fecha: ${_getSelectedDateRangeText()}');}:
                  ()async{
                    await fetchData(codigoCursoSeleccionado!);
                    await fetchAsistencias(codigoCursoSeleccionado!,fechaI!,fechaf!);
                    buildDataTableWidget(registroFinal);
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
                    Icon(Icons.search, color: Colors.black,),
                  ],
                )
              ),

              const SizedBox(width: 485),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
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
          const SizedBox(height: 20),
          Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: showDataTable ? dataTableWidget : Container(),
                ),
              ),
        ]
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
      print('Cursos Enviados: $cursosData');
      print('Cursos Enviados: ${cursosData[1]}');

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
        cursos = cursosList2;
        alumnos = mapList; // Actualiza la lista de cursos en el estado del widget
        print('cursosend: $cursos');
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
        ;
      } else {
        print("Error al obtener datos: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
  void buildDataTableWidget(List<Map<String, dynamic>> data) {
  dataTableWidget =  DataTable(
    
      columns:  [
        const DataColumn(label: Text('Foto')),
        const DataColumn(label: Text('Codigo')),
        DataColumn(
          label: const Text('Nombre'),
          onSort: (columnIndex,ascending){
            setState(() {
            if (ascending) {
              data.sort((a, b) => a['name'].compareTo(b['name']));
            } else {
              data.sort((a, b) => b['name'].compareTo(a['name']));
            }
          });
          },
        ),
        const DataColumn(label: Text('Asistio')),
        const DataColumn(label: Text('Coordenada X')),
        const DataColumn(label: Text('Coordenada Y')),
        DataColumn(label: const Text('fecha'),
        onSort: (columnIndex,ascending){
            setState(() {
                  if (ascending) {
                    data.sort((a, b) {
                      DateTime dateA = DateTime.parse(a['fecha_hora_asistencia']);
                      DateTime dateB = DateTime.parse(b['fecha_hora_asistencia']);
                      return dateA.compareTo(dateB);
                    });
                  } else {
                    data.sort((a, b) {
                      DateTime dateA = DateTime.parse(a['fecha_hora_asistencia']);
                      DateTime dateB = DateTime.parse(b['fecha_hora_asistencia']);
                      return dateB.compareTo(dateA);
                    });
                  }
                });
          },),
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

Future<void> fetchAsistencias(String codigo,String fechaI,String fechaF) async {
  final codigoCurso = codigo;
  final fechaInicio = fechaI;
  String fechaFin;
  List<DateTime> fechasRango = [];

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

    for(var fecha in fechasRango){
    // Iterar a través de cada alumno en alumnosfinal
    for (var alumno in alumnosfinal) {
      Map<String, dynamic> registro = {};

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
        registro['codigo'] = alumno['codigo'];
        registro['name'] = alumno['name'];
        registro['asistencia'] = 'Asistió';
        registro['coordenada_x'] = matchingAsistencia['coordenada_x'];
        registro['coordenada_y'] = matchingAsistencia['coordenada_y'];
        registro['fecha_hora_asistencia'] = matchingAsistencia['fecha_hora_asistencia'];
        registro['urlfotoasistencia'] = matchingAsistencia['urlfotoasistencia'];
        print('AlumnoRecorrido12: $matchingAsistencia');
      } else {
        // Alumno no asistio
        registro['codigo'] = alumno['codigo'];
        registro['name'] = alumno['name'];
        registro['asistencia'] = 'No asistió';
        registro['coordenada_x'] = '---';
        registro['coordenada_y'] = '---';
        registro['fecha_hora_asistencia'] = fechafor;
        registro['urlfotoasistencia'] = null;
      }
      registrosCompletos.add(registro);
    }
    }
    setState(() {
      registroFinal = registrosCompletos;
      
    });
    print('registrosCompletos: $registrosCompletos');
    

    // Build the DataTable widget with updated data for all alumnos
    buildDataTableWidget(registroFinal);
    setState(() {
      showDataTable = true; // Show the DataTable
    });
  } else {
    print("Error en la solicitud: ${response.statusCode}");
  }
}
}