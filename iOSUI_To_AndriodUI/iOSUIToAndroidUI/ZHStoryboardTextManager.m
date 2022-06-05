#import "ZHStoryboardTextManager.h"
#import "ZHStroyBoardFileManager.h"
#import "ZHNSString.h"

static NSMutableDictionary *ZHStoryboardDicM;
static NSMutableDictionary *ZHStoryboardIDDicM;
static NSMutableDictionary *ZHStoryboardPropertyDicM;

@implementation ZHStoryboardTextManager
+ (NSMutableDictionary *)defaultDicM {
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStoryboardDicM == nil) {
            ZHStoryboardDicM = [NSMutableDictionary dictionary];
            
            NSMutableArray *viewsArr = [NSMutableArray array];
            [viewsArr addObject:@"<label "];
            [viewsArr addObject:@"<button "];
            [viewsArr addObject:@"<segmentedControl "];
            [viewsArr addObject:@"<textField "];
            [viewsArr addObject:@"<slider "];
            [viewsArr addObject:@"<tableViewCell "];
            [viewsArr addObject:@"<collectionViewCell "];
            [viewsArr addObject:@"<switch "];
            [viewsArr addObject:@"<activityIndicatorView "];
            [viewsArr addObject:@"<progressView "];
            [viewsArr addObject:@"<pageControl "];
            [viewsArr addObject:@"<stepper "];
            [viewsArr addObject:@"<tableView "];
            [viewsArr addObject:@"<imageView "];
            [viewsArr addObject:@"<collectionView "];
            [viewsArr addObject:@"<textView "];
            [viewsArr addObject:@"<scrollView "];
            [viewsArr addObject:@"<datePicker "];
            [viewsArr addObject:@"<pickerView "];
            [viewsArr addObject:@"<mapView "];
            [viewsArr addObject:@"<view "];
            [viewsArr addObject:@"<searchBar "];
            [viewsArr addObject:@"<webView "];
            [viewsArr addObject:@"<self.view "];      //特殊标识符
            [viewsArr addObject:@"<viewController "]; ////特殊标识符
            
            for (NSString *str in viewsArr) {
                [ZHStoryboardDicM setValue:[NSNumber numberWithInteger:0] forKey:str];
            }
        }
    });
    return ZHStoryboardDicM;
}
+ (NSMutableDictionary *)defaultIDDicM {
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStoryboardIDDicM == nil) { ZHStoryboardIDDicM = [NSMutableDictionary dictionary]; }
    });
    return ZHStoryboardIDDicM;
}
+ (NSMutableDictionary *)defaultPropertyDicM {
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStoryboardPropertyDicM == nil) {
            ZHStoryboardPropertyDicM = [NSMutableDictionary dictionary];
        }
    });
    return ZHStoryboardPropertyDicM;
}

+ (void)done {
    [ZHStoryboardIDDicM removeAllObjects];
    [ZHStoryboardPropertyDicM removeAllObjects];
    
    for (NSString *str in [[self defaultDicM] allKeys]) {
        [ZHStoryboardDicM setValue:[NSNumber numberWithInteger:0] forKey:str];
    }
}

+ (NSInteger)getAllViewCount {
    NSMutableArray *viewsArr = [NSMutableArray array];
    [viewsArr addObject:@"<label "];
    [viewsArr addObject:@"<button "];
    [viewsArr addObject:@"<segmentedControl "];
    [viewsArr addObject:@"<textField "];
    [viewsArr addObject:@"<slider "];
    [viewsArr addObject:@"<tableViewCell "];
    [viewsArr addObject:@"<collectionViewCell "];
    [viewsArr addObject:@"<switch "];
    [viewsArr addObject:@"<activityIndicatorView "];
    [viewsArr addObject:@"<progressView "];
    [viewsArr addObject:@"<pageControl "];
    [viewsArr addObject:@"<stepper "];
    [viewsArr addObject:@"<tableView "];
    [viewsArr addObject:@"<imageView "];
    [viewsArr addObject:@"<collectionView "];
    [viewsArr addObject:@"<textView "];
    [viewsArr addObject:@"<scrollView "];
    [viewsArr addObject:@"<datePicker "];
    [viewsArr addObject:@"<pickerView "];
    [viewsArr addObject:@"<mapView "];
    [viewsArr addObject:@"<view "];
    [viewsArr addObject:@"<searchBar "];
    [viewsArr addObject:@"<webView "];
    
    NSInteger count = 0;
    for (NSString *str in viewsArr) {
        NSNumber *num = ZHStoryboardDicM[str];
        count += [num integerValue];
    }
    return count;
}

