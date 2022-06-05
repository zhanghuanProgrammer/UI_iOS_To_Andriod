#import <Foundation/Foundation.h>

/**这个类是用于根据属性生成固有形式的代码和将这些代码插入到.m文件特定的位置*/

@interface ZHStoryboardTextManager : NSObject

+ (NSMutableDictionary *)defaultIDDicM;
+ (NSMutableDictionary *)defaultPropertyDicM;
+ (NSMutableDictionary *)defaultDicM;

/**为View打上所有标识符(默认顺序) 包括(为所有view的id打上标识符,对应的标识符就是CustomClass)*/
+ (NSString *)addCustomClassToAllViews:(NSString *)text;

+ (NSString *)isView:(NSString *)text;

+ (NSString *)getFatherView:(NSString *)view inViewRelationShipDic:(NSDictionary *)viewRelationShipDic;

+ (void)addCodeText:(NSString *)code toStrM:(NSMutableString *)strM;
+ (void)addCodeTexts:(NSArray *)codes toStrM:(NSMutableString *)strM;

/**往最某个代码后面追加*/
+ (BOOL)addCode:(NSString *)code ToTargetAfter:(NSString *)target toText:(NSMutableString *)text;
/**找到某个函数包括函数里面的内容*/
+ (NSString *)findCodeFunctionWithIdentity:(NSString *)identity WithText:(NSMutableString *)text;
+ (void)done;

@end
