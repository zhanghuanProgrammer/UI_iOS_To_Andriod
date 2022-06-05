#import "ZHNSString.h"

@implementation ZHNSString

+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString
                               RightString:(NSString *)rightString
                                  withText:(NSString *)text
                                    getOne:(BOOL)one
                            withIndexStart:(NSInteger)startIndex
                                stopString:(NSString *)stopString {
    
    if (startIndex >= text.length - 1) { return nil; }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSInteger indexStart = [text rangeOfString:leftString
                                       options:NSLiteralSearch
                                         range:NSMakeRange(startIndex, text.length - startIndex)].location;
    NSInteger indexEnd;
    NSInteger stopIndex = 0;
    if (indexStart != NSNotFound && indexStart < text.length - 1) {
        indexEnd = [text rangeOfString:rightString
                               options:NSLiteralSearch
                                 range:NSMakeRange(indexStart + leftString.length, text.length - indexStart - leftString.length)].location;
        
        if (stopString.length == 0) {
            stopIndex = text.length + 1;
        } else {
            stopIndex = [text rangeOfString:stopString
                        options:NSLiteralSearch
                          range:NSMakeRange(indexStart + leftString.length, text.length - indexStart - leftString.length)].location;
        }
    } else {
        indexEnd = NSNotFound;
    }
    
    while (indexStart != NSNotFound && indexEnd != NSNotFound && indexStart < indexEnd && indexEnd < stopIndex) {
        [arrM addObject:[text substringWithRange:NSMakeRange(indexStart + leftString.length,
                                                             indexEnd - indexStart -
                                                             leftString.length)]];
        
        if (one) { break; }
        
        indexStart = indexEnd + rightString.length;
        
        indexStart = [text rangeOfString:leftString
                                 options:NSLiteralSearch
                                   range:NSMakeRange(indexStart, text.length - indexStart)].location;
        if (indexStart != NSNotFound && indexStart < text.length - 1) {
            indexEnd = [text rangeOfString:rightString
                        options:NSLiteralSearch
                          range:NSMakeRange(indexStart + leftString.length, text.length - indexStart - leftString.length)].location;
        } else
            break;
    }
    return arrM;
}

+ (NSString *)getMidTargetStringBetweenLeftRightStrings:(NSArray *)strings withText:(NSString *)text {
    
    NSInteger curIndex = 0;
    NSInteger indexStart = -1;
    NSInteger indexEnd = -1;
    for (NSInteger i=0; i<strings.count; i++) {
        NSString *string = strings[i];
        NSInteger index = [text rangeOfString:string options:NSLiteralSearch range:NSMakeRange(curIndex, text.length - curIndex)].location;
        if (index == NSNotFound || index > text.length - 1) {
            return @"";
        }else{
            if (indexStart == -1) {
                indexStart = index;
            }
            curIndex = index + string.length;
            if (i == strings.count - 1) {//结束了
                indexEnd = curIndex;
            }
        }
    }
    if (indexStart >= 0 && indexEnd >= 0 && indexEnd > indexStart) {
        //取最近原则
        NSString *ret = [text substringWithRange:NSMakeRange(indexStart, indexEnd - indexStart)];
        NSString *str_new = [self getMidTargetStringBetweenLeftRightStrings:strings withText:[ret substringFromIndex:1]];
        if (str_new.length > 0) {
            return str_new;
        }
        return ret;
    }
    return @"";
}

+ (NSArray *)getMidsBetweenLeftRightStrings:(NSArray *)strings withText:(NSString *)text {
    NSMutableArray *arrM = [NSMutableArray array];
    if (strings.count < 2) {
        return arrM;
    }
    for (NSInteger i=0; i<strings.count - 1; i++) {
        NSString *string1 = strings[i];
        NSString *string2 = strings[i + 1];
        NSArray *mids = [self getMidStringBetweenLeftString:string1 RightString:string2 withText:text getOne:YES withIndexStart:0 stopString:nil];
        if (mids.count <= 0) {
            return arrM;
        }else{
            NSString *mid = mids[0];
            [arrM addObject:mid];
            if(mid.length > 0)text = [text substringFromIndex:[text rangeOfString:mid].location + mid.length];
        }
    }
    return arrM;
}

