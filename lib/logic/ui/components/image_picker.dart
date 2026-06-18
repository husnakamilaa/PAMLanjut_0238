import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:booking_villa/logic/ui/components/colours.dart';

enum ImagePickerShape { rectangle, circle }

class CustomImagePicker extends StatefulWidget {
  final String storageBucket;
  final String? initialImageUrl;
  final ValueChanged<String> onImageUploaded;
  final ImagePickerShape shape;
  final double height;

  const CustomImagePicker({
    super.key,
    required this.storageBucket,
    required this.onImageUploaded,
    this.initialImageUrl,
    this.shape = ImagePickerShape.rectangle,
    this.height = 150,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _uploadedImageUrl = widget.initialImageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

   
      await Supabase.instance.client.storage
          .from(widget.storageBucket)
          .uploadBinary(fileName, bytes);

   
      final publicUrl = Supabase.instance.client.storage
          .from(widget.storageBucket)
          .getPublicUrl(fileName);

    
      setState(() => _uploadedImageUrl = publicUrl);

   
      widget.onImageUploaded(publicUrl);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal upload gambar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

 

  Widget _buildRectangle() {
    final hasImage = _uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty;

    return InkWell(
      onTap: _isUploading ? null : _pickAndUploadImage,
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _isUploading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.navy),
              )
            : hasImage
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _uploadedImageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                "Ganti",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: AppColors.navy),
                      SizedBox(height: 8),
                      Text("Pilih Gambar"),
                    ],
                  ),
      ),
    );
  }

  

  Widget _buildCircle() {
    final hasImage = _uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty;
    const double size = 110;

    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUploadImage,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Lingkaran utama
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: _isUploading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.navy),
                    )
                  : hasImage
                      ? ClipOval(
                          child: Image.network(
                            _uploadedImageUrl!,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 42,
                              color: AppColors.navy,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Foto",
                              style: TextStyle(fontSize: 11, color: AppColors.navy),
                            ),
                          ],
                        ),
            ),

          
            if (!_isUploading)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.shape == ImagePickerShape.circle
        ? _buildCircle()
        : _buildRectangle();
  }
}