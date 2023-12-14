import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:tfm_shipmen_label_reader/Models/orderDetailModel.dart';
import '../Helpers/ProgressBar.dart';
import '../Models/responseMessageModel.dart';
import '../Helpers/alert.dart';
import '../Models/orderModel.dart';
import '../Services/ordersService.dart';

class ReadFramesPage extends StatefulWidget {
  final Order order;

  const ReadFramesPage({super.key, required this.order});

  @override
  _ReadFramesPageState createState() => _ReadFramesPageState();
}

class _ReadFramesPageState extends State<ReadFramesPage> {
  ResponseMessage response = ResponseMessage(hasError: true, message: "", extraData: "");
  int _optionsNumber = 0;

  var labelText1 = "";
  var labelText2 = "";
  var isAKI = false;

  final fMasterTextController = TextEditingController();
  final fQtyTextController = TextEditingController();
  final fPartNumberTextController = TextEditingController();
  final fSerialTextController = TextEditingController();
  final fAKISerialTextController = TextEditingController();

  final pMasterTextController = TextEditingController();
  final pQtyTextController = TextEditingController();
  final pPartNumberTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.order.customerName.contains('AKI')) {
      isAKI = true;
      labelText1 = "AKI WEB";
      labelText2 = "Escanea AKI WEB";
    } else {
      isAKI = false;
      labelText1 = "No. Parte";
      labelText2 = "Escanea Número de Parte";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fSave() async {
    if (isAKI) {
      if (fPartNumberTextController.text.length > 5 &&
          int.parse(fQtyTextController.text) > 0 &&
          fSerialTextController.text.length > 5 &&
          fMasterTextController.text.length > 5 &&
          fAKISerialTextController.text.length > 5) {
        response = await OrdersService.saveOrderContent(OrderDetail(
            id: widget.order.id,
            partNumber: fPartNumberTextController.text,
            quantity: Decimal.parse(fQtyTextController.text),
            serial: fSerialTextController.text,
            master: fMasterTextController.text,
            date: null,
            akiSerial: fAKISerialTextController.text));
        if (!response.hasError) {
          fCleanFields();
          AlertHelper.showSuccessToast(response.message);
        } else {
          AlertHelper.showErrorToast(response.message);
        }
      } else {
        AlertHelper.showErrorToast('Datos incorrectos revisalos!!');
      }
    } else {
      if (fPartNumberTextController.text.length > 5 &&
          int.parse(fQtyTextController.text) > 0 &&
          fSerialTextController.text.length > 5 &&
          fMasterTextController.text.length > 5) {
        response = await OrdersService.saveOrderContent(OrderDetail(
            id: widget.order.id,
            partNumber: fPartNumberTextController.text,
            quantity: Decimal.parse(fQtyTextController.text),
            serial: fSerialTextController.text,
            master: fMasterTextController.text,
            date: null,
            akiSerial: fAKISerialTextController.text));
        if (!response.hasError) {
          fCleanFields();
          AlertHelper.showSuccessToast(response.message);
        } else {
          AlertHelper.showErrorToast(response.message);
        }
      } else {
        AlertHelper.showErrorToast('Datos incorrectos revisalos!!');
      }
    }
  }

  Future<void> pSave() async {
    if (pPartNumberTextController.text.length > 5 && int.parse(pQtyTextController.text) > 0 && pMasterTextController.text.length > 5) {
      response = await OrdersService.saveOrderContent(OrderDetail(
          id: widget.order.id,
          partNumber: pPartNumberTextController.text,
          quantity: Decimal.parse(pQtyTextController.text),
          serial: "",
          master: pMasterTextController.text,
          date: null,
          akiSerial: ""));
      if (!response.hasError) {
        pCleanFields();
        AlertHelper.showSuccessToast(response.message);
      } else {
        AlertHelper.showErrorToast(response.message);
      }
    } else {
      AlertHelper.showErrorToast('Datos incorrectos revisalos!!');
    }
  }

  void fCleanFields() {
    fMasterTextController.text = "";
    fQtyTextController.text = "";
    fPartNumberTextController.text = "";
    fSerialTextController.text = "";
    fAKISerialTextController.text = "";

    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
  }

  void pCleanFields() {
    pMasterTextController.text = "";
    pQtyTextController.text = "";
    pPartNumberTextController.text = "";
    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
  }

  @override
  Widget build(BuildContext context) {
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
                            Text('# Orden: ${widget.order.id}'),
                          ]),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Cliente: ${widget.order.customerName}'),
                          ]))
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      const Expanded(child: Text("")),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                        onPressed: () async => {
                          setState(() {
                            _optionsNumber = 1;
                          })
                        },
                        child: const Text('Lectura de Frames', style: TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      const Expanded(child: Text("")),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                        onPressed: () async => {
                          setState(() {
                            _optionsNumber = 2;
                          })
                        },
                        child: const Text('Lectura de Partes', style: TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      const Expanded(child: Text("")),
                    ]),
                  ),
                ]),
                const Text(''),
                Visibility(
                    visible: _optionsNumber == 1,
                    child: Column(children: <Widget>[
                      const Text('Lectura de Frames', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                      TextFormField(
                        controller: fMasterTextController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onTap: () => fMasterTextController.selection = TextSelection(baseOffset: 0, extentOffset: fMasterTextController.value.text.length),
                        onChanged: (val) {
                          if (val.length > 5 && val[0].toLowerCase() == 's') {
                            fMasterTextController.text = val.substring(1, val.length);
                            FocusScope.of(context).nextFocus();
                          } else {
                            fMasterTextController.text = "";
                            AlertHelper.showErrorToast("Master no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Master', suffixText: 'Escanea Master'),
                      ),
                      TextFormField(
                        controller: fQtyTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => fQtyTextController.selection = TextSelection(baseOffset: 0, extentOffset: fQtyTextController.value.text.length),
                        onChanged: (val) {
                          if (int.parse(val.substring(1, val.length) ?? "0") > 0 && val[0].toLowerCase() == 'q') {
                            fQtyTextController.text = val.substring(1, val.length);
                            FocusScope.of(context).nextFocus();
                          } else {
                            fQtyTextController.text = "";
                            AlertHelper.showErrorToast("Cantidad no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Cantidad', suffixText: 'Escanea Cantidad'),
                      ),
                      TextFormField(
                        controller: fPartNumberTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => fPartNumberTextController.selection = TextSelection(baseOffset: 0, extentOffset: fPartNumberTextController.value.text.length),
                        onChanged: (val) {
                          if (val.length > 5 && val[0].toLowerCase() == 'p') {
                            fPartNumberTextController.text = val.substring(1, val.length);
                            FocusScope.of(context).nextFocus();
                          } else {
                            fPartNumberTextController.text = "";
                            AlertHelper.showErrorToast("${labelText1} no contiene formato correcto");
                          }
                        },
                        decoration: InputDecoration(border: UnderlineInputBorder(), labelText: labelText1, suffixText: labelText2),
                      ),
                      TextFormField(
                        controller: fSerialTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => fSerialTextController.selection = TextSelection(baseOffset: 0, extentOffset: fSerialTextController.value.text.length),
                        onChanged: (val) async {
                          if (val.length > 5 && val[0].toLowerCase() == 's') {
                            fSerialTextController.text = val.substring(1, val.length);
                            if (isAKI == false) {
                              ProgressBar.instance.show(context);
                              await fSave();
                              ProgressBar.instance.hide();
                            } else {
                              FocusScope.of(context).nextFocus();
                            }
                          } else {
                            fSerialTextController.text = "";
                            AlertHelper.showErrorToast("Serial no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Etiqueta Unit', suffixText: 'Escanea Serial'),
                      ),
                      Visibility(
                          visible: isAKI,
                          child: Column(children: <Widget>[
                            TextFormField(
                              controller: fAKISerialTextController,
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              onTap: () => fAKISerialTextController.selection = TextSelection(baseOffset: 0, extentOffset: fAKISerialTextController.value.text.length),
                              onChanged: (val) async {
                                if (val.length > 5 && val[0].toLowerCase() == 'g') {
                                  ProgressBar.instance.show(context);
                                  fAKISerialTextController.text = val.substring(1, val.length);
                                  await fSave();
                                  ProgressBar.instance.hide();
                                } else {
                                  fAKISerialTextController.text = "";
                                  AlertHelper.showErrorToast("AKI Serial no contiene formato correcto");
                                }
                              },
                              decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'AKI Serial', suffixText: 'Escanea Serial'),
                            ),
                            Text(""),
                          ])),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                        Expanded(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                            const Expanded(child: Text("")),
                            ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                              onPressed: () async => {
                                ProgressBar.instance.show(context),
                                await fSave(),
                                ProgressBar.instance.hide(),
                              },
                              child: const Text('Guardar', style: TextStyle(fontSize: 15, color: Colors.white)),
                            ),
                            const Expanded(child: Text("")),
                            ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                              onPressed: () => {fCleanFields()},
                              child: const Text('Limpiar Campos', style: TextStyle(fontSize: 15, color: Colors.white)),
                            ),
                            const Expanded(child: Text("")),
                          ]),
                        ),
                      ]),
                    ])),
                Visibility(
                    visible: _optionsNumber == 2,
                    child: Column(children: <Widget>[
                      const Text('Lectura de Partes', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                      TextFormField(
                        controller: pMasterTextController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onTap: () => pMasterTextController.selection = TextSelection(baseOffset: 0, extentOffset: pMasterTextController.value.text.length),
                        onChanged: (val) {
                          if (val.length > 5 && val[0].toLowerCase() == 's') {
                            pMasterTextController.text = val.substring(1, val.length);
                            FocusScope.of(context).nextFocus();
                          } else {
                            pMasterTextController.text = "";
                            AlertHelper.showErrorToast("Master no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Master', suffixText: 'Escanea Master'),
                      ),
                      TextFormField(
                        controller: pQtyTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => pQtyTextController.selection = TextSelection(baseOffset: 0, extentOffset: pQtyTextController.value.text.length),
                        onChanged: (val) {
                          if (int.parse(val.substring(1, val.length) ?? "0") > 0 && val[0].toLowerCase() == 'q') {
                            pQtyTextController.text = val.substring(1, val.length);
                            FocusScope.of(context).nextFocus();
                          } else {
                            pQtyTextController.text = "";
                            AlertHelper.showErrorToast("Cantidad no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Cantidad', suffixText: 'Escanea Cantidad'),
                      ),
                      TextFormField(
                        controller: pPartNumberTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => pPartNumberTextController.selection = TextSelection(baseOffset: 0, extentOffset: pPartNumberTextController.value.text.length),
                        onChanged: (val) async {
                          if (val.length > 5 && val[0].toLowerCase() == 'p') {
                            ProgressBar.instance.show(context);
                            pPartNumberTextController.text = val.substring(1, val.length);
                            await pSave();
                            ProgressBar.instance.hide();
                          } else {
                            pPartNumberTextController.text = "";
                            AlertHelper.showErrorToast("No. Parte no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Parte', suffixText: 'Escanea Número de Parte'),
                      ),
                      Text(""),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                        Expanded(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                            const Expanded(child: Text("")),
                            ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                              onPressed: () async => {
                                ProgressBar.instance.show(context),
                                await pSave(),
                                ProgressBar.instance.hide(),
                              },
                              child: const Text('Guardar', style: TextStyle(fontSize: 15, color: Colors.white)),
                            ),
                            const Expanded(child: Text("")),
                            ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                              onPressed: () async => {
                                pCleanFields(),
                              },
                              child: const Text('Limpiar Campos', style: TextStyle(fontSize: 15, color: Colors.white)),
                            ),
                            const Expanded(child: Text("")),
                          ]),
                        ),
                      ]),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}