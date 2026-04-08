/// Mock OCR / parsed receipt fields for the preview step.
class ReceiptPreviewData {
  const ReceiptPreviewData({
    required this.dateLabel,
    required this.totalLabel,
    required this.storeName,
    required this.fdNumber,
  });

  final String dateLabel;
  final String totalLabel;
  final String storeName;
  final String fdNumber;

  static const ReceiptPreviewData mock = ReceiptPreviewData(
    dateLabel: '24 Октября 2023',
    totalLabel: '2 450,00 ₽',
    storeName: 'Азбука Вкуса',
    fdNumber: '#000342991',
  );
}
