
# TiMediaPicker

## Description

Gallery / Media picker for iOS that supports multiple selection

## Usage

To access this module from a Titanium project, you would do the following:

    var TiMediaPicker = require('com.bf.TiMediaPicker');

## Example

    var win = Ti.UI.createWindow({
      backgroundColor:'white'
    });
    
    var label = Ti.UI.createLabel({
      text: "open"
    });

    win.add(label);
    win.open();

    var TiMediaPicker = require('com.bf.TiMediaPicker');

    var picker = TiMediaPicker.createPicker();

    picker.addEventListener("success", function onSuccess(e) {
        picker.removeEventListener("success", onSuccess);
        console.log(e.items.length);
        console.log(e.items[0].getSize());
    });

    label.addEventListener("click", function (e) {
        picker.show({
            animated: true,
            acceptMediaType: "image", // or use "video" - "" or no set means both,
            maxSelectableMedia: 2 // use -1 for no limit
        });
    });

## License

Copyright 2016 BouncingFish

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


