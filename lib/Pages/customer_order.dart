import 'package:flutter/material.dart';
import '../Helpers/ProgressBar.dart';
import '../Models/orderModel.dart';
import '../Services/ordersService.dart';

class CustomerOrderPage extends StatefulWidget {
  final Order order;
  final Function callback;

  const CustomerOrderPage({super.key, required this.order, required this.callback});

  @override
  _CustomerOrderPageState createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  @override
  void initState() {
    super.initState();
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
        padding: const EdgeInsets.all(20.0),
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
                      ListTile(
                          title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Cliente:  ${widget.order.customerName}"),
                      ]))
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("Orden:  ${widget.order.id}"),
                          ]),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Modificado por: ${widget.order.lastModifiedBy}'),
                            Text('Estado: ${widget.order.status}'),
                          ]))
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(''),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(''),
                          Column(
                            children: [
                              InkWell(
                                radius: 1000,
                                onTap: () async {
                                  ProgressBar.instance.show(context);
                                  await OrdersService.startScan(widget.order.id);
                                  ProgressBar.instance.hide();
                                  widget.callback(6, widget.order, 0);
                                },
                                child: Image.asset(
                                  'assets/images/Scan.png',
                                  width: 60,
                                ),
                              ),
                              const Text('LECTURA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                            ],
                          ),
                          const Text(''),
                          Column(
                            children: [
                              InkWell(
                                radius: 1000,
                                onTap: () {
                                  widget.callback(7, widget.order, 0);
                                },
                                child: Image.asset('assets/images/Sync.png', width: 60),
                              ),
                              const Text('SINCRONIZACIÓN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                            ],
                          ),
                          const Text(''),
                        ],
                      ),
                      const Text(''),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(''),
                          Column(
                            children: [
                              InkWell(
                                radius: 1000,
                                onTap: () {
                                  widget.callback(8, widget.order, 0);
                                },
                                child: Image.asset('assets/images/detalle.png', width: 60),
                              ),
                              const Text('DETALLES DEL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                              const Text('PEDIDO', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                            ],
                          ),
                          const Text(''),
                          Column(
                            children: [
                              InkWell(
                                radius: 1000,
                                onTap: () {
                                  widget.callback(4, widget.order, 5);
                                },
                                child: Image.asset('assets/images/List.png', width: 60),
                              ),
                              const Text('SERIALES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                              const Text('ESCANEADOS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                            ],
                          ),
                          const Text(''),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(''),
                          Column(
                            children: [
                              InkWell(
                                radius: 1000,
                                onTap: () {
                                  widget.callback(2, "", 0);
                                },
                                child: Image.asset('assets/images/Close.png', width: 60),
                              ),
                              const Text('SALIR DEL', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                              const Text('PEDIDO', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                            ],
                          ),
                          const Text(''),
                        ],
                      ),
                      const Text(''),
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
