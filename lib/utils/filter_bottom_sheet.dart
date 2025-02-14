import 'package:flutter/material.dart';

// THIS IS THE FILTER WIDGET THAT WILL BE SHOWN IN THE MODAL BOTTOM SHEET
class FilterBottomSheet extends StatefulWidget {
  final Function(String?, String?) onFiltering;
  const FilterBottomSheet({super.key, required this.onFiltering});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedContinent;
  String? selectedLanguage;
  bool isContinentExpanded = false;
  bool isLanguageExpanded = false;
  // THIS IS THE LIST OF CONTINENTS AND LANGUAGES TO BE SHOWN IN THE FILTERS
  List<String> languages = [
    "English",
    "French",
    "Spanish",
    "German",
    "Chinese",
    "Portuguese",
    "Italian",
  ];
  List<String> continents = [
    "Asia",
    "Europe",
    "North America",
    "South America",
    "Africa",
    "Oceania",
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            showDragHandle: true,
            enableDrag: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.4,
                  maxChildSize: 1,
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      shape: CircleBorder()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Continents',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isContinentExpanded =
                                          !isContinentExpanded;
                                    });
                                    print('pressed on continents');
                                  },
                                  icon: Icon(
                                    isContinentExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ),
                              ],
                            ),
                            // THIS IS THE FILTER FOR CONTINENTS
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: isContinentExpanded
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: continents.map((continent) {
                                        return ListTile(
                                          leading: Text(
                                            continent,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: Radio(
                                              value: continent,
                                              groupValue: selectedContinent,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedContinent = value;
                                                });
                                              }),
                                        );
                                      }).toList(),
                                    )
                                  : SizedBox.shrink(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Languages',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isLanguageExpanded = !isLanguageExpanded;
                                    });
                                  },
                                  icon: Icon(
                                    isLanguageExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ),
                              ],
                            ),
                            // THIS IS THE FILTER FOR LANGUAGES
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: isLanguageExpanded
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: languages.map((language) {
                                        return ListTile(
                                          title: Text(
                                            language,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: Radio(
                                              value: language,
                                              groupValue: selectedLanguage,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedLanguage = value;
                                                });
                                              }),
                                        );
                                      }).toList(),
                                    )
                                  : SizedBox.shrink(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    foregroundColor:
                                        Theme.of(context).focusColor,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context).focusColor),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedContinent = null;
                                      selectedLanguage = null;
                                    });
                                  },
                                  child: Text('Reset'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Theme.of(context).hintColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  onPressed: () {
                                    // ACCEPTING THE FILTERED DATA
                                    widget.onFiltering(
                                        selectedContinent, selectedLanguage);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Show Result'),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
            });
      },
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: BorderSide(
            color: Theme.of(context).focusColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.filter_alt_outlined),
              SizedBox(width: 4),
              Text('Filter'),
            ],
          ),
        ),
      ),
    );
  }
}
