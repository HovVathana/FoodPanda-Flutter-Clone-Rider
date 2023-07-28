import 'package:flutter/material.dart';
import 'package:foodpanda_rider/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_rider/constants/colors.dart';
import 'package:foodpanda_rider/constants/helper.dart';
import 'package:foodpanda_rider/models/order.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback pickUpOrder;
  bool isHistoryView;
  OrderCard({
    super.key,
    required this.order,
    required this.pickUpOrder,
    this.isHistoryView = false,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isCommentSeeMore = false;

  @override
  Widget build(BuildContext context) {
    double distance = Helper().calculateDistance(
      widget.order.shop.latitude,
      widget.order.shop.longitude,
      widget.order.address.latitude,
      widget.order.address.longitude,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ORDER ID',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    '#${widget.order.id}',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.order.shop.shopImage,
                  ),
                  backgroundColor: scheme.primary,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    widget.order.shop.shopName,
                    style: TextStyle(
                      fontSize: 18,
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_city_outlined,
                      color: scheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PICK UP ORDER',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${widget.order.shop.houseNumber} ${widget.order.shop.street}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.home_work_outlined,
                      color: scheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DELIVER ORDER',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${widget.order.address.houseNumber} ${widget.order.address.street}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      color: Colors.grey[600],
                    ),
                    Text(
                      '${widget.order.deliveryPrice}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat.jm()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                        widget.order.time,
                      )),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      Icons.delivery_dining_outlined,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${distance.toStringAsFixed(2)} km',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'PAYMENT METHOD: ',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.order.isPaid
                      ? '\$ ${widget.order.totalPrice} (Already paid)'
                      : '\$ ${widget.order.totalPrice} (Not yet paid)',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'COMMENT',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                setState(() {
                  isCommentSeeMore = !isCommentSeeMore;
                });
              },
              child: Text(
                widget.order.address.deliveryInstruction ?? '',
                overflow: isCommentSeeMore
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: !widget.isHistoryView ? 20 : 0),
            !widget.isHistoryView
                ? CustomTextButton(
                    text: 'PICK ORDER',
                    onPressed: widget.pickUpOrder,
                    isDisabled: false,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
