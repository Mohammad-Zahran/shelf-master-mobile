import 'package:ar_flutter_plugin_engine/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_engine/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_engine/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_engine/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_engine/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_engine/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_engine/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_engine/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vectorMath64;

class ArViewFor3dObjects extends StatefulWidget {
  final String name;
  final String model3dURl;

  ArViewFor3dObjects({super.key, required this.name, required this.model3dURl});

  @override
  State<ArViewFor3dObjects> createState() => _ArViewFor3dObjectsState();
}

class _ArViewFor3dObjectsState extends State<ArViewFor3dObjects> {
  ARSessionManager? sessionManagerAR;
  ARObjectManager? objectManagerAR;
  ARAnchorManager? anchorManagerAR;
  List<ARNode> allNodesList = [];
  List<ARAnchor> allAnchors = [];

  void createARView(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager locationManagerAR)
  {
    sessionManagerAR = arSessionManager;
    objectManagerAR = arObjectManager;
    anchorManagerAR = arAnchorManager;

    sessionManagerAR!.onInitialize(
      handleRotation: true,
      handlePans: true,
      showWorldOrigin: true,
      showFeaturePoints: false,
      showPlanes: true,
    );
    objectManagerAR!.onInitialize();

    sessionManagerAR!.onPlaneOrPointTap = detectPlaneAndLetUserTap;
    objectManagerAR!.onPanStart = duringOnPanStarted;
    objectManagerAR!.onPanChange = duringOnPanChanged;
    objectManagerAR!.onPanEnd = duringOnPanEnded;
    objectManagerAR!.onRotationStart = duringOnRotationStarted;
    objectManagerAR!.onRotationChange = duringOnRotationChanged;
    objectManagerAR!.onRotationEnd = duringRotationEnded;
  }

  duringOnPanStarted(String object3dNodeName)
  {
    print("Panning Node Started = " + object3dNodeName);
  }

  duringOnPanChanged(String object3dNodeName)
  {
    print("Panning Node Started = " + object3dNodeName);
  }

  duringOnPanEnded(String object3dNodeName, Matrix4 transfromMatrix)
  {
    print("Panning Node Started = " + object3dNodeName);

    final pannedNode = allNodesList.firstWhere((node) => node.name == object3dNodeName);
  }

  duringOnRotationStarted(String object3dNodeName)
  {
    print("Panning Node Started = " + object3dNodeName);
  }

  duringOnRotationChanged(String object3dNodeName)
  {
    print("Panning Node Started = " + object3dNodeName);
  }

  duringRotationEnded(String object3dNodeName, Matrix4 transfromMatrix)
  {
    print("Panning Node Started = " + object3dNodeName);
    final pannedNode = allNodesList.firstWhere((node) => node.name == object3dNodeName);
  }

  Future<void> detectPlaneAndLetUserTap(List<ARHitTestResult> hitTapResultsList) async {
    try {
      var userHitTapResults = hitTapResultsList.firstWhere(
              (ARHitTestResult userHitPoint) => userHitPoint.type == ARHitTestResultType.plane);

      var planeARAnchor = ARPlaneAnchor(transformation: userHitTapResults.worldTransform);

      bool? anchorAdded = await anchorManagerAR!.addAnchor(planeARAnchor);

      if (anchorAdded!) {
        allAnchors.add(planeARAnchor);

        var object3DNewNode = ARNode(
          type: NodeType.webGLB,
          uri: widget.model3dURl,
          scale: vectorMath64.Vector3(0.62, 0.62, 0.62),
          position: vectorMath64.Vector3(0, 0, 0),
          rotation: vectorMath64.Vector4(1, 0, 0, 0),
        );

        bool? addARNodeToAnchor =
        await objectManagerAR!.addNode(object3DNewNode, planeAnchor: planeARAnchor);
        if (addARNodeToAnchor!) {
          allNodesList.add(object3DNewNode);
        } else {
          sessionManagerAR!.onError("Node to Anchor attachment Failed");
        }
      } else {
        sessionManagerAR!.onError("Failed: Anchor cannot be added");
      }
    } catch (e) {
      sessionManagerAR!.onError("No valid plane found on tap");
    }
  }

  Future<void> removeEvery3DObject() async
  {
    allAnchors.forEach((each3dObject)
    {
      anchorManagerAR!.removeAnchor(each3dObject);
    });

    allAnchors = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    sessionManagerAR!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name} 3D Model'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ARView(
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            onARViewCreated: createARView,
          ),
          
          Padding(
            padding: const EdgeInsets.all(17),
            child: Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: ()
                {
                  removeEvery3DObject();
                },
                color: Colors.white,
                height: 35,
                minWidth: 41,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17)
                ),
                child: const Icon(Icons.cleaning_services_rounded, color: Colors.black,),
                ), // Hex code for steel blue.),
              ),
            ),
        ],
      ),
    );
  }
}
