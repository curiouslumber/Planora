import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  static const List<String> options = ['Account', 'Notifications', 'Help'];

  static const List<IconData> icons = [
    Icons.person_outline_outlined,
    Icons.notifications_outlined,
    Icons.help_outline_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(top: 16.0, right: 8.0),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed:
                () => {
                  Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  ),
                },
            icon: Icon(!context.isDarkMode ? Icons.wb_sunny : Icons.mode_night),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            spacing: 32.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/shapes/profile_card.svg',
                      color: context.theme.colorScheme.primary,
                      fit: BoxFit.cover,
                      clipBehavior: Clip.antiAlias,
                    ),
                  ),
                  Positioned(
                    top: -35,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.025),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: context.theme.colorScheme.onPrimary,
                        child: Icon(
                          Icons.person,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 48.0),
                    padding: EdgeInsets.only(top: 12.0),
                    width: 320,
                    height: 154,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      spacing: 4.0,
                      children: [
                        Text(
                          'Noel Pinto',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.top,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 14.0,
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                              ),
                              TextSpan(
                                text: '\u00A0Mumbai, India',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: context.theme.colorScheme.onPrimary,
                                  fontFamily:
                                      context
                                          .theme
                                          .textTheme
                                          .bodyMedium!
                                          .fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 16.0,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  'Meetings',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: context.theme.colorScheme.onPrimary
                                  .withOpacity(0.5),
                              width: 1.0,
                              height: 40.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  'Day Streak',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: context.theme.colorScheme.onPrimary
                                  .withOpacity(0.5),
                              width: 1.0,
                              height: 40.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  'Friends',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 3) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                        tileColor: context.theme.colorScheme.onSurface
                            .withOpacity(0.9),
                        minTileHeight: context.height * 0.08,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: context.theme.colorScheme.surfaceContainer,
                          ),
                        ),
                        trailing: Icon(
                          Icons.logout,
                          color: context.theme.colorScheme.surfaceContainer,
                        ),
                      );
                    }

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                      tileColor: context.theme.colorScheme.primaryContainer,
                      minTileHeight: context.height * 0.08,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text(
                        options[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      trailing: Icon(
                        icons[index],
                        color: context.theme.colorScheme.onPrimaryContainer,
                      ),
                    );
                  },
                  separatorBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                  itemCount: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
