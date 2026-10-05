import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 280),
          Center(child: Text('No products available')),
        ],
      ),
    );
  }
}
