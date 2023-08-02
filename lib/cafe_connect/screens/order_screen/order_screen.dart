// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import '../thanks_pages/thanks_page.dart';
// import 'components/custom_dropdown_button.dart';
import 'components/custom_elevated_button.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String dropdownValue = 'コーヒー';
  String timeDropdownValue = '15時30分';
  bool small = false;
  bool _isSugar = false;
  bool caramel = false;
  bool _isCondecensedMilk = false;
  bool _isPickupOn4thFloor = false;

  Future<void> _saveOrder(
    String time,
    String coffeeType,
    String name,
    bool small,
    bool isSugar,
    bool caramel,
    bool isCondecensedMilk,
    bool isPickupOn4thFloor,
  ) async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    return orders
        .add({
          'time': time,
          'coffeeType': coffeeType,
          'name': name,
          'small': small,
          'isSugar': isSugar,
          'caramel': caramel,
          'isCondecensedMilk': isCondecensedMilk,
          'isPickupOn4thFloor': isPickupOn4thFloor,
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.brown),
                iconSize: 16.0,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
            width: double.infinity,
            height: 500.0,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 400.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF8F7FA),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x320E151B),
                    offset: Offset(0.0, -2.0),
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: _buildBody(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    // labelText: 'Name',
                    labelStyle: TextStyle(color: kTextColor),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: kTextColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'お名前をご記入ください';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation:
                                timeDropdownValue == '15時30分' ? 10.0 : 0.0,
                            borderRadius: BorderRadius.circular(20),
                            child: ElevatedButton(
                              child: Text(
                                '15時30分',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: timeDropdownValue == '15時30分'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  timeDropdownValue = '15時30分';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: timeDropdownValue == '15時30分'
                                    ? Colors.brown
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30, // Increase horizontal padding
                                  vertical: 15, // Increase vertical padding
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation:
                                timeDropdownValue == '17時30分' ? 10.0 : 0.0,
                            borderRadius: BorderRadius.circular(20),
                            child: ElevatedButton(
                              child: Text('17時30分',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      color: timeDropdownValue == '17時30分'
                                          ? Colors.white
                                          : Colors.black)),
                              onPressed: () {
                                setState(() {
                                  timeDropdownValue = '17時30分';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: timeDropdownValue == '17時30分'
                                    ? Colors.brown
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        30, // Increase horizontal padding
                                    vertical: 15), // Increase vertical padding
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Map<String, String>>[
                      {
                        "name": "コーヒー",
                        "image":
                            "https://images.unsplash.com/photo-1634913564795-7825a3266590?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80"
                      },
                      {
                        "name": "カフェオレ",
                        "image":
                            "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80"
                      },
                      {
                        "name": "ちょいふわ\nカフェオレ",
                        "image":
                            "https://images.unsplash.com/photo-1666600638856-dc0fb01c01bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80"
                      },
                      {
                        "name": "ふわふわ\nカフェオレ",
                        "image":
                            "https://images.unsplash.com/photo-1585494156145-1c60a4fe952b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80"
                      },
                      {
                        "name": "アイスコーヒー\n（水出し）",
                        "image":
                            "https://images.unsplash.com/photo-1499961024600-ad094db305cc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80"
                      },
                      {
                        "name": "アイスコーヒー\n(急冷式)",
                        "image":
                            "https://images.unsplash.com/photo-1517959105821-eaf2591984ca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1746&q=80"
                      },
                      {
                        "name": "アイス\nカフェオレ",
                        "image":
                            "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80"
                      },
                      {
                        "name": "アイス\nカフェオレ\n（ミルク多め）",
                        "image":
                            "https://images.unsplash.com/photo-1553909489-ec2175ef3f52?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=930&q=80"
                      },
                      {
                        "name": "ソイラテ",
                        "image":
                            "https://images.unsplash.com/photo-1608651057580-4a50b2fc2281?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80"
                      },
                      {
                        "name": "アイスソイラテ",
                        "image":
                            "https://images.unsplash.com/photo-1471691118458-a88597b4c1f5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80"
                      }
                    ].map((Map<String, String> item) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: item['name'] == dropdownValue
                              ? Colors.brown
                              : null,
                          elevation: item['name'] == dropdownValue ? 10.0 : 0.0,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                dropdownValue = item['name']!;
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: item['name'] == dropdownValue
                                  ? Colors.brown
                                  : null,
                              child: Container(
                                height: 180,
                                width: 150,
                                child: Column(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(
                                        item['image']!,
                                        height: 100,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        item['name']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: item['name'] == dropdownValue
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Topping',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CheckboxListTile(
                  title: const Text("砂糖"),
                  value: _isSugar,
                  onChanged: (bool? value) {
                    setState(() {
                      _isSugar = value!;
                    });
                  },
                  activeColor: Colors.brown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CheckboxListTile(
                  title: const Text("キャラメルシロップ"),
                  value: caramel,
                  onChanged: (bool? value) {
                    setState(() {
                      caramel = value!;
                    });
                  },
                  activeColor: Colors.brown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CheckboxListTile(
                  title: const Text("練乳"),
                  value: _isCondecensedMilk,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCondecensedMilk = value!;
                    });
                  },
                  activeColor: Colors.brown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CheckboxListTile(
                  title: const Text("少なめ（250ml程度）"),
                  value: small,
                  onChanged: (bool? value) {
                    setState(() {
                      small = value!;
                    });
                  },
                  activeColor: Colors.brown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CheckboxListTile(
                  title: const Text("４階で受け取る"),
                  value: _isPickupOn4thFloor,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPickupOn4thFloor = value!;
                    });
                  },
                  activeColor: Colors.brown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveOrder(
                        timeDropdownValue,
                        dropdownValue,
                        _nameController.text,
                        small,
                        _isSugar,
                        caramel,
                        _isCondecensedMilk,
                        _isPickupOn4thFloor,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ThanksPage()),
                      );
                    }
                  },
                  text: '注文',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
