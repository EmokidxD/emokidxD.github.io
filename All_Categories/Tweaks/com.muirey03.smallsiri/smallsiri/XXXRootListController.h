#import <Preferences/PSListController.h>

@interface UIImage (SmallSiri)
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
+ (UIImage *)imageAtPath:(id)arg1;
@end

@interface XXXRootListController : PSListController
@end

@interface SMSBannerCell : UITableViewCell
{
    CGFloat height;
    UIImageView* img;
}

-(id)initWithSpecifier:(id)arg1;
-(CGFloat)preferredHeightForWidth:(CGFloat)arg1;
@end
