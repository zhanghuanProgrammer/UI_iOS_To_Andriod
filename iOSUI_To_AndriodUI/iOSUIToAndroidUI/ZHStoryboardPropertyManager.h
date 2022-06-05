#import "ReadXML.h"
#import <Cocoa/Cocoa.h>
#import "ViewProperty.h"

@interface ZHStoryboardPropertyManager : NSObject

/**为获取每个view的property属性*/
+ (NSDictionary *)getPropertysForView:(NSDictionary *)idAndViewDic
                    withCustomAndName:(NSDictionary *)customAndNameDic
                         andXMLHandel:(ReadXML *)xml;

@end
