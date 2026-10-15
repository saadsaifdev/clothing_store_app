import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_app/cart/cart_manager.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.onCartPressed, this.onSearchPressed});

  final VoidCallback? onCartPressed;
  final VoidCallback? onSearchPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      floating: true,
      snap: true,
      title: Text(
        'New Trend',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.onSurface.withValues(alpha: 0.15),
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: CartManager.instance,
          builder: (context, _) {
            final cartItemCount = CartManager.instance.itemCount;

            return Badge(
              isLabelVisible: cartItemCount > 0,
              label: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  '$cartItemCount',
                  key: ValueKey<int>(cartItemCount),
                ),
              ),
              backgroundColor: colorScheme.onSurface,
              textColor: colorScheme.surface,
              child: IconButton(
                tooltip: 'Shopping cart',
                onPressed: onCartPressed,
                icon: FaIcon(
                  FontAwesomeIcons.cartPlus,
                  color: colorScheme.onSurface,
                  size: 20,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Search products',
          onPressed: onSearchPressed,
          icon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: colorScheme.onSurface,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
