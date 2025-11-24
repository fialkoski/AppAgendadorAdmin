import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {

  static String getWeekdayName(DateTime date) {
    // Lista com os dias da semana em português
    const weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];

    // O DateTime.weekday retorna de 1 (segunda) a 7 (domingo), ajustamos o índice
    return weekdays[date.weekday - 1];
  }

  static salvaDadosLocal(String chave, String valor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(chave, valor);
  }

  static Future<String> buscarDadosLocal(String chave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(chave) ?? '';
  }

  static String formatarData(String data, {apenasDataFormatada = false}) {
    StackTrace.current;
    // Convertendo para um objeto DateTime
    if (apenasDataFormatada) {
      DateTime dateTime = DateTime.parse(data);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else {
      String ano = '';
      String mes = '';
      String dia = '';
      // Divide a string usando '-' como delimitador
      List<String> partes = data.split('-');

      // Reorganiza as partes no formato desejado
      if (partes[2].length == 4) {
        ano = partes[2];
        mes = partes[1];
        dia = partes[0];
        return "$ano-$mes-$dia";
      } else {
        return data;
      }
    }
  }

  static Color? statusAgendamento(String data) {
    List<String> partesData = data.split('/');
    String verificaAgenda =
        "${partesData[2]}-${partesData[1]}-${partesData[0]}";

    DateTime hoje = DateTime.now();
    // Data específica
    DateTime dataEspecifica = DateTime.parse(verificaAgenda);

    // Comparação
    if (hoje.year == dataEspecifica.year &&
        hoje.month == dataEspecifica.month &&
        hoje.day == dataEspecifica.day) {
      return Colors.orangeAccent[100];
    } else if (hoje.isBefore(dataEspecifica)) {
      return Colors.green[100];
    } else {
      return Colors.deepOrangeAccent[200];
    }
  }

  // Função para converter o formato "dd-MM-yyyy" para o formato "yyyy-MM-dd"
  static String dataFormatadaVisual(String date) {
    List<String> partesData = Util.formatarData(
      date,
      apenasDataFormatada: true,
    ).split('-');
    return "${partesData[2]}/${partesData[1]}/${partesData[0]}";
  }

  static Future<bool> checkImageAccessibility(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      debugPrint('Verificando URL $url: Status ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao verificar URL $url: $e');
      return false;
    }
  }
}
