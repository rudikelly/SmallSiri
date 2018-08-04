#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width
#define kHeight [[UIApplication sharedApplication] keyWindow].frame.size.height
#define isX (kHeight >= 812)

@interface UIView (ss)
-(id)_viewControllerForAncestor;
@end

@interface SBAssistantWindow : UIWindow
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

static CGFloat yChange = 0;

//change the frame and corner radius of the siri window - This is where the magic happens
%hook SBAssistantWindow
-(void)becomeKeyWindow
{
    %orig;
    CGFloat yF = isX ? 44 : 10;
    self.frame = CGRectMake(10, yF, kWidth - 20, 90);
    self.subviews[0].layer.cornerRadius = 15;
    self.subviews[0].clipsToBounds = YES;
}
%end

//hide the status bar in the siri window
%hook UIStatusBar
-(void)didMoveToWindow
{
    %orig;
    if ([[[UIApplication sharedApplication] keyWindow] isMemberOfClass:objc_getClass("SBAssistantWindow")])
    {
        self.foregroundColor = [UIColor clearColor];
    }
}
%end

//force button to be on bottom on iPhone X
%hook SiriUISiriStatusView
-(void)layoutSubviews
{
    %orig;
    //get button
    for (UIView* v in self.subviews)
    {
        if ([v isMemberOfClass:[UIButton class]])
        {
            //modify button's frame
            yChange = v.frame.origin.y;
            yChange -= (self.frame.size.height - v.frame.size.height); //will be negative
            v.frame = CGRectMake(0, yChange * -1, self.frame.size.width, self.frame.size.height);
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
%end

//move the help button down so its centered on the iPhoen X
%hook SiriUIHelpButton
-(void)setFrame:(CGRect)arg1
{
    arg1 = CGRectMake(arg1.origin.x, arg1.origin.y - yChange, arg1.size.width, arg1.size.height);
    %orig;
}
%end

//move the flames down so its centered on the iPhoen X
%hook SUICFlamesView
-(void)setFrame:(CGRect)arg1
{
    arg1 = CGRectMake(arg1.origin.x, arg1.origin.y - yChange, arg1.size.width, arg1.size.height);
    %orig;
}
%end

%hook _UIStatusBar
-(void)didMoveToWindow
{
    %orig;
    if ([[[UIApplication sharedApplication] keyWindow] isMemberOfClass:objc_getClass("SBAssistantWindow")])
    {
        [self removeFromSuperview];
    }
}
%end

//hide grabber on iPhone X
%hook MTLumaDodgePillView
-(void)didMoveToWindow
{
    %orig;
    if ([[[UIApplication sharedApplication] keyWindow] isMemberOfClass:objc_getClass("SBAssistantWindow")])
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
    if ([[self _viewControllerForAncestor] isMemberOfClass:objc_getClass("AFUISiriRemoteViewController")])
    {
        self.hidden = YES;
    }
}
%end
