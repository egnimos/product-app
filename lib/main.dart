import 'package:flutter/material.dart';
import 'package:product_app/config/responsive.dart';
import 'package:product_app/page/dashboard.dart';
import 'package:product_app/page/edit_product.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider())
      ],
      child: LayoutBuilder(
        builder: (context, constraints) => OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              title: 'Product App',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              debugShowCheckedModeBanner: false,
              home: const Dashboard(),
              routes: {
                EditProduct.routeName: (ctx) => const EditProduct(),
              },
            );
          },
        ),
      ),
    );
  }
}
