import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();

  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();

    products = apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product API'),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Product>>(
        future: products,

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          // No data
          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No products found'),
            );
          }

          final productList = snapshot.data!;

          // Display products using ListViewBuilder
          return ListView.builder(
            itemCount: productList.length,

            itemBuilder: (context, index) {
              final product = productList[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  leading: Image.network(
                    product.thumbnail,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),

                  title: Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(product.category),

                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                      ),

                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}