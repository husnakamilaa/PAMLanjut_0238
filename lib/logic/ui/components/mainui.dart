// import 'package:booking_villa/logic/ui/pages/admin/dashboard_admin.dart';
// import 'package:flutter/material.dart';
// import 'package:booking_villa/logic/ui/components/colours.dart';

// class MainUI extends StatefulWidget {
//   final String role; 
//   const MainUI({super.key, required this.role});

//   @override
//   State<MainUI> createState() => _MainUIState();
// }

// class _MainUIState extends State<MainUI> {
//   int _selectedIndex = 0;

//   final List<Widget> _adminPages = [
//     const DashboardAdmin(), // Ini halaman dengan kartu statistik itu
//     const Center(child: Text("Customers")),
//     const Center(child: Text("Manage Villa")),
//     const Center(child: Text("Booking")),
//   ];

//   final List<Widget> _customerPages = [
//     const Center(child: Text("Explore Villa")),
//     const Center(child: Text("Riwayat Pemesanan")),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> currentPages = widget.role == 'admin' ? _adminPages : _customerPages;

//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: currentPages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() => _selectedIndex = index),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.navy,
//         unselectedItemColor: AppColors.grey,
//         items: _buildNavItems(widget.role),
//       ),
//     );
//   }

//   List<BottomNavigationBarItem> _buildNavItems(String role) {
//     if (role == 'admin') {
//       return const [
//         BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
//         BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Customers"),
//         BottomNavigationBarItem(icon: Icon(Icons.apartment), label: "Villas"),
//         BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), label: "Bookings"),
//       ];
//     }
//     return const [
//       BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
//       BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
//     ];
//   }
// }