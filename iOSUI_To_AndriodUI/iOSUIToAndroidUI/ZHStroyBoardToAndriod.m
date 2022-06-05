#import "ZHStroyBoardToAndriod.h"
#import "ZHStoryboardTextManager.h"
#import "ZHStroyBoardToAndriodTool.h"
#import "ZHStoryboardXMLManager.h"
#import "ZHFileManager.h"
#import "ReadXML.h"
#import "ZHStroyBoardFileManager.h"
#import "ZHStoryboardPropertyManager.h"

@interface ZHStroyBoardToAndriod ()
@property (nonatomic, strong) NSDictionary *customAndId;
@property (nonatomic, strong) NSDictionary *customAndName;
@property (nonatomic, strong) NSDictionary *idAndViewPropertys;
@property (nonatomic, strong) NSDictionary *idAndOutletViews;
@property (nonatomic, strong) NSDictionary *idAndViews;
@property (nonatomic, strong) NSDictionary *defaultPropertyDicM;
@end

@implementation ZHStroyBoardToAndriod

- (NSString *)StroyBoard_To_xml_path:(NSString *)stroyBoard {
    NSString *filePath = stroyBoard;
    if ([ZHFileManager fileExistsAtPath:filePath] == NO) { return @""; }
    NSString *context = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [self StroyBoard_To_xml_content:context];
}

