class Company {
  String? companyName;
  String? telephone;
  String? fix;
  String? fax;
  String? whatsapp;
  String? faceBook;
  String? shortDescription;
  String? email;
  String? adresse;
  String? cartLimitDescription;
  double? cartLimitMnt;
  String? logo;
  String? about;
  String? user;
  String? pwd;
  List<SliderImages>? sliderImages;
  Company(
      {this.sliderImages,
      this.companyName,
      this.telephone,
      this.email,
      this.adresse,
      this.shortDescription,
      this.whatsapp,
      this.faceBook,
      this.cartLimitDescription,
      this.cartLimitMnt,
      this.fix,
      this.fax,
      this.logo,
      this.about,
      this.user,
      this.pwd});
}

class Links {
  String? name;
  String? url;
  bool? hover;
  bool? showInMobile;

  Links({this.name, this.url, this.hover, this.showInMobile});
}

class SliderImages {
  String? key;
  String? img;
  bool? isHover;
  SliderImages({this.key,this.img, this.isHover});
}

enum DevicePlatform { desktop, mobile, mixte }
