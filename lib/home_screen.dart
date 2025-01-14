import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> models3dList = [
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/arm_chair__furniture.glb?t=2025-01-07T16%3A46%3A58.894Z",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Arm%20chair.png",
      "name": "Arm Chair",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/blossom_sofa_by_modenese.glb?t=2025-01-07T16%3A49%3A16.615Z",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Blossom%20sofa.png",
      "name": "Blossom Sofa",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/living_room_sofa__furniture.glb",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Living%20room%20sofa.png",
      "name": "Living room sofa",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/modern_wooden_wardrobe.glb?t=2025-01-07T16%3A50%3A18.709Z",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Modern%20Wooden%20Wardrobe.png",
      "name": "Modern Wooden Wardrobe",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/realistic_bed_3d_model.glb?t=2025-01-07T16%3A52%3A18.911Z",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Realistic%20Bed%20.png",
      "name": "Realistic Bed",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/round_table_furniture_model.glb?t=2025-01-07T16%3A52%3A29.981Z",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Round%20Table%20Furniture%20Model.png",
      "name": "Round Table Furniture Model",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/table___school_office_-_7_mb.glb",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Table%20School%20office%20.png",
      "name": "Table School office",
    },
    {
      "model3dURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Models3d/bookcase.glb",
      "photoURL": "https://hfutuspzcdfsimnfaouj.supabase.co/storage/v1/object/public/Images/Bookcase.png",
      "name": "Bookcase",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to Shelf Master Mobile",
          style: TextStyle(
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(21),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 253,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    image: const DecorationImage(
                      image: NetworkImage("https://img.freepik.com/premium-photo/interior-furniture-store-with-variety-options-display_997534-26490.jpg"),
                      fit: BoxFit.cover,
                    )
                ),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      "New Year's Sale",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
