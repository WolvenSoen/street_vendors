import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/streeter/controllers/favorites_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helpers.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.put(FavoritesController());
    final dark = Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos', style: TextStyle(fontSize: 20)),
      ),
      body: Obx(
        () => FutureBuilder(
          key: Key(favoritesController.refreshData.value.toString()),
          future: favoritesController.getFavorites(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //RETURN PROGRESS BAR INDICATOR
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                color: AppColors.primaryColor,
              ));
            }

            if (favoritesController.favorites.isEmpty) {
              return const Column(
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text('No has agregado a nadie a tu lista aún!'),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final favorites = snapshot.data as List;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      // GENERATE A LIST OF PERSONS WITH AVATAR and NAME and a button to remove from favorites
                      child: ListTile(
                        title: Text(favorites[index]['vendorName']),
                        leading: CircleAvatar(
                          backgroundImage: favorites[index]['vendorPic'] != '' ?
                          NetworkImage(favorites[index]['vendorPic']) :
                          const AssetImage(TextStrings.AvatarDark) as ImageProvider,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            favoritesController.deleteFavorite(
                                favorites[index]['vendorId']);
                            // REFRESH DATA
                            favoritesController.refreshData.toggle();
                          },
                        ),
                      ),
                    ));
              },
            );
          },
        ),
      ),
    );
  }
}
