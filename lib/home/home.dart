import 'package:flutter/material.dart';

class ProjectListPage extends StatelessWidget {
  final List<Map<String, String>> projects = List.generate(
    10,
    (index) => {
      'projectNumber': 'پروژه شماره ${index + 1}',
      'employer': 'کارفرما ${index + 1}',
      'address': 'خیابان مثال، کوچه ${index + 2}',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, size: 40),
        isExtended: true,
        backgroundColor: Color(0xffDDA853),
        focusColor: Color.fromARGB(255, 233, 151, 18),
        hoverColor: Color.fromARGB(255, 233, 151, 18),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SearchBar(
                  backgroundColor: WidgetStateProperty.all(Color(0xffDDA853)),
                  hintText: "جستوجو",
                  leading: Icon(Icons.search),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xff183B4E),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(60, 0, 0, 0),
                              blurRadius: 8,
                              offset: Offset(4, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // بخش متنی
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project['projectNumber']!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xffDDA853),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'کارفرما: ${project['employer']}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        192,
                                        192,
                                        192,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'آدرس: ${project['address']}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        185,
                                        184,
                                        184,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // فلش
                            Icon(
                              Icons.arrow_forward_ios,
                              color: const Color.fromARGB(255, 200, 189, 255),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
