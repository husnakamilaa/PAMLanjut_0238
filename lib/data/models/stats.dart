class AdminStatsModel {
  final int totalCustomers;
  final int villaAvailable;
  final int bookingConfirmed;
  final int bookingPaid;
  final int bookingCancelled;
 
  AdminStatsModel({
    required this.totalCustomers,
    required this.villaAvailable,
    required this.bookingConfirmed,
    required this.bookingPaid,
    required this.bookingCancelled,
  });
}