#import "ZHXibToAndriod.h"
#import "ZHStoryboardTextManager.h"
#import "ZHStroyBoardToAndriod.h"
#import "ZHXibToSB.h"
#import "ZHFileManager.h"

@interface ZHXibToAndriod ()

@end

@implementation ZHXibToAndriod

- (void)xib_To_xml:(NSString *)xibPath {
    
    NSString *filePath = xibPath;
    if ([ZHFileManager fileExistsAtPath:filePath] == NO) { return; }
    NSString *context = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if ([context containsString:@"viewController"]) {
        [[ZHStroyBoardToAndriod new] StroyBoard_To_xml_path:xibPath];
    }else{
        [[ZHStroyBoardToAndriod new] StroyBoard_To_xml_content:[ZHXibToSB xib_To_sb:xibPath]];
    }
}

@end
