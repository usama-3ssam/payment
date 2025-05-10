import 'package:flutter/material.dart';
import 'package:payment/login.dart';
import 'stripe_payment/pay.dart';

class Medicine {
  final String name;
  final int price;

  Medicine({required this.name, required this.price});
}

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  // Sample list of 10 medicine items
  final List<Medicine> medicines = [
    Medicine(name: 'Aspirin', price: 50),
    Medicine(name: 'Paracetamol', price: 40),
    Medicine(name: 'Ibuprofen', price: 90),
    Medicine(name: 'Amoxicillin', price: 200),
    Medicine(name: 'Cetirizine', price: 120),
    Medicine(name: 'Loratadine', price: 30),
    Medicine(name: 'Metformin', price: 70),
    Medicine(name: 'Prednisone', price: 60),
    Medicine(name: 'Omeprazole', price: 75),
    Medicine(name: 'Hydrochlorothiazide', price: 80),
  ];

  List<Medicine> filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    filteredMedicines = medicines;
  }

  void updateSearch(String query) {
    setState(() {
      filteredMedicines = medicines.where((medicine) {
        return medicine.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.teal,
        leading: const Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Icon(
                Icons.logout,
                size: 34,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: updateSearch,
              decoration: const InputDecoration(
                labelText: 'Search Medicines',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredMedicines.isEmpty
                ? Center(
                    child: Text(
                      'No medicines found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              leading: const Icon(
                                Icons.medical_services,
                                size: 40,
                                color: Colors.teal,
                              ),
                              title: Text(
                                filteredMedicines[index].name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Price: \$${filteredMedicines[index].price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await PayManager.makeStripePayment(
                                      filteredMedicines[index].price, "EGP");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // onPressed: () => PaymentManager.makePayment(
                                //     filteredMedicines[index].price, "EGP"),
                                child: const Text("Pay"),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
