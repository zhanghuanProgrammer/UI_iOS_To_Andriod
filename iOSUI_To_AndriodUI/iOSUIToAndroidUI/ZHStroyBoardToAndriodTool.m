
#import "ZHStroyBoardToAndriodTool.h"
#import "ZHStoryboardTextManager.h"
#import "ZHRepearDictionary.h"
#import "ZHJson.h"

@interface ZHStroyBoardToAndriodTool ()

@property (nonatomic,strong)ZHRepearDictionary *tree;
@property (nonatomic,strong)NSMutableArray *xmlUp;
@property (nonatomic,strong)NSMutableDictionary *viewOrderRank;//控件输出顺序,先上后下,先左后右

@end

@implementation ZHStroyBoardToAndriodTool

- (instancetype)init{
    self = [super init];
    if (self) {
        self.tree = [ZHRepearDictionary new];
        self.viewOrderRank = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (NSString *)getXMLCode{
    self.xmlUp = [NSMutableArray array];
    if (self.tree) {
        [self getXMLRecursive:@"" index:0];
    }
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    if(self.xmlUp.count > 0)[strM appendString:[self.xmlUp componentsJoinedByString:@"\n"]];
    return strM;
}

- (void)getXMLRecursive:(NSString *)fatherView index:(NSInteger)index{
    
    NSMutableArray *ordersRealName = [NSMutableArray array];
    for (NSString *realName in self.tree.dicM) {
        NSDictionary *dicXml = self.tree.dicM[realName];
        NSString *fatherViewSub = dicXml[@"fatherView"];
        
        if (fatherView.length <= 0) {
            if ([fatherViewSub isEqualToString:@"self.view"]) {
                [ordersRealName addObject:realName];
            }
            if ([fatherViewSub isEqualToString:@"self.contentView"]) {
                [ordersRealName addObject:realName];
            }
        }else{
            if ([fatherViewSub isEqualToString:fatherView]) {
                [ordersRealName addObject:realName];
            }
        }
    }
    //排序
    [ordersRealName setArray:[self dealOrderRank:ordersRealName]];
    
    for (NSString *realName in ordersRealName) {
        
        NSDictionary *dicXml = self.tree.dicM[realName];
        NSString *fatherViewSub = dicXml[@"fatherView"];
        
        if (fatherView.length <= 0) {
            if ([fatherViewSub isEqualToString:@"self.view"]) {
                [self creatXMLCodeNode:dicXml realName:[ZHRepearDictionary getKeyForKey:realName] index:index];
            }
            if ([fatherViewSub isEqualToString:@"self.contentView"]) {
                [self creatXMLCodeNode:dicXml realName:[ZHRepearDictionary getKeyForKey:realName] index:index];
            }
        }else{
            if ([fatherViewSub isEqualToString:fatherView]) {
                [self creatXMLCodeNode:dicXml realName:[ZHRepearDictionary getKeyForKey:realName] index:index];
            }
        }
    }
}

- (void)creatXMLCodeNode:(NSDictionary *)node realName:(NSString *)realName index:(NSInteger)index{
    NSString *viewCategoryName_deault = node[@"viewCategoryName_deault"];
    [self.xmlUp addObject:[NSString stringWithFormat:@"\n%@<%@",[self getIndentation:index],viewCategoryName_deault]];
    [self addOrderXMLCodeNode:node index:index];
    [self.xmlUp addObject:[NSString stringWithFormat:@"%@>",[self getIndentation:index+1]]];
    [self getXMLRecursive:realName index:index+1];
    [self.xmlUp addObject:[NSString stringWithFormat:@"\n%@</%@>",[self getIndentation:index],viewCategoryName_deault]];
}

- (void)addOrderXMLCodeNode:(NSDictionary *)node index:(NSInteger)index{
    NSMutableDictionary *tempDicM = [[ZHJson new] copyMutableDicFromDictionary:node];
    for (NSString *key in [self orders]) {
        if (tempDicM[key] != nil) {
            [self.xmlUp addObject:[NSString stringWithFormat:@"%@android:%@=\"%@\"",[self getIndentation:index+1],key,tempDicM[key]]];
            [tempDicM removeObjectForKey:key];
        }
    }
    for (NSString *key in tempDicM) {
        if([key isEqualToString:@"viewCategoryName"] || [key isEqualToString:@"viewCategoryName_deault"] || [key isEqualToString:@"fatherView"])continue;
        [self.xmlUp addObject:[NSString stringWithFormat:@"%@android:%@=\"%@\"",[self getIndentation:index+1],key,node[key]]];
    }
}

- (NSArray *)orders{
    return @[
        @"id",
        @"layout_below",
        @"layout_above",
        @"layout_toLeftOf",
        @"layout_toRightOf",
        @"layout_width",
        @"layout_height",
        @"layout_marginTop",
        @"layout_marginBottom",
        @"layout_marginLeft",
        @"layout_marginRight",
        @"layout_centerHorizontal",
        @"layout_centerVertical",
        @"layout_alignParentRight",
        @"layout_alignParentBottom",
        @"text",
        @"textSize",
        @"textColor",
        @"textStyle",
        @"textAlignment",
        @"fontFamily",
        @"hint",
        @"maxLines",
        @"src",
        @"background",
    ];
}

- (void)initOrderRankWithRect:(NSDictionary *)idAndViewPropertys
             idAndOutletViews:(NSDictionary *)idAndOutletViews
                        views:(NSArray *)views{
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *idStr in views) {
        NSString *viewName = idStr;
        NSString *outlet = idAndOutletViews[viewName];
        if (outlet.length > 0) {
            viewName = outlet;
        }
        ViewProperty *property = idAndViewPropertys[idStr];
        if (viewName && property) {
            [arrM addObject:@{@"viewName":viewName,@"x":property.rect_x,@"y":property.rect_y}];
        }
    }
    [arrM setArray:[arrM sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = obj1;
        NSDictionary *dic2 = obj2;
        double x1 = [dic1[@"x"] doubleValue];
        double x2 = [dic2[@"x"] doubleValue];
        double y1 = [dic1[@"y"] doubleValue];
        double y2 = [dic2[@"y"] doubleValue];
        if (y1 > y2) {
            return YES;
        }else if (y1 < y2) {
            return NO;
        }
        else{
            if (x1 > x2) {
                return YES;
            }else if (x1 < x2) {
                return NO;
            }
        }
        return YES;
    }]];
    //printf("%s\n",[[arrM jsonPrettyStringEncoded] UTF8String]);
    for (NSInteger i=0; i<arrM.count - 1; i++) {
        for (NSInteger j=i+1; j<arrM.count; j++) {
            NSDictionary *view_i = arrM[i];
            NSDictionary *view_j = arrM[j];
            
            NSString *name1 = view_i[@"viewName"];
            NSString *name2 = view_j[@"viewName"];
            NSString *rank = [NSString stringWithFormat:@"%@->%@",name1,name2];
            [self.viewOrderRank setValue:@"YES" forKey:rank];
        }
    }
    //printf("%s\n",[[self.viewOrderRank jsonPrettyStringEncoded] UTF8String]);
}

