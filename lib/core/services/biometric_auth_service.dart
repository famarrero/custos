import 'package:local_auth/local_auth.dart';

/// Servicio para manejar autenticación biométrica (huella digital)
abstract class BiometricAuthService {
  /// Verifica si el dispositivo soporta autenticación biométrica
  Future<bool> isDeviceSupported();

  /// Verifica si hay biométrica disponible y configurada en el dispositivo
  Future<bool> canCheckBiometrics();

  /// Obtiene los tipos de biométrica disponibles en el dispositivo
  Future<List<BiometricType>> getAvailableBiometrics();

  /// Verifica si la huella digital (fingerprint) está disponible
  Future<bool> isFingerprintAvailable();

  /// Autentica usando huella digital
  ///
  /// Retorna true si la autenticación fue exitosa, false si fue cancelada
  /// Lanza una excepción si hay un error
  Future<bool> authenticateWithFingerprint({required String localizedReason});
}

class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> isFingerprintAvailable() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithFingerprint({required String localizedReason}) async {
    try {
      // Verificar que el dispositivo soporte biométrica
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        throw Exception('El dispositivo no soporta autenticación biométrica');
      }

      // Verificar que haya biométrica disponible
      final canCheck = await canCheckBiometrics();
      if (!canCheck) {
        throw Exception('No hay biométrica configurada en el dispositivo');
      }

      // Autenticar con huella digital
      // Usamos biometricOnly: true para requerir solo biométrica, sin fallback a PIN/pattern
      final didAuthenticate = await _localAuth.authenticate(localizedReason: localizedReason, biometricOnly: true);

      return didAuthenticate;
    } on LocalAuthException {
      // Re-lanzar excepciones de local_auth para que el caller pueda manejarlas
      rethrow;
    } catch (e) {
      throw Exception('Error al autenticar con huella digital: ${e.toString()}');
    }
  }
}
