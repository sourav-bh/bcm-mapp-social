import 'package:app/api/api_manager.dart';
import 'package:app/main.dart';
import 'package:app/util/app_style.dart';
import 'package:app/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SearchTweetPage extends StatefulWidget {
  const SearchTweetPage({Key? key}) : super(key: key);

  @override
  State<SearchTweetPage> createState() => _SearchTweetPageState();
}

class _SearchTweetPageState extends State<SearchTweetPage> {
  var _selectedLanguage = 'Englisch';
  final _languageValues = ['Englisch', 'Deutsche'];

  final _formKey = GlobalKey<FormState>();
  final _startDateText = TextEditingController();
  final _endDateText = TextEditingController();
  final _queryText = TextEditingController();

  var viewOnlyDateFormat = DateFormat('dd-MM-yyyy');
  var serverDateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var _selectedStartDate = DateTime.now();
  var _selectedEndDate = DateTime.now();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _searchAction(BuildContext context) {
    String query = _queryText.value.text;

    if ((_formKey.currentState?.validate() ?? false) && query.isNotEmpty) {
      setState(() => _isLoading = true);
      var r = RegExp(r'\(((\w+ ?)*)\)?').allMatches(query).expand((e) => [e[1]]);
      List<String?> queries = [];
      queries.addAll(r);
      ApiManager().searchTweets(queries, serverDateFormat.format(_selectedStartDate), serverDateFormat.format(_selectedEndDate), _selectedLanguage).then((data) {
        setState(() => _isLoading = false);
        Navigator.pushNamed(context, tweetDetailsRoute, arguments: data);
      }, onError: (e) {
        setState(() => _isLoading = false);
        CommonUtil.showAlertDialog(context, 'Fehler', 'Kein Ergebnis');
      });
    } else {
      Fluttertoast.showToast(msg: 'Invalid input! Query or dates are missing');
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showRoundedDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100),
        borderRadius: 10,
        theme: ThemeData(primarySwatch: Colors.blue));
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        _startDateText.value = TextEditingValue(text: viewOnlyDateFormat.format(picked));
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showRoundedDatePicker(
        context: context,
        initialDate: _selectedEndDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100),
        borderRadius: 10,
        theme: ThemeData(primarySwatch: Colors.blue));
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        _endDateText.value = TextEditingValue(text: viewOnlyDateFormat.format(picked));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == false ? Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text('Bitte geben Sie Stichworte in der gewählten Sprache ein Twitter Suche',
                      style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    children: [
                      Text('Sprache', style: Theme.of(context).textTheme.subtitle2,),
                      const SizedBox(width: 30,),
                      Expanded(child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                            isEmpty: false,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text('Sprache'),
                                value: _selectedLanguage,
                                isDense: true,
                                onChanged: (String? newValue) {
                                  _selectedLanguage = newValue ?? '';
                                  state.didChange(newValue);
                                },
                                disabledHint: Text(_selectedLanguage, style: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),),
                                items: _languageValues.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),)
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: TextFormField(
                    controller: _queryText,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,),
                      labelText: 'Stichworte',
                      labelStyle: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),
                      hintText: '(Stichwort 1)(Stichwort 2)......',
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black26, width: 1.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black26, width: 1.0)),
                    ),
                    textAlign: TextAlign.left,
                    cursorColor: Colors.black54,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () => _selectStartDate(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Select start date!';
                                      }
                                      return null;
                                    },
                                    controller: _startDateText,
                                    keyboardType: TextInputType.datetime,
                                    style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'Beginn',
                                      hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),
                                      labelStyle: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),
                                      errorStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                      prefixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: AppColor.Primary,
                                        //color: _icon,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () => _selectEndDate(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) {
                                        return 'Select end date!';
                                      }
                                      return null;
                                    },
                                    controller: _endDateText,
                                    style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      hintText: 'Ende',
                                      hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),
                                      labelStyle: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColor.Primary),
                                      errorStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                      prefixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: AppColor.Primary,
                                        //color: _icon,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: SizedBox(
                    width: 200,
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => AppColor.Primary,),
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                        onPressed: () {
                          _searchAction(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Suchanfrage erstellen',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ) : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}