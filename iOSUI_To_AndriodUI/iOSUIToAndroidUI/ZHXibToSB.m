
#import "ZHXibToSB.h"
#import "ZHNSString.h"

@implementation ZHXibToSB

+ (NSString *)xib_To_sb:(NSString *)xibPath{
    NSString *xib_context = [NSString stringWithContentsOfFile:xibPath encoding:NSUTF8StringEncoding error:nil];
    NSString *className = @"";
    NSString *viewContent = @"";
    
    NSArray *objectsContent = [ZHNSString getMidStringBetweenLeftString:@"<objects>" RightString:@"</objects>" withText:xib_context getOne:YES withIndexStart:0 stopString:nil];
    if (objectsContent.count > 0) {
        NSString *objectContent = objectsContent[0];
        if([objectContent containsString:@"<view "]){
            objectContent = [objectContent substringFromIndex:[objectContent rangeOfString:@"<view "].location];
            if ([objectContent hasSuffix:@"<view "]) {
                objectContent = [objectContent substringFromIndex:@"<view ".length];
                objectContent = [NSString stringWithFormat:@"<view key=\"view\" %@",objectContent];
            }
        }
        NSArray *classNames = [ZHNSString getMidStringBetweenLeftString:@"customClass=\"" RightString:@"\">" withText:objectContent getOne:YES withIndexStart:0 stopString:nil];
        if (classNames.count > 0) {
            className = classNames[0];
        }else{
            return xib_context;
        }
        
        objectContent = [objectContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"customClass=\"%@\"",className] withString:@""];
        viewContent = objectContent;
        
        
        NSString *sb_str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"19529\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" useSafeAreas=\"YES\" colorMatched=\"YES\">\n\
        <device id=\"retina6_1\" orientation=\"portrait\" appearance=\"light\"/>\n\
        <dependencies>\n\
            <deployment version=\"4352\" identifier=\"iOS\"/>\n\
            <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"19519\"/>\n\
            <capability name=\"Safe area layout guides\" minToolsVersion=\"9.0\"/>\n\
            <capability name=\"documents saved in the Xcode 8 format\" minToolsVersion=\"8.0\"/>\n\
        </dependencies>\n\
        <scenes>\n\
            <scene sceneID=\"arT-FS-amk\">\n\
                <objects>\n\
                    <viewController storyboardIdentifier=\"%@\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"5EA-dC-6Ns\" customClass=\"%@\" sceneMemberID=\"viewController\">\n\
                        <layoutGuides>\n\
                            <viewControllerLayoutGuide type=\"top\" id=\"SfN-1d-m1Q\"/>\n\
                            <viewControllerLayoutGuide type=\"bottom\" id=\"sK0-kj-JeK\"/>\n\
                        </layoutGuides>\n %@ \n\
                    </viewController>\n\
                    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"zMd-H5-lWf\" sceneMemberID=\"firstResponder\"/>\n\
                </objects>\n\
                <point key=\"canvasLocation\" x=\"983\" y=\"1167\"/>\n\
            </scene>\n\
        </scenes>\n\
    </document>\n\
    ",className,className,viewContent];
        
        return sb_str;
    }
    
    return xib_context;
}

@end
