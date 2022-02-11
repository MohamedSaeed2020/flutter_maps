import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:flutter_maps/shared/constants/colors.dart';
import 'package:flutter_maps/shared/constants/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  MyDrawer({Key? key}) : super(key: key);

  Widget buildDrawerHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70.0, 10.0, 70.0, 10.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.rectangle,
          ),
          child: Image.asset(
            'assets/images/me.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Mohamed Saeed',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        BlocProvider<PhoneAuthCubit>(
          create: (context) => phoneAuthCubit,
          child:  Text(
            '${phoneAuthCubit.getUserInfo()!.phoneNumber}',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.blue,
      ),
      title: Text(title),
      trailing: trailing ??
          const Icon(
            Icons.arrow_right,
            color: MyColors.blue,
          ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return const Divider(
      height: 0,
      thickness: 0,
      indent: 18,
      endIndent: 24,
    );
  }

  void launchFromUrl(String url) async {
    bool result = await canLaunch(url);
    if (result) {
      await launch(url);
    } else {
      throw "Can't launch $url";
    }
  }

  Widget buildIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => launchFromUrl(url),
      child: Icon(
        icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildIcon(
          FontAwesomeIcons.facebook,
          'https://www.facebook.com/groups/129629915000657',
        ),
        buildIcon(
          FontAwesomeIcons.linkedin,
          'https://www.linkedin.com/in/mohamed-el-saeed',
        ),
        buildIcon(
          Icons.mail,
          'mailto:m.saeed.fci@gmail.com',
        ),
      ],
    );
  }

  Widget buildLogOutBlocProvider(BuildContext context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => phoneAuthCubit,
      child: buildDrawerListItem(
          leadingIcon: Icons.logout,
          title: 'Log Out',
          color: Colors.red,
          trailing: const SizedBox(),
          onTap: () async {
            await phoneAuthCubit.logOut();
            Navigator.of(context).pushReplacementNamed(loginsScreen);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280.0,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(),
            ),
          ),
          buildDrawerListItem(
            leadingIcon: Icons.person,
            title: 'Profile',
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
              leadingIcon: Icons.history,
              title: 'Places History',
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.settings,
            title: 'Settings',
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.help,
            title: 'Help',
          ),
          buildDrawerListItemsDivider(),
          buildLogOutBlocProvider(context),
          const SizedBox(
            height: 80.0,
          ),
          ListTile(
            leading: Text(
              'Follow Us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
