import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl
  });
}

class Post {
  final String title;
  final String content;

  // 📌 [수정] final을 제거하고, 인스턴스마다 독립적인 리스트를 생성하도록 했습니다.
  // 이렇게 해야 .add()를 사용하여 댓글을 추가할 수 있습니다.
  List<String> comments = [];

  Post({
    required this.title,
    required this.content,
  });
}

// 전역 변수
Map<Product, int> globalCartItems = {};
List<Product> globalWishlistItems = [];