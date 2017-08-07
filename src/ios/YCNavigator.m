#import "YCNavigator.h"
#import <MapKit/MapKit.h>

@implementation YCNavigator

- (void)open:(CDVInvokedUrlCommand *)command
{
    NSError* jsonError;
    NSString* arguments = [command argumentAtIndex:0];
    NSData* objectData = [arguments dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* options = [NSJSONSerialization JSONObjectWithData:objectData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonError];

    CLLocationDegrees latitude = [[options objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [[options objectForKey:@"longitude"] doubleValue];
    int type = [[options objectForKey:@"type"] intValue];
    NSString* currentName = options[@"currentName"];
    NSString* distName = options[@"distName"];
    NSString* appName = options[@"appName"];
    
    if(type == 0) {
      CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
      MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
      MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
      [toLocation setName: distName];

      [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                     launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                     MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    } else if(type == 1) {
      NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&lat=%f&lon=%f&dev=0&style=2", appName, latitude, longitude] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
      if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
          urlString = @"https://itunes.apple.com/cn/app/id461703208?mt=8";
      }
    
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else if(type == 2) {
      NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02", latitude, longitude, distName] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    
          if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
              urlString = @"https://itunes.apple.com/cn/app/id452186370?ls=1&mt=8";
          }
    
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end