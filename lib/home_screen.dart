import 'package:flutter/material.dart';
import 'package:shelf_master_mobile/arview_for_3d.dart';
import 'model3d_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final Model3DApi _model3DApi = Model3DApi();
  List<Map<String, dynamic>> models3dList = [];
  List<Map<String, dynamic>> paginatedModels = [];
  bool isLoading = true;
  String searchQuery = "";
  int currentPage = 1;
  final int itemsPerPage = 6;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchModels();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  Future<void> fetchModels() async {
    try {
      final models = await _model3DApi.fetch3DModels();
      setState(() {
        models3dList = models;
        updatePagination(); // Set the first page
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load 3D models: $e")),
      );
    }
  }

  void updatePagination() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    paginatedModels = models3dList.sublist(
      startIndex,
      endIndex > models3dList.length ? models3dList.length : endIndex,
    );
  }

  void filterModels(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1; // Reset to first page on search
      if (query.isEmpty) {
        updatePagination();
      } else {
        models3dList = models3dList
            .where((model) =>
            (model["name"] ?? "").toLowerCase().contains(query.toLowerCase()))
            .toList();
        updatePagination();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "AR Shopping",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Color(0xFF4682B4),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF4682B4)),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4682B4),
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: filterModels,
                decoration: InputDecoration(
                  hintText: "Search 3D models...",
                  prefixIcon:
                  const Icon(Icons.search, color: Color(0xFF4682B4)),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: paginatedModels.length,
                  itemBuilder: (context, index) {
                    final each3dItem = paginatedModels[index];
                    final animation = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (1 / paginatedModels.length) * index,
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ),
                    );

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: GestureDetector(
                          onTap: () {
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
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      each3dItem["photo"] ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Text(
                                    each3dItem["name"] ?? "3D Model",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4682B4),
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (models3dList.length / itemsPerPage).ceil(),
                    (index) {
                  final page = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = page;
                        updatePagination();
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) => setState(() {}),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: currentPage == page
                              ? const Color(0xFF4682B4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF4682B4)),
                        ),
                        child: Text(
                          "$page",
                          style: TextStyle(
                            color: currentPage == page
                                ? Colors.white
                                : const Color(0xFF4682B4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
