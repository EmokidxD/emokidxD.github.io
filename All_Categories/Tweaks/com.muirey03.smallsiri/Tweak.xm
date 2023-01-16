#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define isX (kHeight >= 812)

@interface UIView (ss)
-(id)_viewControllerForAncestor;
@end

@interface SBAssistantWindow : UIWindow
-(void)didSwipeUp;
-(void)didSwipeDown;
-(void)expandSiriView;
-(void)closeSiriView;
@end

@interface UIStatusBar : UIView
@property (nonatomic, retain) UIColor *foregroundColor;
@end

@interface _UIStatusBar : UIView
@property (nonatomic, retain) UIColor *foregroundColor;
@end

@interface _UIRemoteView : UIView
@end

@interface MTLumaDodgePillView : UIView
@end

@interface SiriUISiriStatusView : UIView
@end

@interface SpringBoard
-(void)_simulateHomeButtonPress;
@end

@interface SiriUIHelpButton : UIView
@end

@interface SUICFlamesView : UIView
@end

@interface NSUserDefaults (inDomain)
-(id)objectForKey:(id)arg1 inDomain:(id)arg2 ;
@end

static CGFloat yChange = 0;
static UISwipeGestureRecognizer* swipeUpGesture;
static UISwipeGestureRecognizer* swipeDownGesture;
static SiriUISiriStatusView* status;
static SiriUIHelpButton* helpButton;
static SUICFlamesView* flames;
static _UIRemoteView* remote;
static BOOL hasExpanded = NO;
static UIView* statusBar;
static UIView* sbSuperview;

static BOOL getPrefBool(NSString* key, BOOL fallback)
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key inDomain:@"com.muirey03.smallsiri"];
    return value ? [value boolValue] : fallback;
}

static BOOL isSmall = NO;

//change the frame and corner radius of the siri window - This is where the magic happens
%hook SBAssistantWindow

-(void)becomeKeyWindow
{
    %orig;

    //register for the notifications sent by AFConnection
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandSiriView) name:@"SmallSiriGoBig" object:nil];
	   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractSiriView) name:@"SmallSiriGoSmall" object:nil];
    });


    if (!hasExpanded)
    {
        //tf are these gibberish variable names?
        CGFloat yF = isX ? 44 : 10;
        if (getPrefBool(@"fromBottom", NO))
        {
            self.frame = CGRectMake(10, kHeight - 100, kWidth - 20, 90);
        }
        else
        {
            self.frame = CGRectMake(10, yF, kWidth - 20, 90);
        }
        self.subviews[0].layer.cornerRadius = 15;
        self.subviews[0].clipsToBounds = YES;

        //add a recogniser so we can drag the window up to dismiss
        swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUp)];
        swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self.subviews[0] addGestureRecognizer:swipeUpGesture];

        //add a recogniser so we can drag the window down to expand
        swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeDown)];
        swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [self.subviews[0] addGestureRecognizer:swipeDownGesture];
	   isSmall = YES;
    }
}

-(void)dealloc
{
    %orig;
    hasExpanded = NO;
}

%new
-(void)closeSiriView
{
    if (!hasExpanded)
    {
        //dismiss siri
        [UIView animateWithDuration:0.3f animations:^{
            //animate it upwards
            if (getPrefBool(@"fromBottom", NO))
            {
              self.subviews[0].center = CGPointMake(self.subviews[0].center.x, 180);
            }
            else
            {
              self.subviews[0].center = CGPointMake(self.subviews[0].center.x, -90);
            }

        } completion:^(BOOL finished) {
            //simulate home button press to dismiss it
            [(SpringBoard *)[%c(UIApplication) sharedApplication] _simulateHomeButtonPress];
        }];
    }
}

%new
-(void)expandSiriView
{
    if (!hasExpanded)
    {
        //dismiss siri
        [UIView animateWithDuration:0.5f animations:^{
            //animate it expanding
            self.frame = CGRectMake(0, 0, kWidth, kHeight);
        } completion:^(BOOL finished) {
            //undo all changes:

            for (UIView* v in status.subviews)
            {
                if ([v isMemberOfClass:[UIButton class]])
                {
                    //reset button position
                    v.frame = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
                }
                else
                {
                    //reset siri icon position
                    v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y + yChange, v.frame.size.width, v.frame.size.height);
                }
            }

            //remove corner radius
            self.subviews[0].layer.cornerRadius = 0;
            self.subviews[0].clipsToBounds = NO;

            //rest help button position
            helpButton.frame = CGRectMake(helpButton.frame.origin.x, helpButton.frame.origin.y + yChange, self.frame.size.width, helpButton.frame.size.height);

            //reset flames position
            flames.frame = CGRectMake(flames.frame.origin.x, flames.frame.origin.y + yChange, flames.frame.size.width, flames.frame.size.height);

            //show results
            remote.hidden = NO;

            //show status bar
            [sbSuperview addSubview:statusBar];
        }];
        hasExpanded = YES;
	   isSmall = NO;
    }
}

