#import "ZHStoryboardPropertyManager.h"

@implementation ZHStoryboardPropertyManager
/**为获取每个view的property属性*/
+ (NSDictionary *)getPropertysForView:(NSDictionary *)idAndViewDic
                    withCustomAndName:(NSDictionary *)customAndNameDic
                         andXMLHandel:(ReadXML *)xml {
    NSMutableDictionary *idAndPropertyDicM = [NSMutableDictionary dictionary];
    for (NSString *viewName in idAndViewDic) {
        [self recursiveGetPropertysForViewName:viewName
                                   withViewDic:idAndViewDic[viewName]
                             withCustomAndName:customAndNameDic
                           toIdAndPropertyDicM:idAndPropertyDicM
                                  andXMLHandel:xml];
    }
    return idAndPropertyDicM;
}

+ (void)recursiveGetPropertysForViewName:(NSString *)viewName
                             withViewDic:(NSDictionary *)viewDic
                       withCustomAndName:(NSDictionary *)customAndNameDic
                     toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                            andXMLHandel:(ReadXML *)xml {
    NSString *categoryView = customAndNameDic[viewName];
    if ([categoryView isEqualToString:@"label"]) {
        [self setPropertysForLabel:viewName
                       withViewDic:viewDic
                 withCustomAndName:customAndNameDic
               toIdAndPropertyDicM:idAndPropertyDicM
                      andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"button"]) {
        [self setPropertysForButton:viewName
                        withViewDic:viewDic
                  withCustomAndName:customAndNameDic
                toIdAndPropertyDicM:idAndPropertyDicM
                       andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"imageView"]) {
        [self setPropertysForImageView:viewName
                           withViewDic:viewDic
                     withCustomAndName:customAndNameDic
                   toIdAndPropertyDicM:idAndPropertyDicM
                          andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"tableView"]) {
        [self setPropertysForTableView:viewName
                           withViewDic:viewDic
                     withCustomAndName:customAndNameDic
                   toIdAndPropertyDicM:idAndPropertyDicM
                          andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"tableViewCell"]) {
        [self setPropertysForTableViewCell:viewName
                               withViewDic:viewDic
                         withCustomAndName:customAndNameDic
                       toIdAndPropertyDicM:idAndPropertyDicM
                              andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"collectionView"]) {
        [self setPropertysForCollectionView:viewName
                                withViewDic:viewDic
                          withCustomAndName:customAndNameDic
                        toIdAndPropertyDicM:idAndPropertyDicM
                               andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"collectionViewCell"]) {
        [self setPropertysForCollectionViewCell:viewName
                                    withViewDic:viewDic
                              withCustomAndName:customAndNameDic
                            toIdAndPropertyDicM:idAndPropertyDicM
                                   andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"view"]) {
        [self setPropertysForView:viewName
                      withViewDic:viewDic
                withCustomAndName:customAndNameDic
              toIdAndPropertyDicM:idAndPropertyDicM
                     andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"segmentedControl"]) {
        [self setPropertysForSegmentedControl:viewName
                                  withViewDic:viewDic
                            withCustomAndName:customAndNameDic
                          toIdAndPropertyDicM:idAndPropertyDicM
                                 andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"textField"]) {
        [self setPropertysForTextField:viewName
                           withViewDic:viewDic
                     withCustomAndName:customAndNameDic
                   toIdAndPropertyDicM:idAndPropertyDicM
                          andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"switch"]) {
        [self setPropertysForSwitch:viewName
                        withViewDic:viewDic
                  withCustomAndName:customAndNameDic
                toIdAndPropertyDicM:idAndPropertyDicM
                       andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"activityIndicatorView"]) {
        [self setPropertysForActivityIndicatorView:viewName
                                       withViewDic:viewDic
                                 withCustomAndName:customAndNameDic
                               toIdAndPropertyDicM:idAndPropertyDicM
                                      andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"progressView"]) {
        [self setPropertysForProgressView:viewName
                              withViewDic:viewDic
                        withCustomAndName:customAndNameDic
                      toIdAndPropertyDicM:idAndPropertyDicM
                             andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"pageControl"]) {
        [self setPropertysForPageControl:viewName
                             withViewDic:viewDic
                       withCustomAndName:customAndNameDic
                     toIdAndPropertyDicM:idAndPropertyDicM
                            andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"stepper"]) {
        [self setPropertysForStepper:viewName
                         withViewDic:viewDic
                   withCustomAndName:customAndNameDic
                 toIdAndPropertyDicM:idAndPropertyDicM
                        andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"textView"]) {
        [self setPropertysForTextView:viewName
                          withViewDic:viewDic
                    withCustomAndName:customAndNameDic
                  toIdAndPropertyDicM:idAndPropertyDicM
                         andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"scrollView"]) {
        [self setPropertysForScrollView:viewName
                            withViewDic:viewDic
                      withCustomAndName:customAndNameDic
                    toIdAndPropertyDicM:idAndPropertyDicM
                           andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"datePicker"]) {
        [self setPropertysForDatePicker:viewName
                            withViewDic:viewDic
                      withCustomAndName:customAndNameDic
                    toIdAndPropertyDicM:idAndPropertyDicM
                           andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"pickerView"]) {
        [self setPropertysForPickerView:viewName
                            withViewDic:viewDic
                      withCustomAndName:customAndNameDic
                    toIdAndPropertyDicM:idAndPropertyDicM
                           andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"mapView"]) {
        [self setPropertysForMapView:viewName
                         withViewDic:viewDic
                   withCustomAndName:customAndNameDic
                 toIdAndPropertyDicM:idAndPropertyDicM
                        andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"searchBar"]) {
        [self setPropertysForSearchBar:viewName
                           withViewDic:viewDic
                     withCustomAndName:customAndNameDic
                   toIdAndPropertyDicM:idAndPropertyDicM
                          andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"webView"]) {
        [self setPropertysForWebView:viewName
                         withViewDic:viewDic
                   withCustomAndName:customAndNameDic
                 toIdAndPropertyDicM:idAndPropertyDicM
                        andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"slider"]) {
        [self setPropertysForSlider:viewName
                        withViewDic:viewDic
                  withCustomAndName:customAndNameDic
                toIdAndPropertyDicM:idAndPropertyDicM
                       andXMLHandel:xml];
    }
}

