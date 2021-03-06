#import "propertyNode.h"
#import <Foundation/Foundation.h>

@interface TreeNode : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) TreeNode *child;
@property (nonatomic, strong) TreeNode *brother;
@property (nonatomic, strong) propertyNode *propertys;
@end
