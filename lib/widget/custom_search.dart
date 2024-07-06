import 'package:bitirme_projesi/widget_model/bottom_navigationvar_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> seactTerms = [
    'Yıldız Eczanesi',
    'Mamak Eczanesi',
    'Hekim Eczanesi',
    'Cebeci Eczanesi',
    'Pursaklar Eczanesi',
    'Dikimevi Eczanesi',
    'Kutrluş Eczanesi',
    'Kızılay Eczanesi',
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var element in seactTerms) {
      if (element.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var element in seactTerms) {
      if (element.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Consumer<BottomNavigationBarModel>(
          builder: (context, viewModel, child) {
            return ListTile(
              leading: const Icon(Icons.search_outlined),
              title: Text(result),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => CartView(),
                // ));
              },
            );
          },
        );
      },
    );
  }
}
