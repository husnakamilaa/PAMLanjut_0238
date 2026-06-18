import 'package:booking_villa/logic/ui/components/map_preview.dart';
import 'package:booking_villa/logic/ui/pages/admin/manage_villa/editVilla.dart';
import 'package:booking_villa/logic/ui/pages/customer/bookingVilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_villa/data/models/villa.dart';
import 'package:booking_villa/logic/bloc/villa/villa_bloc.dart';
import 'package:booking_villa/logic/bloc/villa/villa_event.dart';
import 'package:booking_villa/logic/bloc/villa/villa_state.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class KatalogVillaScreen extends StatelessWidget {
  final VillaModel villa;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  const KatalogVillaScreen({
    super.key,
    required this.villa,
    this.checkInDate,
    this.checkOutDate,
  });

  Future<void> _openWhatsApp(BuildContext context) async {
    String nomor = villa.notelpVilla.replaceAll(RegExp(r'[\s\-]'), '');

    if (nomor.startsWith('0')) {
      nomor = '62${nomor.substring(1)}';
    }

    nomor = nomor.replaceAll('+', '');

    final Uri waUri = Uri.parse('https://wa.me/$nomor');


    try {
      await launchUrl(waUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("ERROR WA = $e");
    }
  }

  Future<void> _openMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${villa.latitude},${villa.longitude}',
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = villa.statusAvailable == 'available';
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<VillaBloc, VillaState>(
        listener: (context, state) {
          if (state is VillaActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Villa berhasil diperbarui"),
                backgroundColor: Colors.green,
              ),
            );
            context.read<VillaBloc>().add(FetchAllVillas());
            Navigator.pop(context);
          }
          if (state is VillaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
    
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.navy,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: villa.image.isNotEmpty
                    ? Image.network(
                        villa.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
 
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            villa.namaVilla,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: (isAvailable ? Colors.green : Colors.red)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isAvailable ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isAvailable
                                    ? Icons.check_circle_outline
                                    : Icons.cancel_outlined,
                                size: 14,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                villa.statusAvailable,
                                style: TextStyle(
                                  color: isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

              
                    Text(
                      "${currencyFormatter.format(villa.price)} / malam",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                 
                    _buildSectionTitle("Lokasi"),
                    const SizedBox(height: 10),

                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      text: villa.alamat,
                    ),
                    const SizedBox(height: 16),

                    VillaMapPreview(
                      latitude: villa.latitude!,
                      longitude: villa.longitude!,
                      onTap: _openMaps,
                    ),

                    if (villa.latitude != null && villa.longitude != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.navy,
                            side: const BorderSide(color: AppColors.navy),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _openMaps(),
                          icon: const Icon(Icons.map_outlined, size: 18),
                          label: const Text(
                            "Buka di Google Maps",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    _buildSectionTitle("Deskripsi"),
                    const SizedBox(height: 10),
                    Text(
                      villa.deskripsi,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    _buildSectionTitle("Hubungi via WhatsApp"),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF25D366,
                          ), 
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => _openWhatsApp(context),
                        icon: const Icon(Icons.chat_outlined, size: 20),
                        label: Text(
                          villa.notelpVilla,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    if (checkInDate != null && checkOutDate != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.login,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Check In",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'dd MMM, yyyy',
                                  ).format(checkInDate!),
                                  style: const TextStyle(
                                    color: AppColors.navy,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.logout,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Check Out",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'dd MMM, yyyy',
                                  ).format(checkOutDate!),
                                  style: const TextStyle(
                                    color: AppColors.navy,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1),
                    ],

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          "Booking Sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingPage(
                                villa: villa,
                                initialCheckIn: checkInDate,
                                initialCheckOut: checkOutDate,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.lightblue,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 60,
          color: AppColors.navy,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.navy,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.navy),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isLink ? Colors.blue.shade600 : Colors.grey.shade700,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}
