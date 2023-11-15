import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../app/routes/app_pages.dart';
import '../data/colors.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key,
      required this.product,
      required this.carteQte,
      required this.buttonEnabled,
      required this.backSpace,
      required this.onTap});
  final Category product;
  final bool buttonEnabled;
  final bool backSpace;
  final void Function(bool back,Product product) onTap;
  final void Function(Product product) carteQte;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      children: [
        Div(
            divison: const Division(colL: 12, colM: 12, colS: 12),
            child: ResponsiveBuilder(
              builder: (_, info) {
                if (info.isMobile) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          width: Get.width,
                          product.img!,
                          fit: BoxFit.fitHeight,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.categoryName!,
                            style: GoogleFonts.cairo(
                                fontSize: 22, color: BrandColors.almouasat),
                          ),
                        ),
                        Responsive(
                            children: List.generate(
                                product.products!.length,
                                (io) => Div(
                                    divison: const Division(
                                      colS: 6,
                                      colM: 6,
                                      colL: 3,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _SubProductCard(
                                        onTap: (bool back,p) =>onTap(back,p),
                                        backSpace: backSpace,
                                        product: product.products![io],
                                        height: 230,
                                        carteQte: (p) => carteQte(p),
                                        buttonEnabled: buttonEnabled,
                                      ),
                                    ))))
                      ],
                    ),
                  );
                } else if (info.isNormal) {
                  debugPrint("isNormal");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(  width:  Get.width*.9,
                          child: Image.network(
                          
                            product.img!,
                            
                              fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.categoryName!,
                            style: GoogleFonts.cairo(
                                fontSize: 22, color: BrandColors.almouasat),
                          ),
                        ),
                        Responsive(
                            children: List.generate(
                                product.products!.length,
                                (i) => Div(
                                    divison: const Division(
                                        colS: 4, colM: 4, colL: 3, colXL: 2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _SubProductCard(
                                        onTap: (bool back,pro) =>onTap(back,pro),
                                        backSpace: backSpace,
                                        height: 250,
                                        product: product.products![i],
                                        carteQte: (p) => carteQte(p),
                                        buttonEnabled: buttonEnabled,
                                      ),
                                    ))))
                      ],
                    ),
                  );
                } else if (info.isTablet) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          width: Get.width,
                          product.img!,
                          height: Get.height * .6,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.categoryName!,
                            style: GoogleFonts.cairo(
                                fontSize: 22, color: BrandColors.almouasat),
                          ),
                        ),
                        Responsive(
                            children: List.generate(
                                product.products!.length,
                                (i) => Div(
                                    divison: const Division(
                                      colS: 4,
                                      colM: 4,
                                      colL: 3,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _SubProductCard(
                                        onTap: (bool back,pro) =>onTap(back,pro),
                                        backSpace: backSpace,
                                        height: 250,
                                        product: product.products![i],
                                        carteQte: (p) => carteQte(p),
                                        buttonEnabled: buttonEnabled,
                                      ),
                                    ))))
                      ],
                    ),
                  );
                } else if(info.isDesktop || info.isExtraLarge ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Center(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: SizedBox(  
                            child: Image.network(width:Get.width*0.9,
                              
                              product.img!,
                              
                              fit: BoxFit.fitHeight,
                            ),
                                                 ),
                         ),
                       ),
                      Container(width: Get.width,
                      height: 50,decoration: BoxDecoration(color: BrandColors.kPrimaryColor,),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.categoryName!,
                              style: GoogleFonts.cairo(
                                  fontSize: 22, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Responsive(
                          children: List.generate(
                              product.products!.length,
                              (ip) => Div(
                                  divison: const Division(
                                    colS: 12,
                                    colM: 4,
                                    colL: 3,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _SubProductCard(
                                       onTap: (bool back,pro) =>onTap(back,pro),
                                      backSpace: backSpace,
                                      product: product.products![ip],
                                      height: 330,
                                      carteQte: (p) => carteQte(p),
                                      buttonEnabled: buttonEnabled,
                                    ),
                                  ))))
                    ],
                  );
                }else{
                      return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Center(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: SizedBox(  
                            child: Image.network(width:Get.width*0.9,
                              
                              product.img!,
                              
                              fit: BoxFit.fitHeight,
                            ),
                                                 ),
                         ),
                       ),
                      Container(width: Get.width,
                      height: 50,decoration: BoxDecoration(color: BrandColors.kPrimaryColor,),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.categoryName!,
                              style: GoogleFonts.cairo(
                                  fontSize: 22, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Responsive(
                          children: List.generate(
                              product.products!.length,
                              (ip) => Div(
                                  divison: const Division(
                                    colS: 12,
                                    colM: 4,
                                    colL: 3,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _SubProductCard(
                                       onTap: (bool back,pro) =>onTap(back,pro),
                                      backSpace: backSpace,
                                      product: product.products![ip],
                                      height: 330,
                                      carteQte: (p) => carteQte(p),
                                      buttonEnabled: buttonEnabled,
                                    ),
                                  ))))
                    ],
                  );
               
                }
              },
            )),
      ],
    );
  }
}

