import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Exception thrown when file picker is cancelled by the user
class FilePickerCancelledException implements Exception {
  const FilePickerCancelledException();

  @override
  String toString() => 'File selection cancelled';
}

/// Exception thrown when file extension is invalid
class FileExtensionException implements Exception {
  const FileExtensionException({required this.expectedExtension, required this.actualExtension});

  final String expectedExtension;
  final String actualExtension;

  @override
  String toString() =>
      'El archivo debe tener extensión .$expectedExtension. '
      'Extensión encontrada: .$actualExtension';
}

/// Service for picking files from the device
abstract class FilePickerService {
  /// Picks a file from the device
  ///
  /// Returns the file path if a file was selected, null if cancelled
  /// Throws an exception if there's an error
  Future<String?> pickFile({FileType type = FileType.any, List<String>? allowedExtensions});

  /// Picks a file and validates its extension
  ///
  /// Returns the file path if valid
  /// Throws [FilePickerCancelledException] if user cancelled
  /// Throws [FileExtensionException] if extension is invalid
  /// Throws [Exception] for other errors
  Future<String> pickFileWithExtensionValidation({required String expectedExtension, FileType type = FileType.any});
}

class FilePickerServiceImpl implements FilePickerService {
  FilePickerServiceImpl();

  @override
  Future<String?> pickFile({FileType type = FileType.any, List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(type: type, allowedExtensions: allowedExtensions);

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final platformFile = result.files.single;
    return platformFile.path;
  }

  @override
  Future<String> pickFileWithExtensionValidation({
    required String expectedExtension,
    FileType type = FileType.any,
  }) async {
    final filePath = await pickFile(type: type);

    if (filePath == null) {
      throw const FilePickerCancelledException();
    }

    // Validate extension
    final file = File(filePath);
    final extension = file.path.split('.').last.toLowerCase();

    if (extension != expectedExtension.toLowerCase()) {
      throw FileExtensionException(expectedExtension: expectedExtension, actualExtension: extension);
    }

    return filePath;
  }
}
