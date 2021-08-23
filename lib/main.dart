import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/bloc_observer.dart';
import 'package:mobichan/mobichan.dart';

import 'features/boards/domain/repositories/board_repository.dart';

void main() {
  Bloc.observer = MobichanBlocObserver();
  runApp(
    Mobichan(
      boardRepository: BoardRepository(),
    ),
  );
}