+ (BOOL)isBianLiangMingCode:(NSString *)code{
    if (code.length <= 0) {
        return NO;
    }
    if([code hasPrefix:@"<#"] &&
       [code hasSuffix:@"#>"]) return YES;
    for (NSInteger i=0; i<code.length; i++) {
        unichar ch = [code characterAtIndex:i];
        if (![self checkCharacter2:ch]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isChangLiangMingCode:(NSString *)code{
    if (code.length <= 0) {
        return NO;
    }
    if([code hasPrefix:@"<#"] &&
       [code hasSuffix:@"#>"]) return YES;
    if(code.length >= 3){
        NSString *tmp = [code substringFromIndex:1];
        tmp = [tmp substringToIndex:tmp.length - 1];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"\\\"" withString:@""];
        if([tmp containsString:@"\""])return NO;
    }
    if([code hasPrefix:@"\""] &&
       [code hasSuffix:@"\""]) return YES;
    return NO;
}

+ (BOOL)isBaoHanCode:(NSString *)code arr:(NSArray *)arr{
    if (code.length <= 0) {
        return NO;
    }
    for (NSString *str in arr) {
        if (str.length > 0) {
            if ([code containsString:str]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)checkCharacter:(unichar)ch{
    if (ch >= 'a' && ch <= 'z') { return YES; }
    if (ch >= 'A' && ch <= 'Z') { return YES; }
    if (ch >= '0' && ch <= '9') { return YES; }
    if (ch == '_') { return YES; }
    if (ch == '.') { return YES; }
    return NO;
}

+ (BOOL)checkCharacter2:(unichar)ch{
    if (ch >= 'a' && ch <= 'z') { return YES; }
    if (ch >= 'A' && ch <= 'Z') { return YES; }
    if (ch >= '0' && ch <= '9') { return YES; }
    if (ch == '_') { return YES; }
    if (ch == '.') { return YES; }
    return NO;
}

+ (NSArray<NSString *> *)componentsSeparatedByStrings:(NSArray *)separators text:(NSString *)text{
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=0; i<separators.count; i++) {
        NSString *separator = separators[i];
        if ([text containsString:separator]) {
            NSArray *splits = [text componentsSeparatedByString:separator];
            [arrM addObject:splits[0]];
            text = splits[1];
        }else{
            [arrM addObject:text];
            return arrM;
        }
    }
    return arrM;
}

/**替换代码文件内容的函数,替换整个text里面的旧名字,改成新名字*/
+ (NSString *)changeOldName:(NSString *)oldName
                    newName:(NSString *)newName
                     inText:(NSString *)text {
    if ([oldName isEqualToString:newName]) { return text; }
    
    NSUInteger indexStart = [text rangeOfString:oldName options:NSLiteralSearch].location;
    
    unichar proir, next;
    BOOL proirResult, nextResult;
    while (indexStart != NSNotFound) {
        
        proirResult = YES;
        nextResult  = YES;
        
        //获取前一个字符串
        if (indexStart > 0) {
            proir       = [text characterAtIndex:indexStart - 1];
            proirResult = [self isNoCharacter:proir isProir:YES];
        } else {
            if(indexStart == 0)proirResult = YES;
            else proirResult = NO;
        }
        
        //获取后一个字符串
        if (indexStart + oldName.length < text.length - 1) {
            next       = [text characterAtIndex:indexStart + oldName.length];
            nextResult = [self isNoCharacter:next isProir:NO];
        } else {
            nextResult = NO;
        }
        
        if (proirResult == YES && nextResult == YES) { //条件满足,开始替换
            text = [text stringByReplacingCharactersInRange:NSMakeRange(indexStart, oldName.length)
                                                 withString:newName];
            indexStart = indexStart + newName.length;
        } else {
            indexStart++;
        }
        
        if (indexStart < text.length) {
            indexStart = [text rangeOfString:oldName
                                     options:NSLiteralSearch
                                       range:NSMakeRange(indexStart, text.length - indexStart)]
            .location;
        } else {
            break;
        }
    }
    
    return text;
}

+ (BOOL)isNoCharacter:(unichar)ch isProir:(BOOL)isProir {
    
    if (ch >= 'a' && ch <= 'z') { return NO; }
    if (ch >= 'A' && ch <= 'Z') { return NO; }
    if (isProir == YES && (ch == '_' || ch == '+')) { return NO; }
    return YES;
}

//去除前后空格
+ (NSString *)removeSpaceBeforeAndAfterWithString:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)removeSpacePrefix:(NSString *)text {
    if ([text hasPrefix:@" "]) {
        text = [text substringFromIndex:1];
        return [self removeSpacePrefix:text];
    } else if ([text hasPrefix:@"\t"]) {
        text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpacePrefix:text];
    } else
        return text;
}
+ (NSString *)removeSpaceSuffix:(NSString *)text {
    if ([text hasSuffix:@" "]) {
        text = [text substringToIndex:text.length - 1];
        return [self removeSpaceSuffix:text];
    } else if ([text hasSuffix:@"\t"]) {
        text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpaceSuffix:text];
    } else
        return text;
}

+ (BOOL)isValidateNumber:(NSString *)number {
    NSString *num           = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    return [numberTest evaluateWithObject:number];
}

+ (BOOL)isPureFloat:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    BOOL isFloat = [scan scanFloat:&val] && [scan isAtEnd];
    if ([self isPureInt:string]) { return NO; }
    return isFloat;
}

+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
