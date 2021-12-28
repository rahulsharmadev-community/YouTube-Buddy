// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/appSetting.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appSetting = Provider.of<AppSetting>(context);

    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.transparent),
            currentAccountPicture:
                Align(child: Image.asset('assets/icons/main.png')),
            accountName: Text('YouTube Buddy',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyText1!.color)),
            accountEmail: Text('rahulsharmadev',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyText1!.color))),
        ListTile(
          leading: Image.asset(
            'assets/icons/block.png',
            height: 30,
            color: appSetting.isAdsEnable
                ? Colors.red.shade800
                : Theme.of(context).hintColor,
          ),
          title: const Text('Ads Block'),
          trailing: Switch(
              value: appSetting.isAdsEnable,
              onChanged: (value) => appSetting.adsSwitch()),
        ),
        ListTile(
            leading: Icon(
              Icons.dark_mode,
              color: Theme.of(context).hintColor,
            ),
            title: const Text('Dark Mode'),
            trailing: Switch(
                value: appSetting.isDarkMode,
                onChanged: (value) => appSetting.themeSwitch())),
        ListTile(
            leading: Icon(
              Icons.security,
              color: Theme.of(context).hintColor,
            ),
            title: const Text('Security Boost'),
            trailing: Switch(
                activeColor: Colors.green,
                value: appSetting.incognito,
                onChanged: (value) => appSetting.incognitoSwitch())),
        ListTile(
            leading: Icon(
              Icons.cleaning_services_rounded,
              color: Theme.of(context).hintColor,
            ),
            title: const Text('Cache Cleaner'),
            trailing: Switch(
                activeColor: Colors.green,
                value: appSetting.getClearCache,
                onChanged: (value) => appSetting.clearCacheSwitch())),
        ListTile(
            title: const Text('License'),
            leading: Icon(
              Icons.policy_outlined,
              color: Theme.of(context).hintColor,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => Theme(
                      data: ThemeData(
                        primarySwatch: Colors.red,
                      ),
                      child: LicensePage(
                        applicationIcon: Image.asset(
                          'assets/icons/main.png',
                          height: 50,
                        ),
                        applicationName: 'YouTube Buddy',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2021 rahulsharmadev-community',
                      ),
                    ))))
      ],
    ));
  }
}
