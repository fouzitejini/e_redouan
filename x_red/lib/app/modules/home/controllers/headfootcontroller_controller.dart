import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:popover/popover.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:redouanstore/utilities/sum.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:search_page/search_page.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stepper_page_view/stepper_page_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../../../../data/colors.dart';
import '../../../../data/reposetory/categorie_data.dart';
import '../../../../data/reposetory/commande_data.dart';
import '../../../../data/reposetory/company_settings_data.dart';
import '../../../../data/reposetory/customer_data.dart';
import '../../../../data/reposetory/product_data.dart';
import '../../../../models/category.dart';
import '../../../../models/cmd.dart';
import '../../../../models/company.dart';
import '../../../../models/customers.dart';
import '../../../../models/ligne_cmd.dart';
import '../../../../models/menu.dart';
import '../../../../models/product.dart';
import '../../../../utilities/data_converter.dart';
import '../../../../utilities/ext.dart';
import '../../../../widgets/categorie_card_template.dart';
import '../../../routes/app_pages.dart';
import 'home_controller.dart';

class HeaderController extends GetxController {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  var companyData = CompanySettings();
  final customerData = CustomerData();
  final categoryReposetory = CategoriesData();
  final cntPage = PageController().obs;
  final cmdCode = ''.obs;
  final indexPage = 0.obs;
  final company = Company().obs;
  final onLoad = false.obs;
  final loaded = false.obs;
  final val = false.obs;
  final error = false.obs;
  final categories = <Category>[].obs;
  final badgeQte = 0.0.obs;
  final trackLoad = false.obs;
  final mouse = const PointerEnterEvent().obs;
  final cmdo = CustomerCommandes().obs;
  final minimumCost = 0.0.obs;
  final minimumCostController = TextEditingController().obs;
  final products = <Product>[].obs;
  final categorie = Category().obs;
  final cmdStatus = ''.obs;
  final links = <Links>[
    Links(name: 'الرئيسية', url: Routes.HOME, hover: false, showInMobile: true),
    Links(name: 'من نحن', url: Routes.ABOUT, hover: false, showInMobile: true),
    //Links(name: 'سياسة الخصوصية', url: '', hover: false, showInMobile: true),
    Links(name: 'المتجر', url: '', hover: false, showInMobile: false),
    //Links(name: 'العروض', url: '', hover: false, showInMobile: true),
  ].obs;

  final mobileLinks = <Links>[
    Links(name: 'الرئيسية', url: Routes.HOME, hover: false, showInMobile: true),
    Links(name: 'من نحن', url: Routes.ABOUT, hover: false, showInMobile: true),
    // Links(name: 'سياسة الخصوصية', url: '', hover: false, showInMobile: true),
    // Links(name: 'العروض', url: '', hover: false, showInMobile: true),
  ].obs;
  final tracked = false.obs;
  final webClosed = false.obs;
  final menu = <MasterMenu>[].obs;
  final cmdIDOP = ''.obs;
  final userID = ''.obs;
  final cmdsUser = <LigneCmd>[].obs;
  final currentCustomer = Customer().obs;
  final customerCommandes = <Commandes>[].obs;
  final trackCommande = Commandes().obs;
  final productData = ProductData();
  final customerNameController = TextEditingController().obs;
  final customerTelephoneController = TextEditingController().obs;
  final customerAdresseController = TextEditingController().obs;
  final codeFieldVisibilty = true.obs;
  final codeFieldController = TextEditingController().obs;
  Future<void> init() async {
    await companyData.getCompanyData.then((value) {
      return company.value = value;
    });
    await getCmdO.then((value) => cmdIDOP.value = value);
    await getUid.then((value) => userID.value = value);

    await customerData.readCustomers.then((value) async {
      if (value.where((element) => element.uKey == userID.value).isEmpty) {
        currentCustomer.value = Customer(
            uKey: userID.value,
            userName: '',
            userPwd: '',
            fullName: '',
            adresse: "",
            email: '',
            telephone: '',
            cart: cmdIDOP.value);
        await customerData.create(currentCustomer.value);
      } else {
        currentCustomer.value =
            value.firstWhere((element) => element.uKey == userID.value);
        customerNameController.value.text = currentCustomer.value.fullName!;
        customerTelephoneController.value.text =
            currentCustomer.value.telephone!;
        customerAdresseController.value.text = currentCustomer.value.adresse!;
      }
    });
    await categoryReposetory.readCategories.then((value) {
      categories.value = value
          .where((element) => element.products!
              .where((element) => element.visiblity)
              .isNotEmpty)
          .toList();
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      error.value = true;
    });
    await productData.readI().then((value) => products.value = value);
    await cmdo.value
        .readProductInCMD(currentCustomer.value, Commandes(key: cmdIDOP.value))
        .then((value) {
      cmdsUser.value = cartProducts(value);
      return badgeQte.value = cmdsUser.length.toDouble();
    });

    await loadCMDS();
  }

