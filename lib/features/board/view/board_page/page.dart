import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan/features/board/board.dart';
import 'builders.dart';
import 'handlers.dart';

class BoardPage extends StatefulWidget {
  final bool showWarning;

  const BoardPage({this.showWarning = false, super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SortCubit>(create: (_) => sl<SortCubit>()..getSort()),
        BlocProvider<PostFormCubit>(create: (_) => PostFormCubit()),
        BlocProvider<ThreadsCubit>(create: (_) => sl<ThreadsCubit>()),
        BlocProvider<FavoritesCubit>(
          create: (_) => sl<FavoritesCubit>()..getFavorites(),
        ),
      ],
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          if (state is TabsLoaded) {
            return DefaultTabController(
              length: state.boards.length,
              initialIndex: state.currentIndex,
              child: BlocProvider<SearchCubit>(
                create: (context) => SearchCubit(),
                child: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => widget.handleFormButtonPressed(context),
                    child: const Icon(Icons.edit),
                  ),
                  drawer: const BoardDrawer(),
                  appBar: widget.buildAppBar(context, state.current),
                  body: widget.showWarning
                      ? widget.buildWarning()
                      : widget.buildTabBarView(
                          state.current,
                          state.boards,
                          _scrollController,
                        ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
