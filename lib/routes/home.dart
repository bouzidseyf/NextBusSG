import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextbussg/components/home/bus_stop_list.dart';
import 'package:nextbussg/components/home/favorites/favorites_list.dart';
import 'package:nextbussg/services/provider/favorites.dart';
import 'package:nextbussg/widgets/page_template.dart';
import 'package:nextbussg/widgets/sliver_space.dart';

class HomePage extends StatelessWidget {
  // if there are no favorites (in simlified favorites view), the favorites heading should come below near me
  // if there are in SFV, put favorites at the top
  Future order(BuildContext context) async {
    Widget nearMe = BusStopList(title: 'NEAR ME', iconData: FontAwesomeIcons.locationArrow);
    Widget favoritesComponent = FavoritesBusStopList(
      title: 'FAVORITES',
      iconData: FontAwesomeIcons.heart,
      simplified: true,
    );
    List<Widget> widgetOrder = [
      favoritesComponent,
      SliverSpacing(height: 40),
      nearMe
    ];

    // if there are no favorites, swap the position of favorites and near me
    List favorites = await FavoritesProvider.getFavorites(simplified: true);
    if (favorites.isEmpty) {
      widgetOrder = [nearMe, SliverSpacing(height: 40), favoritesComponent];
    }

    return widgetOrder;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: order(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return PageTemplate(
          children: [
            if (!snapshot.hasData)
              SliverToBoxAdapter(child: Text("Loading"))
            else
              ...snapshot.data
          ],
        );
      },
    );
  }
}