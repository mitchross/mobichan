import 'package:equatable/equatable.dart';

enum Order {
  byBump,
  byReplies,
  byImages,
  byNew,
  byOld,
}

class Sort extends Equatable {
  final Order order;

  const Sort({required this.order});

  static Sort get initial {
    return const Sort(order: Order.byBump);
  }

  @override
  List<Object?> get props => [order];
}
