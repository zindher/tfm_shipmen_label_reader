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
  bool _showWarehouseField = false;

  Order akiOrder = Order();
  Order order = Order();
  var labelText1 = "";
  var labelText2 = "";
  var labelText3 = "";
  var labelText4 = "";
  var isAKI = false;
  var akiPartNumber = "";
  var originText = "";

  final fMasterTextController = TextEditingController();
  final fQtyTextController = TextEditingController();
  final fPartNumberTextController = TextEditingController();
  final fSerialTextController = TextEditingController();
  final fAKISerialTextController = TextEditingController();
  final warehouseLabelTextController = TextEditingController();

  final pMasterTextController = TextEditingController();
  final pMasterProviderTextController = TextEditingController();
  final pQtyTextController = TextEditingController();
  final pPartNumberTextController = TextEditingController();
  final pPartNumberProviderTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.order.clientCode == "A0058") {
      isAKI = true;
      labelText1 = "AKI WEB (Número de parte)";
      labelText2 = "Escanea Número de parte";

      labelText3 = "Parte Aki Web";
      labelText4 = "Master Aki Web";
    } else {
      isAKI = false;
      labelText1 = "No. Parte";
      labelText2 = "Escanea Número de Parte";

      labelText3 = "Parte Proveedor";
      labelText4 = "Master Proveedor";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> validateAkiPart() async {
    try {
      akiOrder = await OrdersService.validateAkiPart(fMasterTextController.text);
      if (akiOrder.quantity != null && akiOrder.quantity! > 0 && akiOrder.partNumber.length > 0) {
        fQtyTextController.text = akiOrder.quantity.toString();
        //fPartNumberTextController.text = akiOrder.partNumber;
        setState(() {
          akiPartNumber = akiOrder.internalPartNumber;
        });

        FocusScope.of(context).nextFocus();
        FocusScope.of(context).nextFocus();
      } else {
        AlertHelper.showErrorToast("Master invalido!!");
        fMasterTextController.text = "";
        fQtyTextController.text = '';
        //fPartNumberTextController.text = '';
        akiPartNumber = "";
        akiOrder = Order();
      }
    } catch (e) {
      fMasterTextController.text = "";
      fQtyTextController.text = '';
      //fPartNumberTextController.text = '';
      akiPartNumber = "";
      akiOrder = Order();
    }
  }

  Future<void> validatePart() async {
    try {
      order = await OrdersService.ValidateSerial(fMasterTextController.text, widget.order.id);
      if (order.partNumber.length > 0) {
        FocusScope.of(context).nextFocus();
      } else {
        AlertHelper.showErrorToast("Master invalido!!");
        fMasterTextController.text = "";
        order = Order();
      }
    } catch (e) {
      fMasterTextController.text = "";
      order = Order();
    }
  }

  Future<void> validateAkiUnit() async {
    var aux = false;
    for (var a in akiOrder.serials!) {
      if (a.contains(fSerialTextController.text.replaceAll(' ', ''))) {
        aux = true;
      }
    }
    if (!aux) {
      AlertHelper.showErrorToast("Etiqueta Unitaria no esta contenida en los seriales de master!!");
      fSerialTextController.text = '';
    } else {
      FocusScope.of(context).nextFocus();
    }
  }

  Future<void> validateUnit() async {
    var aux = false;
    for (var a in order.serials!) {
      if (a.contains(fSerialTextController.text.replaceAll(' ', '')) || a.contains('NO REQUIERE VALIDACION')) {
        aux = true;
      }
    }
    if (!aux) {
      AlertHelper.showErrorToast("Etiqueta Unitaria no esta contenida en los seriales de master!!");
      fSerialTextController.text = '';
    } else {
      await fSave();
    }
  }

  Future<void> validateAkiSerial() async {
    try {
      var a = await OrdersService.validateAkiSerial(fAKISerialTextController.text, fPartNumberTextController.text);
      if (a.hasError) {
        AlertHelper.showErrorToast(a.message);
        fAKISerialTextController.text = '';
      } else {
        await fSave();
      }
    } catch (e) {}
  }

  Future<void> fSave() async {
    setState(() async {
      var auxValidWarehouse = true;
      if((widget.order.validateWarehouse && warehouseLabelTextController.text.length == 0)){
        auxValidWarehouse = false;
      }
      if (isAKI) {
        if (fPartNumberTextController.text.length > 5 &&
            int.parse(fQtyTextController.text) > 0 &&
            fSerialTextController.text.length > 5 &&
            fMasterTextController.text.length > 5 &&
            fAKISerialTextController.text.length > 5 &&
            auxValidWarehouse
        ) {
          response = await OrdersService.saveOrderContent(OrderDetail(
              id: widget.order.id,
              partNumber: fPartNumberTextController.text,
              quantity: Decimal.parse(fQtyTextController.text),
              serial: fSerialTextController.text,
              master: fMasterTextController.text,
              date: null,
              akiSerial: fAKISerialTextController.text,
              qty: ""));
          if (!response.hasError) {
            fCleanFields();
            AlertHelper.showSuccessToast(response.message);
          } else {
            AlertHelper.showErrorToast(response.message);
            fAKISerialTextController.text = "";
          }
        } else {
          FocusScope.of(context).previousFocus();
          FocusScope.of(context).previousFocus();
          FocusScope.of(context).previousFocus();
          FocusScope.of(context).previousFocus();
          if(widget.order.validateWarehouse){
            FocusScope.of(context).previousFocus();
          }
          AlertHelper.showErrorToast('Datos incorrectos revisalos!!');
        }
      } else {
        if (fPartNumberTextController.text.length > 5 &&
            int.parse(fQtyTextController.text) > 0 &&
            fSerialTextController.text.length > 5 &&
            fMasterTextController.text.length > 5&&
            auxValidWarehouse
        ) {
          response = await OrdersService.saveOrderContent(OrderDetail(
              id: widget.order.id,
              partNumber: fPartNumberTextController.text,
              quantity: Decimal.parse(fQtyTextController.text),
              serial: fSerialTextController.text,
              master: fMasterTextController.text,
              date: null,
              akiSerial: fAKISerialTextController.text,
              qty: "",
              warehouseLabel: warehouseLabelTextController.text
          ));
          if (!response.hasError) {
            fCleanFields();
            AlertHelper.showSuccessToast(response.message);
          } else {
            AlertHelper.showErrorToast(response.message);
            fSerialTextController.text = "";
          }
        } else {
          FocusScope.of(context).previousFocus();
          FocusScope.of(context).previousFocus();
          FocusScope.of(context).previousFocus();
          FocusScope.of(context).previousFocus();
          if(widget.order.validateWarehouse){
            FocusScope.of(context).previousFocus();
          }
          AlertHelper.showErrorToast('Datos incorrectos revisalos!!');
        }
      }
    });
  }

  Future<void> pSave() async {
    var auxValidWarehouse = true;
    if((widget.order.validateWarehouse && warehouseLabelTextController.text.length == 0)){
      auxValidWarehouse = false;
    }

    if (pPartNumberTextController.text.length > 5 &&
        pPartNumberProviderTextController.text.length > 5 &&
        int.parse(pQtyTextController.text) > 0 &&
        pMasterTextController.text.length > 5 &&
        pMasterProviderTextController.text.length > 5 &&
        auxValidWarehouse
    ) {
      response = await OrdersService.saveOrderContent(OrderDetail(
          id: widget.order.id,
          partNumber: pPartNumberTextController.text,
          quantity: Decimal.parse(pQtyTextController.text),
          serial: "",
          master: pMasterTextController.text,
          date: null,
          akiSerial: "",
          qty: "",
          partNumberProvider: pPartNumberProviderTextController.text,
          masterProvider: pMasterProviderTextController.text,
          warehouseLabel: warehouseLabelTextController.text
      ));
      if (!response.hasError) {
        pCleanFields();
        AlertHelper.showSuccessToast(response.message);
      } else {
        AlertHelper.showErrorToast(response.message);
        pMasterProviderTextController.text = "";
      }
    } else {
      AlertHelper.showErrorToast('Datos incorrectos revisalos!!');
    }
  }

  Future<void> ValidateMasterProviderOrder() async {
    if (fMasterTextController.text.length > 5) {
      response = await OrdersService.ValidateMasterProviderOrder(fMasterTextController.text, widget.order.id);
      if (response.hasError) {
        fMasterTextController.text = "";
        AlertHelper.showErrorToast(response.message);
      }
    }else{
      fMasterTextController.text = "";
      AlertHelper.showErrorToast("Master no contiene formato correcto");
    }
  }

  Future<void> ValidateMasterProviderOrder1() async {
    if (pMasterTextController.text.length > 5) {
      response = await OrdersService.ValidateMasterProviderOrder(pMasterTextController.text, widget.order.id);
      if (response.hasError) {
        pMasterTextController.text = "";
        AlertHelper.showErrorToast(response.message);
      }
    }else{
      pMasterTextController.text = "";
      AlertHelper.showErrorToast("Master no contiene formato correcto");
    }
  }

  Future<void> validatePartNumber() async {
    if (pPartNumberTextController.text.length > 5 && pPartNumberProviderTextController.text.length > 5) {
      response = await OrdersService.validatePartNumber(widget.order.id, pPartNumberTextController.text, pPartNumberProviderTextController.text);
      if (response.hasError) {
        pPartNumberProviderTextController.text = "";
        AlertHelper.showErrorToast(response.message);
      } else {
        FocusScope.of(context).nextFocus();
      }
    } else {
      AlertHelper.showErrorToast('Los números de parte son incorrectos!!');
    }
  }

  Future<void> validateMaster() async {
    if (pPartNumberTextController.text.length > 5 &&
        pPartNumberProviderTextController.text.length > 5 &&
        pMasterProviderTextController.text.length > 5 &&
        pMasterTextController.text.length > 5) {
      response = await OrdersService.validateMaster(pPartNumberTextController.text, pPartNumberProviderTextController.text);
      if (response.hasError) {
        pPartNumberProviderTextController.text = "";
        AlertHelper.showErrorToast(response.message);
      } else {
        await pSave();
      }
    } else {
      AlertHelper.showErrorToast('Los números de parte son incorrectos!!');
    }
  }

  void fCleanFields() {
    fMasterTextController.text = "";
    fQtyTextController.text = "";
    fPartNumberTextController.text = "";
    fSerialTextController.text = "";
    fAKISerialTextController.text = "";
    originText = "";

    if(widget.order.validateWarehouse){
      warehouseLabelTextController.text = "";
      FocusScope.of(context).previousFocus();
    }

    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
  }

  void pCleanFields() {
    pMasterTextController.text = "";
    pQtyTextController.text = "";
    pPartNumberTextController.text = "";
    pPartNumberProviderTextController.text = "";
    pMasterProviderTextController.text = "";

    if(widget.order.validateWarehouse){
      warehouseLabelTextController.text = "";
      FocusScope.of(context).previousFocus();
    }

    FocusScope.of(context).previousFocus();
    FocusScope.of(context).previousFocus();
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
                        child: const Text('  Locales  ', style: TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      const Expanded(child: Text("")),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff052289))),
                        onPressed: () async => {
                          setState(() {
                            _optionsNumber = 2;
                          })
                        },
                        child: const Text('Passthrough', style: TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      const Expanded(child: Text("")),
                    ]),
                  ),
                ]),
                const Text(''),
                Visibility(
                    visible: _optionsNumber == 1,
                    child: Column(children: <Widget>[
                      const Text('Locales', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                      TextFormField(
                        controller: fMasterTextController,
                        autofocus: true,
                        //focusNode: 1,
                        textInputAction: TextInputAction.next,
                        onTap: () => fMasterTextController.selection = TextSelection(baseOffset: 0, extentOffset: fMasterTextController.value.text.length),
                        onChanged: (val) async {
                          if (val.length > 5 && val[0].toLowerCase() == 's') {
                            ProgressBar.instance.show(context);
                            fMasterTextController.text = val.substring(1, val.length);
                            await ValidateMasterProviderOrder();
                            if(fMasterTextController.text.length > 5){
                              if (isAKI) {
                                await validateAkiPart();
                              } else {
                                await validatePart();
                              }
                            }
                            ProgressBar.instance.hide();
                          } else {
                            fMasterTextController.text = "";
                            AlertHelper.showErrorToast("Master no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Master', suffixText: 'Escanea Master'),
                      ),
                      TextFormField(
                        controller: fQtyTextController,
                        readOnly: isAKI,
                        textInputAction: TextInputAction.next,
                        onTap: () => fQtyTextController.selection = TextSelection(baseOffset: 0, extentOffset: fQtyTextController.value.text.length),
                        onChanged: (val) {
                          int? q = 0;
                          q = int.tryParse(val.substring(1, val.length));
                          if (val[0].toLowerCase() == 'q' && q! > 0) {
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
                        onChanged: (val) async {
                          if (val.length > 5 && val[0].toLowerCase() == 'p') {
                            ProgressBar.instance.show(context);
                            fPartNumberTextController.text = val.substring(1, val.length);
                            var a = await OrdersService.ValidateOriginPartNumber(1, fPartNumberTextController.text, widget.order.id);
                            if (a.hasError) {
                              AlertHelper.showErrorToast(a.message);
                              fAKISerialTextController.text = '';
                            } else {
                              setState(() {
                                _showWarehouseField = bool.parse(a.extraData);
                              });
                              if (isAKI) {
                                if (fPartNumberTextController.text == akiOrder.partNumber) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  fPartNumberTextController.text = "";
                                  AlertHelper.showErrorToast('El número de parte no coinside!!');
                                }
                              } else {
                                response = await OrdersService.ValidatePartNumberInOrder(await OrdersService.startScan(widget.order.id), fPartNumberTextController.text);
                                if (!response.hasError) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  fPartNumberTextController.text = "";
                                  AlertHelper.showErrorToast(response.message);
                                }
                              }
                            }
                            ProgressBar.instance.hide();
                          } else {
                            fPartNumberTextController.text = "";
                            setState(() {
                              _showWarehouseField = false;
                            });
                            AlertHelper.showErrorToast("${labelText1} no contiene formato correcto");
                          }
                        },
                        decoration: InputDecoration(border: UnderlineInputBorder(), labelText: labelText1, suffixText: labelText2),
                      ),
                      Visibility(
                          visible: widget.order.validateWarehouse && _showWarehouseField,
                          child: Column(children: <Widget>[
                            TextFormField(
                              controller: warehouseLabelTextController,
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              onTap: () => warehouseLabelTextController.selection = TextSelection(baseOffset: 0, extentOffset: warehouseLabelTextController.value.text.length),
                              onChanged: (val) async {
                                if (val.length > 5) {
                                  response = await OrdersService.ValidateSerialWarehouse(warehouseLabelTextController.text, fPartNumberTextController.text);
                                  if(!response.hasError){
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else{
                                    warehouseLabelTextController.text = "";
                                    AlertHelper.showErrorToast(response.message);
                                  }
                                } else {
                                  warehouseLabelTextController.text = "";
                                  AlertHelper.showErrorToast("etiqueta no valida");
                                }
                              },
                              decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Etiqueta Warehouse', suffixText: 'Escanea Etiqueta Warehouse'),
                            ),
                            Text(""),
                          ])),
                      TextFormField(
                        controller: fSerialTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => fSerialTextController.selection = TextSelection(baseOffset: 0, extentOffset: fSerialTextController.value.text.length),
                        onChanged: (val) async {
                          try {
                            ProgressBar.instance.show(context);
                            if(originText.length > val.length){
                              val = "";
                              originText = "";
                              fSerialTextController.text = "";
                            }
                            if (isAKI) {
                              if (val.length > 5) {
                                //fSerialTextController.text = val.substring(1, val.length);
                                await validateAkiUnit();
                              } else {
                                fSerialTextController.text = "";
                                AlertHelper.showErrorToast("Serial no contiene formato correcto");
                              }
                            } else {
                              if (val.length > 5) {
                                await validateUnit();
                                //await fSave();
                              } else {
                                fSerialTextController.text = "";
                                AlertHelper.showErrorToast("Serial no contiene formato correcto");
                              }
                            }
                            originText = val;
                            ProgressBar.instance.hide();
                          } catch (exception) {
                            originText = val;
                            ProgressBar.instance.hide();
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Etiqueta Unitaria', suffixText: 'Escanea Serial'),
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
                                  fAKISerialTextController.text = val.substring(1, val.length);
                                  ProgressBar.instance.show(context);
                                  await validateAkiSerial();
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
                      const Text('Passthrough', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                      TextFormField(
                        controller: pPartNumberTextController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onTap: () => pPartNumberTextController.selection = TextSelection(baseOffset: 0, extentOffset: pPartNumberTextController.value.text.length),
                        onChanged: (val) async {
                          if (val.length > 5 && val[0].toLowerCase() == 'p') {
                            ProgressBar.instance.show(context);
                            pPartNumberTextController.text = val.substring(1, val.length);
                            var a = await OrdersService.ValidateOriginPartNumber(2, pPartNumberTextController.text, widget.order.id);
                            if (a.hasError) {
                              AlertHelper.showErrorToast(a.message);
                              pPartNumberTextController.text = "";
                            } else {
                              FocusScope.of(context).nextFocus();
                            }
                            ProgressBar.instance.hide();
                          } else {
                            pPartNumberTextController.text = "";
                            AlertHelper.showErrorToast("No. Parte no contiene formato correcto");
                          }
                        },
                        decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Parte', suffixText: 'Escanea Número de Parte'),
                      ),
                      TextFormField(
                        controller: pQtyTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () => pQtyTextController.selection = TextSelection(baseOffset: 0, extentOffset: pQtyTextController.value.text.length),
                        onChanged: (val) {
                          int? q = 0;
                          q = int.tryParse(val.substring(1, val.length));
                          if (val[0].toLowerCase() == 'q' && q! > 0) {
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
                        controller: pMasterTextController,
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
                        //numero de parte
                        controller: pPartNumberProviderTextController,
                        textInputAction: TextInputAction.next,
                        onTap: () =>
                        pPartNumberProviderTextController.selection = TextSelection(baseOffset: 0, extentOffset: pPartNumberProviderTextController.value.text.length),
                        onChanged: (val) async {
                          if (val.length > 5 && val[0].toLowerCase() == 'p') {
                            //validar numero de parte pendinte voy a mandar numero de parte y parte provedor
                            ProgressBar.instance.show(context);
                            pPartNumberProviderTextController.text = val.substring(1, val.length);
                            await validatePartNumber();
                            ProgressBar.instance.hide();
                          } else {
                            pPartNumberProviderTextController.text = "";
                            AlertHelper.showErrorToast("${labelText3} no contiene formato correcto");
                          }
                        },
                        decoration: InputDecoration(border: UnderlineInputBorder(), labelText: labelText3, suffixText: 'Escanea Número de Parte'),
                      ),
                      Visibility(
                          visible: false,
                          child: Column(children: <Widget>[
                            TextFormField(
                              controller: warehouseLabelTextController,
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              onTap: () => warehouseLabelTextController.selection = TextSelection(baseOffset: 0, extentOffset: warehouseLabelTextController.value.text.length),
                              onChanged: (val) async {
                                if (val.length > 5) {
                                  response = await OrdersService.ValidateSerialWarehouse(warehouseLabelTextController.text, "");
                                  if(!response.hasError){
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else{
                                    warehouseLabelTextController.text = "";
                                    AlertHelper.showErrorToast(response.message);
                                  }
                                } else {
                                  warehouseLabelTextController.text = "";
                                  AlertHelper.showErrorToast("etiqueta no valida");
                                }
                              },
                              decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'Etiqueta Warehouse', suffixText: 'Escanea Etiqueta Warehouse'),
                            ),
                            Text(""),
                          ])),
                      TextFormField(
                        //Master
                        controller: pMasterProviderTextController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onTap: () => pMasterProviderTextController.selection = TextSelection(baseOffset: 0, extentOffset: pMasterProviderTextController.value.text.length),
                        onChanged: (val) async {
                          ProgressBar.instance.show(context);

                          var prefix = 's';
                          if(isAKI){
                            prefix = 'g';
                          }

                          if (val.length > 5 && val[0].toLowerCase() == prefix) {
                            pMasterProviderTextController.text = val.substring(1, val.length);
                            await ValidateMasterProviderOrder1();
                            await validateMaster();
                          } else {
                            pMasterProviderTextController.text = "";
                            AlertHelper.showErrorToast("${labelText4} no contiene formato correcto");
                          }
                          ProgressBar.instance.hide();
                        },
                        decoration: InputDecoration(border: UnderlineInputBorder(), labelText: labelText4, suffixText: 'Escanea Master'),
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