- (NSArray *)dealOrderRank:(NSArray *)views{
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=0; i<views.count; i++) {
        for (NSInteger j=i+1; j<views.count; j++) {
            NSString *view_i = views[i];
            NSString *view_j = views[j];
            NSString *i_j = [NSString stringWithFormat:@"%@->%@",view_i,view_j];
            NSString *j_i = [NSString stringWithFormat:@"%@->%@",view_j,view_i];
            if (self.viewOrderRank[i_j]) {
                if(![arrM containsObject:view_i])[arrM addObject:view_i];
                if(![arrM containsObject:view_j])[arrM addObject:view_j];
                //保证顺序
                NSInteger index_i = [arrM indexOfObject:view_i];
                NSInteger index_j = [arrM indexOfObject:view_j];
                if (index_i > index_j) {
                    [arrM removeObject:view_i];
                    [arrM insertObject:view_i atIndex:index_j];
                }
            }else if (self.viewOrderRank[j_i]) {
                if(![arrM containsObject:view_j])[arrM addObject:view_j];
                if(![arrM containsObject:view_i])[arrM addObject:view_i];
                //保证顺序
                NSInteger index_j = [arrM indexOfObject:view_j];
                NSInteger index_i = [arrM indexOfObject:view_i];
                if (index_j > index_i) {
                    [arrM removeObject:view_j];
                    [arrM insertObject:view_j atIndex:index_i];
                }
            }
        }
    }
    //没有顺序的,往后补上,防止漏掉
    for (NSInteger i=0; i<views.count; i++) {
        NSString *view_i = views[i];
        if(![arrM containsObject:view_i])[arrM addObject:view_i];
    }
    return arrM;
}

- (NSString *)getIndentation:(NSInteger)index{
    NSMutableString *strM = [NSMutableString string];
    for (NSInteger i=0; i<index; i++) {
        [strM appendString:@"    "];
    }
    return strM;
}

