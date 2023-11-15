import 'package:firebase_database/firebase_database.dart';
import 'package:redouanstore/data/reposetory/firebase_database.dart';

import '../../models/company.dart';

class CompanySettings {
  Future<Company> get getCompanyData async {
    Company getCompany = Company(
        companyName: "خضر وفواكه الرضوان",
        email: "Null",
        telephone: "Null",
        adresse: "بركان",
        shortDescription:
            'رواد في مجال الخضار والفواكة بالجملة في المنطقة الشرقية. ونسعى لنصبح رواداً في مجال التوصيل للعملاء مباشرة وتقديم أفضل خدمة بأعلى جودة وبأقل الأسعار .  خضر وفواكه الرضوان: نحن نجني الأجود لأجلك 💛',
        fix: 'Null',
        fax: 'Null',
        cartLimitDescription: 'Null',
        cartLimitMnt: 0.0,
        whatsapp: 'Null',
        logo: 'Null',
        about: "About",
        faceBook: "");
    await FirebaseDatabase.instance.ref("Company").once().then((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<Object?, Object?>);

        getCompany = Database.getCompany(dataMap);
        await getCompanyDataSliderImage
            .then((value) => getCompany.sliderImages = value);
      } else {
        await createCompany(getCompany).whenComplete(() {});
        await getCompanyDataSliderImage
            .then((value) => getCompany.sliderImages = value);
      }
    });

    return getCompany;
  }

  Future<List<SliderImages>> get getCompanyDataSliderImage async {
    List<SliderImages> images = [];
    await FirebaseDatabase.instance
        .ref("Company")
        .child('images')
        .once()
        .then((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<Object?, Object?>);
        for (var element in dataMap.entries) {
          images.add(SliderImages(img: element.value,isHover: false,key: element.key));
        }
      }
    });

    return images;
  }

  Future<void> createCompany(Company companyData) async {
    await FirebaseDatabase.instance
        .ref("Company")
        .set(Database.companyToMap(companyData));
  }

  Future<void> updateCompany(Company companyData) async {
    await FirebaseDatabase.instance
        .ref("Company")
        .update(Database.companyToMap(companyData));
  }

  Future<void> createSlidersImages(String imgKey, String img) async {
    await FirebaseDatabase.instance
        .ref("Company")
        .child('images')
        .child(imgKey)
        .set(img);
  }
    Future<void> removeSlidersImage(String imgKey) async {
    await FirebaseDatabase.instance
        .ref("Company")
        .child('images')
        .child(imgKey)
        .remove();
  }
}
