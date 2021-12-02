import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/config/responsive.dart';
import 'package:product_app/enum.dart';
import 'package:product_app/page/edit_product.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:product_app/widgets/grid_product_widget.dart';
import 'package:product_app/widgets/list_product_widget.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool switchToGrid = false;
  int gridCount = 2;

  @override
  Widget build(BuildContext context) {
    // gridCount = SizeConfig.isPortrait ? 2 : 3;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.dashboard,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Products",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.textMultiplier! * 3.5,
                    letterSpacing: 1.5,
                  ),
                ),
                subtitle: Text(
                  "dashboard",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier! * 2.2,
                    letterSpacing: 1.0,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(EditProduct.routeName, arguments: {
                    "code": EditProductRouteCode.create,
                    "value": null,
                  }),
                  icon: const Icon(Icons.create),
                ),
              ),

              SizedBox(
                width: SizeConfig.isPortrait
                    ? SizeConfig.widthMultiplier! * 100.0
                    : SizeConfig.widthMultiplier! * 95.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Divider(
                        indent: 10.0,
                        thickness: 1.0,
                      ),
                    ),
                    //list
                    IconButton(
                      onPressed: () {
                        setState(() {
                          switchToGrid = !switchToGrid;
                        });
                      },
                      icon: Icon(
                        Icons.list,
                        size: SizeConfig.textMultiplier! * 3.5,
                        color: switchToGrid
                            ? Colors.grey.shade900
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    //grid
                    IconButton(
                      onPressed: () {
                        setState(() {
                          switchToGrid = !switchToGrid;
                        });
                      },
                      icon: Icon(
                        Icons.grid_on,
                        size: SizeConfig.textMultiplier! * 3.5,
                        color: switchToGrid
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
              ),

              //products
              switchToGrid
                  ? Consumer<ProductProvider>(
                      builder: (context, pp, __) => GridView.extent(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        maxCrossAxisExtent: SizeConfig.isPortrait ?  200.0 : 300.0,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        children: pp.products
                            .map((product) =>
                                GridProductWidget(product: product))
                            .toList(),
                      ),
                    )
                  : Consumer<ProductProvider>(
                      builder: (context, pp, __) => ListView.builder(
                        itemCount: pp.products.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, i) => ListProductWidget(
                          product: pp.products[i],
                        ),
                      ),
                    ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
