import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductDialog extends StatefulWidget {
  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _condition;
  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  bool _isFormValid() {
    final price = double.tryParse(_priceController.text);
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _condition != null &&
        (price != null && price > 10) &&
        _images.isNotEmpty;
  }

  void _showImageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                _captureImage();
                Navigator.pop(context);
              },
              child: const Text('Capture Image'),
            ),
            TextButton(
              onPressed: () {
                _uploadImages();
                Navigator.pop(context);
              },
              child: const Text('Upload Image'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _uploadImages() async {
    final List<XFile>? pickedImages =
        await _picker.pickMultiImage(imageQuality: 80);
    if (pickedImages != null && _images.length + pickedImages.length <= 4) {
      setState(() {
        _images.addAll(pickedImages);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can select a maximum of 4 images")),
      );
    }
  }

  void _captureImage() async {
    if (_images.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can select a maximum of 4 images")),
      );
      return;
    }
    final XFile? capturedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (capturedImage != null) {
      setState(() {
        _images.add(capturedImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Condition *',
              ),
              value: _condition,
              items: const [
                DropdownMenuItem(value: 'Good', child: Text('Good')),
                DropdownMenuItem(value: 'Heavy Used', child: Text('Heavy Used')),
              ],
              onChanged: (value) {
                setState(() {
                  _condition = value;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
              ),
              maxLines: 2, // Reduced the area of the description field
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price (must be > 10) *',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showImageOptions(context);
              },
              child: const Text('UPLOAD IMAGES', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isFormValid()) {
                  // Handle the submission logic here
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product submitted successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields correctly")),
                  );
                }
              },
              child: const Text('SELL', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            if (_images.isNotEmpty) ...[
              const Text('Uploaded Images:'),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(_images[index].path),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
