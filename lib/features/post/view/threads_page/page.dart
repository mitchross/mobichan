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

class _ThreadsPageState extends State<ThreadsPage>
    with AutomaticKeepAliveClientMixin {
  final List<int> threadsCountHistory = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<TabsCubit, TabsState>(
          listener: (context, state) {
            if (state is TabsLoaded) {
              final sortState = context.read<SortCubit>().state;
              if (sortState is SortLoaded) {
                final threadsCubit = context.read<ThreadsCubit>();
                final threadsState = threadsCubit.state;
                if (threadsState is! ThreadsLoaded ||
                    threadsState.board != state.current ||
                    threadsState.sort != sortState.sort) {
                  threadsCubit.getThreads(state.current, sortState.sort);
                }
              }
            }
          },
        ),
        BlocListener<SortCubit, SortState>(
          listener: (context, state) {
            if (state is SortLoaded) {
              final tabsState = context.read<TabsCubit>().state;
              if (tabsState is TabsLoaded) {
                final threadsCubit = context.read<ThreadsCubit>();
                final threadsState = threadsCubit.state;
                if (threadsState is! ThreadsLoaded ||
                    threadsState.board != tabsState.current ||
                    threadsState.sort != state.sort) {
                  threadsCubit.getThreads(tabsState.current, state.sort);
                }
              }
            }
          },
        ),
      ],
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, tabsState) {
          if (tabsState is TabsLoaded) {
            return BlocBuilder<SortCubit, SortState>(
              builder: (context, sortState) {
                if (sortState is SortLoaded) {
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final tabsState = context.read<TabsCubit>().state;
    final sortState = context.read<SortCubit>().state;
    if (tabsState is TabsLoaded && sortState is SortLoaded) {
      final threadsCubit = context.read<ThreadsCubit>();
      final threadsState = threadsCubit.state;
      if (threadsState is! ThreadsLoaded ||
          threadsState.board != tabsState.current ||
          threadsState.sort != sortState.sort) {
        threadsCubit.getThreads(tabsState.current, sortState.sort);
      }
    }
  }
}
