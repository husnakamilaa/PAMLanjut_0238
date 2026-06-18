import 'package:booking_villa/data/models/booking.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceWidget extends StatelessWidget {
  final BookingModel booking;
  final String villaName;
  final String villaImage;
  final String customerName;
  final String customerEmail;

  const InvoiceWidget({
    super.key,
    required this.booking,
    required this.villaName,
    required this.villaImage,
    required this.customerName,
    required this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd MMMM yyyy');
    final totalNight =
        booking.tglCheckout.difference(booking.tglCheckin).inDays;
    final pricePerNight =
        totalNight > 0 ? booking.totalPrice ~/ totalNight : 0;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "INVOICE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    _statusBadge(booking.statusBooking),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "#${booking.id.substring(0, 8).toUpperCase()}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Diterbitkan: ${dateFormatter.format(booking.createdAt)}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _sectionTitle("Data Pemesan"),
                const SizedBox(height: 12),
                _infoRow(Icons.person_outline, "Nama", customerName),
                const SizedBox(height: 8),
                _infoRow(Icons.email_outlined, "Email", customerEmail),

                const SizedBox(height: 24),

                
                _sectionTitle("Detail Villa"),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    villaImage,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  villaName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),

                const SizedBox(height: 16),

                
                Row(
                  children: [
                    Expanded(
                      child: _dateCard(
                        "Check In",
                        dateFormatter.format(booking.tglCheckin),
                        Icons.login_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateCard(
                        "Check Out",
                        dateFormatter.format(booking.tglCheckout),
                        Icons.logout_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

               
                _sectionTitle("Rincian Biaya"),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _costRow(
                        "Harga / malam",
                        currencyFormatter.format(pricePerNight),
                      ),
                      const SizedBox(height: 10),
                      _costRow(
                        "Jumlah malam",
                        "$totalNight malam",
                      ),
                      if (booking.payment != null) ...[
                        const SizedBox(height: 10),
                        _costRow(
                          "Metode pembayaran",
                          _formatPaymentMethod(booking.payment!),
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Pembayaran",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            currencyFormatter.format(booking.totalPrice),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

               
                Center(
                  child: Text(
                    "Terima kasih telah memesan villa kami!\nSampaikan invoice ini saat check-in.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.navy,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _dateCard(String label, String date, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.navy),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color badgeColor;
    String label;

    switch (status) {
      case 'confirmed':
        badgeColor = Colors.green;
        label = 'Dikonfirmasi';
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        label = 'Dibatalkan';
        break;
      default:
        badgeColor = Colors.blue;
        label = 'Paid';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    final map = {
      'gopay': 'GoPay',
      'bank_transfer': 'Transfer Bank',
      'credit_card': 'Kartu Kredit',
      'qris': 'QRIS',
      'cstore': 'Minimarket',
      'settlement': 'Lunas',
    };
    return map[method.toLowerCase()] ?? method;
  }
}