- (NSString *)StroyBoard_To_xml_content:(NSString *)context {
    context = [ZHStoryboardTextManager addCustomClassToAllViews:context];
    self.defaultPropertyDicM = [ZHStoryboardTextManager defaultPropertyDicM];
    ReadXML *xml = [ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic = [xml TreeToDict:xml.rootElement];
    NSArray *allViewControllers = [ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
    //获取所有的ViewController名字
    NSArray *viewControllers = [ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
    
    for (NSString *viewController in viewControllers) {
        //创建MVC文件夹
        [ZHStroyBoardFileManager creat_MVC_WithViewControllerName:viewController];
        //创建对应的ViewController文件
        [ZHStroyBoardFileManager creat_android_xml_file:viewController isIds:NO isView:NO isController:YES forViewController:viewController];
        [ZHStroyBoardFileManager creat_android_xml_file:[viewController stringByAppendingString:@"Ids"] isIds:YES isView:NO isController:NO forViewController:viewController];
    }
    
    //获取所有View的CustomClass与对应的id
    self.customAndId = [ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    //获取所有View的CustomClass与对应的真实控件类型名字
    self.customAndName = [ZHStoryboardXMLManager getAllViewCustomAndNameWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndViews = [ZHStoryboardXMLManager getAllViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndViewPropertys = [ZHStoryboardPropertyManager getPropertysForView:self.idAndViews withCustomAndName:self.customAndName andXMLHandel:xml];
    
    NSDictionary *idAndOutletViews = [ZHStoryboardXMLManager getAllOutletViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    NSMutableDictionary *idAndOutletViewDicM = [NSMutableDictionary dictionary];
    
    for (NSString *key in idAndOutletViews) {
        NSString *value = idAndOutletViews[key];
        //所有属性用小m开头
//        if(![value hasPrefix:@"m"]) {
//            value = [@"m" stringByAppendingString:[ZHNSString upFirstCharacter:value]];
//        }
        idAndOutletViewDicM[key] = value;
    }
    self.idAndOutletViews = idAndOutletViewDicM;
    
    //开始操作所有ViewController
    for (NSDictionary *dic in allViewControllers) {
        
        NSString *viewController;
        if (dic[@"customClass"] != nil) {
            viewController = dic[@"customClass"];
            {
                NSString *viewControllerFileName = [viewController stringByAppendingString:viewController]; //对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                //先创建所有cell文件
                NSArray *allTableViewCells = [ZHStoryboardXMLManager getAllTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *tableViewCell in allTableViewCells) {
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManager creat_android_xml_file:tableViewCell isIds:NO isView:YES isController:NO forViewController:viewController];
                    [ZHStroyBoardFileManager creat_android_xml_file:[tableViewCell stringByAppendingString:@"Ids"] isIds:YES isView:NO isController:NO forViewController:viewController];
                }
                
                NSArray *allCollectionViewCells = [ZHStoryboardXMLManager getAllCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *collectionViewCell in allCollectionViewCells) {
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManager creat_android_xml_file:collectionViewCell isIds:NO isView:YES isController:NO forViewController:viewController];
                    [ZHStroyBoardFileManager creat_android_xml_file:[collectionViewCell stringByAppendingString:@"Ids"] isIds:YES isView:NO isController:NO forViewController:viewController];
                }
                
                //插入属性property
                NSArray *views = [ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self = [NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other = [NSMutableDictionary dictionary];
                
                //搜集 self.view 的相关约束
                [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:@"self.view" withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                }
                
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self withNewOtherConstraintDicM:viewConstraintDicM_Other withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second: viewConstraintDicM_Self withNewOtherConstraintDicM:viewConstraintDicM_Other withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three: viewConstraintDicM_Self withNewOtherConstraintDicM:viewConstraintDicM_Other withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic = [NSMutableDictionary dictionary];
                [ZHStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止又一次创建
                NSMutableArray *brotherOrderArrM = [NSMutableArray array];
                
                NSMutableString *bindCode1 = [NSMutableString string];NSMutableString *bindCode2_1 = [NSMutableString string];NSMutableString *bindCode2_2 = [NSMutableString string];NSMutableString *bindCode2_3 = [NSMutableString string];
                for (NSString *idStr in views) {
                    NSString *viewCategoryName = @"";
                    if (self.defaultPropertyDicM[idStr]) viewCategoryName = self.defaultPropertyDicM[idStr];
                    else viewCategoryName = [ZHStroyBoardToAndriodTool iosViewClassToAndroidViewClass:self.customAndName[idStr]];
                    [brotherOrderArrM addObject:self.customAndId[idStr]];
                    
                    NSString *realViewName = @"";
                    NSString *viewName = self.customAndId[idStr];
                    if (self.idAndOutletViews != nil) {
                        if (self.idAndOutletViews[viewName] != nil) { realViewName = self.idAndOutletViews[viewName]; }
                    }
                    realViewName = realViewName.length > 0 ? realViewName : viewName;
                    
                    [bindCode1 appendFormat:@"@BindView(R.id.%@)\n%@ %@;\n",realViewName,viewCategoryName,realViewName];
                    [bindCode2_1 appendFormat:@"private %@ %@;\n",viewCategoryName,realViewName];
                    [bindCode2_2 appendFormat:@"%@ = findViewById(R.id.%@);\n",realViewName,realViewName];
                    [bindCode2_3 appendFormat:@"%@ = rootView.findViewById(R.id.%@);\n",realViewName,realViewName];
                }
                [ZHStoryboardTextManager addCodeTexts:@[bindCode1,bindCode2_1,bindCode2_2,bindCode2_3] toStrM:[ZHStroyBoardFileManager get_xml_ContextByIdentity:[viewControllerFileName stringByAppendingString:@"Ids"]]];
                
                // 1.首先开始创建控件  从父亲的subViews开始
                //从这里,开始生成xml代码
                ZHStroyBoardToAndriodTool *stroyBoardToAndriodTool = [ZHStroyBoardToAndriodTool new];
                [stroyBoardToAndriodTool initOrderRankWithRect:self.idAndViewPropertys idAndOutletViews:self.idAndOutletViews views:views];
                for (NSString *idStr in views) {
                    NSString *fatherView = [ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    
                    NSMutableDictionary *originalConstraintDicM_Self = [NSMutableDictionary dictionary];
                    [ZHStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
                    
                    //创建约束
                    [stroyBoardToAndriodTool getCreatXMLCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self withSelfConstraintDic:originalConstraintDicM_Self isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView withIdAndOutletViewsDic:self.idAndOutletViews withProperty:self.idAndViewPropertys[idStr] WithidAndViewDic:self.customAndId defaultPropertyDicM:self.defaultPropertyDicM inViewRelationShipDic:viewRelationShipDic];
                }
                [ZHStoryboardTextManager addCodeText:[stroyBoardToAndriodTool getXMLCode] toStrM:[ZHStroyBoardFileManager get_xml_ContextByIdentity:viewControllerFileName]];
            }
            
            NSArray *tableViewCellDic = [ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            NSArray *collectionViewCellDic = [ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            
            [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
            [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        }
    }
    
    NSString *mainPath = [ZHStroyBoardFileManager getMainDirectory];
    //这句话一定要加
    [ZHStroyBoardFileManager doneNoWordWrap];
    [ZHStoryboardTextManager done];
    
    self.customAndId   = nil;
    self.customAndName = nil;
    xml           = nil;
    return mainPath;
}

/**递归继续子cell的代码生成*/
- (void)detailSubCells:(NSArray *)subCells andXMLHandel:(ReadXML *)xml withFatherViewController:(NSString *)viewController {
    for (NSDictionary *subDic in subCells) {
        
        NSString *fatherCellName = [xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
        NSString *NewFileName    = [viewController stringByAppendingString:fatherCellName];
        
        //插入属性property
        NSArray *views = [ZHStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:subDic andXMLHandel:xml];
        
        //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
        NSMutableDictionary *viewConstraintDicM_Self  = [NSMutableDictionary dictionary];
        NSMutableDictionary *viewConstraintDicM_Other = [NSMutableDictionary dictionary];
        
        //获取特殊的View --- >self.view
        [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:fatherCellName withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        
        for (NSString *idStr in views) {
            //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
            [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        }
        
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self withNewOtherConstraintDicM:viewConstraintDicM_Other withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self withNewOtherConstraintDicM:viewConstraintDicM_Other withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self withNewOtherConstraintDicM:viewConstraintDicM_Other withXMLHandel:xml];
        
        //在这里插入所有view的创建和约束
        //开始建立一个父子和兄弟关系的链表
        NSMutableDictionary *viewRelationShipDic = [NSMutableDictionary dictionary];
        [ZHStoryboardXMLManager createRelationShipWithControllerDic:subDic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:YES];
        
        //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
        NSMutableArray *brotherOrderArrM = [NSMutableArray array];
        
        NSMutableString *bindCode1 = [NSMutableString string];NSMutableString *bindCode2_1 = [NSMutableString string];NSMutableString *bindCode2_2 = [NSMutableString string];NSMutableString *bindCode2_3 = [NSMutableString string];
        for (NSString *idStr in views) {
            NSString *viewCategoryName = @"";
            if (self.defaultPropertyDicM[idStr]) viewCategoryName = self.defaultPropertyDicM[idStr];
            else viewCategoryName = [ZHStroyBoardToAndriodTool iosViewClassToAndroidViewClass:self.customAndName[idStr]];
            [brotherOrderArrM addObject:self.customAndId[idStr]];
            
            NSString *realViewName = @"";
            NSString *viewName = self.customAndId[idStr];
            if (self.idAndOutletViews != nil) {
                if (self.idAndOutletViews[viewName] != nil) { realViewName = self.idAndOutletViews[viewName]; }
            }
            realViewName = realViewName.length > 0 ? realViewName : viewName;
            
            [bindCode1 appendFormat:@"@BindView(R.id.%@)\n%@ %@;\n",realViewName,viewCategoryName,realViewName];
            [bindCode2_1 appendFormat:@"private %@ %@;\n",viewCategoryName,realViewName];
            [bindCode2_2 appendFormat:@"%@ = findViewById(R.id.%@);\n",realViewName,realViewName];
            [bindCode2_3 appendFormat:@"%@ = rootView.findViewById(R.id.%@);\n",realViewName,realViewName];
        }
        [ZHStoryboardTextManager addCodeTexts:@[bindCode1,bindCode2_1,bindCode2_2,bindCode2_3] toStrM:[ZHStroyBoardFileManager get_xml_ContextByIdentity:[NewFileName stringByAppendingString:@"Ids"]]];
        
        // 1.首先开始创建控件  从父亲的subViews开始
        ZHStroyBoardToAndriodTool *stroyBoardToAndriodTool = [ZHStroyBoardToAndriodTool new];
        for (NSString *idStr in views) {
            NSString *fatherView = [ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
            
            NSMutableDictionary *originalConstraintDicM_Self = [NSMutableDictionary dictionary];
            [ZHStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
            
            //创建约束
            [stroyBoardToAndriodTool getCreatXMLCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self  withSelfConstraintDic:originalConstraintDicM_Self  isCell:YES  withDoneArrM:brotherOrderArrM  withCustomAndNameDic:self.customAndName  addToFatherView:fatherView  withIdAndOutletViewsDic:self.idAndOutletViews withProperty:self.idAndViewPropertys[idStr] WithidAndViewDic:self.customAndId defaultPropertyDicM:self.defaultPropertyDicM inViewRelationShipDic:viewRelationShipDic];
        }
        [ZHStoryboardTextManager addCodeText:[stroyBoardToAndriodTool getXMLCode] toStrM:[ZHStroyBoardFileManager get_xml_ContextByIdentity:NewFileName]];
        
        NSArray *tableViewCellDic = [ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        NSArray *collectionViewCellDic = [ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
    }
}

@end
