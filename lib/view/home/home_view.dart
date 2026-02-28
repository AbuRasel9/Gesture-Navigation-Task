import 'package:flutter/material.dart';
import 'package:gesture_coordination_task/configs/extension.dart';
import 'package:gesture_coordination_task/view/home/widgets/product_card.dart';
import 'package:gesture_coordination_task/view/home/widgets/shimmer_grid.dart';
import 'package:provider/provider.dart';

import '../../model/product_list/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/products_provider.dart';
import '../profileView/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _tabIndex = 0;
  TabController? _tabController;
  int _lastTabCount = 0;

  final ScrollController _scrollController = ScrollController();
  double _dragStartX = 0;
  double _dragStartY = 0;
  bool _horizontalSwipeDetected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadAll();
    });
  }

  TabController _getController(int count) {
    if (_tabController != null && _lastTabCount == count) {
      return _tabController!;
    }
    final safeIndex = _tabIndex.clamp(0, count - 1);
    _tabController?.dispose();
    _tabController = TabController(
      length: count,
      vsync: this,
      initialIndex: safeIndex,
    );
    _lastTabCount = count;
    _tabIndex = safeIndex;
    return _tabController!;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails d) {
    _dragStartX = d.globalPosition.dx;
    _dragStartY = d.globalPosition.dy;
    _horizontalSwipeDetected = false;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_horizontalSwipeDetected) return;
    final dx = d.globalPosition.dx - _dragStartX;
    final dy = d.globalPosition.dy - _dragStartY;
    if (dx.abs() > 40 && dx.abs() / (dy.abs() + 1) > 1.5) {
      _horizontalSwipeDetected = true;
      final ctrl = _tabController;
      if (ctrl == null) return;
      if (dx < 0 && _tabIndex < ctrl.length - 1) {
        _switchTab(_tabIndex + 1);
      } else if (dx > 0 && _tabIndex > 0) {
        _switchTab(_tabIndex - 1);
      }
    }
  }

  void _onPanEnd(DragEndDetails _) {
    _horizontalSwipeDetected = false;
  }

  void _switchTab(int index) {
    final ctrl = _tabController;
    if (ctrl == null || index < 0 || index >= ctrl.length) return;
    setState(() => _tabIndex = index);
    ctrl.animateTo(index);
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  List<String> _tabKeys(List<String> categories) => ['all', ...categories];

  String _tabLabel(String key) => key == 'all' ? 'All' : _capitalize(key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        final tabs = _tabKeys(provider.categories);
        // Controller এখানেই তৈরি হয়, build এর সময়
        final controller = _getController(tabs.length);
        final safeIndex = _tabIndex.clamp(0, tabs.length - 1);
        final labels = tabs.map(_tabLabel).toList();
        final theme = context.theme;

        final products = provider.loading
            ? <Product>[]
            : provider.productsForTab(tabs[safeIndex]);

        return Scaffold(
          backgroundColor: theme.colorScheme.onPrimary,
          body: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: RefreshIndicator(
              color: theme.colorScheme.primary,
              onRefresh: provider.refresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  CustomAppBar(context, controller, labels),
                  if (provider.loading)
                    const ShimmerGridSliver()
                  else if (provider.error != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(provider.error ?? 'Something went wrong'),
                      ),
                    )
                  else if (products.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No products in this category',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverGrid(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (ctx, i) => ProductCard(product: products[i]),
                            childCount: products.length,
                          ),
                        ),
                      ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget CustomAppBar(
      BuildContext context, TabController controller, List<String> labels) {
    final auth = context.watch<AuthProvider>();
    final theme = context.theme;

    return SliverAppBar(
      expandedHeight: 240,
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: const Color(0xFFE31837),
      bottom: TabBar(
        padding: EdgeInsets.only(bottom: 10,),
        controller: controller,
        isScrollable: true,
        onTap: _switchTab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelStyle:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: labels.map((l) => Tab(text: l)).toList(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE31837), Color(0xFFB71C1C)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'daraz',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileScreen()),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white24,
                          child: auth.user != null
                              ? Text(
                            auth.user?.name?.firstname?[0]
                                .toUpperCase() ??
                                '',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                              : Icon(Icons.person,
                              color: theme.colorScheme.onPrimary,
                              size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search,
                            color: theme.colorScheme.onSurface
                                .withOpacity(.4)),
                        const SizedBox(width: 8),
                        Text(
                          'Search for products...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(.4)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '🔥 Flash Sale — Up to 70% OFF!',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}