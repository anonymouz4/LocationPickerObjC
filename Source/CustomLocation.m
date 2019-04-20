//
//  Location.m
//  SnapExt
//
//  Created by Leonardos Jr. on 11.04.19.
//

#import "CustomLocation.h"

@implementation CustomLocation


- (id)initWithName:(NSString*)name location:(CLLocation*)location placemark:(CLPlacemark*)placemark {

	self = [super init];
	self.name = name;
	self.location = location ? location : placemark.location;
	self.placemark = placemark;

	return self;
}

- (NSString*)address {

	for (NSDictionary *addressDic = self.placemark.addressDictionary; addressDic != nil;) {
		
		for(NSArray<NSString*> *lines = addressDic[@"FormattedAddressLines"]; lines != nil;) {
			return [lines componentsJoinedByString:@", "];
		}
		
		return ABCreateStringWithAddressDictionary(addressDic, true);
	}
	
	return [NSString stringWithFormat:@"%f, %f",self.coordinate.latitude,self.coordinate.longitude];
}

@end


@implementation CustomLocation (MKAnnotation)

- (CLLocationCoordinate2D)coordinate {
	return self.location.coordinate;
}
- (NSString*)title {
	return self.name ? self.name : self.address;
}


@end