/**为View打上所有标识符(默认顺序)*/
+ (NSString *)addCustomClassToAllViews:(NSString *)text {
    return [self addCustomClass:text needDealAdapterCell:YES];
}
+ (NSString *)addCustomClassToAllViewsForPureHandProject:(NSString *)text {
    return [self addCustomClass:text needDealAdapterCell:NO];
}
+ (NSString *)addCustomClass:(NSString *)text needDealAdapterCell:(BOOL)needDealAdapterCell {
    NSArray *arr         = [text componentsSeparatedByString:@"\n"];
    NSMutableArray *arrM = [NSMutableArray array];
    NSString *rowStr, *newRowStr, *viewIdenity;
    for (NSInteger i = 0; i < arr.count; i++) {
        rowStr = arr[i];
        
        viewIdenity = [self isView:rowStr];
        //如果这一行代表的是控件
        if (viewIdenity.length > 0) {
            if ([viewIdenity isEqualToString:@"<view "] && i > 0 &&
                ([arr[i - 1] rangeOfString:@"key=\""].location != NSNotFound ||
                 [arr[i - 1] rangeOfString:@"</layoutGuides>"].location != NSNotFound)) {
                    
                    //为了后面好设置约束,需要将这类view的id值设成特殊可识别的标识符
                    //取出id值
                    if ([rowStr rangeOfString:@"id=\""].location != NSNotFound) {
                        NSString *idStr =
                        [rowStr substringFromIndex:[rowStr rangeOfString:@"id=\""].location + 4];
                        idStr = [idStr substringToIndex:[idStr rangeOfString:@"\""].location];
                        NSString *viewCountIdenity =
                        [self getViewCountIdenityWithViewIdenity:@"<self.view "];
                        [[self defaultIDDicM] setValue:idStr forKey:viewCountIdenity];
                    }
                    [arrM addObject:[self replaceAllIdByCustomClass:rowStr]];
                    continue;
                }
            
            //如果这一行里面没有标识符CustomClass
            if ([rowStr rangeOfString:@" customClass"].location == NSNotFound) {
                if ([rowStr hasSuffix:@">"] == YES) {
                    newRowStr = [rowStr substringToIndex:rowStr.length - 1];
                    NSString *viewCountIdenity =
                    [self getViewCountIdenityWithViewIdenity:viewIdenity];
                    newRowStr = [newRowStr
                                 stringByAppendingFormat:@" customClass=\"%@\">", viewCountIdenity];
                    
                    if ([newRowStr rangeOfString:@" customClass=\""].location != NSNotFound &&
                        [newRowStr rangeOfString:@" id=\""].location != NSNotFound) {
                        NSString *customClass = [newRowStr
                                                 substringFromIndex:[newRowStr rangeOfString:@"customClass=\""]
                                                 .location +
                                                 13];
                        customClass = [customClass
                                       substringToIndex:[customClass rangeOfString:@"\""].location];
                        NSString *idStr = [newRowStr
                                           substringFromIndex:[newRowStr rangeOfString:@"id=\""].location + 4];
                        idStr = [idStr substringToIndex:[idStr rangeOfString:@"\""].location];
                        [[self defaultIDDicM] setValue:idStr forKey:customClass];
                    } else {
                        NSLog(@"出现小BUG 有的view没有打CustomClass =%@", newRowStr);
                    }
                    [arrM addObject:[self replaceAllIdByCustomClass:newRowStr]];
                    continue;
                }
            } else if ([rowStr rangeOfString:@" customClass=\""].location != NSNotFound &&
                       [rowStr rangeOfString:@" id=\""].location != NSNotFound) {
                NSString *customClass = [rowStr
                                         substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location + 13];
                customClass =
                [customClass substringToIndex:[customClass rangeOfString:@"\""].location];
                NSString *newCustomClass;
                if (needDealAdapterCell) {
                    newCustomClass = [self detailSpecialCustomClassLikeCell:rowStr];
                } else {
                    newCustomClass = [self noDetailSpecialCustomClassLikeCell:rowStr];
                }
                if (newCustomClass.length > 0) {
                    //替换
                    NSString *oldCustom = [@" customClass=\"" stringByAppendingString:customClass];
                    NSString *newCustom =
                    [@" customClass=\"" stringByAppendingString:newCustomClass];
                    rowStr = [rowStr stringByReplacingOccurrencesOfString:oldCustom
                                                               withString:newCustom];
                    customClass = newCustomClass;
                } else {
                    //算了,还是不把customClass当做名字了吧
                    NSString *newCustomClass =
                    [self getViewCountIdenityWithViewIdenity:viewIdenity];
                    [self.defaultPropertyDicM setValue:customClass forKey:newCustomClass];
                    
                    NSString *oldCustom = [@" customClass=\"" stringByAppendingString:customClass];
                    NSString *newCustom =
                    [@" customClass=\"" stringByAppendingString:newCustomClass];
                    rowStr = [rowStr stringByReplacingOccurrencesOfString:oldCustom
                                                               withString:newCustom];
                    customClass = newCustomClass;
                }
                NSString *idStr =
                [rowStr substringFromIndex:[rowStr rangeOfString:@"id=\""].location + 4];
                idStr = [idStr substringToIndex:[idStr rangeOfString:@"\""].location];
                [[self defaultIDDicM] setValue:idStr forKey:customClass];
            } else {
                NSLog(@"出现小BUG 有的view没有打CustomClass =%@", rowStr);
            }
        } else {
            
            //如果不是控件,就判断是不是ViewController,因为如果是的,就可以清空 CustomClass 和 id
            //的字典了
            
            NSString *tempStr = [ZHNSString removeSpaceBeforeAndAfterWithString:rowStr];
            if ([tempStr hasPrefix:@"<viewController "]) {
                [[self defaultIDDicM] removeAllObjects];
                
                //如果没有打上标识符
                if ([tempStr rangeOfString:@" customClass=\""].location == NSNotFound) {
                    
                    if ([tempStr hasSuffix:@"sceneMemberID=\"viewController\">"]) {
                        NSString *newRowStr = [rowStr stringByReplacingOccurrencesOfString:
                                               @"sceneMemberID=\"viewController\">"
                                                                                withString:@""];
                        NSString *viewCountIdenity =
                        [self getViewCountIdenityWithViewIdenity:@"<viewController "];
                        newRowStr = [newRowStr
                                     stringByAppendingString:[NSString
                                                              stringWithFormat:@"customClass=\"%@\"",
                                                              viewCountIdenity]];
                        newRowStr = [newRowStr
                                     stringByAppendingString:@" sceneMemberID=\"viewController\">"];
                        [arrM addObject:[self replaceAllIdByCustomClass:newRowStr]];
                        continue;
                    }
                }
            }
        }
        [arrM addObject:[self replaceAllIdByCustomClass:rowStr]];
    }
    return [arrM componentsJoinedByString:@"\n"];
}
/**为所有view的id打上标识符,对应的标识符就是CustomClass*/
+ (NSString *)replaceAllIdByCustomClass:(NSString *)text {
    for (NSString *customClass in [self defaultIDDicM]) {
        text = [text stringByReplacingOccurrencesOfString:[self defaultIDDicM][customClass]
                                               withString:customClass];
    }
    return text;
}

