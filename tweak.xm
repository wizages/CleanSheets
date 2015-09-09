%hook UIAlertController

+ (id)alertControllerWithTitle:(id)arg1 message:(id)arg2 preferredStyle:(int)arg3 {
arg3 = 1;
%orig;
return %orig;	
}

%end

