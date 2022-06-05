#import "ZHStroyBoardFileManager.h"

static NSMutableDictionary *ZHStroyBoardFileDicM;
static NSMutableDictionary *ZHStroyBoardContextDicM;
static NSString *MainDirectory;
@implementation ZHStroyBoardFileManager
+ (NSMutableDictionary *)defalutFileDicM {
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardFileDicM == nil) {
            ZHStroyBoardFileDicM = [NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardFileDicM;
}
+ (NSMutableDictionary *)defalutContextDicM {
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardContextDicM == nil) {
            ZHStroyBoardContextDicM = [NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardContextDicM;
}
+ (NSString *)getMainDirectory {
    if (MainDirectory.length > 0) { return MainDirectory; }
    return @"";
}

+ (NSMutableString *)get_xml_ContextByIdentity:(NSString *)identity {
    if ([identity hasSuffix:@".xml"] == NO) { identity = [identity stringByAppendingString:@".xml"]; }
    NSString *filePath = [self defalutFileDicM][identity];
    id obj             = [self defalutContextDicM][filePath];
    if ([obj isKindOfClass:[NSMutableString class]]) { return (NSMutableString *)obj; }
    NSLog(@"出现严重错误,字典保存的不是可变字符串");
    return nil;
}

+ (NSString *)getCurDateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (void)creatFileDirectory {
    NSString *fileDirectory = [self getCurDateString];
    fileDirectory           = [fileDirectory stringByAppendingString:@"代码生成"];
    NSString *directory     = NSHomeDirectory();
    if ([directory rangeOfString:@"/Library"].location != NSNotFound) {
        directory = [directory substringToIndex:[directory rangeOfString:@"/Library"].location];
    }
    directory = [directory stringByAppendingPathComponent:@"Desktop"];
    directory = [directory stringByAppendingPathComponent:fileDirectory];
    [[NSFileManager defaultManager] createDirectoryAtPath:directory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    MainDirectory = directory;
}

+ (void)done {
    //开始保存text到指定路径
    MainDirectory = nil;
    [ZHStroyBoardContextDicM removeAllObjects];
    [ZHStroyBoardFileDicM removeAllObjects];
}

+ (void)doneNoWordWrap {
    for (NSString *filePath in [self defalutContextDicM]) {
        NSMutableString *context = [self defalutContextDicM][filePath];
        [context writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    MainDirectory = nil;
    [ZHStroyBoardContextDicM removeAllObjects];
    [ZHStroyBoardFileDicM removeAllObjects];
}

+ (void)creat_android_xml_file:(NSString *)fileName
                       isIds:(BOOL)isIds
                        isView:(BOOL)isView
                  isController:(BOOL)isController
     forViewController:(NSString *)viewController {
    if (MainDirectory.length <= 0) { [self creat_MVC_WithViewControllerName:viewController]; }
    NSString *directory = MainDirectory;
    directory           = [directory stringByAppendingPathComponent:viewController];
    if (isIds) {
        directory = [directory stringByAppendingPathComponent:@"model"];
    } else if (isView) {
        directory = [directory stringByAppendingPathComponent:@"view"];
    } else if (isController) {
        directory = [directory stringByAppendingPathComponent:@"controller"];
    }
    directory = [directory stringByAppendingPathComponent:fileName];
    NSString *h_m = @".xml";
    directory = [directory stringByAppendingString:h_m];
    [[self defalutContextDicM] setValue:[NSMutableString stringWithString:@""] forKey:directory];
    [[self defalutFileDicM] setValue:directory forKey:[viewController stringByAppendingString:[fileName stringByAppendingString:h_m]]];
}

+ (void)creat_MVC_WithViewControllerName:(NSString *)ViewController {
    if (MainDirectory.length <= 0) { [self creatFileDirectory]; }
    NSString *directory = MainDirectory;
    directory           = [directory stringByAppendingPathComponent:ViewController];
    [[NSFileManager defaultManager] createDirectoryAtPath:directory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    [[NSFileManager defaultManager]
     createDirectoryAtPath:[directory stringByAppendingPathComponent:@"model"]
     withIntermediateDirectories:YES
     attributes:nil
     error:nil];
    [[NSFileManager defaultManager]
     createDirectoryAtPath:[directory stringByAppendingPathComponent:@"view"]
     withIntermediateDirectories:YES
     attributes:nil
     error:nil];
    [[NSFileManager defaultManager]
     createDirectoryAtPath:[directory stringByAppendingPathComponent:@"controller"]
     withIntermediateDirectories:YES
     attributes:nil
     error:nil];
}
+ (void)creat_V_WithViewName_XIB:(NSString *)View {
    if (MainDirectory.length <= 0) { [self creatFileDirectory]; }
    NSString *directory = MainDirectory;
    directory           = [directory stringByAppendingPathComponent:View];
    [[NSFileManager defaultManager] createDirectoryAtPath:directory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
}

#pragma mark 辅助函数
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM {
    if (strM == nil) { strM = [NSMutableString string]; }
    
    for (NSString *str in values) { [strM appendFormat:@"%@\n", str]; }
}



+ (NSString *)getAdapterCollectionViewCellAndTableViewCellName:(NSString *)name {
    
    if ([[name lowercaseString] hasSuffix:@"tableviewcell"]) {
        name = [name substringToIndex:name.length - @"tableviewcell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellName:name];
    } else if ([[name lowercaseString] hasSuffix:@"tabelviewcell"]) {
        name = [name substringToIndex:name.length - @"tabelviewcell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellName:name];
    } else if ([[name lowercaseString] hasSuffix:@"collectionviewcell"]) {
        name = [name substringToIndex:name.length - @"collectionviewcell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellName:name];
    } else if ([[name lowercaseString] hasSuffix:@"cell"]) {
        name = [name substringToIndex:name.length - @"cell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellName:name];
    }
    return name;
}

+ (NSString *)getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:(NSString *)name {
    
    if ([[name lowercaseString] hasSuffix:@"tableviewcell"]) {
        name = [name substringToIndex:name.length - @"tableviewcell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:name];
    } else if ([[name lowercaseString] hasSuffix:@"tabelviewcell"]) {
        name = [name substringToIndex:name.length - @"tabelviewcell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:name];
    } else if ([[name lowercaseString] hasSuffix:@"collectionviewcell"]) {
        name = [name substringToIndex:name.length - @"collectionviewcell".length];
        return [self getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:name];
    }
    return name;
}

@end
