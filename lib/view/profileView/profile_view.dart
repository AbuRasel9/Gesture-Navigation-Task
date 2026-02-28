import 'package:flutter/material.dart';
import 'package:gesture_coordination_task/configs/extension.dart';
import 'package:gesture_coordination_task/view/login/login_view.dart';
import 'package:gesture_coordination_task/view/profileView/widget/Info_card.dart';
import 'package:gesture_coordination_task/view/profileView/widget/info_card_item.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final theme=context.theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE31837),
        foregroundColor: Colors.white,
        title: const Text('My Profile'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
                    (_) => false,
              );
            },
            child: const Text('Logout',
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: user == null
          ? const Center(child: Text('No user data'))
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFFE31837),
              child: Text(
                user.name?.firstname?[0].toUpperCase() ?? "",
                style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              (user.name?.firstname ?? "")+(user.name?.lastname ?? ""),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              '@${user.username}',
              style:theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.4)),
            ),
          ),
          const SizedBox(height: 24),
          InfoCard(
            children: [
              InfoCardItem(icon:Icons.email,label:  'Email',value:  user.email ?? ""),
              Divider(height: 1, indent: 56),
              InfoCardItem(icon:  Icons.phone,label:  'Phone',value:  user.phone ??""),
              Divider(height: 1, indent: 56),
              InfoCardItem(icon:Icons.badge,label:  'User ID', value: '#${user.id}'),
            ],
          ),
        ],
      ),
    );
  }




}

