// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
    backgroundColor:'white'
});
var label = Ti.UI.createLabel({
    right: 30, bottom: 20,
    text: "Open Picker"
});
win.add(label);

var tabbedBar = Titanium.UI.iOS.createTabbedBar({
    left: 30, bottom: 20,
    index: 0,
    labels: ['Video', 'Image'],
    height: 25,
    width:200
});
win.add(tabbedBar);

var container = Ti.UI.createView({
    top: 20,
    width: "100%", height: Ti.UI.SIZE,
    layout: "horizontal"
});

win.add(container);

win.open();

// TODO: write your module tests here
var TiMediaPicker = require('com.bf.TiMediaPicker');
Ti.API.info("module is => " + TiMediaPicker);

var picker = TiMediaPicker.createPicker();

picker.addEventListener("success", function onSuccess(e) {
    // picker.removeEventListener("success", onSuccess);
    console.log(e.items.length);
    console.log(e.items[0].getSize());

    container.removeAllChildren();

    if (e.items[0].getMimeType().indexOf("video") !== -1) {
        var videoPlayer = Titanium.Media.createVideoPlayer({
            top: 20,
            autoplay : true,
            width : "100%",
            height: 300,
            mediaControlStyle : Titanium.Media.VIDEO_CONTROL_DEFAULT,
            scalingMode : Titanium.Media.VIDEO_SCALING_ASPECT_FIT,
            media: e.items[0]
        });
        container.add(videoPlayer);
    }
    else if (e.items[0].getMimeType().indexOf("image") !== -1) {
        for (var i = 0, maxi = e.items.length; i < maxi; i++) {
            var imageView = Titanium.UI.createImageView({
                width : 100,
                image: e.items[i]
            });
            container.add(imageView);
        }
    }
});

label.addEventListener("click", function (e) {
    console.log(tabbedBar.index);
    console.log(tabbedBar.labels);
    console.log(tabbedBar.labels[tabbedBar.index]);
    picker.show({
        animated: true,
        // or "image" - "" or no set mean "both"
        acceptMediaType: tabbedBar.labels[tabbedBar.index].toLowerCase(),
        maxSelectableMedia: 3 // -1 is no limit
    });
});
