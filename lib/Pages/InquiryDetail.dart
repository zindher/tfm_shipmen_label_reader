import 'package:flutter/material.dart';
import '../Models/OrderReportModel.dart';
import '../Models/orderModel.dart';
import '../Services/ordersService.dart';

class InquiryDetailPage extends StatefulWidget {
  final Order order;

  const InquiryDetailPage({super.key, required this.order});

  @override
  _InquiryDetailPageState createState() => _InquiryDetailPageState();
}

class _InquiryDetailPageState extends State<InquiryDetailPage> {
  List<OrderReport> _orderDetails = [];

  Future<void> getOrderDetails() async {
    var a = await OrdersService.getReportDetailsOrder(widget.order.id);
    setState(() {
      _orderDetails = a;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int x = 0; x < _orderDetails.length; x++) ...[
                        ListTile(
                            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(''),
                              Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                const Text('# Parte: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Container(
                                  width: 275,
                                  child: Text('${_orderDetails[x].partNumber}', style: TextStyle(fontSize: 15)),
                                ),
                              ]),
                              Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                const Text('Descripción: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ]),
                              Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                Container(
                                  width: 328,
                                  child: Text('${_orderDetails[x].description}', style: TextStyle(fontSize: 15)),
                                ),
                              ])
                            ]),
                            subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                const Text('Cantidad Planeada', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text('${_orderDetails[x].quantityPlan}'),
                              ]),
                              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                const Text('Escaneadas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text('${_orderDetails[x].quantityReal}'),
                              ]),
                              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                const Text('Diferencia', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text('${_orderDetails[x].quantityDiff}'),
                              ]),
                            ]))
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}