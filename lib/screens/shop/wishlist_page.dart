// lib/screens/shop/wishlist_page.dart
import 'package:flutter/material.dart';
import '../../models.dart';                // 💡 상대 경로로 확실하게 연결
import 'product_detail_page.dart';         // 💡 같은 폴더에 있으므로 바로 부릅니다.

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('위시리스트', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      // 💡 찜한 상품이 없을 때와 있을 때를 구분합니다.
      body: globalWishlistItems.isEmpty
          ? const Center(
        child: Text(
          '위시리스트가 비어 있습니다.\n마음에 드는 상품을 찜해보세요!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalWishlistItems.length,
        itemBuilder: (context, index) {
          final product = globalWishlistItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.pets, color: Colors.grey),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${product.price}원',
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    // 💡 위시리스트에서 제거
                    globalWishlistItems.remove(product);
                  });
                },
              ),
              onTap: () {
                // 💡 클릭 시 상품 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}