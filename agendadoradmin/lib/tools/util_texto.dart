import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UtilTexto {
  static MaskTextInputFormatter cpfFormatter() {
    return MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  }

  static PhoneInputFormatter telefoneFormatter() {
    return PhoneInputFormatter(
      defaultCountryCode: 'BR',
    );
  }

  static String formatarCpfCnpj(String valor) {
    final digits = valor.replaceAll(RegExp(r'\D'), '');

    if (digits.length <= 11) {
      // CPF → 000.000.000-00
      return digits.replaceAllMapped(
        RegExp(r'^(\d{3})(\d{3})(\d{3})(\d{0,2})'),
        (m) =>
            '${m[1]}.${m[2]}.${m[3]}${m[4] != null && m[4]!.isNotEmpty ? "-${m[4]}" : ""}',
      );
    } else {
      // CNPJ → 00.000.000/0000-00
      return digits.replaceAllMapped(
        RegExp(r'^(\d{2})(\d{3})(\d{3})(\d{4})(\d{0,2})'),
        (m) =>
            '${m[1]}.${m[2]}.${m[3]}/${m[4]}${m[5] != null && m[5]!.isNotEmpty ? "-${m[5]}" : ""}',
      );
    }
  }

  static String formatarTelefone(String valor) {
    final digits = valor.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 10) return valor; // Número inválido

    final ddd = digits.substring(0, 2);
    final parte1 =
        digits.length == 10 ? digits.substring(2, 6) : digits.substring(2, 7);
    final parte2 =
        digits.length == 10 ? digits.substring(6) : digits.substring(7);

    return '($ddd) $parte1-$parte2';
  }
}
