import 'package:flutter/material.dart';
import 'package:todo_app/res/colors/app_colors.dart';

class RoundButton extends StatelessWidget {
  final bool loading;
  final String title;
  final VoidCallback? onPress;
  final Color textColor, buttonColor;
  const RoundButton({
    super.key,
    required this.loading,
    required this.title,
    this.onPress,
    this.textColor = AppColors.primary,
    this.buttonColor = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 50,
        width: 400,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Text(title, style: TextStyle(color: textColor)),
              ),
      ),
    );
  }
}
