// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
    backgroundColor:'white'
});
var label = Ti.UI.createLabel({
    text: "open"
});
win.add(label);
win.open();

// TODO: write your module tests here
var com_bf_timediapicker = require('com.bf.TiMediaPicker');
Ti.API.info("module is => " + com_bf_timediapicker);

var picker = com_bf_timediapicker.createPicker();

picker.addEventListener("success", function onSuccess(e) {
    picker.removeEventListener("success", onSuccess);
    console.log(e.items.length);
    console.log(e.items[0].getSize());
});

label.addEventListener("click", function (e) {
    picker.show({ acceptMediaType: "image" });
})
