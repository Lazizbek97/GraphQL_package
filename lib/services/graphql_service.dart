import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQL_Service {
  // GraphQL API url

  static HttpLink baseUrl = HttpLink(
    'https://countries.trevorblades.com/',
  );

  // GraphQLClient

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: baseUrl,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    ),
  );

  // Query string fetching a country by its code

  static String fetchACountry(String code) => """
            query{
              country(code: "${code.toUpperCase()}"){
                  name
                }
            }
  """;

  // Query string fetching all countries

  static fetchAllCountries() => """
      query{
          countries{
              name
          }
        }
  """;

  // Query string fetching countries for specific Continent

  static fetchByContinents(String code) => """
    query{  

          continent(code:"${code.toUpperCase()}"){
            name
            countries{
              name
            }
          }
        }
  """;
}
