import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../platform/receipt_file_exists.dart';
import 'receipt_disk_image.dart';
import 'receipt_placeholder_widget.dart';

class ReceiptImagePreview extends StatelessWidget {
  const ReceiptImagePreview({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
  });

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }
    if (kIsWeb || path.startsWith('http')) {
      return Image.network(
        path,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const ReceiptImagePlaceholder(),
      );
    }
    if (!receiptFileExistsSync(path)) {
      return const ReceiptImagePlaceholder();
    }
    return receiptDiskImage(path, fit);
  }
}
