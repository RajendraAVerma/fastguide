import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SilverScaffoldBody extends StatefulWidget {
  final Widget body;
  final Widget firstTitle;
  final Text secondTitle;
  final Icon leadingAppBarIcon;
  final int leadingAppBarFucntion;
  final Widget actionListTileText;
  final Widget actionListTileIcon;
  final VoidCallback actionListTileOnTap;
  final String imageLink;
  final Widget? bannerText;
  final Widget? bannerSubText;

  SilverScaffoldBody({
    Key? key,
    required this.body,
    required this.firstTitle,
    required this.secondTitle,
    required this.leadingAppBarIcon,
    required this.leadingAppBarFucntion,
    required this.actionListTileText,
    required this.actionListTileIcon,
    required this.actionListTileOnTap,
    required this.imageLink,
    this.bannerText,
    this.bannerSubText,
  });

  @override
  _SilverScaffoldBodyState createState() => _SilverScaffoldBodyState();
}

class _SilverScaffoldBodyState extends State<SilverScaffoldBody> {
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(
        () async {
          await _isAppBarExpanded
              ? setState(
                  () {
                    print('setState is called');
                  },
                )
              : setState(() {
                  print('setState is called');
                });
        },
      );
  }

  bool get _isAppBarExpanded {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            expandedHeight: 200.0,
            backgroundColor: Colors.white,
            elevation: _isAppBarExpanded ? 0.0 : 0.0,
            title: _titleMethod(),
            flexibleSpace: flexibleSpaceMethod(
              widget.imageLink,
              widget.bannerText,
              widget.bannerSubText,
            ),
          ),
        ];
      },
      body: widget.body,
    );
  }

  LayoutBuilder flexibleSpaceMethod(
    String? imageLink,
    Widget? bannerText,
    Widget? bannerSubText,
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
          background: CachedNetworkImage(
            imageUrl: imageLink!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: imageProvider,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: AssetImage("assets/images/bg.png"),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: AssetImage("assets/images/default_bg.png"),
                ),
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
          color: _isAppBarExpanded ? Colors.white : Colors.white,
          elevation: _isAppBarExpanded ? 0.0 : 2.0,
          onTap: () => _isMenuIcon == widget.leadingAppBarFucntion
              ? Scaffold.of(context).openDrawer()
              : Navigator.of(context).pop(),
          child: widget.leadingAppBarIcon,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            child: _isAppBarExpanded ? widget.secondTitle : widget.firstTitle,
          ),
        ),
        SizedBox(width: 10.0),
        CustomIconTextButton(
          icon: widget.actionListTileIcon,
          onTap: widget.actionListTileOnTap,
          text: widget.actionListTileText,
        ),
      ],
    );
  }
}

Widget _flexibleSpaceWidget(Widget? bannerText, Widget? bannerSubText) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          text: '\nStart Learn >',
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
