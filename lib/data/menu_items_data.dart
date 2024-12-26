import 'package:flutter/material.dart';
import '../models/misc/menu_item_model.dart';

class MenuItems {
  static const List<MenuItemModel> firstItems = [
    itemProfile,
  ];

  static List<MenuItemModel> secondItems = [itemSignOut];

  static List<MenuItemModel> pickImageItems = [
    itemFromCamera,
    itemFromGallery,
  ];

  static const itemHome = MenuItemModel(
    id: 1,
    title: 'Home',
    icon: Icons.home_sharp,
  );
  static const itemProfile = MenuItemModel(
    id: 2,
    title: 'Profile',
    icon: Icons.person,
  );
  static const itemSignIn = MenuItemModel(
    id: 3,
    title: 'Sign In',
    icon: Icons.login_sharp,
  );
  static const itemSignOut = MenuItemModel(
    id: 4,
    title: 'Sign Out',
    icon: Icons.logout_sharp,
  );
  static const itemOrderHistory = MenuItemModel(
    id: 5,
    title: 'Order History',
    icon: Icons.history,
  );
  static const itemFromCamera = MenuItemModel(
    id: 6,
    title: 'Camera',
    icon: Icons.camera_alt_outlined,
  );
  static const itemFromGallery = MenuItemModel(
    id: 7,
    title: 'Gallery',
    icon: Icons.photo_outlined,
  );
}
