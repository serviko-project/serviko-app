import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksFilterCubit extends Cubit<String> {
  BookmarksFilterCubit() : super('All');

  void updateFilter(String filter) => emit(filter);
}
