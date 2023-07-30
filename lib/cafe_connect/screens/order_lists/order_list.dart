import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../edito_order_pages/edit_order_page.dart';
import '../order_screen/components/custom_app_bar.dart';
import '../order_screen/components/custom_elevated_button.dart';
import 'components/order_loader.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  Future<Map<String, Map<String, List<Map<String, dynamic>>>>>? _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = loadOrder();
  }

  Future<void> _refreshOrder() async {
    setState(() {
      _orderFuture = loadOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order List'),
      body: RefreshIndicator(
        onRefresh: _refreshOrder,
        child:
            FutureBuilder<Map<String, Map<String, List<Map<String, dynamic>>>>>(
          future: _orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
            } else {
              // Create a separate variable for the orders map.
              Map<String, Map<String, List<Map<String, dynamic>>>> orders =
                  snapshot.data!;
              Map<String, Map<String, List<Map<String, dynamic>>>> ordersMap =
                  orders;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  String time = orders.keys.elementAt(index);
                  int totalOrdersAtThisTime = orders[time]!
                      .values
                      .fold(0, (prev, curr) => prev + curr.length);
                  return ExpansionTile(
                    title: Text('$time     $totalOrdersAtThisTime名',
                        style:
                            TextStyle(color: Colors.brown[800], fontSize: 20)),
                    children: orders[time]!.entries.map((entry) {
                      String coffeeType = entry.key;
                      List<Map<String, dynamic>> ordersList = entry.value;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$coffeeType     ${ordersList.length}名',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.brown[800]),
                              ),
                              Divider(color: Colors.brown[800]),
                              ...ordersList.map((order) {
                                return Dismissible(
                                  key: Key(order[
                                      'name']), // Unique key for Dismissible
                                  onDismissed: (direction) async {
                                    // Remove the item from the Firestore.
                                    CollectionReference orders =
                                        FirebaseFirestore.instance
                                            .collection('orders');
                                    QuerySnapshot querySnapshot =
                                        await orders.get();
                                    for (var doc in querySnapshot.docs) {
                                      Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      if (data['name'] == order['name'] &&
                                          data['coffeeType'] == coffeeType &&
                                          data['time'] == time) {
                                        doc.reference.delete();
                                        break;
                                      }
                                    }

                                    // Update the state of the application to reflect the deletion.
                                    setState(() {
                                      ordersMap[time]![coffeeType]!
                                          .remove(order);
                                      if (ordersMap[time]![coffeeType]!
                                          .isEmpty) {
                                        ordersMap[time]!.remove(coffeeType);
                                        if (ordersMap[time]!.isEmpty) {
                                          ordersMap.remove(time);
                                        }
                                      }
                                    });

                                    // Then show a snackbar.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "${order['name']} dismissed")),
                                    );
                                  },
                                  background: Container(
                                      color: Colors
                                          .red), // Red background on swipe
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.brown[700],
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditOrderPage(
                                                name: order['name'],
                                                initialCoffeeType: coffeeType,
                                                initialTime: time,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${order['name']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.brown[700],
                                            ),
                                          ),
                                          Text(
                                            order['small'] ? '  少なめ' : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.orange,
                                            ),
                                          ),
                                          Text(
                                            order['isSugar'] ? '  砂糖' : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            order['caramel'] ? '  キャラメル' : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          Text(
                                            order['isCondecensedMilk']
                                                ? '  練乳'
                                                : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            order['isPickupOn4thFloor']
                                                ? '  4階受取'
                                                : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: FloatingActionButton(
              onPressed: () async {
                const url =
                    'http://docs.google.com/forms/d/e/1FAIpQLSc1fO0xXfhBt_h-m62Evx0wL_J_z60Xe4rfH-zvxDGnaw-9aQ/viewform';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              backgroundColor: Colors.brown[500],
              heroTag: null,
              child: Icon(Icons.mail),
            ),
          ),
          SizedBox(height: 10),
          CustomElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            text: 'ホームに戻る',
          ),
        ],
      ),
    );
  }
}
