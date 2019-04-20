# LocationPickerObjC
LocationPicker written in ObjC

This was never intended to be a perfect Framework.
I simply wrote it, because I couldn't find any useful LocationPicker in ObjC and I couldn't use Swift.

It works perfectly for my Project, so there might be References or Method Calls to that project.
Simply remove them and replace them with what fits for you best.

Trashed Files:
I tried to implement a Location History, but something didn't work in the saving to userdefaults. It wasn't so important so I didn't finish it. Almost everything therefore is implemented, just uncomment any 'history' stuff.

Finally, I also left a lot of Code I don't use anymore. It's commented out so feel free to remove it.

##### Here's some sample Code:

```objective-c
#import "LocationPickerViewController.h"
	
LocationPickerViewController *picker = [LocationPickerViewController new];
picker.location = [[CustomLocation alloc] initWithName: @"Saved Location" location:SCGeneral.getLocation placemark:nil];
	
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:picker];
[vc presentViewController:navigationController animated:YES completion:nil];
```



It's orientated on [almassapargali/LocationPicker](https://github.com/almassapargali/LocationPicker)(Swift)
