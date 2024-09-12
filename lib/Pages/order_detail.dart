import 'package:flutter/material.dart';
import '../Helpers/ProgressBar.dart';
import '../Helpers/alert.dart';
import '../Models/orderDetailModel.dart';
import '../Models/orderModel.dart';
import '../Services/ordersService.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<OrderDetail> _orderDetails = [];

  Future<void> getOrderDetails(filter) async {
    List<OrderDetail> response = [];
    var o = await OrdersService.getOrderDetailsByOrder(widget.order);
    if (o != null) {
      if (filter.toString().isNotEmpty) {
        response = o
            .where((e) => (e.partNumber.toUpperCase().contains(filter.toString().toUpperCase()) ||
                e.quantity.toString().toUpperCase().contains(filter.toString().toUpperCase()) ||
                e.serial.toUpperCase().contains(filter.toString().toUpperCase()) ||
                e.master.toUpperCase().contains(filter.toString().toUpperCase()) ||
                e.date.toString().toUpperCase().contains(filter.toString().toUpperCase())))
            .toList();
      } else {
        response = o;
      }
    }
    setState(() {
      _orderDetails = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderDetails("");
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
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: [
                  Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
                    TextFormField(
                      onChanged: (text) {
                        ProgressBar.instance.show(context);
                        getOrderDetails(text);
                        ProgressBar.instance.hide();
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Buscar',
                      ),
                    ),
                    Text(''),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _orderDetails.length,
                      itemBuilder: (context, index) {
                        OrderDetail item = _orderDetails[index];
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(item.partNumber),
                          onDismissed: (direction) async {
                            var a = await OrdersService.DeleteScanById(item.id);
                            if (!a.hasError) {
                              setState(() {
                                _orderDetails.removeAt(index);
                              });
                              AlertHelper.showSuccessToast(a.message);
                            } else {
                              AlertHelper.showErrorToast(a.message);
                            }
                          },
                          background: const ColoredBox(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.delete, color: Colors.white, size: 50),
                                ),
                              )),
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(''),
                                      Text('# Parte: ${item.partNumber}'),
                                    ]),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(''),
                                      Text('Cantidad: ${item.qty}'),
                                      Text('Master: ${item.master}'),
                                      Text('Fecha: ${DateFormat('yyyy-MM-dd – kk:mm').format(item.date!)}'),
                                      Text(''),
                                    ]))
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ])
                ]))));
  }
}
