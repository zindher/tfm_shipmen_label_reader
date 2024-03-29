import 'package:flutter/material.dart';
import '../Helpers/ProgressBar.dart';
import '../Helpers/alert.dart';
import '../Models/orderModel.dart';
import '../Models/responseMessageModel.dart';
import '../Services/ordersService.dart';

class SyncPage extends StatefulWidget {
  final Order order;
  final Function callback;

  const SyncPage({super.key, required this.order, required this.callback});

  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  int _optionsNumber = 1;
  int _finish = 0;

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
    ResponseMessage response = ResponseMessage(hasError: true, message: "", extraData: "");
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.all(20.0),
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
                          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(''),
                            Text("Pedido:  ${widget.order.id}"),
                          ]),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(''),
                            Text('Cliente: ${widget.order.customerName}'),
                            Text(''),
                          ]))
                    ],
                  ),
                ),
                Text(""),
                Visibility(
                    visible: _optionsNumber == 1,
                    child: Column(children: <Widget>[
                      InkWell(
                        radius: 1000,
                        child: Image.asset('assets/images/Sync.png', width: 120),
                      ),
                      Text("SINCRONIZA PARA CREAR ", style: const TextStyle(fontSize: 16, color: Colors.green)),
                      Text("TU REMISIÓN", style: const TextStyle(fontSize: 16, color: Colors.green)),
                    ])),
                Visibility(
                    visible: _optionsNumber == 2,
                    child: Column(children: <Widget>[
                      InkWell(
                        radius: 1000,
                        child: Image.asset('assets/images/done.png', width: 120),
                      ),
                      Text("SINCRONIZACIÓN ", style: const TextStyle(fontSize: 16, color: Colors.green)),
                      Text("TERMINADA CON EXITO", style: const TextStyle(fontSize: 16, color: Colors.green)),
                    ])),
                Visibility(
                    visible: _optionsNumber == 3,
                    child: Column(children: <Widget>[
                      InkWell(
                        radius: 1000,
                        child: Image.asset('assets/images/Close.png', width: 120),
                      ),
                      Text("ERROR, CONTACTE A SISTEMAS", style: const TextStyle(fontSize: 16, color: Colors.red)),
                    ])),
                Text(""),
                Text(""),
                Visibility(
                    visible: _finish == 0,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                      onPressed: () async => {
                        ProgressBar.instance.show(context),
                        response = await OrdersService.syncOrder(await OrdersService.startScan(widget.order.id)),
                        if (!response.hasError)
                          {AlertHelper.showSuccessToast(response.message), _optionsNumber = 2, _finish = 1}
                        else
                          {AlertHelper.showErrorToast(response.message), _optionsNumber = 3},
                        setState(() {}),
                        ProgressBar.instance.hide()
                      },
                      child: const Text(' SINCRONIZAR ', style: TextStyle(fontSize: 15, color: Colors.white)),
                    )),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffB40000))),
                    onPressed: () async => {widget.callback(5, widget.order, 2)},
                    child: const Text('    CANCELAR    ', style: TextStyle(fontSize: 15, color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
