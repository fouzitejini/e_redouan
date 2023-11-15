import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../widgets/loading.dart';
import '../controllers/admin_controller.dart';

class AdminHomeView extends GetView {
  AdminHomeView({Key? key}) : super(key: key);
  final cnt = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cnt.loaded.value) {
        cnt.customersHasCmd.listen((event) {
          cnt.customersHasCmd.value = event;
          
        });
  
        return StreamBuilder(
          stream: cnt.initDataCmd(),
          initialData: [],
          builder: (_, data) {
            cnt.chartData.value = List.generate(
                data.data!.length,
                (index) => ChartData(data.data![index].product!.productName!,
                    data.data![index].qte!));
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: Get.height - 50,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                              minimum: 0, maximum: cnt.maxQte.value, interval: 1),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          onTooltipRender: (TooltipArgs args) {
                            final NumberFormat format =
                                NumberFormat.decimalPattern();
                            args.text =
                                '${args.dataPoints![args.pointIndex!.toInt()].x} : ${format.format(args.dataPoints![args.pointIndex!.toInt()].y)}';
                          },
                          title: ChartTitle(text: "المنتجات الاكثر مبيعا"),
                          legend: const Legend(isVisible: false),
                          series: <ChartSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              name: "10 المنتجات الاكثر طلبا  ",
                              dataSource: cnt.chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.inside,
                                  showCumulativeValues: true,
                                  connectorLineSettings:
                                      const ConnectorLineSettings(
                                          // Type of the connector line
                                          type: ConnectorType.line),
                                  builder: (dynamic dataB,
                                      dynamic point,
                                      dynamic series,
                                      int pointIndex,
                                      int seriesIndex) {
                                    return Text(
                                        '${data.data![pointIndex].qte!.toString()} ${data.data![pointIndex].product!.unit!}');
                                  }),
                            )
                          ]))
                ],
              ),
            );
          },
        );
      } else {
        return const Loading();
      }
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
