import 'package:flutter/material.dart';
import 'dart:math';

// void main() {
//   runApp(StyledAppWithoutAppBar());
// }

// enum for Concrete calculation mode
enum ConcreteMode { fixed, formula }

class TabsScreenImproved extends StatefulWidget {
  const TabsScreenImproved({super.key});

  @override
  _TabsScreenImprovedState createState() => _TabsScreenImprovedState();
}

class _TabsScreenImprovedState extends State<TabsScreenImproved>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Laboratory Tab
  final _labNameController = TextEditingController();
  final _officePhoneController = TextEditingController();
  final _samplerPhoneController = TextEditingController();
  final _landlineController = TextEditingController();
  final _addressController = TextEditingController();

  // Variables for Concrete Tab
  ConcreteMode _concreteMode = ConcreteMode.fixed; // Default mode
  final _fixedCoefficientController = TextEditingController();
  final _aController = TextEditingController(text: '0');
  final _bController = TextEditingController(text: '0');
  final _cController = TextEditingController(text: '0');
  double? _calculatedResult; // Nullable to show only when calculated

  // Controllers for Notification Tab
  final _telegramIdController = TextEditingController();
  final String _telegramBotName = "YourBotName";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    _tabController.dispose();
    _labNameController.dispose();
    _officePhoneController.dispose();
    _samplerPhoneController.dispose();
    _landlineController.dispose();
    _addressController.dispose();
    _fixedCoefficientController.dispose();
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    _telegramIdController.dispose();
    super.dispose();
  }

  void _calculateConcreteCoefficient() {
    double a = double.tryParse(_aController.text) ?? 0;
    double b = double.tryParse(_bController.text) ?? 0;
    double c = double.tryParse(_cController.text) ?? 0;
    // Assuming x=1 for simplicity, you can add a field for x
    double x = 1.0;

    setState(() {
      _calculatedResult = a * pow(x, 2) + b * x + c;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold no longer has an appBar
    return Scaffold(
      body: SafeArea(
        // Use SafeArea to avoid notch/system UI overlap
        child: Column(
          children: [
            // Custom TabBar container
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                // indicator: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15.0),
                //   color: Colors.indigo[400],
                // ),
                labelColor: Colors.teal,
                indicatorColor: Colors.teal,
                unselectedLabelColor: Colors.indigo,
                tabs: [
                  Tab(icon: Icon(Icons.business_center), text: 'آزمایشگاه'),
                  Tab(icon: Icon(Icons.layers), text: 'بتن'),
                  Tab(
                    icon: Icon(Icons.notifications_active),
                    text: 'اطلاع رسانی',
                  ),
                ],
              ),
            ),
            // The TabBarView must be wrapped in an Expanded widget
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLaboratoryTab(),
                  _buildConcreteTab(),
                  _buildNotificationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- The rest of the tab building methods remain exactly the same ---
  // (_buildLaboratoryTab, _buildConcreteTab, _buildFixedCoefficientCard, etc.)

  // Stylish Laboratory Tab
  Widget _buildLaboratoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                _labNameController,
                'نام آزمایشگاه',
                Icons.business,
              ),
              _buildTextField(
                _officePhoneController,
                'شماره تماس دفتر',
                Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                _samplerPhoneController,
                'شماره تماس نمونه گیر',
                Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                _landlineController,
                'شماره تماس ثابت',
                Icons.call,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                _addressController,
                'آدرس آزمایشگاه',
                Icons.location_on,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  /* Save lab data logic */
                },
                icon: Icon(Icons.save),
                label: Text('ذخیره اطلاعات'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Concrete Tab with Radio Buttons
  Widget _buildConcreteTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RadioListTile<ConcreteMode>(
                    title: Text('ضریب مقاومت نمونه (ثابت)'),
                    value: ConcreteMode.fixed,
                    groupValue: _concreteMode,
                    onChanged: (ConcreteMode? value) {
                      setState(() {
                        _concreteMode = value!;
                      });
                    },
                  ),
                  RadioListTile<ConcreteMode>(
                    title: Text('محاسبه با فرمول ضریب تبدیل'),
                    value: ConcreteMode.formula,
                    groupValue: _concreteMode,
                    onChanged: (ConcreteMode? value) {
                      setState(() {
                        _concreteMode = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // Conditionally show UI based on selected mode
          if (_concreteMode == ConcreteMode.fixed)
            _buildFixedCoefficientCard()
          else
            _buildFormulaCalculatorCard(),
        ],
      ),
    );
  }

  Widget _buildFixedCoefficientCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTextField(
          _fixedCoefficientController,
          'ضریب ثابت را وارد کنید',
          Icons.filter_1,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget _buildFormulaCalculatorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'معادله: ax² + bx + c',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 15),
            _buildTextField(
              _aController,
              'ضریب a',
              Icons.looks_one,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              _bController,
              'ضریب b',
              Icons.looks_two,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              _cController,
              'ضریب c',
              Icons.looks_3,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _calculateConcreteCoefficient,
              icon: Icon(Icons.calculate),
              label: Text('محاسبه'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_calculatedResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'نتیجه: $_calculatedResult',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Stylish Notification Tab
  Widget _buildNotificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_telegramIdController, 'آیدی تلگرام', Icons.send),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.smart_toy, color: Colors.indigo),
                title: Text(
                  'نام ربات تلگرام',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _telegramBotName,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create styled TextFields with Icons
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }
}
