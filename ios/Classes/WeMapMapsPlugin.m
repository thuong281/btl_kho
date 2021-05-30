#import "WeMapMapsPlugin.h"
#import <wemapgl/wemapgl-Swift.h>

@implementation WeMapMapsPlugin 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWeMapGlFlutterPlugin registerWithRegistrar:registrar];
}
@end