  Future<void> loadCMDS() async {
    await cmdo.value.readAllCmds
        .then((value) => customerCommandes.value = value);
    //codeFieldController.value.text = customerCommandes.length.toString();
  }

  Future<String> get getCommandeStatus async {
    if (codeFieldController.value.text.isNotEmpty &&
        customerCommandes
            .where(
                (element) => element.cmdCode == codeFieldController.value.text)
            .isNotEmpty) {
      var commandeData = customerCommandes.firstWhere(
          (element) => element.cmdCode == codeFieldController.value.text);
      trackCommande.value = commandeData;
      tracked.value = true;
      if (commandeData.confirmed! &&
          !commandeData.confiremdByAdmin! &&
          !commandeData.canceled! &&
          !commandeData.livred!) {
        return 'طلبية قيد الانتظار';
      }
      if (commandeData.confirmed! && !commandeData.confiremdByAdmin! ||
          commandeData.confiremdByAdmin! &&
              commandeData.canceled! &&
              !commandeData.livred!) {
        return 'طلبية مرفوضة ';
      }
      if (commandeData.confirmed! &&
          commandeData.confiremdByAdmin! &&
          !commandeData.canceled! &&
          !commandeData.livred!) {
        return 'طلبية سيتم  تسليمها في  ${intl.DateFormat("dd/MM/yyyy").format(commandeData.livredDate!)} ';
      }
      return 'تم تسليم الطلبية';
    } else {
      tracked.value = false;
      return 'لا توجد اي طلبية مطابقة لهذا الرمز';
    }
  }

  @override
  void onInit() async {
    try {
      error.value = false;
      onLoad.value = true;
      loaded.value = false;
      await init();
    } catch (e) {
      error.value = true;
      onLoad.value = false;
      loaded.value = false;
    } finally {
      onLoad.value = false;
      loaded.value = true;
      error.value = false;
    }
    super.onInit();
  }

