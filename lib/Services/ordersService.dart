import 'dart:convert';
import 'dart:io';
import 'package:decimal/decimal.dart';
//import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import '../Helpers/alert.dart';
import '../Helpers/currentUser.dart';
import '../Models/orderDetailModel.dart';
import '../Models/responseMessageModel.dart';
import '../Providers/appConfig.dart';
import '../Models/orderModel.dart';
import 'package:http/http.dart' as http;

class OrdersService {
  static Future<List<Order>> getOrders() async {
    //SVProgressHUD.show();
    List<Order> orders = [];
    try {
      String url = "${AppConfig.host}/Orders/GetOrders";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      var responseData = json.decode(response.body);
      for (var singleOrder in responseData) {
        Order order = Order(
            customerName: singleOrder["customerName"],
            id: singleOrder["id"],
            lastScanDate: DateTime.parse(
                singleOrder["lastScanDate"] ?? DateTime.now().toString()),
            currentScanInternalID:
                singleOrder["currentScanInternalID"].toString() ?? "",
            statusId: singleOrder["statusId"],
            status: singleOrder["status"],
            lastModifiedBy: singleOrder["lastModifiedBy"] ?? "");
        orders.add(order);
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } finally {
      //SVProgressHUD.dismiss();
      return orders;
    }
  }

  static Future<List<OrderDetail>> getOrderDetailsByOrder(Order order) async {
    //SVProgressHUD.show();
    List<OrderDetail> orderDetails = [];
    try {
      String url = "${AppConfig.host}/Scan/GetScannedByOrder?order=${order.id}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var responseData = json.decode(response.body);
      var a = responseData[0]["scanContent"];

      for (var singleOrder in a) {
        OrderDetail orderDetail = OrderDetail(
            id: singleOrder["id"].toString(),
            partNumber: singleOrder["partNumber"],
            quantity: Decimal.parse(singleOrder[2] ?? "0"),
            serial: singleOrder["serial"],
            master: singleOrder["master"],
            date: DateTime.parse(
                singleOrder["date"] ?? DateTime.now().toString()),
            akiSerial: "");
        orderDetails.add(orderDetail);
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } finally {
      //SVProgressHUD.dismiss();
      return orderDetails;
    }
  }

  static Future<ResponseMessage> saveOrderContent(OrderDetail order) async {
    ResponseMessage responseMessage = ResponseMessage(
        hasError: true, message: "Error de conexión!!", extraData: "");
    //SVProgressHUD.show();
    final currentScanInternalID = await OrdersService.startScan(order.id);
    try {
      String url = "${AppConfig.host}/Scan/SaveScanContent";
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'currentScanInternalID': currentScanInternalID.toString(),
            'partNumber': order.partNumber,
            'quantity': order.quantity.toString(),
            'serial': order.serial,
            'master': order.master,
            'user': CurrentUser.instance.user.idUser.toString(),
            'secondSerial': order.akiSerial
          }));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(
            hasError: bool.parse('${responseData['hasError']}'),
            message: '${responseData['message']}',
            extraData: "");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } finally {
      //SVProgressHUD.dismiss();
      return responseMessage;
    }
  }

  static Future<ResponseMessage> syncOrder(int idScan) async {
    ResponseMessage responseMessage = ResponseMessage(
        hasError: true, message: "Error de conexión!!", extraData: "");
    //SVProgressHUD.show();
    try {
      String url = "${AppConfig.host}/Scan/SyncOrder";
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'idScan': idScan.toString(),
          }));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(
            hasError: bool.parse('${responseData['hasError']}'),
            message: '${responseData['message']}',
            extraData: "");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } finally {
      //SVProgressHUD.dismiss();
      return responseMessage;
    }
  }

  static Future<int> startScan(String orderNumber) async {
    int responseId = 0;
    //SVProgressHUD.show();
    try {
      String url = "${AppConfig.host}/Scan/StartScan";
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'order': orderNumber,
            'idUser': CurrentUser.instance.user.idUser.toString()
          }));

      if (response.statusCode == 200) {
        responseId = int.parse(response.body);
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } finally {
      //SVProgressHUD.dismiss();
      return responseId;
    }
  }
}
