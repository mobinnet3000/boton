final List<Map<String, String>> projects = List.generate(
  10,
  (index) => {
    'projectNumber': 'پروژه شماره ${index + 1}',
    'employer': 'کارفرما ${index + 1}',
    'address': 'خیابان مثال، کوچه ${index + 2}',
  },
);
