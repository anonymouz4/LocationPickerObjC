//
//  UIImage+LocationPicker.m
//  SnapExt
//
//  Created by Leonardos Jr. on 13.04.19.
//

#import "UIImage+LocationPicker.h"
#import "SnapExt.h"


@implementation UIImage (LocationPicker)

+ (UIImage *)imageForResourcePath:(NSString *)path ofType:(NSString *)type {
	return [UIImage imageWithContentsOfFile:[[SCGeneral.sharedInstance resourcesBundle] pathForResource:path ofType:type]];
}
@end
