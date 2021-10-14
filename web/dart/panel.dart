import 'dart:html';

void showpanel(String identifier) {
  querySelector('.greyout')?.style.display = 'flex';
  querySelector(identifier)?.style.display = 'flex';
}

void hidepanel(String identifier) {
  querySelector(identifier)?.style.display = 'none';
  querySelector('.greyout')?.style.display = 'none';
}

void error(String message) async {
  querySelector('#error')
    ?..style.display = 'flex'
    ..text = message;
  await Future.delayed(Duration(seconds: 5));
  querySelector('#error')?.style.display = 'none';
}