+ (NSString *)isView:(NSString *)text {
    
    NSMutableArray *viewsArr = [NSMutableArray array];
    [viewsArr addObject:@"<label "];
    [viewsArr addObject:@"<button "];
    [viewsArr addObject:@"<imageView "];
    [viewsArr addObject:@"<tableView "];
    [viewsArr addObject:@"<tableViewCell "];
    [viewsArr addObject:@"<collectionView "];
    [viewsArr addObject:@"<collectionViewCell "];
    [viewsArr addObject:@"<view "];
    [viewsArr addObject:@"<segmentedControl "];
    [viewsArr addObject:@"<textField "];
    [viewsArr addObject:@"<slider "];
    [viewsArr addObject:@"<switch "];
    [viewsArr addObject:@"<activityIndicatorView "];
    [viewsArr addObject:@"<progressView "];
    [viewsArr addObject:@"<pageControl "];
    [viewsArr addObject:@"<stepper "];
    [viewsArr addObject:@"<textView "];
    [viewsArr addObject:@"<scrollView "];
    [viewsArr addObject:@"<datePicker "];
    [viewsArr addObject:@"<pickerView "];
    [viewsArr addObject:@"<mapView "];
    [viewsArr addObject:@"<searchBar "];
    [viewsArr addObject:@"<webView "];
    NSString *newStr;
    
    text = [ZHNSString removeSpaceBeforeAndAfterWithString:text];
    for (NSString *str in viewsArr) {
        if ([text hasPrefix:str]) {
            newStr = str;
            return newStr;
        }
    }
    
    return @"";
}

+ (NSString *)removeDocSpace:(NSString *)text {
    if ([text rangeOfString:@". "].location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@". " withString:@"."];
        return [self removeDocSpace:text];
    }
    if ([text rangeOfString:@" ."].location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@" ." withString:@"."];
        return [self removeDocSpace:text];
    }
    if ([text rangeOfString:@" ="].location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@" =" withString:@"="];
        return [self removeDocSpace:text];
    }
    if ([text rangeOfString:@"= "].location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@"= " withString:@"="];
        return [self removeDocSpace:text];
    }
    return text;
}