%new
-(void)contractSiriView {
	[UIView animateWithDuration:0.5f animations:^{
		CGFloat yF = isX ? 44 : 10;
		if (getPrefBool(@"fromBottom", NO)) {
			self.frame = CGRectMake(10, kHeight - 100, kWidth - 20, 90);
		} else {
			self.frame = CGRectMake(10, yF, kWidth - 20, 90);
		}
		self.subviews[0].layer.cornerRadius = 15;
		self.subviews[0].clipsToBounds = YES;
	} completion:^(BOOL finished) {
		isSmall = YES;
	}];
}

%new
-(void)didSwipeUp
{
    if (getPrefBool(@"fromBottom", NO))
    {
        [self expandSiriView];
    }
    else
    {
        [self closeSiriView];
    }
}

%new
-(void)didSwipeDown
{
    if (getPrefBool(@"fromBottom", NO))
    {
        [self closeSiriView];
    }
    else
    {
        [self expandSiriView];
    }
}

%end

//XXX: Making siri bigger and smaller on user command (by Squ1dd13)

@interface AceObject : NSObject
@property(copy, nonatomic) NSString *refId;
@property(copy, nonatomic) NSString *aceId;
- (id)properties;
- (id)dictionary;
+ (id)aceObjectWithDictionary:(id)arg1 context:(id)arg2;
@end

@interface AFConnection : NSObject
@property (nonatomic, copy) NSString *userSpeech;
@end

