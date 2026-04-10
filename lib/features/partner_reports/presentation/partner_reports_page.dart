import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/widgets/partner_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/partner_theme.dart';

class PartnerReportsPage extends StatefulWidget {
  const PartnerReportsPage({super.key});

  @override
  State<PartnerReportsPage> createState() => _PartnerReportsPageState();
}

class _PartnerReportsPageState extends State<PartnerReportsPage> {
  String _period = '30 дней';
  String _scope = 'Все филиалы';
  bool _exporting = false;

  Future<Directory> _resolveExportDirectory() async {
    final downloads = await getDownloadsDirectory();
    if (downloads != null && await downloads.exists()) {
      return downloads;
    }

    if (Platform.isAndroid) {
      final androidDownloads = Directory('/storage/emulated/0/Download');
      if (await androidDownloads.exists()) {
        return androidDownloads;
      }
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return getTemporaryDirectory();
  }

  Future<void> _exportTestExcel() async {
    if (_exporting) {
      return;
    }
    setState(() => _exporting = true);
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Ratings'];

      sheet.appendRow(<CellValue>[
        TextCellValue('Branch'),
        TextCellValue('Period'),
        TextCellValue('Food'),
        TextCellValue('Service'),
        TextCellValue('Cleanliness'),
        TextCellValue('Staff'),
        TextCellValue('Average'),
        TextCellValue('Date'),
      ]);

      final now = DateTime.now();
      final dateLabel =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final rows = _fakeRowsForExport(_scope, _period, dateLabel);
      for (final row in rows) {
        sheet.appendRow(row);
      }

      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Не удалось сформировать Excel');
      }

      final dir = await _resolveExportDirectory();
      final file = File(
        '${dir.path}${Platform.pathSeparator}partner_ratings_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );
      await file.writeAsBytes(bytes, flush: true);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Excel сохранен: ${file.path}')));
    } on Object catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка экспорта: $e')));
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  List<List<CellValue>> _fakeRowsForExport(
    String scope,
    String period,
    String dateLabel,
  ) {
    final branch = scope == 'Все филиалы' ? 'Network' : scope;
    const scores = <List<int>>[
      [8, 7, 9, 8],
      [9, 8, 8, 8],
      [7, 8, 9, 7],
      [8, 9, 8, 9],
      [9, 9, 9, 8],
    ];
    final rows = <List<CellValue>>[];
    for (var i = 0; i < scores.length; i++) {
      final s = scores[i];
      final food = s[0];
      final service = s[1];
      final clean = s[2];
      final staff = s[3];
      final avg = ((food + service + clean + staff) / 4).toStringAsFixed(2);
      rows.add(<CellValue>[
        TextCellValue(branch),
        TextCellValue(period),
        IntCellValue(food),
        IntCellValue(service),
        IntCellValue(clean),
        IntCellValue(staff),
        TextCellValue(avg),
        TextCellValue(dateLabel),
      ]);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(PartnerTheme.pagePadding),
        children: [
          const PartnerCard(
            child: Text(
              'Настройте период и филиал для формирования отчёта',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _period,
            decoration: const InputDecoration(labelText: 'Период'),
            items: const [
              DropdownMenuItem(value: '7 дней', child: Text('7 дней')),
              DropdownMenuItem(value: '30 дней', child: Text('30 дней')),
              DropdownMenuItem(value: '90 дней', child: Text('90 дней')),
            ],
            onChanged: (v) => setState(() => _period = v ?? _period),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _scope,
            decoration: const InputDecoration(labelText: 'Филиал / сеть'),
            items: const [
              DropdownMenuItem(
                value: 'Все филиалы',
                child: Text('Все филиалы'),
              ),
              DropdownMenuItem(value: 'Центр', child: Text('Центр')),
              DropdownMenuItem(value: 'Север', child: Text('Север')),
            ],
            onChanged: (v) => setState(() => _scope = v ?? _scope),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _exporting ? null : _exportTestExcel,
            icon: const Icon(Icons.download_rounded),
            label: Text(_exporting ? 'Экспорт...' : 'Экспорт в Excel'),
            style: FilledButton.styleFrom(
              backgroundColor: PartnerTheme.accent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
