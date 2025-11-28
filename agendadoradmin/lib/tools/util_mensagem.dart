import 'package:flutter/material.dart';

class UtilMensagem {
  static Future<void> showSucesso(
    BuildContext context,
    String mensagem, {
    VoidCallback? onPressed,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: Colors.white)),
        action: (onPressed == null)
            ? null
            : SnackBarAction(label: 'Ver detalhes', onPressed: onPressed),
        width: 400,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        backgroundColor: Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> showErro(
    BuildContext context,
    String mensagem, {
    VoidCallback? onPressed,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: Colors.white),),
        action: (onPressed == null)
            ? null
            : SnackBarAction(label: 'Ver detalhes', onPressed: onPressed),
        width: 400,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 10),
        backgroundColor: Color(0xFFD32F2F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
