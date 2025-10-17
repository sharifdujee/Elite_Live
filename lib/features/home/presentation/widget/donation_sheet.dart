

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';


class DonationSheet extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController customAmountController = TextEditingController();

  DonationSheet({super.key});

  void show(BuildContext context) {
    Get.bottomSheet(
      this,
      isScrollControlled: true,
    );
  }

  Widget _buildDonationButton(String text, double amount) {
    return Obx(() {
      final isSelected = controller.selectedDonationAmount.value == amount;
      return GestureDetector(
        onTap: () => controller.selectedDonationAmount.value = amount,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.purple : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ethan Walker',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Donation',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                'Choose a donation amount or send a virtual gift to cheer for your favorite entertainer!',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Preset amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDonationButton('\$2.00', 2.00),
                  _buildDonationButton('\$5.00', 5.00),
                  _buildDonationButton('\$10.00', 10.00),
                  _buildDonationButton('\$50.00', 50.00),
                ],
              ),
              const SizedBox(height: 24),

              // Custom amount input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: customAmountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Enter amount...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pay button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    double amount = controller.selectedDonationAmount.value;
                    if (customAmountController.text.isNotEmpty) {
                      final customAmount = double.tryParse(customAmountController.text);
                      if (customAmount != null && customAmount > 0) {
                        amount = customAmount;
                      }
                    }
                    controller.processDonation(amount);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
