
#import <Cocoa/Cocoa.h>
#import "ViewProperty.h"

@interface ZHStroyBoardToAndriodTool : NSObject

- (void)initOrderRankWithRect:(NSDictionary *)idAndViewPropertys
             idAndOutletViews:(NSDictionary *)idAndOutletViews
                        views:(NSArray *)views;

- (void)getCreatXMLCodeWithIdStr:(NSString *)idStr
                             WithViewName:(NSString *)viewName
                        withConstraintDic:(NSDictionary *)constraintDic
                    withSelfConstraintDic:(NSDictionary *)selfConstraintDic
                                   isCell:(BOOL)isCell
                             withDoneArrM:(NSMutableArray *)doneArrM
                     withCustomAndNameDic:(NSDictionary *)customAndNameDic
                          addToFatherView:(NSString *)fatherView
                  withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews
                           withProperty:(ViewProperty *)property
                       WithidAndViewDic:(NSDictionary *)idAndViewDic
                    defaultPropertyDicM:(NSDictionary *)defaultPropertyDicM
           inViewRelationShipDic:(NSDictionary *)viewRelationShipDic;

- (NSString *)getXMLCode;

+ (NSString *)iosViewClassToAndroidViewClass:(NSString *)categoryView;

@end
