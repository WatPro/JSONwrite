
// Javascript

var url = ScriptApp.getService().getUrl(); 

function onOpen() {
    SpreadsheetApp.getUi()
        .createMenu('MongoDB')
        .addItem('Export', 'Links')
        .addToUi();
}
 
function Links() {
    var html = HtmlService
        .createTemplateFromFile('index').evaluate()
        .setWidth(200)
        .setHeight(80);
    SpreadsheetApp.getUi() 
        .showModalDialog(html, 'Click the links below ');
}

function doGet(e) {
    try{
        if ( e.parameter.hasOwnProperty("id") && e.parameter.hasOwnProperty("sheetname") ) {
            var ss = SpreadsheetApp.openById(e.parameter.id); 
            var sheet = ss.getSheetByName(e.parameter.sheetname);
        } else {
            var ss = SpreadsheetApp.getActiveSpreadsheet();
            var id = ss.getId();
            var sheet = ss.getActiveSheet();
        }
        var jsontext = sheet2jsontext(sheet); 
        var sheetname = sheet.getName(); 
    } catch (err) {
        var json = {"__export_time":Date()};
        json.error = err.message; 
        var jsontext = JSON.stringify(json);
        var sheetname = "error"
    }
    var output = ContentService.
        createTextOutput(jsontext).
        setMimeType(ContentService.MimeType.TEXT); 
    if( e.parameter.hasOwnProperty("download") ) {
        return output.downloadAsFile(sheetname+".json"); 
    } else {
        return output; 
    }
}

function sheet2jsontext(sheet) {
    var sheetname = sheet.getSheetName()
    if( sheet.getFrozenRows()!=1 ) {
        var json = {"__sheet_name":sheetname, "__export_time":Date()}; 
        json.error = 'Please set column names by freezing the first row only. '; 
        return JSON.stringify(json); 
    }
    var lastColumn = sheet.getLastColumn(); 
    if( lastColumn<1 ){
        var json = {"__sheet_name":sheetname, "__export_time":Date()}; 
        json.error = 'No data found. ';
        return JSON.stringify(json);
    }
    var firstrow = sheet.getRange(1, 1, 1, lastColumn).getValues();
    var validColName = /^[\w.]+$/
    var validCols = {}
    for( col=1; col<=lastColumn; col+=1 ) { 
        if( ! validColName.test(firstrow[0][col-1]) ) { continue; }
        validCols["C"+("000" + col).slice(-4)] = {"index":(col-1), "name":firstrow[0][col-1]};
    } 
    var lastRow = sheet.getLastRow(); 
    if( lastRow<=1 ) { 
        var json = {"__sheet_name":sheetname, "__export_time":Date()}; 
        json.error = 'No data found. ';
        json.columns = validCols; 
        return JSON.stringify(json);
    }
    var rangeValue = sheet.getRange(2, 1, lastRow-1, lastColumn).getValues(); 
    var text = ""; 
    for( var ii=0; ii<rangeValue.length; ii+=1 ) {
        var json = {"__sheet_name":sheetname, "__export_time":Date()}; 
        for( var key in validCols ) {
            var jj = validCols[key].index; 
            var name = validCols[key].name; 
            JSONinsert(json,name,rangeValue[ii][jj]);
        }
        text += JSON.stringify(json); 
        text += "\n"; 
    }
    return text; 
}

function JSONinsert(json, name, value) {
    var validRegExp = /^[\w.]+$/;
    if( !validRegExp.test(name) ) { 
        return; 
    }
    var regExp = /^([\w]+)\.([\w.]+)$/; 
    var match = name.match(regExp); 
    if( match===null ) {
        json[name] = value;  
    } else {
        if( !json.hasOwnProperty(match[1]) ) { 
            json[match[1]] = {}; 
        }
        JSONinsert( json[match[1]], match[2], value ); 
    }
    return json;
}

