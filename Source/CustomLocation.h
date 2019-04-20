//
//  Location.h
//  SnapExt
//
//  Created by Leonardos Jr. on 11.04.19.
//

#import "LocationPicker-Frameworks.h"



@interface CustomLocation : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic) CLLocation * location;
@property (nonatomic) CLPlacemark * placemark;

@property (nonatomic, copy) NSString * address;



- (id)initWithName:(NSString*)name location:(CLLocation*)location placemark:(CLPlacemark*)placemark;


@end


@interface CustomLocation(MKAnnotation) <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString * _Nullable title;

@end
