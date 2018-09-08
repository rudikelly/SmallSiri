#include "XXXRootListController.h"

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
