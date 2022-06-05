#import <Cocoa/Cocoa.h>

/**这个类用于创建文件*/

@interface ZHStroyBoardFileManager : NSObject
+ (NSMutableDictionary *)defalutFileDicM;
+ (NSMutableDictionary *)defalutContextDicM;
+ (NSString *)getCurDateString;
+ (NSString *)getMainDirectory;
+ (void)creatFileDirectory;
+ (void)done;
+ (void)doneNoWordWrap;
+ (void)creat_MVC_WithViewControllerName:(NSString *)ViewController;
+ (void)creat_V_WithViewName_XIB:(NSString *)View;

+ (NSMutableString *)get_xml_ContextByIdentity:(NSString *)identity;

+ (void)creat_android_xml_file:(NSString *)fileName
                         isIds:(BOOL)isIds
                        isView:(BOOL)isView
                  isController:(BOOL)isController
             forViewController:(NSString *)viewController;


+ (NSString *)getAdapterCollectionViewCellAndTableViewCellName:(NSString *)name;
+ (NSString *)getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:(NSString *)name;

#pragma mark 辅助函数
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM;

@end
