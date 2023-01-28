#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

%hook SpringBoard
-(id)init{
AudioServicesPlaySystemSound(1005);
return %orig;
}
%end