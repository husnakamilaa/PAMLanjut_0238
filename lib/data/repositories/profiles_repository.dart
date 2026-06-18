import 'package:booking_villa/data/models/profiles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ProfilesModel> getUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception("User belum login");
      }

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return ProfilesModel.fromJson(response);
    } catch (e) {
      throw Exception("Gagal mengambil data profil: $e");
    }
  }
}