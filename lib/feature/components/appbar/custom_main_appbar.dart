// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:vm_fm_4/feature/constants/other/colors.dart';

class CustomMainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMainAppbar({
    Key? key,
    required this.title,
    this.leading,
    this.returnBack,
    this.actions,
    this.elevation,
  }) : super(key: key);

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? returnBack;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      leading: returnBack == true
          ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.black))
          : leading,
      automaticallyImplyLeading: returnBack ?? false,
      actions: actions != null ? actions! : [],
      backgroundColor: APPColors.Main.white,
      elevation: elevation ?? 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}