- (void)setAttribute:(NSString *)attribute value:(NSString *)value selfName:(NSString *)selfName secondItem:(NSString *)secondItem xmlDicM:(NSMutableDictionary *)xmlDicM inViewRelationShipDic:(NSDictionary *)viewRelationShipDic withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews{
    NSString *value_ori = value;
    if(value.length > 0){
        value = [value stringByAppendingString:@"dp"];
    }
    else value = @"0dp";
    NSString *fatherView = [ZHStoryboardTextManager getFatherView:selfName inViewRelationShipDic:viewRelationShipDic];
    BOOL isSelfView = [fatherView isEqualToString:secondItem];
    NSString *outlet = idAndOutletViews[secondItem];
    if(outlet.length <= 0)outlet = secondItem;
    if ([attribute isEqualToString:@"top"]) {
        xmlDicM[@"layout_marginTop"] = value;
        if (!isSelfView) {
            xmlDicM[@"layout_below"] = [NSString stringWithFormat:@"@id/%@",outlet];
        }
    }
    if ([attribute isEqualToString:@"bottom"]) {
        if(value_ori.length > 0 && [value_ori intValue] < 0) value = [NSString stringWithFormat:@"%d",ABS([value_ori intValue])];//ios 相对布局特殊情况
        xmlDicM[@"layout_marginBottom"] = value;
        if (!isSelfView) {
            //并且是同层级的
            xmlDicM[@"layout_above"] = [NSString stringWithFormat:@"@id/%@",outlet];
        }
    }
    if ([attribute isEqualToString:@"leading"]) {
        xmlDicM[@"layout_marginLeft"] = value;
        if (!isSelfView) {
            //并且是同层级的
            xmlDicM[@"layout_toRightOf"] = [NSString stringWithFormat:@"@id/%@",outlet];
        }
    }
    if ([attribute isEqualToString:@"trailing"]) {
        if(value_ori.length > 0 && [value_ori intValue] < 0) value = [NSString stringWithFormat:@"%d",ABS([value_ori intValue])];//ios 相对布局特殊情况
        xmlDicM[@"layout_marginRight"] = value;
        if (!isSelfView) {
            //并且是同层级的
            xmlDicM[@"layout_toLeftOf"] = [NSString stringWithFormat:@"@id/%@",outlet];
        }
    }
    if ([attribute isEqualToString:@"width"]) {
        if (value_ori.length > 0) {
            xmlDicM[@"layout_width"] = value;
        }else{
            xmlDicM[@"layout_width"] = @"wrap_content";
        }
    }
    if ([attribute isEqualToString:@"height"]) {
        if (value_ori.length > 0) {
            xmlDicM[@"layout_height"] = value;
        }else{
            xmlDicM[@"layout_height"] = @"wrap_content";
        }
    }
    if ([attribute isEqualToString:@"centerX"]) {
        if (isSelfView) {
            xmlDicM[@"layout_centerHorizontal"] = @"true";
        }else{
            //同层级的centerX不处理
        }
    }
    if ([attribute isEqualToString:@"centerY"]) {
        if (isSelfView) {
            xmlDicM[@"layout_centerVertical"] = @"true";
        }else{
            //同层级的centerY不处理
        }
    }
}

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
           inViewRelationShipDic:(NSDictionary *)viewRelationShipDic{
    //这里有个宗旨,就是,iOS几乎全是相对布局,没有线性布局的说法,所以,但是安卓的线性布局更灵活,所以,只需要对应的边距和属性就行,生成出来,稍微调整一下就ok了
    
    NSString *realName = viewName;
    BOOL haveRealName = NO;
    if ([idAndOutletViews isKindOfClass:[NSDictionary class]]) {
        NSString *outlet = idAndOutletViews[viewName];
        if (outlet.length > 0) {
            realName = outlet;
            haveRealName = YES;
        }
    }
    NSString *fatherViewName = fatherView;
    if ([idAndOutletViews isKindOfClass:[NSDictionary class]]) {
        NSString *outlet = idAndOutletViews[fatherView];
        if (outlet.length > 0) {
            fatherViewName = outlet;
        }
    }
    NSMutableDictionary *xmlDicM = [NSMutableDictionary dictionary];
    [self.tree setValue:xmlDicM forKey:realName];
    xmlDicM[@"id"] = [@"@+id/" stringByAppendingString:realName];
    xmlDicM[@"fatherView"] = fatherViewName;
    
    NSString *viewCategoryName = @"";
    if (defaultPropertyDicM[idStr]) {
        viewCategoryName = defaultPropertyDicM[idStr];
        xmlDicM[@"viewCategoryName_deault"] = [ZHStroyBoardToAndriodTool iosViewClassToAndroidViewClass:viewCategoryName];
    }
    else {
        viewCategoryName = [ZHStroyBoardToAndriodTool iosViewClassToAndroidViewClass:customAndNameDic[idStr]];
        xmlDicM[@"viewCategoryName_deault"] = viewCategoryName;
    }
    xmlDicM[@"viewCategoryName"] = viewCategoryName;
    
    [self getCodePropertysForViewName:viewName WithidAndViewDic:idAndViewDic withCustomAndName:customAndNameDic withProperty:property xmlDicM:xmlDicM];
    
    NSArray *constraintArr = constraintDic[viewName];
    if (constraintArr.count > 0) {
        for (NSDictionary *constraintSubDic in constraintArr) {
            
            //每一个具体的约束
            NSString *firstAttribute  = constraintSubDic[@"firstAttribute"];
            NSString *firstItem       = constraintSubDic[@"firstItem"];
            NSString *secondAttribute = constraintSubDic[@"secondAttribute"];
            NSString *secondItem      = constraintSubDic[@"secondItem"];
            //NSString *multiplier      = constraintSubDic[@"multiplier"];
            NSString *constant        = constraintSubDic[@"constant"];
            NSString *idStr           = constraintSubDic[@"id"];
            
            if ([firstItem hasPrefix:@"self.view"]) { firstItem = @"self.view"; }
            if ([secondItem hasPrefix:@"self.view"]) { secondItem = @"self.view"; }
            
            if ([firstItem hasSuffix:@"CollectionViewCell"] ||
                [firstItem hasSuffix:@"TableViewCell"]) {
                firstItem = @"self.contentView";
            }
            if ([secondItem hasSuffix:@"CollectionViewCell"] ||
                [secondItem hasSuffix:@"TableViewCell"]) {
                secondItem = @"self.contentView";
            }
            
            if ([self isSystemIdStr:firstItem]) {
                if (isCell) {
                    firstItem = @"self.contentView";
                } else {
                    firstItem = fatherView;
                }
            }
            
            if ([self isSystemIdStr:secondItem]) {
                if (isCell) {
                    secondItem = @"self.contentView";
                } else {
                    secondItem = fatherView;
                }
            }
            
            // 1.如果该约束的第一对象是自己
            if ([firstItem isEqualToString:viewName]) {
                if (secondItem.length > 0) { //第2对象存在
                    if (secondAttribute.length > 0) {
                        if ([secondItem hasPrefix:@"self."]) {
                            if (constant.length > 0) {
                                [self setAttribute:firstAttribute value:constant selfName:viewName secondItem:secondItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            } else {
                                [self setAttribute:firstAttribute value:constant selfName:viewName secondItem:secondItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            }
                        } else {
                            if (constant.length > 0) {
                                [self setAttribute:firstAttribute value:constant selfName:viewName secondItem:secondItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            } else {
                                [self setAttribute:firstAttribute value:constant selfName:viewName secondItem:secondItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            }
                        }
                    } else {
                        NSLog(@"%@", @"约束很奇怪  有secondItem 没有 secondAttribute");
                    }
                    
                } else { //第2对象不存在
                    if (constant.length > 0) {
                        [self setAttribute:firstAttribute value:constant selfName:viewName secondItem:secondItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                    } else {
                        NSLog(@"%@", @"约束很奇怪  宽高没有值");
                    }
                }
                
            } else if ([secondItem isEqualToString:viewName]) {
                
                if (firstItem.length > 0 && [self isSystemIdStr:firstItem] == NO) {
                    if (firstAttribute.length > 0) {
                        
                        if ([firstItem hasPrefix:@"self."]) {
                            if (constant.length > 0) {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            } else {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            }
                        } else {
                            if (constant.length > 0) {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            } else {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            }
                        }
                        
                    } else {
                        NSLog(@"%@", @"约束很奇怪  有firstItem 没有 firstAttribute");
                    }
                } else {
                    if (selfConstraintDic[viewName] != nil) {
                        BOOL isSelfConstraint = NO;
                        for (NSDictionary *dicTemp in selfConstraintDic[viewName]) {
                            if ([dicTemp[@"id"] isEqualToString:idStr]) {
                                isSelfConstraint = YES;
                                break;
                            }
                        }
                        if (isSelfConstraint == YES) {
                            if (firstItem.length <= 0) {
                                if (isCell) {
                                    firstItem = viewName;
                                } else {
                                    firstItem = fatherView;
                                }
                            }
                            if (constant.length > 0) {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            } else {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            }
                        } else {
                            if (firstItem.length <= 0) {
                                if (firstAttribute.length > 0 && secondAttribute.length > 0) {
                                    firstItem = fatherView;
                                } else {
                                    if (isCell) {
                                        firstItem = @"self.contentView";
                                    } else {
                                        firstItem = @"self.view";
                                    }
                                }
                            }
                            if (constant.length > 0) {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            } else {
                                [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                            }
                        }
                    } else {
                        if (firstItem.length <= 0) {
                            if (firstAttribute.length > 0 && secondAttribute.length > 0) {
                                firstItem = fatherView;
                            } else {
                                if (isCell) {
                                    firstItem = @"self.contentView";
                                } else {
                                    firstItem = @"self.view";
                                }
                            }
                        }
                        if (constant.length > 0) {
                            [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                        } else {
                            [self setAttribute:secondAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                        }
                    }
                }
                
            } else {
                if (firstAttribute.length > 0) {
                    [self setAttribute:firstAttribute value:constant selfName:viewName secondItem:firstItem xmlDicM:xmlDicM inViewRelationShipDic:viewRelationShipDic withIdAndOutletViewsDic:idAndOutletViews];
                } else {
                    NSLog(@"%@", @"约束很奇怪  没有firstAttribute");
                }
            }
        }
    }
    
    if(xmlDicM[@"layout_marginLeft"] || xmlDicM[@"layout_marginRight"]){
        if (xmlDicM[@"layout_marginLeft"] && xmlDicM[@"layout_marginRight"]) {
            //do nothing
        }else if (xmlDicM[@"layout_marginLeft"]){
            //do nothing
        }else if (xmlDicM[@"layout_marginRight"]){
            xmlDicM[@"layout_alignParentRight"] = @"true";
        }
    }else{
        if (xmlDicM[@"layout_centerHorizontal"]) {
            //do nothing
        }else{
            xmlDicM[@"layout_marginLeft"] = [NSString stringWithFormat:@"%@dp",property.rect_x];
        }
    }
    if(xmlDicM[@"layout_marginTop"] || xmlDicM[@"layout_marginBottom"]){
        if (xmlDicM[@"layout_marginTop"] && xmlDicM[@"layout_marginBottom"]) {
            //do nothing
        }else if (xmlDicM[@"layout_marginTop"]){
            //do nothing
        }else if (xmlDicM[@"layout_marginBottom"]){
            xmlDicM[@"layout_alignParentBottom"] = @"true";
        }
    }else{
        if (xmlDicM[@"layout_centerVertical"]) {
            //do nothing
        }else{
            xmlDicM[@"layout_marginTop"] = [NSString stringWithFormat:@"%@dp",property.rect_y];
        }
    }
    if(xmlDicM[@"layout_width"] == nil) {
        if(xmlDicM[@"layout_marginLeft"] && xmlDicM[@"layout_marginRight"]){
            xmlDicM[@"layout_width"] = @"match_parent";
        }else{
            xmlDicM[@"layout_width"] = @"wrap_content";
        }
    }
    if(xmlDicM[@"layout_height"] == nil) {
        if(xmlDicM[@"layout_marginTop"] && xmlDicM[@"layout_marginBottom"]){
            xmlDicM[@"layout_height"] = @"match_parent";
        }else{
            xmlDicM[@"layout_height"] = @"wrap_content";
        }
    }
}

/**判断是不是系统自动打上的标识符*/
- (BOOL)isSystemIdStr:(NSString *)idStr {
    if (idStr.length == 10) {
        unichar ch1, ch2;
        ch1 = [idStr characterAtIndex:3];
        ch2 = [idStr characterAtIndex:6];
        if (ch1 == '-' && ch2 == '-') { return YES; }
    }
    return NO;
}

/**根据property属性生成代码*/
- (void)getCodePropertysForViewName:(NSString *)viewName
                   WithidAndViewDic:(NSDictionary *)idAndViewDic
                  withCustomAndName:(NSDictionary *)customAndNameDic
                       withProperty:(ViewProperty *)property
                            xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self recursiveGetPropertysCodeForViewName:viewName
                                  withProperty:property
                                 withIdAndName:idAndViewDic
                             withCustomAndName:customAndNameDic
                                       xmlDicM:xmlDicM];
}

- (void)recursiveGetPropertysCodeForViewName:(NSString *)viewName
                                withProperty:(ViewProperty *)property
                               withIdAndName:(NSDictionary *)idAndNameDic
                           withCustomAndName:(NSDictionary *)customAndNameDic
                                     xmlDicM:(NSMutableDictionary *)xmlDicM {
    NSString *categoryView = customAndNameDic[viewName];
    
    if ([categoryView isEqualToString:@"label"]) {
        [self getPropertyCodeForLabel:viewName
                         withProperty:property
                        withIdAndName:idAndNameDic
                           xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"button"]) {
        [self getPropertyCodeForButton:viewName
                          withProperty:property
                         withIdAndName:idAndNameDic
                            xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"imageView"]) {
        [self getPropertyCodeForImageView:viewName
                             withProperty:property
                            withIdAndName:idAndNameDic
                               xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"tableView"]) {
        [self getPropertyCodeForTableView:viewName
                             withProperty:property
                            withIdAndName:idAndNameDic
                               xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"collectionView"]) {
        [self getPropertyCodeForCollectionView:viewName
                                  withProperty:property
                                 withIdAndName:idAndNameDic
                                    xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"view"]) {
        [self getPropertyCodeForView:viewName
                        withProperty:property
                       withIdAndName:idAndNameDic
                          xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"segmentedControl"]) {
        [self getPropertyCodeForSegmentedControl:viewName
                                    withProperty:property
                                   withIdAndName:idAndNameDic
                                      xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"textField"]) {
        [self getPropertyCodeForTextField:viewName
                             withProperty:property
                            withIdAndName:idAndNameDic
                               xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"switch"]) {
        [self getPropertyCodeForSwitch:viewName
                          withProperty:property
                         withIdAndName:idAndNameDic
                            xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"activityIndicatorView"]) {
        [self getPropertyCodeForActivityIndicatorView:viewName
                                         withProperty:property
                                        withIdAndName:idAndNameDic
                                           xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"progressView"]) {
        [self getPropertyCodeForProgressView:viewName
                                withProperty:property
                               withIdAndName:idAndNameDic
                                  xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"pageControl"]) {
        [self getPropertyCodeForPageControl:viewName
                               withProperty:property
                              withIdAndName:idAndNameDic
                                 xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"stepper"]) {
        [self getPropertyCodeForStepper:viewName
                           withProperty:property
                          withIdAndName:idAndNameDic
                             xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"textView"]) {
        [self getPropertyCodeForTextView:viewName
                            withProperty:property
                           withIdAndName:idAndNameDic
                              xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"scrollView"]) {
        [self getPropertyCodeForScrollView:viewName
                              withProperty:property
                             withIdAndName:idAndNameDic
                                xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"datePicker"]) {
        [self getPropertyCodeForDatePicker:viewName
                              withProperty:property
                             withIdAndName:idAndNameDic
                                xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"pickerView"]) {
        [self getPropertyCodeForPickerView:viewName
                              withProperty:property
                             withIdAndName:idAndNameDic
                                xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"mapView"]) {
        [self getPropertyCodeForMapView:viewName
                           withProperty:property
                          withIdAndName:idAndNameDic
                             xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"searchBar"]) {
        [self getPropertyCodeForSearchBar:viewName
                             withProperty:property
                            withIdAndName:idAndNameDic
                               xmlDicM:xmlDicM];
    }
    if ([categoryView isEqualToString:@"webView"]) {
        [self getPropertyCodeForWebView:viewName
                           withProperty:property
                          withIdAndName:idAndNameDic
                             xmlDicM:xmlDicM];
    }
}

- (void)getPropertyCodeForLabel:(NSString *)viewName
                   withProperty:(ViewProperty *)property
                  withIdAndName:(NSDictionary *)idAndNameDic
                     xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"text",@"textAlignment",@"adjustsFontSizeToFit",@"numberOfLines",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.text.length > 0)xmlDicM[@"text"] = property.text;
    if (property.textAlignment.length > 0 && [property.textAlignment isEqualToString:@"natural"] == NO)
        xmlDicM[@"textAlignment"] = property.textAlignment;
    if (property.numberOfLines.length > 0)xmlDicM[@"maxLines"] = property.numberOfLines;
    if (property.pointSize.length > 0)xmlDicM[@"textSize"] = [property.pointSize stringByAppendingString:@"dp"];
    if (property.textStyle.length > 0)xmlDicM[@"textStyle"] = property.textStyle;
    if (property.textColor_red.length > 0 || property.textColor_green.length > 0 ||
        property.textColor_blue.length > 0) {
        xmlDicM[@"textColor"] = [self hexadecimalFromUIColor:[NSColor colorWithRed:[[self getThreedigits:property.textColor_red] doubleValue] green:[[self getThreedigits:property.textColor_green] doubleValue] blue:[[self getThreedigits:property.textColor_blue] doubleValue] alpha:[property.textColor_alpha doubleValue]]];
    }
    xmlDicM[@"fontFamily"] = @"sans-serif";
}
- (void)getPropertyCodeForButton:(NSString *)viewName
                    withProperty:(ViewProperty *)property
                   withIdAndName:(NSDictionary *)idAndNameDic
                      xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"title",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.title.length > 0)xmlDicM[@"text"] = property.title;
    if (property.pointSize.length > 0)xmlDicM[@"textSize"] = [property.pointSize stringByAppendingString:@"dp"];
    if (property.textStyle.length > 0)xmlDicM[@"textStyle"] = property.textStyle;
    
    if (property.titleColor_red.length > 0 || property.titleColor_green.length > 0 ||
        property.titleColor_blue.length > 0) {
        xmlDicM[@"textColor"] = [self hexadecimalFromUIColor:[NSColor colorWithRed:[[self getThreedigits:property.titleColor_red] doubleValue] green:[[self getThreedigits:property.titleColor_green] doubleValue] blue:[[self getThreedigits:property.titleColor_blue] doubleValue] alpha:[property.titleColor_alpha doubleValue]]];
    }
    xmlDicM[@"fontFamily"] = @"sans-serif";
}
- (void)getPropertyCodeForImageView:(NSString *)viewName
                       withProperty:(ViewProperty *)property
                      withIdAndName:(NSDictionary *)idAndNameDic
                         xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"image",@"contentMode"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.image.length > 0){
        //去后缀
        NSString *imageName = [property.image stringByDeletingPathExtension];
        xmlDicM[@"src"] = [NSString stringWithFormat:@"@mipmap/%@",imageName];
    }
}
- (void)getPropertyCodeForTableView:(NSString *)viewName
                       withProperty:(ViewProperty *)property
                      withIdAndName:(NSDictionary *)idAndNameDic
                         xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"style",@"rowHeight"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForCollectionView:(NSString *)viewName
                            withProperty:(ViewProperty *)property
                           withIdAndName:(NSDictionary *)idAndNameDic
                              xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForView:(NSString *)viewName
                  withProperty:(ViewProperty *)property
                 withIdAndName:(NSDictionary *)idAndNameDic
                    xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForSegmentedControl:(NSString *)viewName
                              withProperty:(ViewProperty *)property
                             withIdAndName:(NSDictionary *)idAndNameDic
                                xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.segment.length > 0) {
        NSArray *tempArr = [property.segment componentsSeparatedByString:@"_$_"];
        if (tempArr.count > 0) {
            NSMutableString *segments = [NSMutableString string];
            for (NSInteger i = 0; i < tempArr.count; i++) {
                NSString *str = tempArr[i];
                [segments appendFormat:@"@\"%@\"", str];
                if (i < tempArr.count - 1) { [segments appendString:@","]; }
            }
        }
    }
}
- (void)getPropertyCodeForTextField:(NSString *)viewName
                       withProperty:(ViewProperty *)property
                      withIdAndName:(NSDictionary *)idAndNameDic
                         xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"textAlignment",@"clearButtonMode",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.pointSize.length > 0)xmlDicM[@"textSize"] = [property.pointSize stringByAppendingString:@"dp"];
    if (property.textStyle.length > 0)xmlDicM[@"textStyle"] = property.textStyle;
    if (property.textColor_red.length > 0 || property.textColor_green.length > 0 ||
        property.textColor_blue.length > 0) {
        xmlDicM[@"textColor"] = [self hexadecimalFromUIColor:[NSColor colorWithRed:[[self getThreedigits:property.textColor_red] doubleValue] green:[[self getThreedigits:property.textColor_green] doubleValue] blue:[[self getThreedigits:property.textColor_blue] doubleValue] alpha:[property.textColor_alpha doubleValue]]];
    }
    xmlDicM[@"fontFamily"] = @"sans-serif";
}
- (void)getPropertyCodeForSlider:(NSString *)viewName
                    withProperty:(ViewProperty *)property
                   withIdAndName:(NSDictionary *)idAndNameDic
                      xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForSwitch:(NSString *)viewName
                    withProperty:(ViewProperty *)property
                   withIdAndName:(NSDictionary *)idAndNameDic
                      xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"on"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForActivityIndicatorView:(NSString *)viewName
                                   withProperty:(ViewProperty *)property
                                  withIdAndName:(NSDictionary *)idAndNameDic
                                     xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForProgressView:(NSString *)viewName
                          withProperty:(ViewProperty *)property
                         withIdAndName:(NSDictionary *)idAndNameDic
                            xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForPageControl:(NSString *)viewName
                         withProperty:(ViewProperty *)property
                        withIdAndName:(NSDictionary *)idAndNameDic
                           xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForStepper:(NSString *)viewName
                     withProperty:(ViewProperty *)property
                    withIdAndName:(NSDictionary *)idAndNameDic
                       xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForTextView:(NSString *)viewName
                      withProperty:(ViewProperty *)property
                     withIdAndName:(NSDictionary *)idAndNameDic
                        xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"textAlignment",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.pointSize.length > 0)xmlDicM[@"textSize"] = [property.pointSize stringByAppendingString:@"dp"];
    if (property.textStyle.length > 0)xmlDicM[@"textStyle"] = property.textStyle;
    if (property.textColor_red.length > 0 || property.textColor_green.length > 0 ||
        property.textColor_blue.length > 0) {
        xmlDicM[@"textColor"] = [self hexadecimalFromUIColor:[NSColor colorWithRed:[[self getThreedigits:property.textColor_red] doubleValue] green:[[self getThreedigits:property.textColor_green] doubleValue] blue:[[self getThreedigits:property.textColor_blue] doubleValue] alpha:[property.textColor_alpha doubleValue]]];
    }
    xmlDicM[@"fontFamily"] = @"sans-serif";
}
- (void)getPropertyCodeForScrollView:(NSString *)viewName
                        withProperty:(ViewProperty *)property
                       withIdAndName:(NSDictionary *)idAndNameDic
                          xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForDatePicker:(NSString *)viewName
                        withProperty:(ViewProperty *)property
                       withIdAndName:(NSDictionary *)idAndNameDic
                          xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForPickerView:(NSString *)viewName
                        withProperty:(ViewProperty *)property
                       withIdAndName:(NSDictionary *)idAndNameDic
                          xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForMapView:(NSString *)viewName
                     withProperty:(ViewProperty *)property
                    withIdAndName:(NSDictionary *)idAndNameDic
                       xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}
