import 'package:flutter/material.dart';
import 'package:tfm_shipmen_label_reader/Pages/log_off.dart';
import 'package:tfm_shipmen_label_reader/Pages/order_inquiry.dart';
import 'package:tfm_shipmen_label_reader/Pages/read_frames.dart';
import 'package:tfm_shipmen_label_reader/Pages/scan.dart';
import 'package:tfm_shipmen_label_reader/Pages/settings.dart';
import 'package:tfm_shipmen_label_reader/Pages/sync.dart';
import '../Helpers/currentUser.dart';
import '../Models/orderModel.dart';
import 'customer_order.dart';
import 'order_detail.dart';

class MasterPage extends StatefulWidget {
  final int SelectedIndex;
  final Object Obj;

  const MasterPage({super.key, required this.SelectedIndex, required this.Obj});

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int _selectedIndex = 0;
  int _menuIconSelection = 2;
  int _prevPage = 0;
  var _obj;
  String _title = '';
  bool _isBackButtonVisible = false;

  void _changePage(index, extraParam, prevPage) {
    setState(() {
      _selectedIndex = index;
      _obj = extraParam;
      _prevPage = prevPage;
      switch (_selectedIndex) {
        case 0:
          _title = 'CONFIGURACIONES';
          _isBackButtonVisible = false;
          break;
        case 1:
          _title = 'CONSULTA DE PEDIDOS';
          _isBackButtonVisible = false;
          break;
        case 2:
          _title = 'ESCANEO PEDIDO';
          _isBackButtonVisible = false;
          break;
        case 3:
          _title = 'SALIR';
          _isBackButtonVisible = false;
          break;
        case 4:
          var a = extraParam as Order;
          _title = 'Orden: ${a.id}';
          _isBackButtonVisible = true;
          break;
        case 5:
          _title = 'Escaneo de ordenes';
          _isBackButtonVisible = true;
          break;
        case 6:
          _title = 'Escanner';
          _isBackButtonVisible = true;
          break;
        case 7:
          _title = 'Sincronizar';
          _isBackButtonVisible = true;
          break;
      }
      if (_selectedIndex == 4) {
        _menuIconSelection = 1;
      } else if (_selectedIndex == 5) {
        _menuIconSelection = 2;
      } else if (_selectedIndex == 6) {
        _menuIconSelection = 2;
      } else if (_selectedIndex == 7) {
        _menuIconSelection = 2;
      } else {
        _menuIconSelection = _selectedIndex;
      }
      if (_prevPage == 5) {
        _menuIconSelection = 2;
      }
    });
  }

  @override
  void initState() {
    setState(() {
      _changePage(widget.SelectedIndex, '', 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _changePage(index, '', 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Scaffold();
    if (_selectedIndex == 0) {
      body = const SettingsPage();
    } else if (_selectedIndex == 1) {
      body = OrderInquiryPage(callback: _changePage);
    } else if (_selectedIndex == 2) {
      body = ScanPage(callback: _changePage);
    } else if (_selectedIndex == 3) {
      body = const LogOffPage();
    } else if (_selectedIndex == 4) {
      body = OrderDetailPage(order: _obj);
    } else if (_selectedIndex == 5) {
      body = CustomerOrderPage(order: _obj as Order, callback: _changePage);
    } else if (_selectedIndex == 6) {
      body = ReadFramesPage(order: _obj as Order);
    } else if (_selectedIndex == 7) {
      body = SyncPage(order: _obj as Order, callback: _changePage);
    }

    return Scaffold(
        appBar: AppBar(
            leading: Visibility(
              visible: _isBackButtonVisible,
              child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_selectedIndex == 4) {
                      if (_prevPage == 5) {
                        _changePage(5, _obj as Object, 0);
                      } else {
                        _changePage(1, '', 0);
                      }
                    } else if (_selectedIndex == 5) {
                      _changePage(2, '', 0);
                    } else if (_selectedIndex == 6) {
                      _changePage(5, _obj as Object, 0);
                    } else if (_selectedIndex == 7) {
                      _changePage(5, _obj as Object, 0);
                    } else {
                      _changePage(1, '', 0);
                    }
                  }),
            ),
            centerTitle: true,
            title: Column(
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topLeft,
                  child: Text(_title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff01136D))),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                      "${CurrentUser.instance.user.name} ${CurrentUser.instance.user.lastName}",
                      style: const TextStyle(fontSize: 16), selectionColor: Color(0xff595959)),
                )
              ],
            )),
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff052289),
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(color: Colors.blue),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.barcode_reader),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: '',
            ),
          ],
          currentIndex: _menuIconSelection,
          onTap: _onItemTapped,
        ));
  }
}
