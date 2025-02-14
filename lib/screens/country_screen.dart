import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// THIS SCREEN DISPLAYS THE STATISTICS OF THE SELECTED COUNTRY FROM THE HOME SCREEN
class CountryScreen extends StatefulWidget {
  final Map<String, dynamic> countryStats;
  const CountryScreen({super.key, required this.countryStats});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  List<String> imageUrls = [];
  bool isLoading = true;
  int currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    if (widget.countryStats['flag'] != null &&
        widget.countryStats['coatOfArms'] != null) {
      imageUrls = [
        widget.countryStats['flag'],
        widget.countryStats['coatOfArms']
      ];
    } else {
      imageUrls = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          widget.countryStats['name'],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // THE IMAGE SLIDER WITH FLAG AND COAT OF ARMS
                  CarouselSlider(
                    carouselController: _carouselController,
                    items: imageUrls.map((url) {
                      return Container(
                        width: size.width * 0.8,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                        height: 250,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        autoPlayInterval: Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }),
                  ),
                  Positioned(
                    left: 7,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      // padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          _carouselController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          print("pressed");
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 7,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          _carouselController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentIndex,
                        count: imageUrls.length,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey,
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STATISTICS SECTIONS
                  
                  // First Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText(
                          'Population: ', widget.countryStats['population']),
                      SizedBox(height: 12),
                      _buildRichText(
                          'Continent: ', widget.countryStats['continent']),
                      SizedBox(height: 12),
                      _buildRichText(
                          'Capital: ', widget.countryStats['capital']),
                    ],
                  ),
                  SizedBox(height: 20), // Space between sections

                  // Second Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText(
                          'Language: ', widget.countryStats['language']),
                      SizedBox(height: 12),
                      _buildRichText(
                          'Area: ', '${widget.countryStats['area']} km²'),
                      SizedBox(height: 12),
                      _buildRichText(
                          'Driving Side: ', widget.countryStats['drivingSide']),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Third Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText(
                          'Time Zone: ', widget.countryStats['timeZone'] ?? ''),
                      SizedBox(height: 12),
                      _buildRichText(
                          'Dialing Code: ', widget.countryStats['dialingCode']),
                      SizedBox(height: 12),
                      _buildRichText(
                          'Currency: ', widget.countryStats['currency']),
                    ],
                  ),
                ],
              )

// Helper Function for RichText
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextSpan(
            text: ' $value',
            style: TextStyle(fontSize: 16)
          ),
        ],
      ),
    );
  }
}
