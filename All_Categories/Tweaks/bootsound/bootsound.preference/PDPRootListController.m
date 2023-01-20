#import <Foundation/Foundation.h>
#import "PDPRootListController.h"

@implementation PDPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openGithub {
	[[UIAplication shareApplication]
	openURL:[NSURL URLWithString:@"https://github.com/emokidxd/"]
	options:@{}
	completionHandler:nil];
}

@end
