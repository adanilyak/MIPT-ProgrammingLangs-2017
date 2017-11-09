function createTable() {
  var table = document.createElement("table");
  table.style.border = '1px solid black';

  var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');

  for(var i = 0; i < 21; i++) {
    var tr = table.insertRow(i);
    for(var j = 0; j < 27; j++) {
      var td = tr.insertCell(j);
      td.style.border = '1px solid gray';
      td.style.height = 20;
      td.style.width = 100;

      if(j == 0 && i != 0) {
        td.innerHTML = "<b>" + i + "</b>";
        td.width = 40;
        continue;
      }

      if(i == 0 && j != 0) {
        td.innerHTML = "<b>" + letters[j - 1] + "</b>";
        td.style.width = 100;
        continue;
      }

      td.setAttribute("contenteditable", "true");
      td.addEventListener('keypress', onKey);
      td.id = letters[j - 1] + i;
    }
  }

  document.body.appendChild(table);
}

function len(param) {
  return param.length
}

function onKey(e) {
  var key = e.which || e.keyCode;
  if (key === 13) { // 13 is enter
    e.preventDefault();
    var td = e.path[0];
    if (td.innerText.charAt(0) === '=') {
      td.innerText = td.innerText.substr(1);
      td.innerText = calculate(td.innerText);
    }
  }
}

function calculate(text) {
  var input = text;
  var regexp = /[A-Z][0-9]+/g;
  var result = input.match(regexp);

  if(result == null) {
    input = replaceFunctions(input);
    return safeEval(input);
  } else {
    for(var i = 0; i < result.length; i++) {
      var td = document.getElementById(result[i]);
      var calculated = calculate(td.innerText);
      input = input.replace(result[i], calculated);
    }
    input = replaceFunctions(input);
    return safeEval(input);
  }

}

function replaceFunctions(text) {
  var input = text;
  input = input.replace(/ABS/g, 'Math.abs');
  input = input.replace(/SIN/g, 'Math.sin');
  input = input.replace(/LEN/g, 'String.len');
  return input;
}

function safeEval(text) {
  try {
    var result = eval(text);
    return result;
  } catch(error) {
    return text;
  }
}

String.len = function(str) {
  return String(str).length;
};
