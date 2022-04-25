import 'package:flutter/material.dart';
import 'package:graphql_example/services/graphql_service.dart';

class FilterProvider extends ChangeNotifier {
  int filterNumber = 1;

  returnQuery({String? code}) {
    switch (filterNumber) {
      case 0:
        return GraphQL_Service.fetchAllCountries();
      case 1:
        return GraphQL_Service.fetchACountry(code!);
      case 2:
        return GraphQL_Service.fetchByContinents(code!);
    }
  }

  filterData(Map<String, dynamic> data) {
    switch (filterNumber) {
      case 0:
        return data['countries'];
      case 1:
        return data['country'];
      case 2:
        return data['continent']['countries'];
    }
  }

  changeFilter(int filterNum) {
    filterNumber = filterNum;
    notifyListeners();
  }
}
