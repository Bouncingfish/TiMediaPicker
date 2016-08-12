//
//  ComBfTiMediaPickerPickerProxy.m
//  TiMediaPicker
//
//  Created by Duy Bao Nguyen on 8/8/16.
//
//

#import "TiApp.h"
#import "TiBlob.h"
#import "ComBfTiMediaPickerPickerProxy.h"

@implementation ComBfTiMediaPickerPickerProxy

-(void)show:(id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];
    NSString *acceptMediaType = [TiUtils stringValue:@"acceptMediaType" properties:args def:@""];

    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];

    // set accept media types
    if (![acceptMediaType  isEqual: @""]) {
        if ([acceptMediaType  isEqual: @"image"]) {
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
            picker.assetsFetchOptions = fetchOptions;
        }
        else if ([acceptMediaType  isEqual: @"video"]) {
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
            picker.assetsFetchOptions = fetchOptions;
        }
    }

    // request authorization status
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            // set delegate
            picker.delegate = self;

            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;

            // present picker
            [[[[TiApp app] controller] topPresentedController] presentViewController:picker
                                                                            animated:animated
                                                                          completion:nil];
        });
    }];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assetsCount: %d", [assets count]);

    // assets contains PHAsset objects.
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeNone;
    requestOptions.networkAccessAllowed = YES; // able to download iCloud images
    requestOptions.synchronous = NO;

    // progress view background
    UIView *progressViewBackground = [[UIView alloc] initWithFrame:picker.view.frame];
    progressViewBackground.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [picker.view addSubview:progressViewBackground];

    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.center = picker.view.center;
    [picker.view addSubview:progressView];

    PHImageManager *manager = [PHImageManager defaultManager];
    NSMutableArray *blobs = [NSMutableArray arrayWithCapacity:[assets count]];
    __block NSUInteger imagesCount = 0;

    requestOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressView setProgress: ((float)imagesCount + progress) / [assets count] ];
        });
    };

    // Retrive all images
    for (PHAsset *asset in assets) {
        [manager requestImageForAsset:asset
            targetSize:PHImageManagerMaximumSize
            contentMode:PHImageContentModeDefault
            options:requestOptions
            resultHandler:^void(UIImage *image, NSDictionary *info) {
                NSData *imgData = UIImageJPEGRepresentation(image, 1);
                NSLog(@"Size of current image(bytes): %d",[imgData length]);

                if ([imgData length] != 0) {
                    TiBlob *blob = [[TiBlob alloc] initWithImage:image];
                    [blobs addObject:blob];
                    imagesCount++;
                    [progressView setProgress:imagesCount / [assets count]];

                    if (imagesCount == [assets count]) {
                        NSLog(@"Get all");
                        if (picker != nil) {
                            [picker dismissViewControllerAnimated:YES completion:^{
                                if ([self _hasListeners:@"success"]) {
                                    NSMutableDictionary *reponseObject = [[NSMutableDictionary alloc] init];
                                    [reponseObject setObject:blobs forKey:@"items"];
                                    [self fireEvent:@"success" withObject:reponseObject];
                                }
                            }];
                        }
                    }
                }
                else {
                    if ([self _hasListeners:@"error"]) {
                        [self fireEvent:@"error"];
                        [picker dismissViewControllerAnimated:YES completion:nil];
                    }
                    else {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message:@"An error occurred while fetching data. Please check your connection and try again."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction
                            actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {
                                [picker dismissViewControllerAnimated:YES completion:nil];
                            }
                        ];
                        
                        [alert addAction:defaultAction];
                        
                        [[[[TiApp app] controller] topPresentedController] presentViewController:alert
                                                                                        animated:YES
                                                                                      completion:nil];
                    }
                }
            }
        ];
    }
}

@end
