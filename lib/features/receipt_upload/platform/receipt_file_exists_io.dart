import 'dart:io' show File;

bool receiptFileExistsSync(String path) {
  if (path.isEmpty) {
    return false;
  }
  if (path.startsWith('http')) {
    return true;
  }
  try {
    return File(path).existsSync();
  } catch (_) {
    return false;
  }
}
