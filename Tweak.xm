@interface SpringBoard : NSObject  
-(void)_simulateLockButtonPress; //gotta define it u know?
@end

@interface UIStatusBarWindow : UIWindow
-(void)tapping; //from %new
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)]; //(tapping) will be used as a void down in the %new
    tapRecognizer.numberOfTapsRequired = 2; // 2 taps 
    tapRecognizer.cancelsOtherTouchesInView = NO; //a safe way of adding a gesture, so that it doesn't break other gestures in the view. (thanks squiddy love u)
    [self addGestureRecognizer:tapRecognizer];  //add that tap gesture

    return self;
}

%new // hey lets make a new void 

-(void)tapping {
  notify_post("com.kietha.taptapsleep"); 
}

%end

%ctor
{
  if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) { //check if its springboard
    int regToken; // The registration token
    notify_register_dispatch("com.kietha.taptapsleep", &regToken, dispatch_get_main_queue(), ^(int token) {  //Request notification delivery to a dispatch queue
    [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress]; //locks device :)
  });
    }
  }
 
*/https://developer.apple.com/documentation/darwinnotify/1433440-notify_register_dispatch?language=objc /* read more about notify register dispatch here: /*
