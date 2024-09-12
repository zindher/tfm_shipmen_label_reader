import 'dart:convert';
import 'dart:io';
import 'package:decimal/decimal.dart';
import '../Helpers/alert.dart';
import '../Helpers/currentUser.dart';
import '../Models/OrderReportModel.dart';
import '../Models/orderDetailModel.dart';
import '../Models/responseMessageModel.dart';
import '../Providers/appConfig.dart';
import '../Models/orderModel.dart';
import 'package:http/http.dart' as http;

class OrdersService {
  static Future<ResponseMessage> ValidatePartNumberInOrder(int idScan, String partNumber) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/ValidatePartNumberInOrder?idScan=${idScan.toString()}&partNumber=${partNumber}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<List<Order>> getOrders() async {
    List<Order> orders = [];
    try {
      String url = "${AppConfig.host}/Orders/GetOrders";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var singleOrder in responseData) {
          Order order = Order(
              customerName: singleOrder["customerName"],
              id: singleOrder["id"],
              lastScanDate: DateTime.parse(singleOrder["lastScanDate"] ?? DateTime.now().toString()),
              currentScanInternalID: singleOrder["currentScanInternalID"].toString() ?? "",
              statusId: singleOrder["statusId"],
              status: singleOrder["status"],
              lastModifiedBy: singleOrder["lastModifiedBy"] ?? "",
              clientCode: singleOrder["clienteCode"]);
          orders.add(order);
        }
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return orders;
    }
  }

  static Future<Order> validateAkiPart(String master) async {
    Order order = Order();
    try {
      String url = "${AppConfig.host}/Scan/ValidatePartSerialAkiSeat?master=${master}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<String>? serials = (responseData["serials"] as List)?.cast<String>();
        order = Order(partNumber: responseData["partNumber"], internalPartNumber: responseData["partNumberInternal"], quantity: responseData["quantity"], serials: serials);
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
      if (order.serials?.length == 0) {
        AlertHelper.showErrorToast("No hay seriales registrados!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return order;
    }
  }

  static Future<Order> ValidateSerial(String master, String orderId) async {
    Order order = Order();
    try {
      String url = "${AppConfig.host}/Scan/ValidateSerial?master=${master}&order=${orderId}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<String>? serials = (responseData["serials"] as List)?.cast<String>();
        order = Order(partNumber: responseData["partNumber"], internalPartNumber: responseData["partNumberInternal"], quantity: responseData["quantity"], serials: serials);
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
      if (order.serials?.length == 0) {
        AlertHelper.showErrorToast("No hay seriales registrados!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return order;
    }
  }

  static Future<ResponseMessage> validateAkiSerial(String serial, String partNumber) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/ValidateAkiSerial?akiSerial=${serial}&partNumber=${partNumber}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<ResponseMessage> validatePartNumber(String order, String partNumber, String partNumberProvider) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/ValidateMatchPartNumber?order=${order}&partNumber=${partNumber}&partNumberProvider=${partNumberProvider}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<ResponseMessage> validateMaster(String masterProvider, String order) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/ValidateMasterProviderOrder?masterProvider=${masterProvider}&order=${order}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<ResponseMessage> ValidateMasterProviderOrder(String masterProvider, String order) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/ValidateMasterProviderOrder?masterProvider=${masterProvider}&order=${order}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<List<OrderDetail>?> getOrderDetailsByOrder(Order order) async {
    List<OrderDetail>? orderDetails = [];
    try {
      String url = "${AppConfig.host}/Scan/GetScannedByOrder?order=${order.id}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        var a = responseData[0]["scanContent"];

        for (var singleOrder in a) {
          OrderDetail orderDetail = OrderDetail(
              id: singleOrder["id"].toString(),
              partNumber: singleOrder["partNumber"],
              quantity: Decimal.parse(singleOrder[2] ?? "0"),
              serial: singleOrder["serial"],
              master: singleOrder["master"],
              date: DateTime.parse(singleOrder["date"] ?? DateTime.now().toString()),
              akiSerial: "",
              qty: singleOrder["quantity"].toString());
          orderDetails.add(orderDetail);
        }
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      if(orderDetails.length == 1 && orderDetails[0].id == "0")
        orderDetails = null;
      return orderDetails;
    }
  }

  static Future<List<OrderReport>> getReportDetailsOrder(String orderId) async {
    List<OrderReport> orderDetails = [];
    try {
      String url = "${AppConfig.host}/Scan/GetReportDetailsOrder?order=${orderId}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var singleOrder in responseData) {
          OrderReport orderDetail = OrderReport(
            partNumber: singleOrder["partNumber"],
            description: singleOrder["description"],
            quantityPlan: Decimal.parse(singleOrder["quantityPlan"].toString() ?? "0"),
            quantityReal: Decimal.parse(singleOrder["quantityReal"].toString() ?? "0"),
            quantityDiff: Decimal.parse(singleOrder["quantityDiff"].toString() ?? "0"),
          );
          orderDetails.add(orderDetail);
        }
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return orderDetails;
    }
  }

  static Future<ResponseMessage> saveOrderContent(OrderDetail order) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
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
            'secondSerial': order.akiSerial,
            'partNumberProvider': order.partNumberProvider,
            'masterProvider': order.masterProvider
          }));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<ResponseMessage> syncOrder(int idScan) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/SyncOrder";
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'idScan': idScan.toString(), 'idUser': CurrentUser.instance.user.idUser.toString()}));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<int> startScan(String orderNumber) async {
    int responseId = 0;
    try {
      String url = "${AppConfig.host}/Scan/StartScan";
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'order': orderNumber, 'idUser': CurrentUser.instance.user.idUser.toString()}));

      if (response.statusCode == 200) {
        responseId = int.parse(response.body);
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseId;
    }
  }

  static Future<ResponseMessage> ValidateOriginPartNumber(int idOrigin, String partNumber, String order) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/ValidateOriginPartNumber?idOrigin=${idOrigin}&partNumber=${partNumber}&order=${order}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }

  static Future<ResponseMessage> DeleteScanById(String idScan) async {
    ResponseMessage responseMessage = ResponseMessage(hasError: true, message: "Error de conexión!!", extraData: "");
    try {
      String url = "${AppConfig.host}/Scan/DeleteScanById?idScan=${idScan}&idUser=${CurrentUser.instance.user.idUser.toString()}";
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        responseMessage = ResponseMessage(hasError: bool.parse('${responseData['hasError']}'), message: '${responseData['message']}', extraData: "");
      } else {
        AlertHelper.showErrorToast("Error de conexión!!");
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    } catch (e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    } finally {
      return responseMessage;
    }
  }
}
