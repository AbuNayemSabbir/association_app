import 'package:association_app/utills/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color color;
  final double width;

  const CustomElevatedButton({super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.color = CustomColors.primaryColor,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            //side: BorderSide(color:  color.withOpacity(0.6)),
          ),),
        onPressed: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ],
        ),
      ),
    );
  }
}
