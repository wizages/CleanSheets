%hook UIAlertController
- (NSArray * )actions { %log; NSArray *  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (NSArray * )textFields { %log; NSArray *  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)setTitle:(NSString * )title { %log; %orig; }
- (NSString * )title { %log; NSString *  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)setMessage:(NSString * )message { %log; %orig; }
- (NSString * )message { %log; NSString *  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)setPreferredStyle:(long long )preferredStyle { %log; %orig; }
- (long long )preferredStyle { %log; long long  r = %orig; HBLogDebug(@" = %lld", r); return r; }
- (void)_setAttributedTitle:(NSAttributedString * )attributedTitle { %log; %orig; }
- (NSAttributedString * )_attributedTitle { %log; NSAttributedString *  r = %orig; HBLogDebug(@" = %@", r); return r; }
- (void)_setAttributedMessage:(NSAttributedString * )attributedMessage { %log; %orig; }
- (void)setContentViewController:(UIViewController * )contentViewController { %log; %orig; }
- (UIViewController * )contentViewController { %log; UIViewController *  r = %orig; HBLogDebug(@" = %@", r); return r; }
+(id)notifyMeConfirmationControllerWithHandler:(/*^block*/id)arg1  { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+(BOOL)_shouldSendLegacyMethodsFromViewWillTransitionToSize { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
+(id)alertControllerWithTitle:(id)arg1 message:(id)arg2 preferredStyle:(long long)arg3  { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
+(BOOL)_shouldUsePresentationController { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
-(void)_gkAddCancelButtonWithNoAction { %log; %orig; }
-(void)dealloc { %log; %orig; }
-(UIView *)_foregroundView { %log; UIView * r = %orig; HBLogDebug(@" = %@", r); return r; }
-(BOOL)shouldAutorotate { %log; BOOL r = %orig; HBLogDebug(@" = %d", r); return r; }
-(void)traitCollectionDidChange:(id)arg1  { %log; %orig; }
-(void)viewDidLayoutSubviews { %log; %orig; }
-(void)viewWillTransitionToSize:(CGSize)arg1 withTransitionCoordinator:(id)arg2  { %log; %orig; }
-(id)initWithNibName:(id)arg1 bundle:(id)arg2  { %log; id r = %orig; HBLogDebug(@" = %@", r); return r; }
-(void)loadView { %log; %orig; }
-(void)setModalPresentationStyle:(long long)arg1  { %log; %orig; }
-(void)viewWillAppear:(BOOL)arg1  { %log; %orig; }
-(void)viewDidLoad { %log; %orig; }
%end

%hook UIActionSheet

-(void)setActionSheetStyle:(long long)arg1 {
	%log;
	HBLogDebug(@" = %lld", arg1)
	%orig;
}

-(id)initWithTitle:(id)arg1 delegate:(id)arg2 cancelButtonTitle:(id)arg3 destructiveButtonTitle:(id)arg4 otherButtonTitles:(id)arg5 {
	%log;
	HBLogDebug(@" = %@", arg1)
	%orig;
	return %orig;
}

%end
