import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThreadsPage extends StatefulWidget {
  final Board board;
  const ThreadsPage(this.board, {super.key});

  @override
  State<ThreadsPage> createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  final List<int> threadsCountHistory = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsCubit, TabsState>(
      builder: (context, tabsState) {
        if (tabsState is TabsLoaded) {
          return BlocBuilder<SortCubit, SortState>(
            builder: (context, sortState) {
              if (sortState is SortLoaded) {
                context
                    .read<ThreadsCubit>()
                    .getThreads(tabsState.current, sortState.sort);
                return BlocConsumer<ThreadsCubit, ThreadsState>(
                  listener: (context, threadsState) => widget.buildListener(
                    context,
                    threadsState,
                    threadsCountHistory,
                  ),
                  buildWhen: (previous, current) {
                    // Only rebuild if the list of threads changes or we switch from loading/error to loaded
                    if (current is ThreadsLoaded && previous is ThreadsLoaded) {
                      return current.threads != previous.threads;
                    }
                    return current != previous;
                  },
                  builder: (context, threadsState) {
                    if (threadsState is ThreadsLoaded) {
                      return widget.buildLoaded(
                        board: widget.board,
                        threads: threadsState.threads,
                        sort: sortState.sort,
                      );
                    } else {
                      return widget.buildLoading();
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
