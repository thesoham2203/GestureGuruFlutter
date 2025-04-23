import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
late List<CameraDescription> cameras;
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameracontroller;
  late Future<void> cameravalue;
  @override
  void initState(){
    super.initState();
    cameracontroller = CameraController(cameras[0], ResolutionPreset.max);
    cameravalue = cameracontroller.initialize();
  }
  @override
  void dispose(){
    super.dispose();
    cameracontroller.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(future: cameravalue, builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return SizedBox(
                  height:MediaQuery.of(context).size.height,
                  child: CameraPreview(cameracontroller)
              );
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          })
        ],
      ),
    );
  }
}
