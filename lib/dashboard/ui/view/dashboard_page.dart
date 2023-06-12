import 'package:case_study_frontend/constants/flutter_contstants.dart';
import 'package:case_study_frontend/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<DashboardBloc>(context).add(const GetUserRelationStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Text(
                "Instagram",
                style: TextStyle(color: Colors.black),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.heart_broken,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.message,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: BlocBuilder<DashboardBloc, DashboardState>(
                buildWhen: (prev, curr) => prev.applicationState != curr.applicationState,
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.userRelations.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var userRelations = state.userRelations;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StoryScreen()),
                              );
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
                                child: Container(
                                  decoration: userRelations[index].allSeen!
                                      ? null
                                      : BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.pink,
                                            width: 2,
                                          ),
                                        ),
                                  child: CircleAvatar(
                                    radius: 32,
                                    child: ClipOval(
                                      child: Image.network(
                                        'https://loremflickr.com/320/240',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(userRelations[index].user!.name.toString()),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const Expanded(
              flex: 6,
              child: Center(child: Text("TODO: Fill the place with dummy data, later.")),
            )
          ],
        ));
  }
}

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
