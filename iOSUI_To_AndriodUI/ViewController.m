//
//  ViewController.m
//  iOSToJava
//
//  Created by Mac on 2022/6/5.
//

#import "ViewController.h"
#import "XMDragView.h"
#import "XMFileItem.h"
#import "MBProgressHUD.h"
#import "ZHStroyBoardToAndriod.h"
#import "ZHXibToAndriod.h"

@interface ViewController()<XMDragViewDelegate>

/**
 *  支持处理的类型，目前仅支持png、jpg、ipa、car文件
 */
@property (nonatomic, copy) NSArray *extensionList;
@property (weak) IBOutlet NSTextField *filed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 支持的扩展名文件
    self.extensionList = @[@"xib", @"storyboard"];
}

#pragma mark - XMDragViewDelegate

/**
 *  处理拖拽文件代理
 */
- (void)dragView:(XMDragView *)dragView didDragItems:(NSArray *)items
{
    [self addPathsWithArray:items];
}

#pragma mark - other
/**
 *  添加拖拽进来的文件
 */
- (void)addPathsWithArray:(NSArray*)path
{
    BOOL haveDid = NO;
    for (NSString *addItem in path) {
        
        XMFileItem *fileItem = [XMFileItem xmFileItemWithPath:addItem];
        
        // 过滤不支持的文件格式
        if (fileItem.isDirectory) {
            [MBProgressHUD showText:@"仅支持.xib .storyboard格式文件,可批量多选拖入" view:self.view];
        }else{
            BOOL isExpectExtension = NO;
            NSString *pathExtension = [addItem pathExtension];
            for (NSString *item in self.extensionList) {
                if ([item isEqualToString:pathExtension]) {
                    isExpectExtension = YES;
                    break;
                }
            }
            
            if (!isExpectExtension) {
                [MBProgressHUD showText:@"仅支持.xib .storyboard格式文件,可批量多选拖入" view:self.view];
                continue;
            }
            if ([pathExtension containsString:@"xib"]) {
                [[ZHXibToAndriod new] xib_To_xml:fileItem.filePath];
            }
            if ([pathExtension containsString:@"storyboard"]) {
                [[ZHStroyBoardToAndriod new] StroyBoard_To_xml_path:fileItem.filePath];
            }
            haveDid = YES;
        }
    }
    
    if (haveDid) {
        [MBProgressHUD showText:@"生成成功,文件在桌面上" view:self.view];
    }
    
}

@end
