import 'package:flutter/material.dart';
import 'package:graphql_example/providers/filter_provider.dart';
import 'package:graphql_example/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();

  String queryString = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text("GraphQL example app"),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "search",
                  suffixIcon: SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: const Icon(Icons.search),
                          onTap: () {
                            queryString =
                                GraphQL_Service.fetchACountry(controller.text);
                            setState(() {});
                          },
                        ),
                        InkWell(
                          child: const Icon(Icons.filter_list_outlined),
                          onTap: () {
                            _showBottomSHeetOptions();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          toolbarHeight: 100,
        ),
        body: GraphQLProvider(
          client: GraphQL_Service.client,
          child: Query(
            options: QueryOptions(
              document: gql(
                context
                    .watch<FilterProvider>()
                    .returnQuery(code: controller.text),
              ),
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              //  If there is any exceptions or errors to get the data

              if (result.hasException) {
                return Center(
                  child: result.hasException.toString() == 'true'
                      ? const Text("No data yet")
                      : Text(result.hasException.toString()),
                );
              }

              // if the data hasn't came yet

              if (result.isLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              // When the response came
              var repositories;

              // Check if response is valid to filter
              try {
                repositories =
                    context.watch<FilterProvider>().filterData(result.data!);
              } catch (e) {
                return const Center(
                  child: Text("No data found"),
                );
              }

            // data not found for given query

              if (repositories == null) {
                return const Center(
                  child: Text("No data found"),
                );
              }
            // Everything is fine and you got the data, show it on UI
            
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: context.watch<FilterProvider>().filterNumber != 1
                          ? Text(repositories[index]['name'].toString())
                          : Text(repositories['name'].toString()),
                    ),
                  );
                },
                itemCount: repositories.length,
              );
            },
          ),
        ),
      ),
    );
  }

  // BottomSHeet Options

  _showBottomSHeetOptions() => showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.read<FilterProvider>().changeFilter(0);
                },
                child: const Card(
                  child: ListTile(
                    title: Text("All Countries"),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<FilterProvider>().changeFilter(1);
                },
                child: const Card(
                  child: ListTile(
                    title: Text("Search by Country's code"),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<FilterProvider>().changeFilter(2);
                },
                child: const Card(
                  child: ListTile(
                    title: Text("Search by Continents Code"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
