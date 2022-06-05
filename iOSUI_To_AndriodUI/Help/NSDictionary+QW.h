
#import <Cocoa/Cocoa.h>

@interface NSObject (SCJson)

- (id)valueForUniqueKey:(NSString *)key;
- (id)valueForUniqueKeys:(NSArray *)keys;
- (NSString *)stringValueForUniqueKey:(NSString *)key;
- (NSString *)stringValueForUniqueKeys:(NSArray *)keys;

- (id)valueForUniqueKey:(NSString *)key checkClass:(Class)cls;
- (id)valueForUniqueKeys:(NSArray *)keys checkClass:(Class)cls;

@end

@interface NSDictionary (SCJson)

/**
 从字典里获取key值对应的value值
 tips:
 1.如果当前NSDictionary找到了key值,返回value,否则遍历子NSDictionary
 */
- (id)valueForUniqueKey:(NSString *)key;

/**
 从字典里获取key值对应的value值 根据路径
 */
- (id)valueForUniqueKeys:(NSArray *)keys;

/**
 从字典里获取key值对应的value值 最终返回字符串,无论里面是什么类型,都转成字符串
 */
- (NSString *)stringValueForUniqueKey:(NSString *)key;
- (NSString *)stringValueForUniqueKeys:(NSArray *)keys;

- (NSDictionary *)dicValueForUniqueKey:(NSString *)key;

/*检查一下是否是某个类型,如果不是,就返回nil,防止误判断,导致后面进行操作报错*/
- (id)valueForUniqueKey:(NSString *)key checkClass:(Class)cls;
- (id)valueForUniqueKeys:(NSArray *)keys checkClass:(Class)cls;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

@interface NSArray (SCMutable)
- (NSMutableArray *)copyMutable;
@end

@interface NSDictionary (SCMutable)
- (NSMutableDictionary *)copyMutable;
@end
