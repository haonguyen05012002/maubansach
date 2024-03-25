import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThanhtoanPage extends StatefulWidget {
  @override
  _ThanhtoanPageState createState() => _ThanhtoanPageState();
}

class _ThanhtoanPageState extends State<ThanhtoanPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isOrderSummaryExpanded = false;
  double _totalCost =
  199.97; // Example total cost, replace with actual calculation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Xác nhận', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.white],
            )
          ),

        child:

        SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đơn đặt hàng',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                SizedBox(height: 10),
                _buildOrderSummary(),
                SizedBox(height: 20),
                Text('Thông tin vận chuyển',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                _buildTextInput('Tên', Icons.person),
                _buildTextInput('Địa chỉ', Icons.home),
                _buildTextInput('Thành phố', Icons.location_city),
                SizedBox(height: 20),
                Text('Phương thức thanh toán',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                _buildPaymentDropdown(),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    onPressed: () => _submitOrder(context),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      child: Text('Xác nhận đơn hàng',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }

  Widget _buildOrderSummary() {
    return Card(
      color: Colors.deepPurple.shade50,
      child: ExpansionTile(
        title: Text('Đơn đặt hàng',
            style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
        children: [
          ListTile(
            title: Text('Tổng tiền:'),
            trailing: Text('\$$_totalCost',
                style: TextStyle(color: Colors.deepPurple, fontSize: 16)),
          )
        ],
        onExpansionChanged: (bool expanded) {
          setState(() => _isOrderSummaryExpanded = expanded);
        },
        initiallyExpanded: _isOrderSummaryExpanded,
      ),
    );
  }

  Widget _buildTextInput(String label, IconData icon) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurple),
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple.shade200)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentDropdown() {
    String _selectedPaymentMethod = 'Thẻ tín dụng';
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.payment, color: Colors.deepPurple),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple.shade200)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
      ),
      value: _selectedPaymentMethod,
      items: <String>['Thẻ tín dụng', 'Thẻ ghi nợ', 'PayPal']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPaymentMethod = newValue!;
        });
      },
    );
  }

  void _submitOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác nhận đơn hàng'),
            content: Text('Đặt hàng thành công'),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: TextStyle(color: Colors.deepPurple)),
                onPressed: () {
// Close the dialog
                  Navigator.of(context).pop();
// Optionally, navigate the user to a confirmation page or back to the home page
                },
              ),
            ],
          );
        },
      );
    }
  }
}
