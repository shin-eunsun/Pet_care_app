// lib/screens/shop/product_detail_page.dart
import 'package:flutter/material.dart';
import '../../models.dart'; // 💡 상대 경로로 확실하게 연결하여 모든 에러를 해결합니다.

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    // 💡 위시리스트에 이미 포함되어 있는지 확인하는 로직
    final isFavorite = globalWishlistItems.contains(widget.product);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                if (isFavorite) {
                  globalWishlistItems.remove(widget.product);
                } else {
                  globalWishlistItems.add(widget.product);
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.product.price}원',
              style: const TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                // 💡 장바구니에 상품 추가 또는 개수 증가
                if (globalCartItems.containsKey(widget.product)) {
                  globalCartItems[widget.product] = globalCartItems[widget.product]! + 1;
                } else {
                  globalCartItems[widget.product] = 1;
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('장바구니에 상품을 담았습니다.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              '장바구니 담기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}