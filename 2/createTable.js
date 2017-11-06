function createTable() {
  var table = document.createElement("table");
  table.style.border = '1px solid black';

  var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
  console.log(letters)

  for(var i = 0; i < 21; i++) {
    var tr = table.insertRow(i);
    for(var j = 0; j < 27; j++) {
      var td = tr.insertCell(j);
      td.style.border = '1px solid gray';
      td.height = 20;
      td.width = 100;

      if(j == 0 && i != 0) {
        td.innerHTML = "<b>" + i + "</b>";
        td.width = 40;
        continue;
      }

      if(i == 0 && j != 0) {
        td.innerHTML = "<b>" + letters[j - 1] + "</b>";
        td.width = 100;
        continue;
      }

      td.setAttribute("contenteditable", "true");
    }
  }

  document.body.appendChild(table);
}
