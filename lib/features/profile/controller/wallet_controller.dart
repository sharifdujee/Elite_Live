import 'package:get/get.dart';

class WalletController extends GetxController {
  var totalEarning = 16.18.obs;

  var transactions = <Map<String, dynamic>>[
    {
      'title': 'Payment to ABS Fresh',
      'date': 'Sep 28, 2025 - 10:32 AM',
      'amount': 250.00,
    },
    {
      'title': 'Wallet Top-Up (Bkash)',
      'date': 'Sep 26, 2025 - 04:45 PM',
      'amount': 500.00,
    },
    {
      'title': 'Refund from ValAcademy',
      'date': 'Sep 26, 2025 - 04:45 PM',
      'amount': 500.00,
    },
    {
      'title': 'Payment to THRDZ Store',
      'date': 'Sep 20, 2025 - 09:05 PM',
      'amount': 75.00,
    },
    {
      'title': 'Payment to THRDZ Store',
      'date': 'Sep 20, 2025 - 09:05 PM',
      'amount': 75.00,
    },
    {
      'title': 'Payment to THRDZ Store',
      'date': 'Sep 20, 2025 - 09:05 PM',
      'amount': 75.00,
    },
  ].obs;
}
