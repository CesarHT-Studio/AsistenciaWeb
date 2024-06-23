
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

List<int>? generateExcel(List<Map<String, dynamic>> data) {
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // Obtener las claves (nombres de columnas) de los datos
  var columnNames = data[0].keys.toList();

  // Agregar encabezados a la hoja de cálculo
  sheet.appendRow(columnNames);
  // Agregar datos a la hoja de cálculo
  for (var registro in data) {
    var rowData = columnNames.map((columnName) => registro[columnName]).toList();
    sheet.appendRow(rowData);
  }
  // Agregar datos a la hoja de cálculo
  return excel.encode();
}

void downloadExcel(List<Map<String, dynamic>> data) {
  final excelBytes = generateExcel(data);

  final blob = Blob([Uint8List.fromList(excelBytes!)]);
  final url = Url.createObjectUrlFromBlob(blob);

  final anchor = AnchorElement(href: url)
    ..target = 'blank'
    ..download = 'example.xlsx' // Nombre del archivo
    ..text = 'Descargar Excel';

  // Agregar el enlace al DOM y hacer clic en él
  document.body!.append(anchor);
  anchor.click();

  // Limpieza después de la descarga
  document.body!.children.remove(anchor);
  Url.revokeObjectUrl(url);
}