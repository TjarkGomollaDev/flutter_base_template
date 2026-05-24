import 'package:flutter/material.dart';

class QuickSearchItemModel {
  final IconData icon;
  final String text;

  QuickSearchItemModel({
    required this.icon,
    required this.text,
  });
}

final List<QuickSearchItemModel> quickSearchItems = [
  QuickSearchItemModel(
    icon: Icons.add,
    text: 'Add money',
  ),
  QuickSearchItemModel(
    icon: Icons.keyboard_double_arrow_up_sharp,
    text: 'Top movers',
  ),
  QuickSearchItemModel(
    icon: Icons.shopping_bag_rounded,
    text: 'My net worth',
  ),
  QuickSearchItemModel(
    icon: Icons.credit_card,
    text: 'Cards',
  ),
  QuickSearchItemModel(
    icon: Icons.person,
    text: 'Account details',
  ),
];
