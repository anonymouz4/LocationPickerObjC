//
//  SearchHistoryManager.h
//  SnapExt
//
//  Created by Leonardos Jr. on 11.04.19.
//

#import "SnapExt.h"


@interface SearchHistoryManager : NSObject

- (NSArray<Location2*>* _Nonnull)history;
@end



struct _LocationDicKeys {
	NSString * _Nonnull name;
	NSString * _Nonnull locationCoordinates;
	NSString * _Nonnull placemarkCoordinates;
	NSString * _Nonnull placemarkAddressDic;
} LocationDicKeys2 = {@"Name", @"LocationCoordinates", @"PlacemarkCoordinates", @"PlacemarkAddressDic"};
typedef struct _LocationDicKeys _LocationDicKeys;

struct _CoordinateDicKeys {
	NSString * _Nonnull latitude;
	NSString * _Nonnull longitude;
} CoordinateDicKeys2 = {@"Latitude", @"Longitude"};
typedef struct _CoordinateDicKeys _CoordinateDicKeys;


@interface CLLocation (DefaultsDic)
+ (NSDictionary*_Nonnull)toDefaultsDic:(CLLocationCoordinate2D)arg1;

+ (CLLocationCoordinate2D * _Nullable)fromDefaultsDic:(NSDictionary*_Nonnull)dic;

@end


@interface Location2(DefaultsDic)
- (Location2 * _Nullable)fromDefaultsDic:(NSDictionary*_Nonnull)dic;
- (NSDictionary * _Nullable)toDefaultsDic;
@end
