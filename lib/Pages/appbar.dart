import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  late String? title;
  Widget? leading;
  CustomAppBar({Key? key, this.title, this.leading}) : super(key: key);

  final Color myColor = Color(0xff4044fc);

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Material(
          elevation: 16.0,
          child: ListTile(
            trailing: Image.asset(
              'images/eazyapp-logo-blue.png',
              height: 48,
              width: 40,
            ),
            leading: leading,
            title: Stack(
              children: [
                Positioned(
                  left: 135,
                  top: 16,
                  child: Text(
                    title.toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: myColor,
                        fontSize: 16,
                      ),
                    ),
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
