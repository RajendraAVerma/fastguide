import 'package:fastguide/admin/screens/admin_home/chapter/contents/chapter_contents/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Shimmer.fromColors(
        baseColor: Colors.blue.shade100,
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 80,
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: 20.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}
