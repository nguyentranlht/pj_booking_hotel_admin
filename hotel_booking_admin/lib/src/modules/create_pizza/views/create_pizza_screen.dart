import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/create_pizza_bloc/create_pizza_bloc.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:hotel_repository/hotel_repository.dart';
import '../../../components/my_text_field.dart';
import '../components/macro.dart';
import 'dart:html' as html;

class CreatePizzaScreen extends StatefulWidget {
  const CreatePizzaScreen({super.key});

  @override
  State<CreatePizzaScreen> createState() => _CreatePizzaScreenState();
}

class _CreatePizzaScreenState extends State<CreatePizzaScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final distController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ratingController = TextEditingController();
  final reviewsController = TextEditingController();
  final numberRoomController = TextEditingController();
  final peopleController = TextEditingController();
  bool creationRequired = false;
  String? _errorMsg;
  late Hotel pizza;

  @override
  void initState() {
    pizza = Hotel.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePizzaBloc, CreatePizzaState>(
      listener: (context, state) {
        if (state is CreatePizzaSuccess) {
          setState(() {
            creationRequired = false;
            context.go('/');
          });
          context.go('/');
        } else if (state is CreatePizzaLoading) {
          setState(() {
            creationRequired = true;
          });
        }
      },
      child: BlocListener<UploadPictureBloc, UploadPictureState>(
        listener: (context, state) {
          if (state is UploadPictureLoading) {
          } else if (state is UploadPictureSuccess) {
            setState(() {
              pizza.imagePath = state.url;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create a New Hotel !',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 1000,
                        maxWidth: 1000,
                      );
                      if (image != null && context.mounted) {
                        context.read<UploadPictureBloc>().add(UploadPicture(
                            await image.readAsBytes(), basename(image.path)));
                      }
                    },
                    child: pizza.imagePath.startsWith(('http'))
                        ? Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(pizza.imagePath),
                                    fit: BoxFit.cover)))
                        : Ink(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.photo,
                                  size: 100,
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Add a Picture here...",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: nameController,
                                  hintText: 'Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: addressController,
                                  hintText: 'Address',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: priceController,
                                  hintText: 'Price',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('Is Select :'),
                              const SizedBox(
                                width: 10,
                              ),
                              Checkbox(
                                  value: pizza.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      pizza.isSelected = value!;
                                    });
                                  })
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: distController,
                                  hintText: 'Dist',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: ratingController,
                                  hintText: 'Rating',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: reviewsController,
                                  hintText: 'Reviews',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: numberRoomController,
                                  hintText: 'Number Room',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: peopleController,
                                  hintText: 'People',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    }
                                    return null;
                                  })),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  !creationRequired
                      ? SizedBox(
                          width: 400,
                          height: 40,
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    pizza.titleTxt = nameController.text;
                                    pizza.subTxt = addressController.text;
                                    pizza.perNight =
                                        int.parse(priceController.text);
                                    pizza.dist =
                                        double.parse(distController.text);
                                    pizza.rating =
                                        double.parse(ratingController.text);
                                    pizza.reviews =
                                        int.parse(reviewsController.text);
                                    pizza.room?.numberRoom =
                                        int.parse(numberRoomController.text);
                                    pizza.room?.people =
                                        int.parse(peopleController.text);
                                  });
                                  print(pizza.toString());
                                  context
                                      .read<CreatePizzaBloc>()
                                      .add(CreatePizza(pizza));
                                }
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  'Create Pizza',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