  Widget get header => ResponsiveBuilder(
        builder: (BuildContext context, SizingInformation sizingInformation) {
          return Get.width <= 768
              ? Container(
                  height: 80,
                  color: BrandColors.kPrimaryColor,
                  child: Column(
                    children: [
                      Container(
                          width: Get.width,
                          color: BrandColors.googleRed,
                          child: Center(
                            child: Marquee(
                              textDirection: TextDirection.rtl,
                              animationDuration: const Duration(seconds: 1),
                              backDuration: const Duration(milliseconds: 5000),
                              pauseDuration: const Duration(milliseconds: 2500),
                              directionMarguee: DirectionMarguee.oneDirection,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  company.value.cartLimitDescription!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                      Center(
                        child: Row(
                          children: [
                            Center(
                              child: IconButton(
                                  onPressed: () {
                                    showDialogMenu();
                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    color: Colors.white.withOpacity(1),
                                  )),
                            ),
                            Expanded(flex: 6, child: Container()),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: InkWell(
                                child: Icon(
                                  Icons.trolley,
                                  color: BrandColors.backgrounGray,
                                  size: 25,
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                          child: SizedBox(
                                              height: 600,
                                              child: Dialog(
                                                child: Column(children: [
                                                  Text("تتبع الطلبيات",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: BrandColors
                                                              .xboxGrey)),
                                                  Visibility(
                                                    visible: codeFieldVisibilty
                                                        .value,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: TextFormField(
                                                          onChanged: (e) {},
                                                          controller:
                                                              codeFieldController
                                                                  .value,
                                                          validator:
                                                              ValidationBuilder()
                                                                  .minLength(10)
                                                                  .maxLength(10)
                                                                  .build(),
                                                          decoration: InputDecoration(
                                                              border: const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1)),
                                                              labelText:
                                                                  "كود الطلبية"
                                                                      .tr,
                                                              isCollapsed: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 10,
                                                                      bottom:
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  tracked.value
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              "مرجع الطلبية: ${trackCommande.value.key!}"),
                                                        )
                                                      : Container(),
                                                  tracked.value
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              "تاريخ ارسال الطلبية:   ${intl.DateFormat('dd/MM/yyyy').format(trackCommande.value.date!)}"),
                                                        )
                                                      : Container(),
                                                  tracked.value
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              "  قيمة السلة:   ${DataConverter.currencyConvert(trackCommande.value.cart!.sumTotal((element) => element.product!.isSale! ? element.qte! * element.product!.sPrice! : element.qte! * element.product!.nPrice!).toDouble())}"),
                                                        )
                                                      : Container(),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(customerCommandes
                                                                .where((element) =>
                                                                    element
                                                                        .cmdCode ==
                                                                    codeFieldController
                                                                        .value
                                                                        .text)
                                                                .isNotEmpty
                                                            ? "حالة الطلبية: ${cmdStatus.value}"
                                                            : cmdStatus.value),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          await getCommandeStatus
                                                              .then((e) =>
                                                                  cmdStatus
                                                                      .value = e);
                                                          Get.appUpdate();
                                                        },
                                                        child: const Center(
                                                          child: Text("تتبع"),
                                                        )),
                                                  )
                                                ]),
                                              ))));
                                },
                              ),
                            ),
                            Visibility(
                              visible: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: BrandColors.backgrounGray,
                                    size: 25,
                                  ),
                                  onPressed: () => showSearch(
                                    context: context,
                                    delegate: SearchPage<Product>(
                                      items: products,
                                      searchLabel: 'ادخل اسم المنتج',
                                      suggestion: const Center(
                                        child: Text('البحث عن منتج'),
                                      ),
                                      failure: const Center(
                                        child: Text('لا يوجد اي منتج :('),
                                      ),
                                      filter: (product) =>
                                          [product.productName],
                                      builder: (product) => ListTile(
                                        onTap: () {
                                          Get.find<HomeController>()
                                              .backVisible
                                              .value = true;
                                          Get.toNamed(Routes.PRODUCT_DETAIL,
                                              parameters: {"p": product.key!});
                                        },
                                        title: Text(product.productName!),
                                        subtitle: Text(product.productName!),
                                        trailing: Text(!product.isSale!
                                            ? DataConverter.currencyConvert(
                                                product.nPrice!)
                                            : DataConverter.currencyConvert(
                                                product.sPrice!)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(
                                FontAwesomeIcons.cartArrowDown,
                                color: BrandColors.backgrounGray,
                                size: 25,
                              ),
                              onPressed: () async {
                                await init();
                                minimumCost.value = cmdsUser
                                    .sumTotal((element) =>
                                        element.product!.isSale!
                                            ? element.qte! *
                                                element.product!.sPrice!
                                            : element.qte! *
                                                element.product!.nPrice!)
                                    .toDouble();

                                showCart();
                              },
                              label: Text("سلتي".tr,
                                  style: TextStyle(
                                    color: BrandColors.backgrounGray,
                                  )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    BrandColors.kPrimaryColor.withOpacity(.4),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 90,
                  color: BrandColors.kPrimaryColor,
                  child: Column(
                    children: [
                      Container(
                          width: Get.width,
                          height: 30,
                          color: BrandColors.googleRed,
                          child: Center(
                            child: Marquee(
                              textDirection: TextDirection.rtl,
                              animationDuration: const Duration(seconds: 1),
                              backDuration: const Duration(milliseconds: 5000),
                              pauseDuration: const Duration(milliseconds: 2500),
                              directionMarguee: DirectionMarguee.oneDirection,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  company.value.cartLimitDescription!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                      Row(
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/logo.png",
                                  height: 60, fit: BoxFit.fitHeight),
                              Row(
                                children: List.generate(
                                    links.length,
                                    (index) => InkWell(
                                          onHover: (e) {
                                            links[index].hover = e;
                                            links.refresh();
                                          },
                                          onTap: () {
                                            if (links[index].name == 'المتجر') {
                                              showPopover(
                                                transitionDuration:
                                                    const Duration(seconds: 1),
                                                context: context,
                                                bodyBuilder: (context) =>
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "الاصناف"),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    Responsive(
                                                                  children: List.generate(
                                                                      categories.take(10).length,
                                                                      (index) => Div(
                                                                          divison: const Division(colS: 6, colM: 3, colL: 2),
                                                                          child: InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.toNamed(Routes.CATEGORIES, parameters: {
                                                                                'c': categories[index].key!
                                                                              });
                                                                              categorie.value = categories[index];
                                                                              Get.appUpdate();
                                                                            },
                                                                            child:
                                                                                CategoryTemplateCard(
                                                                              categorie: categories[index],
                                                                            ),
                                                                          ))),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                onPop: () => print(
                                                    'Popover was popped!'),
                                                direction:
                                                    PopoverDirection.bottom,
                                                width: Get.width,
                                                height: 400,
                                                arrowHeight: 0,
                                                arrowWidth: 0,
                                              );
                                              return;
                                            }
                                            Get.toNamed(links[index].url!);
                                          },
                                          child: MouseRegion(
                                            onEnter:
                                                (PointerEnterEvent event) =>
                                                    mouse.value = event,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(links[index].name!,
                                                  style: TextStyle(
                                                      color: links[index].hover!
                                                          ? BrandColors
                                                              .alpamareBlue
                                                          : Colors.white)),
                                            ),
                                          ),
                                        )),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: SizedBox(
                                          height: 35,
                                          child: SearchField<Product>(
                                              suggestions: products
                                                  .map(
                                                      (element) =>
                                                          SearchFieldListItem<
                                                              Product>(
                                                            element
                                                                .productName!,
                                                            item: element,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  Get.find<
                                                                          HomeController>()
                                                                      .backVisible
                                                                      .value = true;
                                                                  Get.toNamed(
                                                                      Routes
                                                                          .PRODUCT_DETAIL,
                                                                      parameters: {
                                                                        "p": element
                                                                            .key!
                                                                      });
                                                                },
                                                                child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                            element.productName!),
                                                                      )),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(!element.isSale!
                                                                            ? DataConverter.currencyConvert(element.nPrice!)
                                                                            : DataConverter.currencyConvert(element.sPrice!)),
                                                                      )
                                                                    ])),
                                                          ))
                                                  .toList(),
                                              searchInputDecoration: InputDecoration(
                                                  label: Text("البحث عن منتج",
                                                      style: TextStyle(
                                                          color: BrandColors
                                                              .backgrounGray)),
                                                  isDense: true,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0,
                                                          color: BrandColors
                                                              .backgrounGray)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          gapPadding: 0,
                                                          borderSide: BorderSide(
                                                              width: 0,
                                                              color: BrandColors
                                                                  .xboxGreen))))),
                                    )),
                                Visibility(
                                  visible: true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: InkWell(
                                      child: Icon(
                                        Icons.trolley,
                                        color: BrandColors.backgrounGray,
                                        size: 25,
                                      ),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                                child: SizedBox(
                                                    height: 600,
                                                    child: Dialog(
                                                      child: Column(children: [
                                                        Text("تتبع الطلبيات",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: BrandColors
                                                                    .xboxGrey)),
                                                        Visibility(
                                                          visible:
                                                              codeFieldVisibilty
                                                                  .value,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 20,
                                                                    bottom: 20,
                                                                    right: 20),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(7.0),
                                                              child: Form(
                                                                key: _form,
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (e) {},
                                                                  controller:
                                                                      codeFieldController
                                                                          .value,
                                                                  validator: ValidationBuilder(
                                                                          requiredMessage:
                                                                              'المرجو ادخال رمز التتبع الصحيح')
                                                                      .minLength(
                                                                          10)
                                                                      .maxLength(
                                                                          10)
                                                                      .build(),
                                                                  decoration: InputDecoration(
                                                                      border: const OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1)),
                                                                      labelText:
                                                                          "كود الطلبية"
                                                                              .tr,
                                                                      isCollapsed:
                                                                          true,
                                                                      contentPadding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              15,
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                   trackLoad.value?const SizedBox(height:80,width:80,child:CircularProgressIndicator()) :      tracked.value
                                                            ? Column(children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                      "مرجع الطلبية: ${trackCommande.value.key!}"),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                      "مرجع الطلبية: ${trackCommande.value.key!}"),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                      "تاريخ ارسال الطلبية:   ${intl.DateFormat('dd/MM/yyyy').format(trackCommande.value.date!)}"),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                      "  قيمة السلة:   ${DataConverter.currencyConvert(trackCommande.value.cart!.sumTotal((element) => element.product!.isSale! ? element.qte! * element.product!.sPrice! : element.qte! * element.product!.nPrice!).toDouble())}"),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                      "حالة الطلبية: ${cmdStatus.value}"),
                                                                ),
                                                              ])
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                    cmdStatus
                                                                        .value),
                                                              ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                trackLoad
                                                                        .value =
                                                                    true;
                                                                     Get.appUpdate();
                                                                await Get.find<
                                                                        HeaderController>()
                                                                    .init();

                                                                await Get.find<
                                                                        HomeController>()
                                                                    .init();
                                                                await getCommandeStatus
                                                                    .then((e) =>
                                                                        cmdStatus.value =
                                                                            e);
                                                               
                                                                trackLoad
                                                                        .value =
                                                                    false;
                                                                     Get.appUpdate();
                                                              },
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                    "تتبع"),
                                                              )),
                                                        )
                                                      ]),
                                                    ))));
                                      },
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: Icon(
                                    FontAwesomeIcons.cartArrowDown,
                                    color: BrandColors.backgrounGray,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    await init();
                                    minimumCost.value = cmdsUser
                                        .sumTotal((element) =>
                                            element.product!.isSale!
                                                ? element.qte! *
                                                    element.product!.sPrice!
                                                : element.qte! *
                                                    element.product!.nPrice!)
                                        .toDouble();

                                    showCart();
                                  },
                                  label: Text("سلتي".tr,
                                      style: TextStyle(
                                        color: BrandColors.backgrounGray,
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: BrandColors.kPrimaryColor
                                        .withOpacity(.4),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
        },
      );

  Widget get footer => Container(
        color: BrandColors.kPrimaryColor,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
          child: Responsive(
            children: [
              Div(
                  divison: const Division(colS: 12, colM: 12, colL: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${company.value.companyName} ${DateTime.now().year}",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${company.value.shortDescription}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton.outlined(
                                  onPressed: () async {
                                    await launchUrl(
                                        Uri.parse(company.value.faceBook!));
                                  },
                                  icon: const Icon(Icons.facebook,
                                      color: Colors.white, size: 18)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton.outlined(
                                  onPressed: () async {
                                    var link = WhatsAppUnilink(
                                      phoneNumber: company.value.whatsapp,
                                      text: "خضر وفواكه الرضوان",
                                    );
                                    // Convert the WhatsAppUnilink instance to a Uri.
                                    // The "launch" method is part of "url_launcher".
                                    await launchUrl(link.asUri());
                                  },
                                  icon: const Icon(FontAwesomeIcons.whatsapp,
                                      color: Colors.white, size: 18)),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Div(
                  divison: const Division(colS: 12, colM: 12, colL: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("روابط مهمة",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            links.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {},
                                  child: Text("${links[index].name}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white))),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              Div(
                  divison: const Division(colS: 12, colM: 12, colL: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("تواصل معنا",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.mobile,
                                    size: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text("${company.value.telephone}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white))),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.phone,
                                    size: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text("${company.value.telephone}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white))),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.fax,
                                    size: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text("${company.value.fix}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white))),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.locationPin,
                                    size: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text("${company.value.adresse}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white))),
                              ],
                            )),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      );
  showDialogMenu() {
    showDialog(
        context: Get.context!,
        builder: (_) => Dialog.fullscreen(
              child: SizedBox(
                height: Get.height,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      color: BrandColors.kPrimaryColor,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.close,
                                color: BrandColors.backgrounGray,
                              )),
                        ],
                      ),
                    ),
                    Image.asset("assets/images/logo.png",
                        height: 60, fit: BoxFit.fitHeight),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: List.generate(
                            mobileLinks.length,
                            (index) => InkWell(
                                  onTap: () {
                                    Get.toNamed(links[index].url!);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(mobileLinks[index].name!),
                                  ),
                                )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Divider(
                        color: BrandColors.darkgray,
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Ctegories"),
                              ),
                              Responsive(
                                children: List.generate(
                                    categories.length,
                                    (index) => Div(
                                        divison: const Division(
                                            colS: 6, colM: 3, colL: 2),
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.CATEGORIES,
                                                parameters: {
                                                  'c': categories[index].key!
                                                });
                                            categorie.value = categories[index];
                                            Get.appUpdate();
                                          },
                                          child: CategoryTemplateCard(
                                            categorie: categories[index],
                                          ),
                                        ))),
                              ),
                            ],
                          )),
                    ))
                  ],
                ),
              ),
            ));
  }

  void showCart() {
    //GlobalKey<FormState> _form= GlobalKey<FormState>();
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (_) => Dialog(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: Get.width - 50,
                  height: Get.height - 50,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StepperPageView(
                          physics: const NeverScrollableScrollPhysics(),
                          pageController: cntPage.value,
                          initialPage: indexPage.value,
                          pageSteps: [
                            PageStep(
                              isActive: true,
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('السلة'.tr),
                                  ),
                                  IconButton(
                                      onPressed: cmdsUser.isEmpty
                                          ? null
                                          : () async {
                                              print("wai");
                                              var link = WhatsAppUnilink(
                                                text:
                                                    "${List.generate(cmdsUser.length, (index) => '${cmdsUser[index].product!.productName!} x ${cmdsUser[index].qte!} ${cmdsUser[index].product!.unit!}')}\n",
                                              );

                                              await launchUrl(link.asUri());
                                            },
                                      icon: Icon(Icons.share,
                                          color: BrandColors.alpamareBlue))
                                ],
                              ),
                              content: SizedBox(
                                width: double.infinity,
                                child: Column(children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('السلة',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                                onPressed: cmdsUser.isEmpty
                                                    ? null
                                                    : () async {
                                                        var ttttt =
                                                            "${List.generate(cmdsUser.length, (index) => '${index + 1} - ${cmdsUser[index].product!.productName!} (${cmdsUser[index].qte!} ${cmdsUser[index].product!.unit!})')}\n"
                                                                .replaceAll(
                                                                    '[', '');
                                                        var link =
                                                            WhatsAppUnilink(
                                                          text: ttttt
                                                              .replaceAll(
                                                                  ']', '')
                                                              .replaceAll(
                                                                  ',', '\n'),
                                                        );

                                                        await launchUrl(
                                                            link.asUri());
                                                      },
                                                icon: Icon(Icons.share,
                                                    color: BrandColors
                                                        .alpamareBlue)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: ScrollTransformView(
                                    children: List.generate(
                                        cmdsUser.length,
                                        (index) => ScrollTransformItem(
                                                builder: (double scrollOffset) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1)),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(cmdsUser[
                                                                      index]
                                                                  .product!
                                                                  .productName!),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  '${cmdsUser[index].qte!.toString()}  (${cmdsUser[index].product!.unit!})'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Directionality(
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          child: Text(DataConverter.currencyConvert(cmdsUser[
                                                                      index]
                                                                  .product!
                                                                  .isSale!
                                                              ? cmdsUser[index]
                                                                      .qte! *
                                                                  cmdsUser[
                                                                          index]
                                                                      .product!
                                                                      .sPrice!
                                                              : cmdsUser[index]
                                                                      .qte! *
                                                                  cmdsUser[
                                                                          index]
                                                                      .product!
                                                                      .nPrice!)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                  )),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              company
                                                  .value.cartLimitDescription!,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                              DataConverter.currencyConvert(
                                                  cmdsUser
                                                      .sumTotal((element) =>
                                                          element.product!
                                                                  .isSale!
                                                              ? element.qte! *
                                                                  element
                                                                      .product!
                                                                      .sPrice!
                                                              : element.qte! *
                                                                  element
                                                                      .product!
                                                                      .nPrice!)
                                                      .toDouble()),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: Container()),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: minimumCost.value <
                                                      company
                                                          .value.cartLimitMnt!
                                                  ? null
                                                  : () {
                                                      cntPage.value
                                                          .jumpToPage(1);
                                                    },
                                              child: const Center(
                                                child: Text("التالي"),
                                              )),
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            ),
                            PageStep(
                              title: const Text('المعلومات الشخصية'),
                              content: Form(
                                key: _form,
                                child: Column(
                                  children: [
                                    const Text('المعلومات الشخصية',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900)),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                top: 20,
                                                bottom: 20,
                                                right: 20),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: TextFormField(
                                                onChanged: (e) {},
                                                controller:
                                                    customerNameController
                                                        .value,
                                                validator: ValidationBuilder()
                                                    .minLength(3)
                                                    .build(),
                                                decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1)),
                                                    labelText:
                                                        "الاسم الكامل".tr,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 10,
                                                            bottom: 10)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                top: 20,
                                                bottom: 20,
                                                right: 20),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                textAlign: TextAlign.end,
                                                textDirection:
                                                    TextDirection.ltr,
                                                controller:
                                                    customerTelephoneController
                                                        .value,
                                                validator: ValidationBuilder()
                                                    .phone()
                                                    .build(),
                                                inputFormatters: const <TextInputFormatter>[
                                                  // FilteringTextInputFormatter
                                                  //   .allow(RegExp(
                                                  //    r'(^\d*\.?\d{0,2})'))
                                                ],
                                                decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1)),
                                                    labelText: "رقم الهاتف".tr,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 10,
                                                            bottom: 10)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                top: 20,
                                                bottom: 20,
                                                right: 20),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: TextFormField(
                                                onChanged: (e) {},
                                                controller:
                                                    customerAdresseController
                                                        .value,
                                                validator: ValidationBuilder()
                                                    .minLength(5)
                                                    .build(),
                                                decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1)),
                                                    labelText:
                                                        "عنوان الاقامة".tr,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 10,
                                                            bottom: 10)),
                                                maxLines: null,
                                                maxLength: 200,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  cntPage.value.jumpToPage(0);
                                                },
                                                child: const Center(
                                                  child: Text("السابق"),
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_form.currentState!
                                                      .validate()) {
                                                    Get.appUpdate();
                                                    cntPage.value.jumpToPage(2);
                                                  }
                                                },
                                                child: const Center(
                                                  child: Text("التالي"),
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            PageStep(
                              title: const Text('ارسال الطلبية'),
                              content: Column(children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('المعلومات الشخصية',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900)),
                                ),
                                Container(
                                  width: 350,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: BrandColors.backgrounGray,
                                  ),
                                  child: Stack(children: [
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                'الاسم: ${customerNameController.value.text}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                'رقم الهاتف: ${customerTelephoneController.value.text}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                'العنوان: ${customerAdresseController.value.text}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                'المبلغ الواجب اداؤه: ${DataConverter.currencyConvert(cmdsUser.sumTotal((element) => element.product!.isSale! ? element.qte! * element.product!.sPrice! : element.qte! * element.product!.nPrice!).toDouble())}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        ),
                                      ),
                                    ])
                                  ]),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              cntPage.value.jumpToPage(1);
                                            },
                                            child: const Center(
                                              child: Text("السابق"),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              var _customer = Customer(
                                                  uKey: userID.value,
                                                  fullName:
                                                      customerNameController
                                                          .value.text,
                                                  telephone:
                                                      customerTelephoneController
                                                          .value.text,
                                                  adresse:
                                                      customerAdresseController
                                                          .value.text,
                                                  userName: "",
                                                  userPwd: "",
                                                  email: "");
                                              final rs = RandomString();
                                              cmdCode.value =
                                                  rs.getRandomString(
                                                      lowersCount: 2,
                                                      uppersCount: 2,
                                                      specialsCount: 0,
                                                      numbersCount: 6);
                                              print(cmdCode.value);
                                              await cmdo.value
                                                  .update(_customer);
                                              await cmdo.value
                                                  .updateCmd(
                                                      _customer,
                                                      Commandes(
                                                          key: cmdIDOP.value,
                                                          cmdCode:
                                                              cmdCode.value,
                                                          confirmed: true,
                                                          date: DateTime.now(),
                                                          canceled: false,
                                                          livred: false,
                                                          closed: false,
                                                          confiremdByAdmin:
                                                              false,
                                                          customer: _customer))
                                                  .whenComplete(() async {
                                                await box.remove('cmd');
                                                await box.write(
                                                  'cmd',
                                                  uuid.value.v1(),
                                                );
                                              });
                                              Get.appUpdate();
                                              cntPage.value.jumpToPage(3);
                                            },
                                            child: const Center(
                                              child: Text("التالي"),
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                            PageStep(
                                title: const Text("تنبيه"),
                                content: Column(
                                  children: [
                                    const Text("تنبيه"),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                              width: 250,
                                              height: 150,
                                              child: Center(
                                                  child: Text(
                                                      "تم ارسال الطلبية بنجاح"))),
                                          SizedBox(
                                              height: 150,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        'كود تتبع الطلبية ${cmdCode.value}'),
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        await Clipboard.setData(
                                                            ClipboardData(
                                                                text: cmdCode
                                                                    .value));
                                                      },
                                                      child: const Icon(
                                                          Icons.copy))
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('انهاء')),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  )),
            )));
  }

