//
//  SearchHistoryManager.m
//  SnapExt
//
//  Created by Leonardos Jr. on 11.04.19.
//

#import "SearchHistoryManager.h"

@implementation SearchHistoryManager

NSString * const HistoryKey = @"RecentLocationsKey";


- (NSArray<Location2*>*)history {
	
	NSArray<NSDictionary*>* history = [NSUserDefaults.standardUserDefaults objectForKey:HistoryKey];
	if (!history) history = @[];
	
//	Location.
//	[history contactmao]
	
	NSDictionary *newDict = NSDictionary.dictionary;
	[history enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		Location2 *newLocation = [CLLocation fromDefaultsDic:obj];
		if (newLocation) [newDict setValue:obj. forKey:<#(nonnull NSString *)#>]
		
	}]
	
	
	
}

@end

@implementation CLLocation (DefaultsDic)
+ (NSDictionary*)toDefaultsDic:(CLLocationCoordinate2D)arg1 {
	return @{CoordinateDicKeys2.latitude: [NSNumber numberWithDouble:arg1.latitude], CoordinateDicKeys2.longitude: [NSNumber numberWithDouble:arg1.longitude]};
}

+ (CLLocationCoordinate2D * _Nullable)fromDefaultsDic:(NSDictionary*_Nonnull)dic {
	
	NSNumber *latitude = dic[CoordinateDicKeys2.latitude];
	NSNumber *longitude = dic[CoordinateDicKeys2.longitude];
	if (latitude == nil || longitude == nil) return nil;
	
	return &((CLLocationCoordinate2D){.latitude = latitude.doubleValue, .longitude = longitude.doubleValue});
}

@end


@implementation Location2(DefaultsDic)

- (NSDictionary * _Nullable)toDefaultsDic {
	
	NSDictionary * addressDic = self.placemark.addressDictionary;
	NSDictionary * placemarkCoordinatesDic = [CLLocation toDefaultsDic:self.placemark.location.coordinate];
	if (addressDic == nil) return nil;
	
	NSDictionary *dic = @{
						  LocationDicKeys2.locationCoordinates: [CLLocation toDefaultsDic:self.location.coordinate],
						  LocationDicKeys2.placemarkAddressDic: addressDic,
						  LocationDicKeys2.placemarkCoordinates: placemarkCoordinatesDic
						  };
	
	if (self.name) [dic setValue:self.name forKey:LocationDicKeys2.name];
	return dic;
}

- (Location2 * _Nullable)fromDefaultsDic:(NSDictionary*_Nonnull)dic {
	
	NSDictionary * placemarkCoordinatesDic = dic[LocationDicKeys2.placemarkCoordinates];
	CLLocationCoordinate2D * placemarkCoordinates = [CLLocation fromDefaultsDic:placemarkCoordinatesDic];
	NSDictionary * placemarkAddressDic = dic[LocationDicKeys2.placemarkAddressDic];
	if (placemarkCoordinatesDic == nil || placemarkCoordinates == nil || placemarkAddressDic == nil) return nil;
	

	NSDictionary * coordinatesDic = dic[LocationDicKeys2.locationCoordinates];

	CLLocationCoordinate2D * coordinate = [CLLocation fromDefaultsDic:coordinatesDic];
	
	CLLocation * location = [[CLLocation alloc] initWithLatitude:coordinate->latitude longitude:coordinate->longitude];
	
	MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:*placemarkCoordinates addressDictionary:placemarkAddressDic];
	
	
	return [[Location2 alloc] init:dic[LocationDicKeys2.name] location:location placemark:placemark];
	
}




@end