- (void)getPropertyCodeForSearchBar:(NSString *)viewName
                       withProperty:(ViewProperty *)property
                      withIdAndName:(NSDictionary *)idAndNameDic
                         xmlDicM:(NSMutableDictionary *)xmlDicM {
    //    @"placeholder",@"backgroundImage"
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
    if (property.placeholder.length > 0)xmlDicM[@"hint"] = property.placeholder;
}
- (void)getPropertyCodeForWebView:(NSString *)viewName
                     withProperty:(ViewProperty *)property
                    withIdAndName:(NSDictionary *)idAndNameDic
                       xmlDicM:(NSMutableDictionary *)xmlDicM {
    [self getPublicPropertyCodeForView:viewName WithProperty:property xmlDicM:xmlDicM];
}

/**根据公共属性生成代码*/
- (void)getPublicPropertyCodeForView:(NSString *)viewName
                        WithProperty:(ViewProperty *)property
                          xmlDicM:(NSMutableDictionary *)xmlDicM {
    // 1.Color
    if (property.backgroundColor_red.length > 0 || property.backgroundColor_green.length > 0 ||
        property.backgroundColor_blue.length > 0) {
        xmlDicM[@"background"] = [self hexadecimalFromUIColor:[NSColor colorWithRed:[[self getThreedigits:property.backgroundColor_red] doubleValue] green:[[self getThreedigits:property.backgroundColor_green] doubleValue] blue:[[self getThreedigits:property.backgroundColor_blue] doubleValue] alpha:[property.backgroundColor_alpha doubleValue]]];
    }
}

