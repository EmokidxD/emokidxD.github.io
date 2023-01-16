#include "XXXRootListController.h"

#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width

@implementation XXXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)openGithub
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Muirey03/SmallSiri"]];
}

-(void)openTwitter
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Muirey03"]];
}

@end

@implementation SMSBannerCell
-(id)initWithSpecifier:(id)arg1
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (self)
	{
		height = kWidth * 0.533;
		CGRect imgFrame = CGRectMake(0, 0, kWidth, height);
		img = [[UIImageView alloc] initWithFrame:imgFrame];
		[img setImage:[UIImage imageNamed:@"banner@3x.png" inBundle:[NSBundle bundleForClass:[self class]]]];

		[self addSubview:img];
	}
	return self;
}

-(CGFloat)preferredHeightForWidth:(CGFloat)arg1
{
	return height;
}
@end
