import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:product_app/config/responsive.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/page/edit_product.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../enum.dart';

class ListProductWidget extends StatelessWidget {
  final Product product;

  const ListProductWidget({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 14.0,
      ),
      width: SizeConfig.widthMultiplier! * 100.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          //image,
          Container(
            width: 120.0,
            height: 150.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/shopping1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // SizedBox(width: 10.0,),
          //info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InfoWidget(product: product),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final Product product;
  const InfoWidget({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDate = DateFormat.yMd().format(product.launcedAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //name
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  product.name,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.textMultiplier! * 3.5,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //update
                  IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(EditProduct.routeName, arguments: {
                      "code": EditProductRouteCode.update,
                      "value": product,
                    }),
                    icon: const Icon(Icons.update),
                  ),
                  //delete
                  IconButton(
                    onPressed: () {
                      // set up the buttons
                      Widget cancelButton = TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                      );
                      Widget continueButton = TextButton(
                        child: const Text("Continue"),
                        onPressed: () {
                          Provider.of<ProductProvider>(context, listen: false)
                              .deleteProduct(product.id);
                          Navigator.of(context).pop();
                        },
                      );
                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: const Text("Warning"),
                        content: const Text(
                            "are you sure, you want to delete it permanently"),
                        actions: [
                          cancelButton,
                          continueButton,
                        ],
                      );
                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //launched at
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
          child: Text(
            selectedDate,
            softWrap: true,
          ),
        ),
        //launched site
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
          child: Text(
            product.launchedSite,
            softWrap: true,
          ),
        ),
        //rate
        Expanded(
          child: RatingBarIndicator(
            rating: product.rate,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
