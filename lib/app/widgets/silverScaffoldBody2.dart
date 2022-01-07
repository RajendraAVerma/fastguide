import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/video/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SilverScaffoldBody2 extends StatefulWidget {
  final Widget body;
  final Text firstTitle;
  final Text secondTitle;
  final Icon leadingAppBarIcon;
  final int leadingAppBarFucntion;
  final Text actionListTileText;
  final Icon actionListTileIcon;
  final VoidCallback actionListTileOnTap;
  final ImageProvider? imageProvider;
  final Text? bannerText;
  final Text? bannerSubText;

  SilverScaffoldBody2({
    Key? key,
    required this.body,
    required this.firstTitle,
    required this.secondTitle,
    required this.leadingAppBarIcon,
    required this.leadingAppBarFucntion,
    required this.actionListTileText,
    required this.actionListTileIcon,
    required this.actionListTileOnTap,
    this.imageProvider,
    this.bannerText,
    this.bannerSubText,
  });

  @override
  _SilverScaffoldBody2State createState() => _SilverScaffoldBody2State();
}

class _SilverScaffoldBody2State extends State<SilverScaffoldBody2> {
  ScrollController? _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: false,
                expandedHeight: 300.0,
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: _titleMethod(),
                flexibleSpace: flexibleSpaceMethod(
                  widget.imageProvider,
                  widget.bannerText,
                  widget.bannerSubText,
                ),
                // bottom: PreferredSize(
                //   child: Container(
                //     padding: EdgeInsets.all(5.0),
                //     color: Colors.orange,
                //     child: CrearVideo(),
                //   ),
                //   preferredSize: Size.fromHeight(300),
                // ),
              ),
            ];
          },
          body: Container(child: widget.body),
        ),
      ],
    );
  }

  LayoutBuilder flexibleSpaceMethod(
    ImageProvider? imageProvider,
    Text? bannerText,
    Text? bannerSubText,
  ) {
    var top = 0.0;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        top = constraints.biggest.height;

        return FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          centerTitle: true,
          title: AnimatedOpacity(
            curve: Curves.easeInQuad,
            duration: Duration(milliseconds: 200),
            opacity: top >= 150 ? 1.0 : 0.0,
            child: _flexibleSpaceWidget(
              bannerText,
              bannerSubText,
            ),
          ),
          background: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topRight,
                image: imageProvider == null
                    ? AssetImage("assets/images/bg.png")
                    : imageProvider,
              ),
            ),
          ),
        );
      },
    );
  }

  Row _titleMethod() {
    int _isMenuIcon = 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomIconButton(
          color: Colors.white,
          elevation: 2.0,
          onTap: () => _isMenuIcon == widget.leadingAppBarFucntion
              ? Scaffold.of(context).openDrawer()
              : Navigator.of(context).pop(),
          child: widget.leadingAppBarIcon,
        ),
        SizedBox(width: 10.0),
        widget.firstTitle,
        Spacer(),
        CustomIconTextButton(
          icon: widget.actionListTileIcon,
          onTap: () => widget.actionListTileOnTap,
          text: widget.actionListTileText,
        ),
      ],
    );
  }
}

Widget _flexibleSpaceWidget(Text? bannerText, Text? bannerSubText) {
  return Container(
    child: Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: double.infinity,
            alignment: Alignment.bottomLeft,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  bannerText == null
                      ? gradientText(
                          text: '''Knowledge 
Is Power''',
                          color1: Color(0xff0038fe),
                          color2: Color(0xff42d1ec),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )
                      : bannerText,
                  bannerSubText == null
                      ? gradientText(
                          text: '\nLearn Now >',
                          color1: Color(0xff0038fe),
                          color2: Color(0xff42d1ec),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          fontSize: 8,
                        )
                      : bannerSubText,
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
