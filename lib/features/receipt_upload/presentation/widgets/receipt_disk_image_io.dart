import 'dart:io' show File;

import 'package:flutter/material.dart';

import 'receipt_placeholder_widget.dart';

Widget receiptDiskImage(String path, BoxFit fit) {
  return Image.file(
    File(path),
    fit: fit,
    gaplessPlayback: true,
    errorBuilder: (_, __, ___) => const ReceiptImagePlaceholder(),
  );
}
