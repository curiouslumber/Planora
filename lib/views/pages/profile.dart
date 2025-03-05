import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  static const List<String> options = ['Account', 'Settings', 'Help'];

  static const List<IconData> icons = [
    Icons.person_outline_outlined,
    Icons.settings_outlined,
    Icons.help_outline_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              spacing: 32.0,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed:
                          () => {
                            Get.changeThemeMode(
                              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                            ),
                          },
                      icon: Icon(
                        !context.isDarkMode
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: context.theme.colorScheme.onSurface
                            // ignore: deprecated_member_use
                            .withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/shapes/profile_card.svg',
                        // ignore: deprecated_member_use
                        color: context.theme.colorScheme.primary,
                        fit: BoxFit.cover,
                        clipBehavior: Clip.antiAlias,
                        width: context.width * 0.85,
                      ),
                    ),
                    Positioned(
                      top: -35,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.colorScheme.onSurface
                              // ignore: deprecated_member_use
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
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: context.width * 0.8,
                        height: context.height * 0.2,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 2.0,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Noel Pinto',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          size: 12.0,
                                          color:
                                              context
                                                  .theme
                                                  .colorScheme
                                                  .onPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\u00A0Mumbai, India',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              context
                                                  .theme
                                                  .colorScheme
                                                  .onPrimary,
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
                              ],
                            ),
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
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Meetings',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: context.theme.colorScheme.onPrimary
                                  // ignore: deprecated_member_use
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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Day Streak',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: context.theme.colorScheme.onPrimary
                                  // ignore: deprecated_member_use
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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Friends',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            context.theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          tileColor: context.theme.colorScheme.onSurface
                          // ignore: deprecated_member_use
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
      ),
    );
  }
}
