# LocationPickerObjC
LocationPicker written in ObjC

This was never intended to be a perfect Framework.
I simply wrote it, because I couldn't find any useful LocationPicker in ObjC and I couldn't use Swift.

It works perfectly for my Project, so there might be References or Method Calls to that project.
Simply remove them and replace them with what fits for you best.

Here's some sample Code:



```objective-c
#import "LocationPickerViewController.h"
	
LocationPickerViewController *picker = [LocationPickerViewController new];
picker.location = [[CustomLocation alloc] initWithName: @"Saved Location" location:SCGeneral.getLocation placemark:nil];
	
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:picker];
[vc presentViewController:navigationController animated:YES completion:nil];
```



It's orientated on [almassapargali/LocationPicker](https://github.com/almassapargali/LocationPicker)(Swift)
