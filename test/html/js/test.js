var context = new Excel.Context();

//option-1
var selection = context.workbook.worksheets.getItem('sheet1').range('A1:B2').getReferencedObject();

//option-2
var selection = context.workbook.worksheets.getItem('sheet1').getRange('A1:B2', true);
var binding = selection.createBinding();

context.executeAsync()
      .then(function () {
          selection.font.color = "red"; //for option-1
          binding.range.font.color = "red"; //for option-2
      })
      .fail(function (error) {
          console.error(error.toString());
      }

      



var context = new Excel.Context();

var selection = context.workbook.worksheets.getItem('sheet1').getRange('A1:B2');
var binding = selection.createBinding();

context.executeAsync()
    .then(function () {
        binding.range.font.color = "red"; 
    })
    .fail(function (error) {
        console.error(error.toString());
    }


