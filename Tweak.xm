#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <FrontBoardServices/FBSSystemService.h>
#import <spawn.h>
#import <notify.h>

@interface SpringBoard : NSObject  // Sleep time
-(void)_simulateLockButtonPress;
@end

@interface UIStatusBarWindow : UIWindow
-(void)tapping;
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];

    return self;
}

%new

-(void)tapping {
  notify_post("com.kietha.taptapsleep");
}

%end

%ctor {
  NSString *currentID = NSBundle.mainBundle.bundleIdentifier;
  if ([currentID isEqualToString:@"com.apple.springboard"]) {
    int regToken;
    notify_register_dispatch("com.kietha.taptapsleep", &regToken, dispatch_get_main_queue(), ^(int token) {
    [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress];
  });
    }
  }
