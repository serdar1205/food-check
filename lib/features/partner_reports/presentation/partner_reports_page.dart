import 'package:flutter/material.dart';
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Экспорт в Excel подготовлен (demo)'),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Экспорт в Excel'),
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
