import '../../providers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../util/index.dart' show DateExtension, StringExtensions, Http;
import '../../models/orderModel.dart';
import '../../providers/ordersProvider.dart';
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show Loader, HttpServiceExceptionWidget, ActiveButton, ShimmerWidget, Toast;

import '../tabbar.dart';
import '../auth/loginScreen.dart';
import 'orderDetailScreen.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with WidgetsBindingObserver {
  bool _isLoading;
  Exception _error;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, () => _getOrders());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // This ensures transition to detail screen if resumed by a notification
      _getOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrdersProvider>(context);

    if (!userProvider.isLoggedIn) {
      return _userNotLoggedIn();
    } else if (_error != null) {
      return HttpServiceExceptionWidget(
        exception: _error,
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Tabbar(index: 1),
              transitionDuration: Duration.zero,
            ),
          );
        },
      );
    } else if (_isLoading && orderProvider.isEmpty) {
      return _shimmerWidget();
    } else {
      return Stack(
        children: [
          orderProvider.isEmpty ? _noOrders() : _orderList(orderProvider),
          _isLoading ? Loader() : Container()
        ],
      );
    }
  }

  Future<void> _getOrders() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
    if (userProvider.isLoggedIn && orderProvider.isEmpty) {
      // If user is logged in, download order list
      try {
        setState(() {
          _isLoading = true;
          _error = null;
        });
        await orderProvider.getOrders();
      } catch (error) {
        _error = error;
      } finally {
        setState(() => _isLoading = false);
      }
    }
    if (userProvider.notificationOrderId.isNotNullAndEmpty) {
      final order =
          orderProvider.getOrderWithId(userProvider.notificationOrderId);
      userProvider.notificationOrderId = '';
      if (order != null) {
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailScreen(order.id)),
          ),
        );
      }
    }
  }

  Future<void> _nextOrders() async {
    // If user is logged in, download order list
    try {
      setState(() => _isLoading = true);
      await Provider.of<OrdersProvider>(context, listen: false).nextOrders();
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _userNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/orderCart.png'),
          SizedBox(height: 16.0),
          Text(
            'Nothing here!',
            style: AppTheme.textStyle.w700.color100.size(15.0).lineHeight(1.3),
          ),
          SizedBox(height: 16.0),
          Text(
            'Login / Signup to  manage your orders',
            style: AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
          ),
          SizedBox(height: 24),
          ActiveButton(
            title: 'Login',
            width: 240,
            onPressed: () => Navigator.pushNamed(context, LoginScreen.route),
          ),
        ],
      ),
    );
  }

  Widget _noOrders() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No orders placed yet!',
            style: AppTheme.textStyle.w800.color05.size(72.0),
          ),
          SizedBox(height: 24.0),
          Text(
            'Many amazing products to purchase',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
        ],
      ),
    );
  }

  Widget _orderList(OrdersProvider provider) {
    final addButtonForMoreOrders =
        provider.currentPage + 1 < provider.pages ? 1 : 0;
    return Container(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: provider.orders.length + 1 + addButtonForMoreOrders,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              'Orders',
              style: AppTheme.textStyle.w700.size(22).lineHeight(1.4),
            );
          } else if (index <= provider.orders.length) {
            return _orderTile(provider.orders[index - 1]);
          } else {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _nextOrders(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.dividerColor,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'View Past Orders',
                    style: AppTheme.textStyle.w600
                        .size(15)
                        .lineHeight(1.3)
                        .colored(AppTheme.primaryColor),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _orderTile(OrderModel order) {
    final dateMessage = order.isCompleted
        ? '${order.completionDate.dateFormatDayMonth} • ${order.completionDate.dateFormatTime}'
        : 'Delivery by ${order.expectedDeliveryDate.dateFormatWeekDayMonthDay}';

    final deliverySlotMessage =
        order.isCompleted || order.deliverySlot.isNullOrEmpty
            ? ''
            : ' • ${order.deliverySlot}';

    final image = order.isDelivered
        ? 'assets/images/success.png'
        : 'assets/images/failure.png';

    return OpenContainer(
      closedElevation: 0.0,
      transitionDuration: Duration(milliseconds: 300),
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: openContainer,
          child: Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.seller.brandName,
                        style: AppTheme.textStyle.w600.color100
                            .size(15)
                            .lineHeight(1.3),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      '₹${order.totalAmount.toString()}',
                      style: AppTheme.textStyle.w600.color100
                          .size(13)
                          .lineHeight(1.5),
                    )
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$dateMessage$deliverySlotMessage',
                            style: AppTheme.textStyle.w500.color50
                                .size(12)
                                .lineHeight(1.3),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              order.isCompleted
                                  ? Image.asset(image)
                                  : Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                        color: order.statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                              SizedBox(width: 4.0),
                              Text(
                                order.statusMessage,
                                style: AppTheme.textStyle.w500.color50
                                    .size(12)
                                    .lineHeight(1.3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    order.payment.isSuccess
                        ? Image.asset('assets/images/stampPaid.png')
                        : Container(),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(
                  thickness: 1.0,
                  color: AppTheme.dividerColor,
                ),
              ],
            ),
          ),
        );
      },
      openBuilder: (_, __) => OrderDetailScreen(order.id),
    );
  }

  Widget _shimmerWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          ShimmerWidget(
            child: Text(
              'Orders',
              style: AppTheme.textStyle.w700.size(22).lineHeight(1.4),
            ),
          ),
          ...List<Widget>.generate(
            10,
            (index) => ShimmerWidget(
              child: Container(
                padding: EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 48.0),
                        Expanded(
                          child: Container(
                            height: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 4.0),
                                  Container(
                                    width: 100,
                                    height: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 48),
                        Image.asset('assets/images/stampPaid.png')
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Divider(
                      thickness: 1.0,
                      color: AppTheme.color25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
