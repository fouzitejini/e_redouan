import 'dart:html';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redouanstore/app/routes/app_pages.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../../../../data/colors.dart';
import '../../../../models/admin_menu.dart';

import '../../../../utilities/ext.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/admi_menu_controller_controller.dart';
import '../controllers/admin_controller.dart';
import 'admin_acount_view.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({
    super.key,
    required this.child,
    required this.ontap,
    required this.menu,
    required this.deadSession,
    required this.cmds,
  });
  final Widget child;
  final List<AdminMasterMenu> menu;
  final void Function(int index) ontap;
  final bool deadSession;
  final int cmds ;

  @override
  Widget build(BuildContext context) {
    return deadSession
        ? AdminAcountView()
        : Scaffold(
            body: ResponsiveBuilder(builder: (_, size) {
              if (Get.width >= 768) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.maxFinite,
                      color: BrandColors.almouasat,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.HOME);
                                },
                                child: Text(
                                  "عودة الى الموقع",
                                  style: TextStyle(
                                      color: BrandColors.backgrounGray),
                                )),
                          ),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Badge(
                              label: Text(cmds.toString()),
                              child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.HOME);
                                  },
                                  child: Text(
                                    "Commandes",
                                    style: TextStyle(
                                        color: BrandColors.backgrounGray),
                                  )),
                            ),
                          ),

                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                onPressed: () {
                                  
                                },
                                child: Text(
                                  "V 1.0.0.0",
                                  style: TextStyle(
                                      color: BrandColors.backgrounGray),
                                )),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                 
                                  box.remove("sessionTime");
                                  box.write('sessionTime',
                                      DateTime(2000, 1, 1).toString());
                                  Get.toNamed(Routes.HOME);
                                  Get.find<HomeController>().init();
                                  Get.find<AdminController>().onInit();
                                  Get.find<AdminController>().deadSession.value =true;
                                  
                                },
                                label: Text(
                                  "تسجيل الخروج ",
                                  style: TextStyle(
                                      color: BrandColors.xboxGrey),
                                ),
                                icon: const Icon(Icons.exit_to_app)),
                          )
                        ],
                      ),
                    ),
                    Responsive(children: [
                      Div(
                          divison: const Division(colS: 3),
                          child: _DesktopMenu(
                            menu: menu,
                            ontap: (int index) {
                              return ontap(index);
                            },
                          )),
                      Div(divison: const Division(colS: 9), child: child),
                    ]),
                  ],
                );
              } else {
                return _MobileMenu(
                    menu: menu,
                    ontap: (int index) {
                      return ontap(index);
                    },
                    child: child);
              }
            }),
          );
  }
}

class _DesktopMenu extends StatelessWidget {
  const _DesktopMenu({required this.menu, required this.ontap});
  final List<AdminMasterMenu> menu;
  final void Function(int index) ontap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height - 50,
      child: Container(
        color: BrandColors.almouasat,
        child: Accordion(
            maxOpenSections: 1,
            headerBackgroundColorOpened: Colors.black54,
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: List.generate(menu.length, (index) {
              if (menu[index].subMenu!.isNotEmpty) {
                return AccordionSection(
                  isOpen: false,
                  leftIcon: Icon(menu[index].icon!, color: Colors.white),
                  headerBackgroundColor: Colors.amber,
                  headerBackgroundColorOpened: Colors.red,
                  header:
                      Text(menu[index].menuTitle!, style: const TextStyle()),
                  content: Column(
                    children: List.generate(
                        menu[index].subMenu!.length,
                        (i) => ListTile(
                              title: Text(
                                menu[index].subMenu![i].menuTitle!,
                                style: const TextStyle(),
                              ),
                              leading: Icon(menu[index].subMenu![i].icon!),
                              onTap: () {
                                return ontap(menu[index].subMenu![i].index!);
                              },
                            )),
                  ),

                  contentHorizontalPadding: 20,
                  contentBorderWidth: 1,
                  // onOpenSection: () => print('onOpenSection ...'),
                  // onCloseSection: () => print('onCloseSection ...'),
                );
              } else {
                return AccordionSection(
                  onOpenSection: () {
                    //  Get.toNamed(Routes.ADMIN);
                  },
                  isOpen: false,
                  leftIcon: Icon(menu[index].icon!, color: Colors.white),
                  headerBackgroundColor: Colors.amber,
                  headerBackgroundColorOpened: Colors.red,
                  header:
                      Text(menu[index].menuTitle!, style: const TextStyle()),
                  content: const Text("Home"),
                );
              }
            })),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  _MobileMenu({required this.child, required this.menu, required this.ontap});
  final Widget child;
  final List<AdminMasterMenu> menu;
  final void Function(int index) ontap;
  final cnt = Get.put(AdminMenuController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => Dialog.fullscreen(
                            child: SizedBox(
                              height: Get.height - 50,
                              child: Container(
                                color: BrandColors.almouasat,
                                child: Accordion(
                                    maxOpenSections: 1,
                                    headerBackgroundColorOpened: Colors.black54,
                                    scaleWhenAnimating: true,
                                    openAndCloseAnimation: true,
                                    headerPadding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    sectionOpeningHapticFeedback:
                                        SectionHapticFeedback.heavy,
                                    sectionClosingHapticFeedback:
                                        SectionHapticFeedback.light,
                                    children:
                                        List.generate(menu.length, (index) {
                                      if (menu[index].subMenu!.isNotEmpty) {
                                        return AccordionSection(
                                          isOpen: false,
                                          leftIcon: Icon(menu[index].icon!,
                                              color: Colors.white),
                                          headerBackgroundColor: Colors.amber,
                                          headerBackgroundColorOpened:
                                              Colors.red,
                                          header: Text(menu[index].menuTitle!,
                                              style: const TextStyle()),
                                          content: Column(
                                            children: List.generate(
                                                menu[index].subMenu!.length,
                                                (i) => ListTile(
                                                      title: Text(
                                                        menu[index]
                                                            .subMenu![i]
                                                            .menuTitle!,
                                                        style:
                                                            const TextStyle(),
                                                      ),
                                                      leading: Icon(menu[index]
                                                          .subMenu![i]
                                                          .icon!),
                                                      onTap: () {
                                                        Get.back();
                                                        return ontap(menu[index]
                                                            .subMenu![i]
                                                            .index!);
                                                      },
                                                    )),
                                          ),

                                          contentHorizontalPadding: 20,
                                          contentBorderWidth: 1,
                                          // onOpenSection: () => print('onOpenSection ...'),
                                          // onCloseSection: () => print('onCloseSection ...'),
                                        );
                                      } else {
                                        return AccordionSection(
                                          onOpenSection: () {
                                            // Get.toNamed(Routes.ADMIN);
                                          },
                                          isOpen: false,
                                          leftIcon: Icon(menu[index].icon!,
                                              color: Colors.white),
                                          headerBackgroundColor: Colors.amber,
                                          headerBackgroundColorOpened:
                                              Colors.red,
                                          header: Text(menu[index].menuTitle!,
                                              style: const TextStyle()),
                                          content: const Text("Home"),
                                        );
                                      }
                                    })),
                              ),
                            ),
                          ));
                },
                child: const Icon(
                  Icons.menu,
                  size: 35,
                ),
              )
            ],
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}