class _SubProductCard extends StatelessWidget {
  const _SubProductCard(
      {required this.product,
      required this.height,
      required this.carteQte,
      required this.buttonEnabled,
      required this.backSpace,
      required this.onTap});
  final bool backSpace;
  final void Function(Product product) carteQte;
  final bool buttonEnabled;
  final Product product;
  final double height;
  final void Function(bool back,Product product) onTap;
  @override
  Widget build(BuildContext context) {
    return product.isSale!
        ? _SubProductCardInSales(
            backSpace: backSpace,
            product: product,
            height: height,
            carteQte: (p) => carteQte(p),
            buttonEnabled: buttonEnabled, 
            onTap: (back,pro) =>onTap(back,pro),
          )
        : InkWell(
            onTap: ()=>onTap(true,product),
            child: Container(
              height: 350,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: BrandColors.lightSliverColor.withOpacity(.4),
                border: Border.all(
                  width: 1,
                  color: BrandColors.almouasat,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                      child: Image.network(
                    product.img!,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.fill,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.unit.toString(),
                      style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: BrandColors.xboxGreen),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.productName!,
                      style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: BrandColors.xboxGreen),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          "${product.nPrice!.toStringAsFixed(2)} درهم",
                          style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: BrandColors.xboxGreen),
                        )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed:
                                !buttonEnabled ? null : () => carteQte(product),
                            icon: const Icon(
                              FontAwesomeIcons.cartPlus,
                              size: 20,
                              color: Colors.white,
                            ),
                            label: Text(
                              "اضافة الى السلة",
                              style:
                                  TextStyle(color: Colors.white.withOpacity(1)),
                            ),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: BrandColors.kPrimaryColor,
                                backgroundColor:
                                    BrandColors.xboxGreen.withOpacity(.4),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}

class _SubProductCardInSales extends StatelessWidget {
  const _SubProductCardInSales(
      {required this.product,
      required this.height,
      required this.carteQte,
      required this.buttonEnabled,
      required this.backSpace,
      required this.onTap});
  final bool buttonEnabled;
  final Product product;
  final double height;
  final bool backSpace;
  final void Function(bool back,Product product) onTap;
  final void Function(Product product) carteQte;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>onTap(true,product),
      child: Container(
        height: 350,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: BrandColors.lightSliverColor.withOpacity(.4),
          border: Border.all(
            width: 1,
            color: BrandColors.almouasat,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Image.network(
                  product.img!,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.fill,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.unit.toString(),
                    style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.xboxGreen),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.productName!,
                    style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.xboxGreen),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "${product.nPrice!.toStringAsFixed(2)} درهم",
                            style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: BrandColors.youtubeRed,
                                decoration: TextDecoration.lineThrough),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "${product.sPrice!.toStringAsFixed(2)} درهم",
                            style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: BrandColors.xboxGreen),
                          )),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed:
                              !buttonEnabled ? null : () => carteQte(product),
                          icon: const Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: Text(
                            "اضافة الى السلة",
                            style:
                                TextStyle(color: Colors.white.withOpacity(1)),
                          ),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: BrandColors.kPrimaryColor,
                              backgroundColor:
                                  BrandColors.xboxGreen.withOpacity(.4),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Positioned(
                top: 10,
                right: 10,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                      color: BrandColors.xboxGreen,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "تخفيض ${(((product.nPrice! - product.sPrice!) / product.nPrice!) * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}



/**Container(width: double.infinity,height:300,
        decoration: BoxDecoration(
          border: Border.all(color: BrandColors.kPrimaryColor)
        ),
          child: Column(children:[
            Expanded(child: Image.network(product.img!)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.oPrice!.toString()),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text(product.productName!),
             )
          ])), */