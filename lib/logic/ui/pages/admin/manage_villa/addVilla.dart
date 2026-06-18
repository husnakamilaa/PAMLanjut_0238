import 'package:booking_villa/data/models/villa.dart';
import 'package:booking_villa/logic/ui/components/custom_textfield.dart';
import 'package:booking_villa/logic/ui/components/date_picker.dart';
import 'package:booking_villa/logic/ui/components/formatter.dart';
import 'package:booking_villa/logic/ui/components/image_picker.dart';
import 'package:booking_villa/logic/ui/components/map_picker.dart';
import 'package:booking_villa/logic/ui/components/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_villa/logic/bloc/villa/villa_bloc.dart';
import 'package:booking_villa/logic/bloc/villa/villa_event.dart';
import 'package:booking_villa/logic/bloc/villa/villa_state.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';
import 'package:intl/intl.dart';

class AddVillaPage extends StatefulWidget {
  const AddVillaPage({super.key});

  @override
  State<AddVillaPage> createState() => _AddVillaPageState();
}

class _AddVillaPageState extends State<AddVillaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController notelpController = TextEditingController();
  final TextEditingController mapsController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  String status = 'available';
  DateTime? selectedDate = DateTime.now();
  double? latitude;
  double? longitude;

  String? finalImageUrl;

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    priceController.dispose();
    notelpController.dispose();
    mapsController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tambah Villa",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.navy,
      ),

      body: BlocListener<VillaBloc, VillaState>(
        listener: (context, state) {
          if (state is VillaActionSuccess) {
            context.read<VillaBloc>().add(FetchAllVillas());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Villa berhasil ditambahkan"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pushReplacementNamed(context, '/manage_villa');
          }

          if (state is VillaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },

        child: SingleChildScrollView(
      
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: namaController,
                  label: "Nama Villa",
                  icon: Icons.home_work_outlined,
                ),
                CustomTextField(
                  controller: deskripsiController,
                  label: "Deskripsi",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                CustomTextField(
                  controller: priceController,
                  label: "Harga (Rp)",
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [PriceInputFormatter()],

                  validator: (value) {
                    final clean =
                        value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
                    final price = int.tryParse(clean);
                    if (price == null || price < 50000)
                      return 'Harga minimal Rp 50.000';
                    return null;
                  },
                ),
                CustomTextField(
                  controller: notelpController,
                  label: "No. Telepon / WhatsApp",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneInputFormatter(maxDigits: 13)],
                  validator: (value) {
                    if (value == null || value.length < 10)
                      return 'Nomor HP minimal 10 digit';
                    if (!value.startsWith('08'))
                      return 'Nomor HP harus diawali 08';
                    return null;
                  },
                ),
                CustomTextField(
                  controller: alamatController,
                  label: "Alamat Lengkap",
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text("Pilih Lokasi"),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapPicker()),
                    );

                    if (result != null) {
                      setState(() {
                        latitude = result['latitude'];
                        longitude = result['longitude'];
                      });
                    }
                  },
                ),
                if (latitude != null && longitude != null)
                  VillaMapPreview(latitude: latitude!, longitude: longitude!),
                const SizedBox(height: 10),
                const Text(
                  "Gambar Villa",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomImagePicker(
                  storageBucket: 'villa_image', // bucket terpisah
                  onImageUploaded: (url) {
                    setState(() => finalImageUrl = url);
                  },
                ),

                if (finalImageUrl == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      "Gambar wajib dipilih",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: "Status Ketersediaan",
                    prefixIcon: const Icon(
                      Icons.event_available,
                      color: AppColors.navy,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'available',
                      child: Text("Available"),
                    ),
                    DropdownMenuItem(
                      value: 'Unavailable',
                      child: Text("Unavailable"),
                    ),
                  ],
                  onChanged: (value) => setState(() => status = value!),
                ),

                const SizedBox(height: 20),

                CustomDatePicker(
                  label: "Tanggal Dibuat (Created At)",
                  selectedDate: selectedDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: BlocBuilder<VillaBloc, VillaState>(
                    builder: (context, state) {
                      if (state is VillaLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.navy,
                          ),
                        );
                      }

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
  
                          final isFormValid = _formKey.currentState!.validate();
                      
                          if (!isFormValid) return;

                          if (latitude == null || longitude == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Lokasi Maps wajib dipilih!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; 
                          }

                          if (finalImageUrl == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Gambar wajib dipilih!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate() &&
                              finalImageUrl != null) {
                         
                            final newVilla = VillaModel(
                              namaVilla: namaController.text,
                              deskripsi: deskripsiController.text,
                              price: int.tryParse(priceController.text) ?? 0,
                              notelpVilla: notelpController.text,
                              image: finalImageUrl!,
                              statusAvailable: status,
                              maps: mapsController.text,
                              alamat: alamatController.text,
                              latitude: latitude!,
                              longitude: longitude!,
                              createdAt: selectedDate,
                            );

                           
                            context.read<VillaBloc>().add(
                              AddVillaEvent(newVilla),
                            );
                          }
                        },
                        child: const Text(
                          "Simpan Data Villa",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
