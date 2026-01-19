import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

/// Diálogo de carga que muestra un indicador y un mensaje
/// No puede ser cerrado por el usuario hasta que se cierre programáticamente
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, this.message});

  final String? message;

  /// Muestra el diálogo de carga
  /// Retorna el BuildContext del diálogo para poder cerrarlo después
  static Future<void> show(BuildContext context, {String? message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Cierra el diálogo de carga si está abierto
  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // No se puede cerrar con el botón de retroceso
      child: AlertDialog(
        contentPadding: EdgeInsets.all(context.xl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCircularProgressIndicator(dimension: 24),
            SizedBox(height: context.lg),
            Text(
              message ?? context.l10n.loadingDialogMessage,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
