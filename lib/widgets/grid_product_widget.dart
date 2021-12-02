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

class GridProductWidget extends StatelessWidget {
  final Product product;
  const GridProductWidget({
    required this.product,
    Key? key,
  }) : super(key: key);

  Widget header(BuildContext context) {
    return Container(
      // width: SizeConfig.widthMultiplier! * 40.0,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: Colors.grey.shade900,
      ),
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //title
          Flexible(
            child: Text(
              product.name,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.textMultiplier! * 3.2,
                // letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),

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
                icon: const Icon(
                  Icons.update,
                  color: Colors.white,
                ),
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
    );
  }

  Widget footer(BuildContext context) {
    final selectedDate = DateFormat.yMd().format(product.launcedAt);
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: Colors.grey.shade900,
      ),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //launched site
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 5.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    product.launchedSite,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                Text(
                  selectedDate,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(color: Colors.white),
                ),
                // ),
              ],
            ),
          ),
          // ),
          //rate
          Flexible(
            child: RatingBarIndicator(
              rating: product.rate,
              unratedColor: Colors.white,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.isPortrait ? 200.0 : 300.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          //header
          Expanded(
            child: header(context),
          ),
          //body
          Container(
            // width: SizeConfig.widthMultiplier! * 40.0,
            height: SizeConfig.isPortrait ? 100.0 : 200.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/shopping1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //footer
          Expanded(
            child: footer(context),
          ),
        ],
      ),
    );
  }
}

// Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GridTile(
//         header: 
//         child: 
