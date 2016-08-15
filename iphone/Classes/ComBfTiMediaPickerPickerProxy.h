//
//  ComBfTiMediaPickerPickerProxy.h
//  TiMediaPicker
//
//  Created by Duy Bao Nguyen on 8/8/16.
//
//

#import "TiProxy.h"
#import "CTAssetsPickerController.h"

@interface ComBfTiMediaPickerPickerProxy : TiProxy <CTAssetsPickerControllerDelegate> {
    NSUInteger maxSelectableMedia;
}

-(void)show:(id)args;

@end
