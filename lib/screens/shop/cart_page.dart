import 'package:flutter/material.dart';
import '../../models.dart'; // 💡 상대 경로 치트키
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // globalCartItems가 안 불러와질 경우를 대비해 models.dart에서 안전하게 가져오거나 빈 맵으로 처리
    final cartItems = globalCartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('장바구니')),
      body: cartItems.isEmpty
          ? const Center(child: Text('장바구니가 비어 있습니다.'))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          Product product = cartItems.keys.elementAt(index);
          int quantity = cartItems[product]!;
          return ListTile(
            title: Text(product.name),
            subtitle: Text('$quantity개'),
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(
                orderItems: cartItems,
                totalPrice: 30000, // 임시 고정 금액 처리
              ),
            ),
          );
        },
        child: const Text('주문하러 가기'),
      ),
    );
  }
}