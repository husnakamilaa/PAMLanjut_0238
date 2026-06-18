import 'package:booking_villa/logic/ui/components/bottomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:booking_villa/data/models/booking.dart';
import 'package:booking_villa/data/repositories/booking_repository.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';
import 'package:booking_villa/logic/ui/components/invoice_viewer.dart';

class RiwayatBookingPage extends StatefulWidget {
  const RiwayatBookingPage({super.key});

  @override
  State<RiwayatBookingPage> createState() => _RiwayatBookingPageState();
}

class _RiwayatBookingPageState extends State<RiwayatBookingPage> {
  final BookingRepository _bookingRepo = BookingRepository();
  late Future<List<BookingModel>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = _loadBookings();
  }

  Future<List<BookingModel>> _loadBookings() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Future.value([]);
    }
    return _bookingRepo.getMyBookings(user.id);
  }

  Future<void> _refresh() async {
    setState(() {
      _futureBookings = _loadBookings();
    });
    await _futureBookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Riwayat Booking"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<BookingModel>>(
          future: _futureBookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Gagal memuat riwayat:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ),
                ],
              );
            }

            final bookings = snapshot.data ?? [];

            if (bookings.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Belum ada riwayat booking",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _BookingCard(booking: bookings[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _BookingCard extends StatefulWidget {
  final BookingModel booking;

  const _BookingCard({required this.booking});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  bool _expanded = false;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'paid':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final statusColor = _statusColor(booking.statusBooking);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        booking.villaImage != null &&
                            booking.villaImage!.isNotEmpty
                        ? Image.network(
                            booking.villaImage!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.villaName ?? "Villa",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${DateFormat('dd MMM yyyy').format(booking.tglCheckin)} - ${DateFormat('dd MMM yyyy').format(booking.tglCheckout)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currencyFormatter.format(booking.totalPrice),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor, width: 1),
                        ),
                        child: Text(
                          booking.statusBooking,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  InvoiceViewerWidget(paymentProof: booking.paymentProof),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 70,
      height: 70,
      color: AppColors.lightblue,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.navy,
        size: 24,
      ),
    );
  }
}
