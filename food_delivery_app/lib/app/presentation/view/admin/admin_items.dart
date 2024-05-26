import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/data/helpers/constants.dart';
import 'package:food_delivery_app/app/domain/model/food_item.dart';
import 'package:food_delivery_app/app/presentation/common/app_elevated_button.dart';
import 'package:food_delivery_app/app/presentation/common/app_text_field.dart';
import 'package:food_delivery_app/app/presentation/common/widget_support.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/sources/database.dart';

class AdminItems extends StatefulWidget {
  const AdminItems({super.key});

  @override
  State<AdminItems> createState() => _AdminItemsState();
}

class _AdminItemsState extends State<AdminItems> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _detailsController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  String? selectedCategory;
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();

  Future<void> pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  uploadItem() async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("food-images")
        .child(
            '${_nameController.text}.${selectedImage!.path.split('.').last}');
    final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

    var downloadUrl = await (await task).ref.getDownloadURL();
    final item = FoodItem(
      image: downloadUrl,
      description: _detailsController.text,
      shortDescription: _shortDescriptionController.text,
      name: _nameController.text,
      category: selectedCategory!,
      price: double.parse(_priceController.text),
      deliveryTime: int.parse(_deliveryTimeController.text),
    );
    await Database().addFoodItem(selectedCategory!, item.toJson()).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Text(
              'Food Item added.',
              style: AppWidget.semiBoldTextFieldStyle()
                  .copyWith(color: Colors.white),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminItems(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Food Item',
          style: AppWidget.headlineTextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Image',
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: FormField(
                        validator: (value) {
                          if (selectedImage == null) {
                            return 'Please add an image';
                          }
                          return null;
                        },
                        builder: (state) {
                          return Card(
                            child: selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 50,
                                      color: state.hasError
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ...field('Food Name', _nameController, Icons.food_bank,
                    (value) {
                  if (value!.isEmpty) {
                    return 'Please enter food name';
                  }
                  return null;
                }),
                ...field(
                    'Food Price', _priceController, Icons.price_change_outlined,
                    (value) {
                  if (value!.isEmpty) {
                    return 'Please enter food price';
                  }
                  return null;
                }, keyboardType: TextInputType.number),
                ...field('Delivery Time (minutes)', _deliveryTimeController,
                    Icons.timer_outlined, (value) {
                  if (value!.isEmpty) {
                    return 'Please enter delivery time';
                  }
                  return null;
                }, keyboardType: TextInputType.number),
                ...field(
                    'Short Description', _shortDescriptionController, Icons.food_bank,
                    (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a short description';
                  }
                  return null;
                }),
                ...field('Food Details', _detailsController, Icons.food_bank,
                    (value) {
                  if (value!.isEmpty) {
                    return 'Please enter food details';
                  }
                  return null;
                }, maxlines: 10),
                Text(
                  'Food Category',
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red.shade900,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    elevation: 1,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select category';
                      }
                      return null;
                    },
                    style: AppWidget.lightTextFieldStyle(),
                    items: List.generate(categories.length, (index) {
                      final name = categories.keys.elementAt(index);
                      final icon = categories[name];
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(icon),
                            ),
                            Text(name),
                          ],
                        ),
                      );
                    }),
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: AppElevatedButton('Upload new Food', onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadItem();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> field(
    String label,
    TextEditingController controller,
    IconData icon,
    String? Function(String?)? validator, {
    int? maxlines,
    TextInputType? keyboardType,
  }) {
    return [
      Text(
        label,
        style: AppWidget.semiBoldTextFieldStyle(),
      ),
      AppTextField(
        controller: controller,
        hintText: label,
        prefixIcon: icon,
        maxlines: maxlines,
        keyboardType: keyboardType ?? TextInputType.text,
        validator: validator,
      ),
    ];
  }
}
