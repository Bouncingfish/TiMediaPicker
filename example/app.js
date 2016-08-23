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
var TiMediaPicker = require('com.bf.TiMediaPicker');
Ti.API.info("module is => " + TiMediaPicker);

var picker = TiMediaPicker.createPicker();

picker.addEventListener("success", function onSuccess(e) {
    picker.removeEventListener("success", onSuccess);
    console.log(e.items.length);
    console.log(e.items[0].getSize());
    console.log(e.items[0].getLength());

    if (e.items[0].getMimeType().indexOf("video") !== -1) {
        var videoPlayer = Titanium.Media.createVideoPlayer({
            autoplay : true,
            height : 300,
            width : 300,
            mediaControlStyle : Titanium.Media.VIDEO_CONTROL_DEFAULT,
            scalingMode : Titanium.Media.VIDEO_SCALING_ASPECT_FIT,
            media: e.items[0]
        });
        win.add(videoPlayer);
    }
});

label.addEventListener("click", function (e) {
    picker.show({
        animated: true,
        acceptMediaType: "video", // or "video" - "" or no set mean "both",
        maxSelectableMedia: 2 // -1 is no limit
    });
});
