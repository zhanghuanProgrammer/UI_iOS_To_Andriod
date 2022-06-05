#import <Cocoa/Cocoa.h>

@interface ZHJson : NSObject

/**将Dictionary转换成MutableDictionary*/
- (NSMutableDictionary *)copyMutableDicFromDictionary:(NSDictionary *)dic;
/**将NSArray转换成MutableNSArray*/
- (NSMutableArray *)copyMutableArrFromArray:(NSArray *)arr;

@end
