import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColumnGapPage extends StatefulWidget {
  const ColumnGapPage({Key? key}) : super(key: key);

  @override
  State<ColumnGapPage> createState() => _ColumnGapPageState();
}

class _ColumnGapPageState extends State<ColumnGapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(title: const Text("Column缝隙")),
      body: Column(
        children: [
          _buildContainer(),
          _buildContainer(),
          _buildContainer(),
          _buildContainer(),
          _buildContainer(),
          _buildContainer(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    Widget resultWidget = Container(
      width: double.infinity,
      height: 50,
      color: Colors.white,
    );
    // resultWidget = FitContainer(child: resultWidget);
    return resultWidget;
  }
}

class FitContainer extends SingleChildRenderObjectWidget {
  const FitContainer({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FitContainerRenderObject();
  }
}

class _FitContainerRenderObject extends RenderProxyBox {
  @override
  Size get size {
    final _size = super.size;
    return Size(_size.width, _size.height.floorToDouble());
  }
}
