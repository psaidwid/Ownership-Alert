#import <LocalAuthentication/LocalAuthentication.h>

static NSString *domainString = @"com.flowgaming.ownershipalert";

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static BOOL osaIsEnabled = YES;
static BOOL powerMenuIsDisabled = YES;
static BOOL allowTouchIDBypass = YES;
static BOOL triggeredAuthentication = NO;
static NSString* userName = @"John Appleseeed";
static NSString* contactInfo = @"911";

@interface SBPowerDownController
-(void)orderFront;
@end

%hook SBPowerDownController

-(void)orderFront
{
  if (!triggeredAuthentication)
  {
    NSNumber *d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"switchEnableTweak" inDomain:domainString];
	  osaIsEnabled = (d)? [d boolValue]:NO;
    d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"switchDisablePowerMenu" inDomain:domainString];
	  powerMenuIsDisabled = (d)? [d boolValue]:NO;
    d = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"switchTouchIDBypass" inDomain:domainString];
	  allowTouchIDBypass = (d)? [d boolValue]:NO;

    if (!osaIsEnabled)
    {
      %orig();
      return;
    }

    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"textboxName" inDomain:domainString];
    contactInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"textboxContact" inDomain:domainString];

    UIAlertView *alertInfo = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Property of %@", userName]
    message:contactInfo
    delegate:self
    cancelButtonTitle:@"Okay"
    otherButtonTitles:nil];

    [alertInfo show];

    if (!powerMenuIsDisabled)
    {
      %orig();
    }

    if (allowTouchIDBypass && !triggeredAuthentication)
    {
      LAContext *context = [[LAContext alloc] init];
      NSError *error = nil;
      NSString *reason = @"Please authenticate using TouchID.";

      if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
        localizedReason:reason
        reply:^(BOOL success, NSError *error)
        {
          dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
          {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
              if (success)
              {
                %orig();
                triggeredAuthentication = NO;
              }
              else
              {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Authentication Error"
                message:@"Invalid Fingerprint"
                delegate:self
                cancelButtonTitle:@"Okay"
                otherButtonTitles:nil];

                [alert show];
              }
            });
          });
        }];
        triggeredAuthentication = YES;
      }
      else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"TouchID Error"
        message:@"TouchID Not Active"
        delegate:self
        cancelButtonTitle:@"Okay"
        otherButtonTitles:nil];

        [alert show];
      }
	  }
  }
  else if (triggeredAuthentication)
  {
    %orig();
    triggeredAuthentication = NO;
  }

  return;
}
%end
