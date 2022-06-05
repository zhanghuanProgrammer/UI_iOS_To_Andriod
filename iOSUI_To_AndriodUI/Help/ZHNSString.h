#import <Cocoa/Cocoa.h>

@interface ZHNSString : NSObject

/**根据左右取中间字符串,返回为数组*/
+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString
                               RightString:(NSString *)rightString
                                  withText:(NSString *)text
                                    getOne:(BOOL)one
                            withIndexStart:(NSInteger)startIndex
                                stopString:(NSString *)stopString;

+ (NSString *)getMidTargetStringBetweenLeftRightStrings:(NSArray *)strings withText:(NSString *)text;

+ (NSArray *)getMidsBetweenLeftRightStrings:(NSArray *)strings withText:(NSString *)text;

+ (BOOL)isBianLiangMingCode:(NSString *)code;
+ (BOOL)isChangLiangMingCode:(NSString *)code;
+ (BOOL)isBaoHanCode:(NSString *)code arr:(NSArray *)arr;
+ (NSArray<NSString *> *)componentsSeparatedByStrings:(NSArray *)separators text:(NSString *)text;

+ (NSString *)changeOldName:(NSString *)oldName newName:(NSString *)newName inText:(NSString *)text;

+ (NSString *)removeSpaceBeforeAndAfterWithString:(NSString *)str;

+ (NSString *)removeSpacePrefix:(NSString *)text;
+ (NSString *)removeSpaceSuffix:(NSString *)text;

+ (BOOL)isValidateNumber:(NSString *)number;
+ (BOOL)isPureFloat:(NSString *)string;
+ (BOOL)isPureInt:(NSString *)string;

@end
