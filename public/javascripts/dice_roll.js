$('#wrapDiceButton').live('click', function() {
  var textBox = $('#roll_query');
  if (textBox.caret().text.length > 0) {
    //If text is selected, wrap it in []
    var startToken = textBox.caret().start;
    var endToken = textBox.caret().end;
    var initialText = textBox.caret().text;
    var strLength = textBox.attr('value').length;


    var begin = textBox.caret({start:0, end: startToken});
    begin = textBox.caret().text;

    var end = textBox.caret({start:endToken, end: strLength });
    end = textBox.caret().text;

    textBox.attr('value', begin + "[" + initialText + "]" + end);
    textBox.caret({start:startToken+1, end:endToken+1});

  } else {
    //Otherwise insert [1d4] and select 1d4
    var startToken = textBox.caret().start;
    var endToken = textBox.caret().end;
    var initialText = "1d4";
    var strLength = textBox.attr('value').length;


    var begin = textBox.caret({start:0, end: startToken});
    begin = textBox.caret().text;

    var end = textBox.caret({start:endToken, end: strLength });
    end = textBox.caret().text;

    textBox.attr('value', begin + "[" + initialText + "]" + end);

    textBox.caret({start:startToken+1, end:endToken + initialText.length + 1});
  }
});