#include "XXXRootListController.h"

@implementation XXXRootListController
-(NSArray *)specifiers {
 if (!_specifiers){
  _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
 }
 return _specifiers;
}

-(void)Respring{
 [HBRespringController respring];
}
@end
