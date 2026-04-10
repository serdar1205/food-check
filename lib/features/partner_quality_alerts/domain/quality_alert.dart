class QualityAlert {
  const QualityAlert({
    required this.id,
    required this.branch,
    required this.criterion,
    required this.event,
    required this.dateLabel,
  });

  final String id;
  final String branch;
  final String criterion;
  final String event;
  final String dateLabel;
}
