import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:rescue_my_beauty/rescue_my_beauty_routes.dart';

@FFRoute(
  name: "rescue://homepage",
  routeName: "HomePage",
)
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Wrap(
          spacing: 20,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "のび太が静香を救う",
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              "大雄之拯救静香",
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () {
                _doPlay(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Play",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _doPlay(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.rescueGamepage);
  }
}
