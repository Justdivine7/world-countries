import 'package:country_stats_app/screens/country_screen.dart';
import 'package:country_stats_app/theme/theme_provider.dart';
import 'package:country_stats_app/utils/filter_bottom_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Dio dio = Dio();
  Map<String, List<Map<String, String>>> countries = {};
  Map<String, List<Map<String, String>>> filteredCountries = {};
  String? selectedLanguage;
  String? selectedContinent;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
 
  Future<void> fetchCountries() async {
    try {
      Response response = await dio.get("https://restcountries.com/v3.1/all");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        _groupCountries(data);
        print('Countries fetched successfully');
      }
    } catch (error) {
      print("Error fetching data:$error");
    }
  }
  // LOGIC TO GROUP COUNTRIES BY ALPHABETICAL ORDER

  void _groupCountries(List<dynamic> countryStats) {
    Map<String, List<Map<String, String>>> alphabetCountries = {};
    for (var country in countryStats) {
      String name = country['name']['common'];
      String flagUrl = country['flags']['png'];
      String capital =
          (country['capital'] != null && country['capital'].isNotEmpty)
              ? country['capital'][0]
              : 'No Capital';
      String continent =
          (country['continents'] != null && country['continents'].isNotEmpty)
              ? country['continents'][0]
              : 'Unknown';
      String language = country['languages']?.values.first ?? 'Unknown';
      String timeZone =
          (country['timezones'] != null && country['timezones'].isNotEmpty)
              ? country['timezones'][0]
              : 'Unknown';
      String population = country['population']?.toString() ?? 'Unknown';
      String area = country['area']?.toString() ?? 'Unknown';
      String currency = country['currencies']?.keys.first ?? 'Unknown';
      String dialingCode = (country['idd']?['root'] ?? '') +
          ((country['idd']?['suffixes'] != null &&
                  country['idd']?['suffixes'].isNotEmpty)
              ? country['idd']['suffixes'][0]
              : '');
      String coatOfArms = country['coatOfArms']['png'] ?? 'No Coat of Arms';
      String drivingSide = country['car']?['side'] ?? 'Unknown';

      String firstLetter = name[0].toUpperCase();
      if (!alphabetCountries.containsKey(firstLetter)) {
        alphabetCountries[firstLetter] = [];
      }
      alphabetCountries[firstLetter]!.add({
        'name': name,
        "capital": capital,
        'flag': flagUrl,
        'continent': continent,
        'language': language,
        'timezone': timeZone,
        'population': population,
        'area': area,
        'drivingSide': drivingSide,
        "currency": currency,
        'dialingCode': dialingCode,
        'coatOfArms': coatOfArms,
      });
    }
    alphabetCountries.forEach((key, value) {
      value.sort((a, b) => a['name']!.compareTo(b['name']!));
    });
    setState(() {
      countries = Map.fromEntries(alphabetCountries.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)));
      filteredCountries = countries;
      isLoading = false;
    });
  }

  // LOGIC TO SEARCH COUNTRIES

  void _searchCountries(String query) {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredCountries = countries;
      });
      return;
    }
    Map<String, List<Map<String, String>>> tempFiltered = {};
    countries.forEach((letter, countryList) {
      List<Map<String, String>> filteredList = countryList.where((country) {
        String countryName = country['name']!.toLowerCase();
        String capital = country['capital']!.toLowerCase();
        return countryName.contains(query) || capital.contains(query);
      }).toList();
      if (filteredList.isNotEmpty) {
        tempFiltered[letter] = filteredList;
      }
    });
    setState(() {
      filteredCountries = tempFiltered;
    });
  }

// LOGIC TO APPLY FILTERS
  void applyFilter(String? continent, String? language) {
    Map<String, List<Map<String, String>>> tempApplyFiltered = {};
    countries.forEach((letter, countryList) {
      List<Map<String, String>> filteredList = countryList.where((country) {
        bool matchContinent =
            continent == null || country['continent'] == continent;
        bool matchLanguage =
            language == null || country['language'] == language;
        return matchContinent && matchLanguage;
      }).toList();
      if (filteredList.isNotEmpty) {
        tempApplyFiltered[letter] = filteredList;
      }
    });
    setState(() {
      filteredCountries = tempApplyFiltered;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCountries();
 
     
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: themeProvider.isDarkMode
                  ? Image.asset(
                      'asset/images/logo.png',
                      width: 90,
                      height: 50,
                    )
                  : Image.asset(
                      'asset/images/ex_logo.png',
                      width: 90,
                      height: 50,
                    ),
            ),
            IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(themeProvider.isDarkMode
                    ? Icons.nightlight_outlined
                    : Icons.wb_sunny_outlined),
              ),
            ),
          ],
        ),
      ),
      body:isLoading? _buildShimmerEffect()  :Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) => _searchCountries(value),
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).cardColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                hintText: 'Search Country',
                hintStyle: TextStyle(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterBottomSheet(
                  onFiltering: applyFilter,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  String letter = filteredCountries.keys.elementAt(index);
                  List<Map<String, dynamic>> country =
                      filteredCountries[letter]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...country.map(
                        (country) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryScreen(
                                  countryStats: country,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image: DecorationImage(
                                  image: NetworkImage(country["flag"]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(country['name']!),
                            subtitle: Text(country['capital']!),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

  }

  // LOADER FOR SHIMMER EFFECT
  Widget _buildShimmerEffect() {
  return ListView.builder(
    itemCount: 10,  
    itemBuilder: (context, index) {
      return ListTile(
        leading: Shimmer.fromColors(
         baseColor: Theme.of(context).canvasColor,
          highlightColor:  Theme.of(context).highlightColor,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Theme.of(context).canvasColor,
          highlightColor:  Theme.of(context).highlightColor,
          child: Container(
            height: 10,
            width: 70,
            color: Colors.white,
          ),
        ),
        subtitle: Shimmer.fromColors(
          baseColor: Theme.of(context).canvasColor,
          highlightColor:  Theme.of(context).highlightColor,
          child: Container(
            height: 10,
            width: 70,
            color: Colors.white,
          ),
        ),
      );
    },
  );
}
}
