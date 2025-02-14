import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_motor/models/product_history.dart'
    as productHistoryModel;
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:inventory_motor/utils/status.dart';
import 'package:inventory_motor/widgets/appbar_widget.dart';
import 'package:inventory_motor/widgets/button_widget.dart';
import 'package:inventory_motor/widgets/rounded_textfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:inventory_motor/providers/update_product_provider.dart';
import 'package:inventory_motor/models/product.dart';

class FormUpdatePage extends StatefulWidget {
  final Product product;

  const FormUpdatePage({super.key, required this.product});

  @override
  State<FormUpdatePage> createState() => _FormUpdatePageState();
}

class _FormUpdatePageState extends State<FormUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _exitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  Status? _selectedStatus;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.product.title;
    _dateController.text =
        widget.product.date.toIso8601String().split('T').first;
    _entryController.text = widget.product.entry.toString();
    _exitController.text = widget.product.exit.toString();
    _descriptionController.text = widget.product.description;
    _selectedStatus = widget.product.status;
    _selectedImage = File(widget.product.image);
    _totalController.text = widget.product.total.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _entryController.dispose();
    _exitController.dispose();
    _descriptionController.dispose();
    _totalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppbarWidget.myAppBar(null, "Update Produk"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RoundedTextField(
              controller: _titleController,
              labelText: 'Nama Produk',
            ),
            RoundedTextField(
              controller: _dateController,
              labelText: 'Tanggal',
              keyboardType: TextInputType.datetime,
              onTap: () => _selectDate(context),
            ),
            DropdownButtonFormField<Status>(
              value: _selectedStatus,
              items: Status.values.map((Status status) {
                return DropdownMenuItem<Status>(
                  value: status,
                  child: Text(Product.statusToString(status)),
                );
              }).toList(),
              onChanged: null,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_selectedStatus == Status.masuk)
              RoundedTextField(
                controller: _entryController,
                labelText: 'Jumlah Masuk',
                keyboardType: TextInputType.number,
              ),
            if (_selectedStatus == Status.keluar)
              RoundedTextField(
                controller: _exitController,
                labelText: 'Jumlah Keluar',
                keyboardType: TextInputType.number,
              ),
            RoundedTextField(
              controller: _totalController,
              labelText: 'Total Saat Ini',
              keyboardType: TextInputType.number,
            ),
            RoundedTextField(
              controller: _descriptionController,
              labelText: 'Deskripsi',
              isMultiline: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
  width: double.infinity,
  height: 150,
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black,      // Hitam
          Color(0xFF0A7D07), // Hijau
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ElevatedButton(
      onPressed: _pickImage,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.transparent, // Tombol menjadi transparan agar gradasi terlihat
        foregroundColor: Colors.white,
      ),
      child: _selectedImage == null
          ? const Icon(
              Icons.image,
              size: 54,
            )
          : Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            ),
    ),
  ),
),
            const Spacer(),
            SizedBox(
  width: double.infinity,
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black,      // Hitam
          Color(0xFF0A7D07), // Hijau
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),  // Optional, agar tombol punya sudut melengkung
    ),
    child: ButtonWidget.myButton(
      "Update Produk",
      Colors.transparent, // Warna tombol transparan agar gradasi terlihat
      SelectColor.kWhite,
      _submitForm,
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = selectedDate.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada gambar/foto yang dipilih")),
      );
    }
  }

  void _submitForm() {
    if (_formIsValid()) {
      if (_selectedStatus == Status.masuk) {
        _updateProduct(Status.masuk);
      } else {
        if (int.parse(_exitController.text) >
            int.parse(_totalController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Pengeluaran tidak boleh melebihi total")),
          );
        } else {
          _updateProduct(Status.keluar);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ada yang masih kosong")),
      );
    }
  }

  bool _formIsValid() {
    if (_selectedStatus == Status.masuk) {
      return _titleController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          _entryController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _totalController.text.isNotEmpty &&
          (_selectedImage != null);
    } else {
      return _titleController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          _exitController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _totalController.text.isNotEmpty &&
          (_selectedImage != null);
    }
  }

  void _updateProduct(Status status) {
    final productProvider =
        Provider.of<GetAllProductProvider>(context, listen: false);
    final productHistoryProvider =
        Provider.of<GetAllProductHistoryProvider>(context, listen: false);

    int total;
    if (status == Status.masuk) {
      total =
          int.parse(_entryController.text) + int.parse(_totalController.text);
    } else {
      total =
          int.parse(_totalController.text) - int.parse(_exitController.text);
    }

    final updatedProduct = widget.product.copyWith(
      title: _titleController.text,
      date: DateTime.parse(_dateController.text),
      entry: int.parse(_entryController.text),
      exit: int.parse(_exitController.text),
      description: _descriptionController.text,
      image: _selectedImage?.path ?? "",
      total: total,
    );

    final bool entryChanged = updatedProduct.entry != widget.product.entry;
    final bool exitChanged = updatedProduct.exit != widget.product.exit;

    Status newStatus = updatedProduct.status;
    if (entryChanged && exitChanged) {
      newStatus = updatedProduct.entry > updatedProduct.exit
          ? Status.masuk
          : Status.keluar;
    } else if (entryChanged) {
      newStatus = Status.masuk;
    } else if (exitChanged) {
      newStatus = Status.keluar;
    }
    final updatedProductWithNewStatus =
        updatedProduct.copyWith(status: newStatus);

    String description = 'Produk telah diperbarui';
    if (entryChanged && exitChanged) {
      final int entryDifference = updatedProduct.entry - widget.product.entry;
      final int exitDifference = updatedProduct.exit - widget.product.exit;
      description +=
          ' pemasukan sebesar $entryDifference dan pengeluaran sebesar $exitDifference';
    } else if (entryChanged) {
      final int entryDifference = updatedProduct.entry - widget.product.entry;
      description +=
          ' dengan melakukan pemasukan sebesar $entryDifference dari total masuk ${updatedProduct.entry - entryDifference}';
    } else if (exitChanged) {
      final int exitDifference = updatedProduct.exit - widget.product.exit;
      description +=
          ' dan pengeluaran sebesar $exitDifference dari total keluar ${updatedProduct.exit - exitDifference}';
    } else {
      description =
          'Produk telah diperbarui tidak ada perubahan dalam pemasukan ataupun pengeluaran';
    }

    final updateProductHistory = productHistoryModel.ProductHistory(
      id: '',
      productId: updatedProduct.id,
      title: updatedProduct.title,
      date: updatedProduct.date,
      status: newStatus,
      entry: entryChanged
          ? updatedProduct.entry - widget.product.entry
          : int.parse(_entryController.text),
      exit: exitChanged
          ? updatedProduct.exit - widget.product.exit
          : int.parse(_exitController.text),
      description: description,
      image: updatedProduct.image,
    );

    runUpdateProduct(updatedProductWithNewStatus, updateProductHistory,
        productProvider, productHistoryProvider);
  }

  Future<Null> runUpdateProduct(
      Product product,
      productHistoryModel.ProductHistory productHistory,
      GetAllProductProvider productProvider,
      GetAllProductHistoryProvider productHistoryProvider) {
    final provider = Provider.of<UpdateProductProvider>(context, listen: false);
    return provider
        .updateProduct(
      product,
      productProvider,
      productHistoryProvider,
      productHistory,
    )
        .then((_) {
      if (provider.error == null) {
        productProvider.fetchProducts();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error!)),
        );
      }
    });
  }
}