#pragma mark Getting User Speech
%hook AFConnectionClientServiceDelegate
-(void)speechRecognized:(id)arg1 {
	//arg1 --> recognition --> phrases --> object --> interpretations --> object --> tokens --> object --> text
	NSMutableString *fullPhrase = [NSMutableString string];
	NSArray *phrases = [(NSObject *)arg1 valueForKeyPath:@"recognition.phrases"];
	if([phrases count] > 0) {
		for(id phrase in phrases) {
			NSArray *interpretations = [(NSObject *)phrase valueForKey:@"interpretations"];
			if([interpretations count] > 0) {
				id interpretation = interpretations[0];
				NSArray *tokens = [(NSObject *)interpretation valueForKey:@"tokens"];
				if([tokens count] > 0) {
					for(id token in tokens) {
						[fullPhrase appendString:[[(NSObject *)token valueForKey:@"text"] stringByAppendingString:@" "]];
					}
				}
			}
		}
	}
	NSString *speech = [[[fullPhrase copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
	[[(NSObject *)self valueForKey:@"_connection"] setValue:speech forKey:@"userSpeech"];
	%orig;
}
%end

#pragma mark Custom reply
%hook AFConnection
%property (nonatomic, copy) NSString *userSpeech;

-(void)_doCommand:(id)arg1 reply:(/*^block*/id)arg2 {
	//work out if we should be giving a custom reply
	NSString *notificationName = @"";
	NSString *stringToSpeak = @"";
	if([self.userSpeech isEqualToString:@"go smaller"]) {
		if(isSmall) {
			stringToSpeak = @"Sorry, I can't go any smaller.";
			notificationName = @".";
		} else {
			stringToSpeak = @"Ok, I'll go smaller.";
			notificationName = @"SmallSiriGoSmall";
		}
	} else if ([self.userSpeech isEqualToString:@"go bigger"]) {
		if(!isSmall) {
			stringToSpeak = @"Sorry, I can't go any bigger.";
			notificationName = @".";
		} else {
			stringToSpeak = @"Ok, I'll go bigger.";
			notificationName = @"SmallSiriGoBig";
		}
	} else {
		//respond normally and quit
		%orig;
		return;
	}

	//create a context for the ace object
	id context = NSClassFromString(@"BasicAceContext");
	id object = arg1;

	//get the original dictionary
	NSMutableDictionary *dict = [[(NSObject *)object valueForKey:@"dictionary"] mutableCopy];

	/*
	How it works:
	Siri processes what the user says to it, and then cooks up a reply. It then synthesizes the speech for the reply, while displaying a view with the spoken text.
	To give custom replies, we need to a) change the string that is synthesized, and b) change the text of the view.
	*/

	//change the text on the views
	if([dict objectForKey:@"views"]) {
		NSArray *views = [dict objectForKey:@"views"];
		NSMutableArray *modifiedViews = [NSMutableArray array];

		//views is an array of dictionaries
		for(NSDictionary *view in views) {
			NSMutableDictionary *mutableView = [view mutableCopy];
			[mutableView setValue:stringToSpeak forKey:@"speakableText"];
			[mutableView setValue:stringToSpeak forKey:@"text"];
			[modifiedViews addObject:[mutableView copy]];
		}

		[dict setValue:[modifiedViews copy] forKey:@"views"];
	}

	//change the speech string
	if([dict objectForKey:@"dialogStrings"]) {
		[dict setValue:@[stringToSpeak] forKey:@"dialogStrings"];
	}

	//create a new ace object with the modified dictionary
	AceObject *aceObject = [%c(AceObject) aceObjectWithDictionary:[dict copy] context:context];

	//run normally with the modified ace object and the original block
	%orig(aceObject, arg2);

	//now siri has spoken, we need to actually carry out the command
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];

	//reset
	self.userSpeech = @"";
}
%end


//hide the status bar in the siri window
%hook UIStatusBar
-(void)didMoveToWindow
{
    %orig;
    if ([[self window] isMemberOfClass:objc_getClass("SBAssistantWindow")] && !hasExpanded)
    {
        statusBar = self;
        sbSuperview = self.superview;
        [self removeFromSuperview];
    }
}
%end

%hook _UIStatusBar
-(void)didMoveToWindow
{
    %orig;
    if ([[self window] isMemberOfClass:objc_getClass("SBAssistantWindow")] && !hasExpanded)
    {
        statusBar = self;
        sbSuperview = self.superview;
        [self removeFromSuperview];
    }
}
%end

//force button to be on bottom on iPhone X
%hook SiriUISiriStatusView
-(id)init
{
    self = %orig;
    if (self)
    {
        status = self;
    }
    return self;
}

-(void)layoutSubviews
{
    %orig;
    if (!hasExpanded)
    {
        //get button
        for (UIView* v in self.subviews)
        {
            if ([v isMemberOfClass:[UIButton class]])
            {
                //modify button's frame
                yChange = v.frame.origin.y;
                yChange -= (self.frame.size.height - v.frame.size.height); //will be negative
                v.frame = CGRectMake(0, yChange * -1, v.frame.size.width, v.frame.size.height);
                //move the siri icon down by the same amount:
                for (UIView* b in self.subviews)
                {
                    if (![b isMemberOfClass:[UIButton class]])
                    {
                        //modify icon's frame
                        b.frame = CGRectMake(b.frame.origin.x, b.frame.origin.y - yChange, b.frame.size.width, b.frame.size.height);
                        break;
                    }
                }
                break;
            }
        }
    }
}
%end

//move the help button down so its centered on the iPhoen X
%hook SiriUIHelpButton
-(id)init
{
    self = %orig;
    if (self)
    {
        helpButton = self;
    }
    return self;
}

-(void)setFrame:(CGRect)arg1
{
    if (!hasExpanded)
    {
        arg1 = CGRectMake(arg1.origin.x, arg1.origin.y - yChange, arg1.size.width, arg1.size.height);
    }
    %orig;
}
%end

//move the flames down so its centered on the iPhoen X
%hook SUICFlamesView
-(id)init
{
    self = %orig;
    if (self)
    {
        flames = self;
    }
    return self;
}

-(void)setActiveFrame:(CGRect)arg1
{
    if (!hasExpanded)
    {
        arg1 = CGRectMake(arg1.origin.x, arg1.origin.y - yChange, arg1.size.width, arg1.size.height);
    }
    %orig;
}
%end

//hide grabber on iPhone X
%hook MTLumaDodgePillView
-(void)didMoveToWindow
{
    %orig;
    if ([[[UIApplication sharedApplication] keyWindow] isMemberOfClass:objc_getClass("SBAssistantWindow")] && !hasExpanded)
    {
        [self removeFromSuperview];
    }
}
%end

//hide the results text that would get in the way
%hook _UIRemoteView
-(void)didMoveToSuperview
{
    %orig;
    if ([[self _viewControllerForAncestor] isMemberOfClass:objc_getClass("AFUISiriRemoteViewController")] && !hasExpanded)
    {
        remote = self;
        self.hidden = YES;
    }
}
%end