// cntPage.value.jumpToPage(1);
  List<LigneCmd> cartProducts(List<LigneCmd> items) {
    List<LigneCmd> productsL = [];

    Map<String, List<LigneCmd>> groupedItems =
        groupBy(items, (item) => item.product!.key!);
    groupedItems.forEach((key, value) {
      // print(productsI.firstWhere((element) => element.key == key).cmdKey);
      productsL.add(LigneCmd(
          product: products.firstWhere((element) => element.key == key),
          qte: value.sumTotal((el) => el.qte!).toDouble()));
    });

    return productsL;
  }

  Future<void> create() async {
    await getCmdO.then((value) => cmdIDOP.value = value);

    cmds.where((p0) => p0.key == cmdIDOP.value).forEach((p) {});

    if (cmds
            .where((p) => p.confirmed! || p.canceled! || p.livred! || p.closed!)
            .where((p) => p.key == cmdIDOP.value)
            .isNotEmpty ||
        cmds.isEmpty) {
      await getCmdO.then((value) {
        cmdIDOP.value = value;
        currentCustomer.value.cart = value;
      });
      //  await box.remove('cmd');

      await getCmdO.then((value) => cmdIDOP.value = value);
      await cust.createCustomerCmd(
          currentCustomer.value,
          Commandes(
              key: cmdIDOP.value,
              date: DateTime.now(),
              livred: false,
              confirmed: false,
              canceled: false,
              closed: false,
              customer: Customer(uKey: userID.value)));
    }
  }

  final cmds = <Commandes>[].obs;

  Future<String> get getUid async {
    if ((await box.read('userKey')) == null) {
      await box.write(
        'userKey',
        uuid.value.v1(),
      );
    }
    return await box.read('userKey');
  }

  Future<String> get getCmdO async {
    if ((await box.read('cmd')) == null) {
      await box.write(
        'cmd',
        uuid.value.v1(),
      );
    }
    return await box.read('cmd');
  }

  final uuid = const Uuid().obs;
  final cust = CustomerCommandes();

  /**Icon(Icons.search),
  tooltip: 'Search people',
  onPressed: () => showSearch(
    context: context,
    delegate: SearchPage<Person>(
      items: people,
      searchLabel: 'Search people',
      suggestion: Center(
        child: Text('Filter people by name, surname or age'),
      ),
      failure: Center(
        child: Text('No person found :('),
      ),
      filter: (person) => [
        person.name,
        person.surname,
        person.age.toString(),
      ],
      builder: (person) => ListTile(
        title: Text(person.name),
        subtitle: Text(person.surname),
        trailing: Text('${person.age} yo'),
      ),
    ),
  ) */
}
