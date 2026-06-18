import 'package:booking_villa/logic/bloc/auth/auth_bloc.dart';
import 'package:booking_villa/logic/bloc/auth/auth_event.dart';
import 'package:booking_villa/logic/bloc/auth/auth_state.dart';
import 'package:booking_villa/logic/bloc/profiles/profiles_bloc.dart';
import 'package:booking_villa/logic/bloc/profiles/profiles_event.dart';
import 'package:booking_villa/logic/bloc/profiles/profiles_state.dart';
import 'package:booking_villa/logic/bloc/villa/villa_bloc.dart';
import 'package:booking_villa/logic/bloc/villa/villa_event.dart';
import 'package:booking_villa/logic/bloc/villa/villa_state.dart';
import 'package:booking_villa/logic/ui/components/bottomNavbar.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';
import 'package:booking_villa/logic/ui/components/custom_card_villa.dart';
import 'package:booking_villa/logic/ui/components/date_picker.dart';
import 'package:booking_villa/logic/ui/components/promoCarousel.dart';
import 'package:booking_villa/logic/ui/components/search_bar.dart';
import 'package:booking_villa/logic/ui/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  bool _isLoadingPayment = false;

  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<VillaBloc>().add(FetchAllVillas());
    context.read<ProfileBloc>().add(FetchProfile());
    // scroll pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        final villaState = context.read<VillaBloc>().state;
        if (villaState is VillaLoaded &&
            villaState.hasMore &&
            !villaState.isFilteredByDate) {
          context.read<VillaBloc>().add(LoadMoreVillas());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      String displayName = "Traveler";
                      String? avatarUrl;

                      if (state is ProfileLoaded) {
                        displayName = state.profile.nama.isNotEmpty
                            ? state.profile.nama
                            : "Traveler";
                        avatarUrl = state.profile.image.isNotEmpty
                            ? state.profile.image
                            : null;
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                       
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, $displayName 👋",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.navy,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Welcome to Traveler",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Logout + Avatar
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    LogoutRequested(),
                                  );
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: AppColors.navy,
                                ),
                                tooltip: "Logout",
                              ),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.navy,
                                backgroundImage: avatarUrl != null
                                    ? NetworkImage(avatarUrl)
                                    : null,
                                child: avatarUrl == null
                                    ? Text(
                                        displayName.isNotEmpty
                                            ? displayName[0].toUpperCase()
                                            : 'T',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

  
                CustomSearchBar(
                  hintText: "Search your dream villa...",
                  onChanged: (query) {
                    searchQuery = query;
                    context.read<VillaBloc>().add(SearchVillaEvent(query));
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePicker(
                              label: "check-in",
                              selectedDate: checkInDate,
                              onDateChanged: (newDate) =>
                                  setState(() => checkInDate = newDate),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomDatePicker(
                              label: "check-out",
                              selectedDate: checkOutDate,
                              onDateChanged: (newDate) =>
                                  setState(() => checkOutDate = newDate),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text("Cari Villa Tersedia"),
                          onPressed: () {
                            if (checkInDate == null || checkOutDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Pilih tanggal check-in dan check-out",
                                  ),
                                ),
                              );
                              return;
                            }
                            print(
                              "checkIn: $checkInDate, checkOut: $checkOutDate",
                            );
                            context.read<VillaBloc>().add(
                              SearchAvailableVillaEvent(
                                query: searchQuery,
                                checkIn: checkInDate!,
                                checkOut: checkOutDate!,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 10),
                  child: const Text(
                    "Promo Spesial",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                PromoCarousel(),

                const SizedBox(height: 30),

                BlocBuilder<VillaBloc, VillaState>(
                  builder: (context, state) {
                    if (state is VillaLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.navy),
                      );
                    } else if (state is VillaLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                
                          if (!state.isFilteredByDate)
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.amber.shade300,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Pilih tanggal & klik 'Cari Villa Tersedia' untuk cek ketersediaan",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Label hasil
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              state.isFilteredByDate
                                  ? "Villa Tersedia (${state.villas.length})"
                                  : "Rekomendasi Villa",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (state.villas.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Tidak ada villa tersedia untuk tanggal ini.",
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.70,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                              itemCount: state.villas.length,
                              itemBuilder: (context, index) {
                                return VillaCard(
                                  villa: state.villas[index],
                                  checkInDate: checkInDate,
                                  checkOutDate: checkOutDate,
                                  isAvailabilityChecked: state.isFilteredByDate,
                                );
                              },
                            ),
                          if (state.hasMore && !state.isFilteredByDate)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.navy,
                                ),
                              ),
                            )
                          else if (!state.hasMore)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: Text(
                                  "Semua villa sudah ditampilkan",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    } else if (state is VillaError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 100), // Spasi bawah biar gak mentok
              ],
            ),
          ),
        ),
      ),
    );
  }
}