+ (void)setPropertysForLabel:(NSString *)viewName
                 withViewDic:(NSDictionary *)viewDic
           withCustomAndName:(NSDictionary *)customAndNameDic
         toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                andXMLHandel:(ReadXML *)xml {
    //获取text
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[
                                         @"text", @"textAlignment", @"adjustsFontSizeToFit", @"numberOfLines", @"pointSize"
                                         ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    NSDictionary *fontDescriptionDic = [xml getOneDegreeChildWithName:@"fontDescription" withDic:viewDic];
    if (fontDescriptionDic) {
        NSString *name = fontDescriptionDic[@"name"];
        NSString *weight = fontDescriptionDic[@"weight"];
        if (weight && weight.length > 0) {
            property.textStyle = @"bold";
        }
        if (name && ![[name lowercaseString] containsString:@"regular"]) {
            property.textStyle = @"bold";
        }
    }
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForButton:(NSString *)viewName
                  withViewDic:(NSDictionary *)viewDic
            withCustomAndName:(NSDictionary *)customAndNameDic
          toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                 andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"title", @"pointSize" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
    
    NSDictionary *titleColorDic = [xml getOneDegreeChildWithName:@"state" withDic:viewDic];
    NSDictionary *colorDic      = [xml getOneDegreeChildWithName:@"color" withDic:titleColorDic];
    NSDictionary *fontDescriptionDic = [xml getOneDegreeChildWithName:@"fontDescription" withDic:viewDic];
    if (fontDescriptionDic) {
        NSString *name = fontDescriptionDic[@"name"];
        NSString *weight = fontDescriptionDic[@"weight"];
        if (weight && weight.length > 0) {
            property.textStyle = @"bold";
        }
        if (name && ![[name lowercaseString] containsString:@"regular"]) {
            property.textStyle = @"bold";
        }
    }
    if ([colorDic[@"key"] isEqualToString:@"titleColor"]) {
        property.titleColor_red = [xml getPropertyWithName:@"red" withDic:colorDic needInChild:NO];
        property.titleColor_green =
        [xml getPropertyWithName:@"green" withDic:colorDic needInChild:NO];
        property.titleColor_blue =
        [xml getPropertyWithName:@"blue" withDic:colorDic needInChild:NO];
        property.titleColor_alpha =
        [xml getPropertyWithName:@"alpha" withDic:colorDic needInChild:NO];
    }
}
+ (void)setPropertysForImageView:(NSString *)viewName
                     withViewDic:(NSDictionary *)viewDic
               withCustomAndName:(NSDictionary *)customAndNameDic
             toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                    andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"image", @"contentMode" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForTableView:(NSString *)viewName
                     withViewDic:(NSDictionary *)viewDic
               withCustomAndName:(NSDictionary *)customAndNameDic
             toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                    andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"style", @"rowHeight" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForTableViewCell:(NSString *)viewName
                         withViewDic:(NSDictionary *)viewDic
                   withCustomAndName:(NSDictionary *)customAndNameDic
                 toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                        andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"reuseIdentifier" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForCollectionView:(NSString *)viewName
                          withViewDic:(NSDictionary *)viewDic
                    withCustomAndName:(NSDictionary *)customAndNameDic
                  toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                         andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForCollectionViewCell:(NSString *)viewName
                              withViewDic:(NSDictionary *)viewDic
                        withCustomAndName:(NSDictionary *)customAndNameDic
                      toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                             andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"reuseIdentifier" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForView:(NSString *)viewName
                withViewDic:(NSDictionary *)viewDic
          withCustomAndName:(NSDictionary *)customAndNameDic
        toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
               andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSegmentedControl:(NSString *)viewName
                            withViewDic:(NSDictionary *)viewDic
                      withCustomAndName:(NSDictionary *)customAndNameDic
                    toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                           andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
    
    NSDictionary *segmentsDic = [xml getOneDegreeChildWithName:@"segments" withDic:viewDic];
    if (segmentsDic != nil) {
        property.segment = @"";
        
        NSInteger count  = 1;
        NSArray *arrTemp = [xml childDic:segmentsDic];
        for (id obj in arrTemp) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subDic = obj;
                if (subDic) {
                    NSString *segment =
                    [xml getPropertyWithName:@"title" withDic:subDic needInChild:NO];
                    property.segment = [property.segment stringByAppendingString:segment];
                    if (count != arrTemp.count) {
                        property.segment = [property.segment stringByAppendingString:@"_$_"];
                    }
                }
                count++;
            }
        }
    }
}
+ (void)setPropertysForTextField:(NSString *)viewName
                     withViewDic:(NSDictionary *)viewDic
               withCustomAndName:(NSDictionary *)customAndNameDic
             toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                    andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"textAlignment", @"clearButtonMode", @"pointSize" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    NSDictionary *fontDescriptionDic = [xml getOneDegreeChildWithName:@"fontDescription" withDic:viewDic];
    if (fontDescriptionDic) {
        NSString *name = fontDescriptionDic[@"name"];
        NSString *weight = fontDescriptionDic[@"weight"];
        if (weight && weight.length > 0) {
            property.textStyle = @"bold";
        }
        if (name && ![[name lowercaseString] containsString:@"regular"]) {
            property.textStyle = @"bold";
        }
    }
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSlider:(NSString *)viewName
                  withViewDic:(NSDictionary *)viewDic
            withCustomAndName:(NSDictionary *)customAndNameDic
          toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                 andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSwitch:(NSString *)viewName
                  withViewDic:(NSDictionary *)viewDic
            withCustomAndName:(NSDictionary *)customAndNameDic
          toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                 andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"on" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForActivityIndicatorView:(NSString *)viewName
                                 withViewDic:(NSDictionary *)viewDic
                           withCustomAndName:(NSDictionary *)customAndNameDic
                         toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                                andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForProgressView:(NSString *)viewName
                        withViewDic:(NSDictionary *)viewDic
                  withCustomAndName:(NSDictionary *)customAndNameDic
                toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                       andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForPageControl:(NSString *)viewName
                       withViewDic:(NSDictionary *)viewDic
                 withCustomAndName:(NSDictionary *)customAndNameDic
               toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                      andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForStepper:(NSString *)viewName
                   withViewDic:(NSDictionary *)viewDic
             withCustomAndName:(NSDictionary *)customAndNameDic
           toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                  andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForTextView:(NSString *)viewName
                    withViewDic:(NSDictionary *)viewDic
              withCustomAndName:(NSDictionary *)customAndNameDic
            toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                   andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"textAlignment", @"pointSize" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    NSDictionary *fontDescriptionDic = [xml getOneDegreeChildWithName:@"fontDescription" withDic:viewDic];
    if (fontDescriptionDic) {
        NSString *name = fontDescriptionDic[@"name"];
        NSString *weight = fontDescriptionDic[@"weight"];
        if (weight && weight.length > 0) {
            property.textStyle = @"bold";
        }
        if (name && ![[name lowercaseString] containsString:@"regular"]) {
            property.textStyle = @"bold";
        }
    }
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForScrollView:(NSString *)viewName
                      withViewDic:(NSDictionary *)viewDic
                withCustomAndName:(NSDictionary *)customAndNameDic
              toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                     andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForDatePicker:(NSString *)viewName
                      withViewDic:(NSDictionary *)viewDic
                withCustomAndName:(NSDictionary *)customAndNameDic
              toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                     andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForPickerView:(NSString *)viewName
                      withViewDic:(NSDictionary *)viewDic
                withCustomAndName:(NSDictionary *)customAndNameDic
              toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                     andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForMapView:(NSString *)viewName
                   withViewDic:(NSDictionary *)viewDic
             withCustomAndName:(NSDictionary *)customAndNameDic
           toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                  andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSearchBar:(NSString *)viewName
                     withViewDic:(NSDictionary *)viewDic
               withCustomAndName:(NSDictionary *)customAndNameDic
             toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                    andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[ @"placeholder", @"backgroundImage" ]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForWebView:(NSString *)viewName
                   withViewDic:(NSDictionary *)viewDic
             withCustomAndName:(NSDictionary *)customAndNameDic
           toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM
                  andXMLHandel:(ReadXML *)xml {
    ViewProperty *property = [ViewProperty new];
    [self setPropertysForPropertyNames:@[]
                           withViewDic:viewDic
                            toProperty:property
                          andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}

/**根据字符串数组去拿去对应的属性字段*/
+ (void)setPropertysForPropertyNames:(NSArray *)Propertys
                         withViewDic:(NSDictionary *)viewDic
                          toProperty:(ViewProperty *)property
                        andXMLHandel:(ReadXML *)xml {
    [self setPropertysForPublicWithViewDic:viewDic toProperty:property andXMLHandel:xml];
    
    for (NSString *propertyName in Propertys) {
        NSString *tempResult =
        [xml getPropertyWithName:propertyName withDic:viewDic needInChild:YES];
        if (tempResult.length > 0) {
            if ([property hasProperty:propertyName]) {
                [property setValue:tempResult forKey:propertyName];
            } else {
                NSLog(@"%@", @"有的属性没有赋到值");
            }
        }
    }
}

/**设置公共属性*/
+ (void)setPropertysForPublicWithViewDic:(NSDictionary *)viewDic
                              toProperty:(ViewProperty *)property
                            andXMLHandel:(ReadXML *)xml {
    // 1.rect
    NSDictionary *rectDic = [xml getOneDegreeChildWithName:@"rect" withDic:viewDic];
    if (rectDic != nil) {
        property.rect_x = [xml getPropertyWithName:@"x" withDic:rectDic needInChild:NO];
        property.rect_y = [xml getPropertyWithName:@"y" withDic:rectDic needInChild:NO];
        property.rect_w = [xml getPropertyWithName:@"width" withDic:rectDic needInChild:NO];
        property.rect_h = [xml getPropertyWithName:@"height" withDic:rectDic needInChild:NO];
    }
    
    // 2.Color
    NSDictionary *colorDic = [xml getOneDegreeChildWithName:@"color" withDic:viewDic];
    if (colorDic) {
        if ([colorDic[@"key"] isEqualToString:@"textColor"]) {
            property.textColor_red =
            [xml getPropertyWithName:@"red" withDic:colorDic needInChild:NO];
            property.textColor_green =
            [xml getPropertyWithName:@"green" withDic:colorDic needInChild:NO];
            property.textColor_blue =
            [xml getPropertyWithName:@"blue" withDic:colorDic needInChild:NO];
            property.textColor_alpha =
            [xml getPropertyWithName:@"alpha" withDic:colorDic needInChild:NO];
            
        } else if ([colorDic[@"key"] isEqualToString:@"backgroundColor"]) {
            property.backgroundColor_red =
            [xml getPropertyWithName:@"red" withDic:colorDic needInChild:NO];
            property.backgroundColor_green =
            [xml getPropertyWithName:@"green" withDic:colorDic needInChild:NO];
            property.backgroundColor_blue =
            [xml getPropertyWithName:@"blue" withDic:colorDic needInChild:NO];
            property.backgroundColor_alpha =
            [xml getPropertyWithName:@"alpha" withDic:colorDic needInChild:NO];
        }
    }
    
    // action
    NSDictionary *connectionsDic = [xml getOneDegreeChildWithName:@"connections" withDic:viewDic];
    NSArray *subConnectionsArr   = [xml childDic:connectionsDic];
    for (id obj in subConnectionsArr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subConnectionsDic = obj;
            if ([[xml dicNodeName:subConnectionsDic] isEqualToString:@"action"]) {
                property.selector =
                [xml getPropertyWithName:@"selector" withDic:subConnectionsDic needInChild:NO];
                property.eventType =
                [xml getPropertyWithName:@"eventType" withDic:subConnectionsDic needInChild:NO];
            }
        }
    }
}

@end
