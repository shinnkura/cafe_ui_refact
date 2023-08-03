import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../edito_order_pages/edit_order_page.dart';
import '../order_screen/components/custom_elevated_button.dart';
import 'components/order_loader.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  Future<Map<String, Map<String, List<Map<String, dynamic>>>>>? _orderFuture;

  // Define a map of coffee types to image URLs
  final Map<String, String> coffeeImages = {
    'コーヒー':
        'https://images.unsplash.com/photo-1634913564795-7825a3266590?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
    'カフェオレ':
        'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80',
    'ちょいふわカフェオレ':
        'https://images.unsplash.com/photo-1666600638856-dc0fb01c01bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
    'ふわふわカフェオレ':
        'https://images.unsplash.com/photo-1585494156145-1c60a4fe952b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80',
    'アイスコーヒー（水出し）':
        'https://images.unsplash.com/photo-1499961024600-ad094db305cc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
    'アイスコーヒー(急冷式)':
        'https://images.unsplash.com/photo-1517959105821-eaf2591984ca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1746&q=80',
    'アイスカフェオレ':
        'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80',
    'アイスカフェオレ（ミルク多め）':
        'https://images.unsplash.com/photo-1553909489-ec2175ef3f52?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=930&q=80',
  };

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
                    title: Text(
                      '$time     $totalOrdersAtThisTime名',
                      style: TextStyle(
                        color: Colors.brown[800],
                        fontSize: 24,
                      ),
                    ),
                    children: orders[time]!.entries.map((entry) {
                      String coffeeType = entry.key;
                      List<Map<String, dynamic>> ordersList = entry.value;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  '$coffeeType     ${ordersList.length}名',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.brown[800],
                                  ),
                                  textAlign: TextAlign.left, // Add this line
                                ),
                              ),
                            ],
                          ),
                          ...ordersList.map((order) {
                            return Dismissible(
                              key: Key(order['name']),
                              onDismissed: (direction) async {
                                // Remove the item from the Firestore.
                                CollectionReference orders = FirebaseFirestore
                                    .instance
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
                                  ordersMap[time]![coffeeType]!.remove(order);
                                  if (ordersMap[time]![coffeeType]!.isEmpty) {
                                    ordersMap[time]!.remove(coffeeType);
                                    if (ordersMap[time]!.isEmpty) {
                                      ordersMap.remove(time);
                                    }
                                  }
                                });

                                // Then show a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("${order['name']} dismissed")),
                                );
                              },
                              background: Container(
                                  color: Colors.red), // Red background on swipe
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 10,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                coffeeImages[coffeeType] ?? ''),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${order['name']}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.brown[700],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    order['small'] ? '少なめ' : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                  Text(
                                                    order['isSugar']
                                                        ? '砂糖'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    order['caramel']
                                                        ? 'キャラメル'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.purple,
                                                    ),
                                                  ),
                                                  Text(
                                                    order['isCondecensedMilk']
                                                        ? '練乳'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Text(
                                                    order['isPickupOn4thFloor']
                                                        ? '4階受取'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () async {
                const url =
                    'http://docs.google.com/forms/d/e/1FAIpQLSc1fO0xXfhBt_h-m62Evx0wL_J_z60Xe4rfH-zvxDGnaw-9aQ/viewform';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              backgroundColor: Colors.brown[500],
              heroTag: null,
              child: Icon(Icons.mail),
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              text: 'ホームに戻る',
            ),
          ],
        ),
      ),
    );
  }
}
