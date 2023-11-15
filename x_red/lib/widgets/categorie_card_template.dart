import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../models/category.dart';


class CategoryTemplateCard extends StatelessWidget {
  const CategoryTemplateCard({super.key, required this.categorie});
  final Category categorie;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        width: 180,
        decoration: BoxDecoration(border: Border.all(width: 1,color: BrandColors.almouasat.withOpacity(.4))),
        child: Column(children: [Expanded(child: 
        Image.network(categorie.img!,width: double.infinity,fit: BoxFit.fitWidth,)
        ), 
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(categorie.categoryName!),
        )],),
      ),
    );
  }
}
