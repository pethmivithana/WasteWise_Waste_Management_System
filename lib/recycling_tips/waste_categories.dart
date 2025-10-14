import 'package:csse_waste_management/user_management/login_signup/screen/home.dart';
import 'package:flutter/material.dart';

class WasteCategoriesScreen extends StatefulWidget {
  const WasteCategoriesScreen({super.key});

  @override
  _WasteCategoriesScreenState createState() => _WasteCategoriesScreenState();
}

class _WasteCategoriesScreenState extends State<WasteCategoriesScreen> {
  String _identifiedWasteType = '';
  String _recyclingTip = '';
  String _scientificDescription = '';
  String _importance = '';
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> categories = [
    {'name': 'Plastic', 'image': 'assets/images/plastic.png'},
    {'name': 'Glass', 'image': 'assets/images/glass.jpeg'},
    {'name': 'Metal', 'image': 'assets/images/metal.jpg'},
    {'name': 'Paper', 'image': 'assets/images/paper.jpeg'},
    {'name': 'Electronics', 'image': 'assets/images/electronic.jpg'},
    {'name': 'Organic', 'image': 'assets/images/organic.jpg'},
    {'name': 'Textiles', 'image': 'assets/images/textile.jpeg'},
    {'name': 'Batteries', 'image': 'assets/images/batteries.jpg'},
    {'name': 'Hazardous Waste', 'image': 'assets/images/hazardous.jpeg'},
    {'name': 'Construction Waste', 'image': 'assets/images/construction.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Categories'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C04B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What do you need to recycle/dispose of?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Tips display section
              _identifiedWasteType.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waste Type: $_identifiedWasteType',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoBox(
                          title: 'Scientific Description',
                          content: _scientificDescription,
                          color: Colors.blue[100]!,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoBox(
                          title: 'Importance of Recycling',
                          content: _importance,
                          color: Colors.orange[100]!,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoBox(
                          title: 'Recycling Tips',
                          content: _recyclingTip,
                          color: Colors.green[100]!,
                        ),
                      ],
                    )
                  : const Text(
                      'Select a waste type from the categories below.'),
              const SizedBox(height: 32),
              const Text(
                'Categories:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _identifiedWasteType = categories[index]['name']!;
                        _scientificDescription = _generateScientificDescription(
                            _identifiedWasteType.toLowerCase());
                        _importance = _generateImportance(
                            _identifiedWasteType.toLowerCase());
                        _recyclingTip = _generateRecyclingTip(
                            _identifiedWasteType.toLowerCase());
                      });
                      // Scroll to the tips section
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              categories[index]['image']!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              categories[index]['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(
      {required String title, required String content, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Generate detailed tips for each category
  String _generateRecyclingTip(String wasteType) {
    switch (wasteType) {
      case 'plastic':
        return _plasticTips();
      case 'glass':
        return _glassTips();
      case 'metal':
        return _metalTips();
      case 'paper':
        return _paperTips();
      case 'electronics':
        return _electronicsTips();
      case 'organic':
        return _organicTips();
      case 'textiles':
        return _textileTips();
      case 'batteries':
        return _batteryTips();
      case 'hazardous waste':
        return _hazardousWasteTips();
      case 'construction waste':
        return _constructionWasteTips();
      default:
        return 'No recycling tips available for this waste type.';
    }
  }

  // Generate scientific descriptions for each waste type
  String _generateScientificDescription(String wasteType) {
    switch (wasteType) {
      case 'plastic':
        return 'Plastic is a synthetic material made from polymers, which are long chains of molecules. It is widely used due to its durability and versatility.';
      case 'glass':
        return 'Glass is a solid material made from silica, soda ash, and limestone. It is non-reactive, making it an ideal container material.';
      case 'metal':
        return 'Metal is a type of material that is typically hard, shiny, and malleable. Metals are used in various applications due to their strength and conductivity.';
      case 'paper':
        return 'Paper is a material produced by pressing together moist fibers, typically cellulose pulp derived from wood, rags, or grasses.';
      case 'electronics':
        return 'Electronics include devices powered by electricity, often containing various materials such as metals, plastics, and glass.';
      case 'organic':
        return 'Organic waste consists of biodegradable materials, typically derived from plant or animal sources, that can be composted.';
      case 'textiles':
        return 'Textiles are flexible materials made from fibers or fabrics, often used for clothing, upholstery, and various household items.';
      case 'batteries':
        return 'Batteries are devices that store chemical energy and convert it to electrical energy, often containing hazardous materials.';
      case 'hazardous waste':
        return 'Hazardous waste refers to waste materials that pose a potential threat to public health or the environment.';
      case 'construction waste':
        return 'Construction waste includes materials generated during the construction or demolition of buildings, such as concrete, wood, and metals.';
      default:
        return 'No scientific description available for this waste type.';
    }
  }

  // Generate importance of recycling for each waste type
  String _generateImportance(String wasteType) {
    switch (wasteType) {
      case 'plastic':
        return 'Recycling plastic reduces pollution, conserves natural resources, and saves energy compared to producing new plastic.';
      case 'glass':
        return 'Recycling glass saves energy and raw materials, reducing the environmental impact of glass production.';
      case 'metal':
        return 'Recycling metal conserves natural resources and reduces energy consumption while minimizing pollution.';
      case 'paper':
        return 'Recycling paper saves trees, conserves water, and reduces landfill waste.';
      case 'electronics':
        return 'Recycling electronics helps recover valuable materials and prevents toxic substances from harming the environment.';
      case 'organic':
        return 'Composting organic waste reduces landfill use, improves soil health, and supports sustainable agriculture.';
      case 'textiles':
        return 'Recycling textiles reduces landfill waste and conserves resources used in producing new fabrics.';
      case 'batteries':
        return 'Recycling batteries prevents hazardous materials from polluting the environment and allows for the recovery of valuable metals.';
      case 'hazardous waste':
        return 'Proper disposal of hazardous waste protects public health and the environment from potential risks.';
      case 'construction waste':
        return 'Recycling construction waste reduces landfill use, conserves resources, and minimizes environmental impact.';
      default:
        return 'No importance information available for this waste type.';
    }
  }

// Recycling tips for new waste types
  String _textileTips() {
    return '''
    ★ Donate gently used clothing to charities.
    ★ Recycle fabric scraps at designated drop-off points.
    ★ Avoid throwing away old textiles; reuse or upcycle if possible.
    ★ Check for local textile recycling programs.
    ★ Store textiles in a cool, dry place until ready for recycling.
    ''';
  }

  String _batteryTips() {
    return '''
    ★ Take batteries to designated recycling centers.
    ★ Avoid throwing batteries in the trash.
    ★ Store batteries in a cool, dry place until disposal.
    ★ Use battery recycling kits if available.
    ★ Check local regulations for battery disposal.
    ''';
  }

  String _hazardousWasteTips() {
    return '''
    ★ Identify hazardous materials before disposal.
    ★ Take hazardous waste to special collection sites.
    ★ Don’t mix hazardous waste with regular trash.
    ★ Follow local guidelines for disposal of chemicals.
    ★ Store hazardous waste in a secure place until disposal.
    ''';
  }

  String _constructionWasteTips() {
    return '''
    ★ Separate recyclable materials from regular waste.
    ★ Check for local construction waste recycling facilities.
    ★ Donate leftover materials to community projects.
    ★ Use reusable materials whenever possible.
    ★ Follow local regulations for disposing of construction debris.
    ''';
  }

  // Existing recycling tips methods
  String _plasticTips() {
    return '''
    ★ Rinse and clean plastic before recycling.
    ★ Remove labels if possible.
    ★ Crush bottles to save space.
    ★ Don’t recycle plastic bags curbside.
    ★ Avoid recycling black plastic.
    ★ Separate bottle caps from containers.
    ★ Check for recycling symbols.
    ★ Avoid recycling multi-layer plastics.
    ★ Reuse sturdy plastic containers.
    ★ Keep plastic dry and clean.
    ''';
  }

  String _glassTips() {
    return '''
    ★ Rinse and clean glass bottles and jars.
    ★ Remove caps and lids.
    ★ Avoid recycling broken glass.
    ★ Separate colored glass from clear glass.
    ★ Don’t recycle drinking glasses or window glass.
    ★ Check if your city accepts glass recycling.
    ★ Don’t recycle mirrors or light bulbs.
    ★ Reuse glass containers whenever possible.
    ★ Store glass in a safe, dry place.
    ★ Avoid mixing glass with other materials.
    ''';
  }

  String _metalTips() {
    return '''
    ★ Rinse and clean metal containers before recycling.
    ★ Remove labels if possible.
    ★ Flatten cans to save space.
    ★ Avoid recycling metal items not accepted in curbside recycling.
    ★ Check for local metal recycling programs.
    ★ Don’t recycle aluminum foil or greasy metal.
    ★ Keep metals dry and clean.
    ★ Remove non-metal components from metal items.
    ★ Store metals in a safe, dry place until recycling.
    ★ Donate metal items in good condition.
    ''';
  }

  String _paperTips() {
    return '''
    ★ Keep paper clean and dry before recycling.
    ★ Remove plastic windows from envelopes.
    ★ Don’t recycle greasy or food-soiled paper.
    ★ Flatten cardboard boxes to save space.
    ★ Check local paper recycling guidelines.
    ★ Reuse paper for notes or crafts.
    ★ Avoid mixing paper types in recycling bins.
    ★ Remove staples and paper clips if required.
    ★ Store paper in a dry place until recycling.
    ★ Shred sensitive documents before recycling.
    ''';
  }

  String _electronicsTips() {
    return '''
    ★ Find a certified e-waste recycling facility.
    ★ Remove personal data from devices before recycling.
    ★ Don’t throw electronics in the trash.
    ★ Check for manufacturer take-back programs.
    ★ Store electronics in a safe place until disposal.
    ★ Reuse or donate working devices if possible.
    ★ Follow local regulations for e-waste disposal.
    ★ Remove batteries from electronics where possible.
    ★ Recycle accessories like chargers and cables.
    ★ Keep electronics away from moisture before recycling.
    ''';
  }

  String _organicTips() {
    return '''
    ★ Compost kitchen scraps like fruit and vegetable peels.
    ★ Use biodegradable bags for composting.
    ★ Avoid composting meat and dairy.
    ★ Check for local composting programs.
    ★ Keep organic waste in a sealed container to reduce odor.
    ★ Use yard waste for composting.
    ★ Maintain a balanced compost mix of green and brown materials.
    ★ Turn compost regularly for aeration.
    ★ Keep compost in a dry, shaded area.
    ★ Use compost for garden soil enrichment.
    ''';
  }
}
