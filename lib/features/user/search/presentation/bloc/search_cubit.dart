import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit()
    : super(
        SearchInitial([
          'Category 1',
          'Category 2',
          'Category 3',
          'Category 4',
          'Category 5',
          'Category 6',
          'Category 7',
          'Category 8',
        ]),
      );

  final List<String> _recents = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
    'Category 6',
    'Category 7',
    'Category 8',
  ];

  void search(String query) {
    if (query.isEmpty) {
      emit(SearchInitial(List.from(_recents)));
      return;
    }

    emit(SearchLoading());

    Future.delayed(const Duration(seconds: 1), () {
      if (query.toLowerCase() == 'nothing') {
        emit(SearchEmpty(query));
      } else {
        if (!_recents.contains(query)) {
          _recents.insert(0, query);
        }

        emit(
          SearchLoaded(
            query,
            15,
            List.generate(
              15,
              (index) => {
                'name': 'Provider Name ${index + 1}',
                'service': 'Service Title ${index + 1}',
                'price': 25.0 + (index * 2),
                'rating': 4.0 + (index % 10) / 10,
                'reviews': 100 + (index * 30),
                'image':
                    "https://imgs.search.brave.com/UveizRxweFrraMwnNtB7kFdENT_6dhwB5FpySUMnm3I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wbHVz/LnVuc3BsYXNoLmNv/bS9wcmVtaXVtX3Bo/b3RvLTE2NjEzMzM0/NDU5NDEtOTUzMTcz/OWU1NGUwP2ZtPWpw/ZyZxPTYwJnc9MzAw/MCZhdXRvPWZvcm1h/dCZmaXQ9Y3JvcCZp/eGxpYj1yYi00LjEu/MCZpeGlkPU0zd3hN/akEzZkRCOE1IeHpa/V0Z5WTJoOE9YeDhj/bVZ3WVdseUpUSXdj/MlZ5ZG1salpYeGxi/bnd3Zkh3d2ZIeDhN/QT09",
              },
            ),
          ),
        );
      }
    });
  }

  void clearRecents() {
    _recents.clear();
    if (state is SearchInitial) {
      emit(SearchInitial(List.from(_recents)));
    }
  }

  void removeRecent(String query) {
    _recents.remove(query);
    if (state is SearchInitial) {
      emit(SearchInitial(List.from(_recents)));
    }
  }
}
