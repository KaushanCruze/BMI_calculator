import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  String name;
  String address;
  String gender;
  DateTime dateOfBirth;
  double weight;
  double height;
  User({
    required this.name,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
  });

  int calculateAge() {
    DateTime now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  double calculateBMI() {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String getWeightComment(double threshold) {
    double bmi = calculateBMI();
    if (bmi < threshold) {
      return "Underweight";
    } else if (bmi >= threshold && bmi < 25) {
      return "Normal weight";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  String getHeightComment() {
    if (height < 150) {
      return "Short";
    } else if (height >= 150 && height < 170) {
      return "Average";
    } else {
      return "Tall";
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI CALCULATOR',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(152, 33, 243, 1),
      ),
      home: UserInfoScreen(),
    );
  }
}

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'Male';
  DateTime? _selectedDate;
  double? _weight;
  double? _height;

  Widget displaywidget = Container();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form fields

      User user = User(
        name: _nameController.text,
        address: _addressController.text,
        gender: _gender,
        dateOfBirth: _selectedDate!,
        weight: _weight!,
        height: _height!,
      );
      //Display Information
      setState(() {
        displaywidget = Center(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NAME ~~~~~~~~~ : ${user.name}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('ADDRESS ~~~~~~  : ${user.address}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('GENDER ~~~~~~~  : ${user.gender}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('DATE OF BIRTH ~~  : ${user.dateOfBirth.toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('AGE ~~~~~~~~~~  : ${user.calculateAge()}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('WEIGHT ~~~~~~~   : ${user.weight.toStringAsFixed(2)} kg',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('HEIGHT ~~~~~~~~ : ${user.height.toStringAsFixed(2)} cm',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(''),
                Text(
                    'BMI                              : ${user.calculateBMI().toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Weight Comment      : ${user.getWeightComment(25)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Height Comment       : ${user.getHeightComment()}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI CALCULATOR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 120.0,
        backgroundColor: Color.fromARGB(
            255, 74, 3, 61), // Set the background color to purple
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('GENDER               ', style: TextStyle(fontSize: 16)),
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 16.0),
              Text('DATE OF BIRTH', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : _selectedDate.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(150, 16, 150, 1),
                    minimumSize: const Size(300.0, 50.0),
                    elevation: 2,
                    padding:
                        EdgeInsets.all(16.0), // Adjust the padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'WEIGHT (in kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your weight';
                  }
                  double? weight = double.tryParse(value);
                  if (weight == null || weight < 1 || weight > 150) {
                    return 'Please enter a valid weight (between 1 and 150)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'HEIGHT (in cm)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your height';
                  }
                  double? height = double.tryParse(value);
                  if (height == null || height < 50 || height > 250) {
                    return 'Please enter a valid height (between 50 and 250)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _height = double.parse(value!);
                },
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Calculate BMI',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(129, 22, 141, 1),
                    padding: EdgeInsets.all(16.0),
                    minimumSize: const Size(10.0, 60.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed: _submitForm,
                ),
              ),
              SizedBox(height: 16.0),
              displaywidget,
            ],
          ),
        ),
      ),
    );
  }
}
