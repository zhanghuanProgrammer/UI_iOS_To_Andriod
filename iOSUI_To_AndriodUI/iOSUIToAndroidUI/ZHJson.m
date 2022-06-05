#import "ZHJson.h"
#import "NSDictionary+QW.h"
#import "NSArray+ZH.h"
#import "NSDictionary+ZH.h"

@implementation ZHJson

- (NSMutableDictionary *)copyMutableDicFromDictionary:(NSDictionary *)dic {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    for (NSString *key in dic) {
        id obj = dic[key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [dicM setValue:[self copyMutableDicFromDictionary:obj] forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [dicM setValue:[self copyMutableArrFromArray:obj] forKey:key];
        } else {
            [dicM setValue:obj forKey:key];
        }
    }
    return dicM;
}

- (NSMutableArray *)copyMutableArrFromArray:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray array];
    for (id obj in arr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [arrM addObject:[self copyMutableDicFromDictionary:obj]];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [arrM addObject:[self copyMutableArrFromArray:obj]];
        } else {
            [arrM addObject:obj];
        }
    }
    return arrM;
}

@end