/**获取字符串三位小数*/
- (NSString *)getThreedigits:(NSString *)str {
    if (str.length <= 5) { return str; }
    return [str substringToIndex:5];
}

- (NSString *)upFirstCharacter:(NSString *)text {
    if (text.length <= 0) { return @""; }
    NSString *firstCharacter = [text substringToIndex:1];
    return [[firstCharacter uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
}

- (NSString *)hexadecimalFromUIColor:(NSColor *)uicolor {
    CGColorRef color              = uicolor.CGColor;
    size_t count                  = CGColorGetNumberOfComponents(color);
    const CGFloat *components     = CGColorGetComponents(color);
    static NSString *stringFormat = @"#%02x%02x%02x";
    NSString *hex                 = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex              = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat, (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    return hex;
}

+ (NSString *)iosViewClassToAndroidViewClass:(NSString *)categoryView{
    if ([categoryView isEqualToString:@"label"]) {
        return @"TextView";
    }
    if ([categoryView isEqualToString:@"button"]) {
        return @"Button";
    }
    if ([categoryView isEqualToString:@"imageView"]) {
        return @"ImageView";
    }
    if ([categoryView isEqualToString:@"tableView"]) {
        return @"RecyclerView";
    }
    if ([categoryView isEqualToString:@"tableViewCell"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"collectionView"]) {
        return @"RecyclerView";
    }
    if ([categoryView isEqualToString:@"collectionViewCell"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"view"]) {
        return @"RelativeLayout";
    }
    if ([categoryView isEqualToString:@"segmentedControl"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"textField"]) {
        return @"EditText";
    }
    if ([categoryView isEqualToString:@"switch"]) {
        return @"Switch";
    }
    if ([categoryView isEqualToString:@"activityIndicatorView"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"progressView"]) {
        return @"ProgressBar";
    }
    if ([categoryView isEqualToString:@"pageControl"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"stepper"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"textView"] || [[categoryView lowercaseString] isEqualToString:@"iqtextview"]) {
        return @"EditText";
    }
    if ([categoryView isEqualToString:@"scrollView"]) {
        return @"ScrollView";
    }
    if ([categoryView isEqualToString:@"datePicker"]) {
        return @"DatePicker";
    }
    if ([categoryView isEqualToString:@"pickerView"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"mapView"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"searchBar"]) {
        return @"";
    }
    if ([categoryView isEqualToString:@"webView"]) {
        return @"WebView";
    }
    if ([categoryView isEqualToString:@"slider"]) {
        return @"SeekBar";
    }
    return @"RelativeLayout";//不识别的,默认都返回RelativeLayout
}


@end
