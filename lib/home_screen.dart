import 'package:flutter/material.dart';
import 'package:shelf_master_mobile/arview_for_3d.dart';
import 'model3d_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
// Push to Copy of main branch
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Model3DApi _model3DApi = Model3DApi();
  List<Map<String, dynamic>> models3dList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchModels();
  }

  Future<void> fetchModels() async {
    try {
      final models = await _model3DApi.fetch3DModels();
      setState(() {
        models3dList = models;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load 3D models: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AR Based Shopping App",
          style: TextStyle(
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : models3dList.isEmpty
            ? const Center(child: Text("No models available."))
            : Container(
          padding: const EdgeInsets.all(21),
          child: Column(
            children: [
              const SizedBox(height: 19),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 9,
                  children: models3dList.map((each3dItem) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to AR view when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArViewFor3dObjects(
                              name: each3dItem["name"] ?? "3D Model",
                              model3dURl: each3dItem["model3D"] ?? "",
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            image: DecorationImage(
                              image: NetworkImage(
                                each3dItem["photo"] ?? "",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
