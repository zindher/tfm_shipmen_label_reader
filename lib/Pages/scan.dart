import 'package:flutter/material.dart';
import '../Models/orderModel.dart';
import '../Services/ordersService.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ScanPage extends StatefulWidget {
  final Function callback;

  const ScanPage({super.key, required this.callback});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _userEditTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Order>> getOrders(filter) async {
    List<Order> response = [];
    var o = await OrdersService.getOrders();
    if (filter.toString().isNotEmpty) {
      response = o
          .where((e) =>
              (e.statusId == null || e.statusId == 1 || e.statusId == 2) &&
              (e.id.toUpperCase().contains(filter.toString().toUpperCase()) || e.customerName.toUpperCase().contains(filter.toString().toUpperCase())))
          .toList();
    } else {
      response = o.where((e) => e.statusId == null || e.statusId == 1 || e.statusId == 2).toList();
    }
    return response;
  }

  Widget _customPopupItemBuilder(BuildContext context, Order item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.id),
        subtitle: Text(
          item.customerName,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(flex: 1, child: Text("")),
                    Expanded(
                      flex: 6,
                      child: DropdownSearch<Order>(
                          asyncItems: (String? filter) => getOrders(filter) ,
                          onChanged: (Order? value) {
                            setState(() {
                              widget.callback(5, value, 0);
                            });
                          },
                          popupProps: PopupProps.bottomSheet(

                            fit: FlexFit.tight,
                            showSelectedItems: true,
                            isFilterOnline: true,
                            itemBuilder: _customPopupItemBuilder,
                            showSearchBox: true,

                            searchFieldProps: TextFieldProps(
                              controller: _userEditTextController,
                              autofocus: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _userEditTextController.clear();
                                  },
                                ),
                              ),
                            ),
                          ),
                          compareFn: (item, selectedItem) => item.id == selectedItem.id,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              label: Text('Selecciona Orden'),
                            ),
                          )),
                    ),
                    const Expanded(flex: 1, child: Text("")),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }
}
