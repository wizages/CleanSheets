
#import <Social/SLComposeViewController.h>
#import <Social/SLServiceTypes.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import "Generic.h"

@interface cleansheetsRootListController : PSListController

@end


@implementation cleansheetsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)loadView {
	[super loadView];
	UIImage* image = [UIImage imageNamed:@"Icon/heart.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
	image = [image changeImageColor:[UIColor colorWithRed:127.0f/255.0f green:71.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
	CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
     
    [someButton addTarget:self action:@selector(heartWasTouched) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    ((UINavigationItem*)self.navigationItem).rightBarButtonItem = heartButton;
}

-(void) viewWillAppear:(BOOL) animated{
	[super viewWillAppear:animated];
	UIView *header;
	header = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 60)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, header.frame.size.width, header.frame.size.height - 10)];
	label.text = @"CleanSheets";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:48];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:127.0f/255.0f green:71.0f/255.0f blue:221.0f/255.0f alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;

    header.frame = CGRectMake(header.frame.origin.x, header.frame.origin.y, header.frame.size.width, header.frame.size.height + 35);
    label.frame = CGRectMake(label.frame.origin.x, 10, label.frame.size.width, label.frame.size.height - 5);
    [header addSubview:label];      
    UILabel *subText = [[UILabel alloc] initWithFrame:CGRectMake(header.frame.origin.x, label.frame.origin.y + label.frame.size.height, header.frame.size.width, 20)];
    subText.text = @"Because clean is always better.";
    subText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    subText.backgroundColor = [UIColor clearColor];
    subText.textColor = [UIColor colorWithRed:127.0f/255.0f green:71.0f/255.0f blue:221.0f/255.0f alpha:1.0];
    subText.textAlignment = NSTextAlignmentCenter;

    [header addSubview:subText];
    [self.table setTableHeaderView:header];
}

-(void)heartWasTouched
{
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeController setInitialText:@"I mustache you a question, why you not using #CleanSheets by @Wizages because dirty was so yesterday."];
    
    [self presentViewController:composeController animated:YES completion:nil];
}

-(void)respring
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    system("killall -9 SpringBoard");
#pragma clang diagnostic pop
}

@end