+ (NSString *)removeSelfString:(NSString *)str{
    if ([str hasPrefix:@"self."]) {
        str = [str substringFromIndex:@"self.".length];
    }
    return str;
}

+ (NSString *)getFatherView:(NSString *)view
      inViewRelationShipDic:(NSDictionary *)viewRelationShipDic {
    for (NSString *fatherView in viewRelationShipDic) {
        NSArray *subViews = viewRelationShipDic[fatherView];
        if ([subViews containsObject:view]) { return fatherView; }
    }
    return @"";
}

/**判断是不是系统自动打上的标识符*/
+ (BOOL)isSystemIdStr:(NSString *)idStr {
    if (idStr.length == 10) {
        unichar ch1, ch2;
        ch1 = [idStr characterAtIndex:3];
        ch2 = [idStr characterAtIndex:6];
        if (ch1 == '-' && ch2 == '-') { return YES; }
    }
    return NO;
}

+ (NSString *)removeSelfString:(NSString *)str outletViewsDic:(NSDictionary *)idAndOutletViews{
    if ([str hasPrefix:@"self."]) {
        str = [str substringFromIndex:@"self.".length];
    }
    if ([idAndOutletViews isKindOfClass:[NSDictionary class]]) {
        NSString *outlet = idAndOutletViews[str];
        if (outlet.length > 0) {
            return outlet;
        }
    }
    return str;
}


