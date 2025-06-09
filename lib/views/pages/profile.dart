import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planora/bloc/auth_bloc.dart';
import 'package:planora/cubit/theme_cubit.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/utils/app_theme.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/home_page.dart';

class Profile extends StatelessWidget {
  final UserModel user;
  const Profile({super.key, required this.user});

  static const List<String> options = ['Account', 'Settings', 'Help'];

  static const List<IconData> icons = [
    Icons.person_outline_outlined,
    Icons.settings_outlined,
    Icons.help_outline_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: null)),
          );
        }
      },
      child: Scaffold(
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
                            () => context.read<ThemeCubit>().toggleTheme(),
                        icon: Icon(
                          context.read<ThemeCubit>().state.theme ==
                                  AppTheme.lightTheme
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
                              color: Theme.of(context).colorScheme.onSurface
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
                          color: Theme.of(context).colorScheme.primary,
                          fit: BoxFit.cover,
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width * 0.85,
                        ),
                      ),
                      Positioned(
                        top: -35,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.onSurface
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            child: Icon(
                              Icons.person,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.2,
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
                                    user.displayName,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeights.semiBold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            size: 12.0,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\u00A0${user.email}',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            fontFamily:
                                                Theme.of(context)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Meetings',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.5),
                                    width: 1.0,
                                    height: 40.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Day Streak',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.5),
                                    width: 1.0,
                                    height: 40.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Friends',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
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
                      itemBuilder: (context, index) {
                        if (index == 3) {
                          return ListTile(
                            onTap:
                                () => context.read<AuthBloc>().add(
                                  SignOutRequested(),
                                ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            tileColor: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant
                            // ignore: deprecated_member_use
                            .withOpacity(0.9),
                            minTileHeight:
                                MediaQuery.of(context).size.height * 0.08,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeights.medium,
                                fontSize: 16.0,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                              ),
                            ),
                            trailing: Icon(
                              Icons.logout,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                            ),
                          );
                        }

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          tileColor: Theme.of(context).colorScheme.primary,
                          minTileHeight:
                              MediaQuery.of(context).size.height * 0.08,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          title: Text(
                            options[index],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.medium,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          trailing: Icon(
                            icons[index],
                            color: Theme.of(context).colorScheme.onPrimary,
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
      ),
    );
  }
}
