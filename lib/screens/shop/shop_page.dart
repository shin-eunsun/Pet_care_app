// lib/screens/shop/shop_page.dart
import 'package:flutter/material.dart';
import '../../models.dart';                // 상대 경로 연결
import 'cart_page.dart';                  // 장바구니 페이지 연결
import 'product_detail_page.dart';         // 상품 상세 페이지 연결
import 'wishlist_page.dart';              // 위시리스트 페이지 연결

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // 상품 목록 더미 데이터
  final List<Product> dummyProducts = [
    Product(id: '1', name: '유기농 강아지 사료', price: 29000, imageUrl: ''),
    Product(id: '2', name: '고양이 츄르 락토프리', price: 4500, imageUrl: ''),
    Product(id: '3', name: '천연 양모 펫 장난감', price: 12000, imageUrl: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('쇼핑몰', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          // 1. 위시리스트(하트) 버튼
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.favorite_border, color: Colors.black),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '${globalWishlistItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. 장바구니 버튼
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 12.0, right: 20.0, top: 16.0, bottom: 16.0),
              child: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return GestureDetector(
            // 💡 [오류 해결] 에러의 원인이었던 onPressed를 GestureDetector 스펙에 맞는 onTap으로 수정하고 모든 괄호를 닫았습니다.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Center(child: Icon(Icons.pets, size: 40, color: Colors.grey)),
                    ),
                  ),
                  paddingText(product.name, 16, FontWeight.bold),
                  paddingText('${product.price}원', 14, FontWeight.w500, color: Colors.orange),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 텍스트 패딩용 헬퍼 위젯
  Widget paddingText(String text, double size, FontWeight weight, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: size, fontWeight: weight, color: color),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}