/**第一个字母大写*/
+ (NSString *)upFirstCharacter:(NSString *)text {
    if (text.length <= 0) { return @""; }
    NSString *firstCharacter = [text substringToIndex:1];
    return [[firstCharacter uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
}
/**第一个字母小写写*/
+ (NSString *)lowerFirstCharacter:(NSString *)text {
    if (text.length <= 0) { return @""; }
    NSString *firstCharacter = [text substringToIndex:1];
    return [[firstCharacter lowercaseString] stringByAppendingString:[text substringFromIndex:1]];
}

+ (NSString *)detailSpecialCustomClassLikeCell:(NSString *)rowStr {
    NSMutableArray *viewsArr = [NSMutableArray array];
    [viewsArr addObject:@"<tableViewCell "];
    [viewsArr addObject:@"<collectionViewCell "];
    
    NSString *customClass =
    [rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location + 13];
    customClass = [customClass substringToIndex:[customClass rangeOfString:@"\""].location];
    
    customClass =
    [ZHStroyBoardFileManager getAdapterCollectionViewCellAndTableViewCellName:customClass];
    
    NSString *newCustomClass;
    NSString *text = [ZHNSString removeSpaceBeforeAndAfterWithString:rowStr];
    for (NSString *str in viewsArr) {
        if ([text hasPrefix:str]) {
            newCustomClass = str;
            newCustomClass = [newCustomClass substringFromIndex:1];
            newCustomClass = [newCustomClass substringToIndex:newCustomClass.length - 1];
            newCustomClass =
            [customClass stringByAppendingString:[self upFirstCharacter:newCustomClass]];
            break;
        }
    }
    return newCustomClass;
}

+ (NSString *)noDetailSpecialCustomClassLikeCell:(NSString *)rowStr {
    NSMutableArray *viewsArr = [NSMutableArray array];
    [viewsArr addObject:@"<tableViewCell "];
    [viewsArr addObject:@"<collectionViewCell "];
    
    NSString *customClass =
    [rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location + 13];
    customClass = [customClass substringToIndex:[customClass rangeOfString:@"\""].location];
    
    customClass = [ZHStroyBoardFileManager
                   getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:customClass];
    
    NSString *newCustomClass;
    NSString *text = [ZHNSString removeSpaceBeforeAndAfterWithString:rowStr];
    for (NSString *str in viewsArr) {
        if ([text hasPrefix:str]) {
            
            newCustomClass = str;
            newCustomClass = [newCustomClass substringFromIndex:1];
            newCustomClass = [newCustomClass substringToIndex:newCustomClass.length - 1];
            newCustomClass =
            [customClass stringByAppendingString:[self upFirstCharacter:newCustomClass]];
            break;
        }
    }
    
    return newCustomClass;
}

+ (NSString *)getViewCountIdenityWithViewIdenity:(NSString *)viewIdenity {
    NSString *viewCountIdenity = viewIdenity;
    if ([viewCountIdenity hasPrefix:@"<"]) {
        viewCountIdenity = [viewCountIdenity substringFromIndex:1];
    }
    if ([viewCountIdenity hasSuffix:@" "]) {
        viewCountIdenity = [viewCountIdenity substringToIndex:viewCountIdenity.length - 1];
    }
    NSNumber *num = [self defaultDicM][viewIdenity];
    if (num) {
        NSInteger count = [num integerValue];
        
        //处理特殊的customClass，因为cell上一旦没有打上对应cell的标识，就会找不到文件，不好处理（TableviewCell，CollectionViewCell）
        
        NSArray *specialViews = @[ @"tableViewCell", @"collectionViewCell" ];
        
        NSString *specialViewFirst = @"";
        for (NSString *specialView in specialViews) {
            if ([viewCountIdenity hasPrefix:specialView]) {
                specialViewFirst = [[specialView substringToIndex:1] uppercaseString];
                break;
            }
        }
        
        if (specialViewFirst.length > 0) {
            viewCountIdenity =
            [viewCountIdenity stringByAppendingFormat:@"%@%ld", specialViewFirst, count + 1];
        } else
            viewCountIdenity = [viewCountIdenity stringByAppendingFormat:@"%ld", count + 1];
        
        count++;
        [self defaultDicM][viewIdenity] = [NSNumber numberWithInteger:count];
        
        for (NSString *specialView in specialViews) {
            if ([viewCountIdenity hasPrefix:specialView]) {
                viewCountIdenity = [viewCountIdenity substringFromIndex:specialView.length];
                viewCountIdenity =
                [viewCountIdenity stringByAppendingString:[self upFirstCharacter:specialView]];
                break;
            }
        }
        
        return viewCountIdenity;
    }
    return viewCountIdenity;
}

/**判断是否是特殊控件*/
+ (BOOL)isTableViewOrCollectionView:(NSString *)text {
    text = [self removeSuffixNumber:text];
    if ([text isEqualToString:@"tableView"] || [text isEqualToString:@"collectionView"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTableView:(NSString *)text {
    text = [self removeSuffixNumber:text];
    if ([text isEqualToString:@"tableView"]) { return YES; }
    return NO;
}
+ (BOOL)isCollectionView:(NSString *)text {
    text = [self removeSuffixNumber:text];
    if ([text isEqualToString:@"collectionView"]) { return YES; }
    return NO;
}
+ (NSInteger)getTableViewCount:(NSArray *)views {
    NSInteger count = 0;
    for (NSString *view in views) {
        if ([self isTableView:view]) { count++; }
    }
    return count;
}
+ (NSInteger)getCollectionViewCount:(NSArray *)views {
    NSInteger count = 0;
    for (NSString *view in views) {
        if ([self isCollectionView:view]) { count++; }
    }
    return count;
}
+ (NSArray *)getTableView:(NSArray *)views {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *view in views) {
        if ([self isTableView:view]) { [arrM addObject:view]; }
    }
    return arrM;
}
+ (NSArray *)getCollectionView:(NSArray *)views {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *view in views) {
        if ([self isCollectionView:view]) { [arrM addObject:view]; }
    }
    return arrM;
}
+ (BOOL)hasSuffixNumber:(NSString *)text {
    unichar ch = [text characterAtIndex:text.length - 1];
    if (ch >= '0' && ch <= '9') { return YES; }
    return NO;
}
+ (NSString *)removeSuffixNumber:(NSString *)text {
    unichar ch = [text characterAtIndex:text.length - 1];
    while (ch >= '0' && ch <= '9') {
        text = [text substringToIndex:text.length - 1];
        ch   = [text characterAtIndex:text.length - 1];
    }
    return text;
}

/**往最某个代码后面追加*/
+ (BOOL)addCode:(NSString *)code ToTargetAfter:(NSString *)target toText:(NSMutableString *)text {
    if ([text rangeOfString:target].location == NSNotFound) { return NO; }
    
    NSInteger endIndex    = [text rangeOfString:target].location + target.length;
    NSString *startString = [text substringToIndex:endIndex];
    NSString *endString   = [text substringFromIndex:endIndex];
    
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:startString];
    [strM appendString:@"\n"];
    [strM appendString:code];
    [strM appendString:@"\n"];
    [strM appendString:endString];
    [text setString:strM];
    
    return YES;
}

+ (void)addCodeText:(NSString *)code toStrM:(NSMutableString *)strM{
    [strM appendString:@"\n"];
    [strM appendString:code];
    [strM appendString:@"\n"];
}

+ (void)addCodeTexts:(NSArray *)codes toStrM:(NSMutableString *)strM{
    for (NSString *code in codes) {
        [self addCodeText:code toStrM:strM];
    }
}

@end
