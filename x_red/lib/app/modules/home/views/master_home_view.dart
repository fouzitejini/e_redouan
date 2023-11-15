import 'package:flutter/material.dart';

import '../../../../models/company.dart';
import 'head_foot.dart';
import 'home_view.dart';

class MasterHomeView extends StatefulWidget {
  const MasterHomeView({Key? key}) : super(key: key);
  
  @override
  State<MasterHomeView> createState() => _MasterHomeViewState();
}

class _MasterHomeViewState extends State<MasterHomeView> {
  var company = Company();
  @override
  Widget build(BuildContext context) {
    return MasterHome(
        child: HomeView(
        
          onTap: (double ex) {},
        ));
  }
}
