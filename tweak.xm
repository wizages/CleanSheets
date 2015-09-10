%hook UIAlertController
static bool resize;
static bool doWork;

+ (id)alertControllerWithTitle:(id)arg1 message:(id)arg2 preferredStyle:(int)arg3 {
if (arg3 == 0)
{
	resize = true;
}
else {
	resize = false;
}
arg3 = 1;
%orig;
return %orig;	
}

-(id)visualStyleForAlertControllerStyle:(long long)arg1 traitCollection:(id)arg2 descriptor:(id)arg3{
	if (resize)
	{
	arg1 = 0;
	}
	%orig;
	return %orig;
}

-(id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	%log;
	doWork = true;
	%orig;
	HBLogDebug(@"Nib: %@ , bundle: %@", arg1, arg2);
	return %orig;
}
-(void)setPreferredStyled:(long long)arg1 {
	if (doWork)
	{
	%log;
	arg1 = 0;
	}
	%orig;
}

-(void)setTitle:(NSString *)arg1 {
	%log;
	%orig;
}

-(long long)preferredStyle {
	if (doWork)
	{
	%log;
	return 1;
	}
	return %orig;
}

%end


%hook UIAlertControllerVisualStyle

-(bool) hideActionSeparators
{
	return TRUE;
}


%end
