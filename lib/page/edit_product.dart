import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:product_app/config/responsive.dart';
import 'package:product_app/enum.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = "/edit-product";

  const EditProduct({Key? key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;
  Product _newProduct = Product(
    id: DateTime.now().toString(),
    name: "",
    launcedAt: DateTime.now(),
    launchedSite: "",
    rate: 0.0,
  );
  EditProductRouteCode routeCode = EditProductRouteCode.unknown;
  double popularityRating = 0.0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeInfo =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      routeCode = routeInfo["code"];
      if (mounted && routeCode == EditProductRouteCode.update) {
        setState(() {
          _newProduct = routeInfo["value"];
        });
        popularityRating = _newProduct.rate;
        Provider.of<ProductProvider>(context, listen: false)
            .updateDate(_newProduct.launcedAt);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: routeCode == EditProductRouteCode.update
            ? const Text("update product")
            : const Text("create product"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              try {
                if (!_formKey.currentState!.validate()) return;
                _formKey.currentState!.save();
                _newProduct.launcedAt =
                    Provider.of<ProductProvider>(context, listen: false)
                        .dateTime;
                _newProduct.rate = popularityRating;
                //create
                if (routeCode == EditProductRouteCode.create) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .addProduct(_newProduct);
                }
                //update
                if (routeCode == EditProductRouteCode.update) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .updateProduct(_newProduct);
                }

                Provider.of<ProductProvider>(context, listen: false)
                    .updateDate(DateTime.now());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("saved successfully"),
                  ),
                );

                Navigator.of(context).pop();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$error"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                //name (unique)
                TextFormField(
                  initialValue: routeCode == EditProductRouteCode.update
                      ? _newProduct.name
                      : "",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "add the product name",
                    labelText: "name",
                    // labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                    //       fontSize: SizeConfig.textMultiplier! * 3.2,
                    //     ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    final products =
                        Provider.of<ProductProvider>(context, listen: false)
                            .products;
                    final anyFirstProducts = products.firstWhere(
                      (prod) => prod.name == value,
                      orElse: () => Product(
                          id: "",
                          name: "",
                          launcedAt: DateTime.now(),
                          launchedSite: "",
                          rate: 0.0),
                    );
                    if (anyFirstProducts.name.isNotEmpty) {
                      if (routeCode == EditProductRouteCode.update &&
                          anyFirstProducts.id == _newProduct.id) {
                        return null;
                      }
                      return "name should be unique";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newProduct.name = value!;
                  },
                ),

                SizedBox(
                  height: SizeConfig.heightMultiplier! * 5.0,
                ),

                //launchedAt (date picker) DateFormat.yMd()
                Consumer<ProductProvider>(
                  builder: (context, pp, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Builder(builder: (context) {
                      final selectedDate = DateFormat.yMd().format(pp.dateTime);
                      return Text(
                        "selected labels $selectedDate",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: SizeConfig.textMultiplier! * 2.2,
                            ),
                      );
                    }),
                  ),
                ),

                Consumer<ProductProvider>(
                  builder: (context, pp, __) => ElevatedButton.icon(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: pp.dateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (picked != null) {
                        pp.updateDate(picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("choose date"),
                  ),
                ),

                SizedBox(
                  height: SizeConfig.heightMultiplier! * 5.0,
                ),

                //launched site
                TextFormField(
                  initialValue: routeCode == EditProductRouteCode.update
                      ? _newProduct.launchedSite
                      : "",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "link",
                    labelText: "launched site",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(
                      Icons.link,
                      size: SizeConfig.textMultiplier! * 4.5,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "invalid url";
                    }
                    //https
                    if (!value.contains("https://")) {
                      return "https link is supported";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newProduct.launchedSite = value!;
                  },
                ),

                SizedBox(
                  height: SizeConfig.heightMultiplier! * 5.0,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "popularity rating",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: SizeConfig.textMultiplier! * 2.2,
                        ),
                  ),
                ),

                //popularity (rate)
                RatingBar.builder(
                  initialRating: routeCode == EditProductRouteCode.update
                      ? _newProduct.rate
                      : 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    popularityRating = rating;
                  },
                ),

                SizedBox(
                  height: SizeConfig.heightMultiplier! * 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
