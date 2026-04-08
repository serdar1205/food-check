import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/orders_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../application/orders_list_cubit.dart';
import 'widgets/order_card_tile.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  late final OrdersListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createOrdersListCubit()..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersListCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  OrdersUiConstants.horizontalPadding,
                  16,
                  OrdersUiConstants.horizontalPadding,
                  8,
                ),
                child: Text(
                  'Заказы',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.splashTitle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: OrdersUiConstants.horizontalPadding,
                ),
                child: Text(
                  'История ваших заказов и визитов',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<OrdersListCubit, OrdersListState>(
                  builder: (context, state) {
                    if (state.status == RequestStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.authAccentYellow,
                        ),
                      );
                    }
                    if (state.status == RequestStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.errorMessage ?? 'Не удалось загрузить',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () =>
                                    context.read<OrdersListCubit>().load(),
                                child: const Text('Повторить'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state.orders.isEmpty) {
                      return Center(
                        child: Text(
                          'Заказов пока нет',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.authAccentYellow,
                      onRefresh: () => context.read<OrdersListCubit>().load(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          OrdersUiConstants.horizontalPadding,
                          0,
                          OrdersUiConstants.horizontalPadding,
                          24,
                        ),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return OrderCardTile(
                            order: order,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Заказ ${order.id} — в разработке',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
