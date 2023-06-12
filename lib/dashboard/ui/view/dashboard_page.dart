import 'package:case_study_frontend/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/flutter_contstants.dart';

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
                  print(state.applicationState);
                  print(state.userRelations);
                  return Container(
                    color: Colors.red,
                    child: ListView.builder(
                      itemCount: 8,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: CircleAvatar(
                            radius: 36,
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                            ),
                          ),
                        );
                      },
                    ),
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
