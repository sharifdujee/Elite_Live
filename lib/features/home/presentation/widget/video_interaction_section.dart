
import 'package:elites_live/features/home/presentation/widget/comment_sheet.dart';
import 'package:elites_live/features/home/presentation/widget/donation_sheet.dart';
import 'package:elites_live/features/home/presentation/widget/share_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/global_widget/custom_text_view.dart';



class VideoInteractionSection extends StatelessWidget {
  const VideoInteractionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildItem(Icons.favorite, "4.5M", Colors.red),
          SizedBox(width: 19),
          GestureDetector(
            onTap: (){
              CommentSheet().show(context);

            },
            child: _buildItem(FontAwesomeIcons.comment, "25.2k"),
          ),
          SizedBox(width: 19),
          GestureDetector(
            onTap: () {
              DonationSheet.show(context, eventId: '');
            },
            child: _buildItem(FontAwesomeIcons.donate, "Donate"),
          ),
          SizedBox(width: 19),
          GestureDetector(
            onTap: () => ShareSheet().show(context),
            child: _buildItem(Icons.share, "Share"),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String text, [Color? color]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 4),
        CustomTextView(       text: text),

      ],
    );
  }














}
