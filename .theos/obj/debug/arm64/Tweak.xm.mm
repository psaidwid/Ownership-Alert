#line 1 "Tweak.xm"
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBPowerDownController; 
static void (*_logos_orig$_ungrouped$SBPowerDownController$orderFront)(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBPowerDownController$orderFront(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); 

#line 21 "Tweak.xm"



static void _logos_method$_ungrouped$SBPowerDownController$orderFront(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
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
      _logos_orig$_ungrouped$SBPowerDownController$orderFront(self, _cmd);
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
      _logos_orig$_ungrouped$SBPowerDownController$orderFront(self, _cmd);
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
                [self orderFront];
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
    _logos_orig$_ungrouped$SBPowerDownController$orderFront(self, _cmd);
    triggeredAuthentication = NO;
  }

  return;
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBPowerDownController = objc_getClass("SBPowerDownController"); MSHookMessageEx(_logos_class$_ungrouped$SBPowerDownController, @selector(orderFront), (IMP)&_logos_method$_ungrouped$SBPowerDownController$orderFront, (IMP*)&_logos_orig$_ungrouped$SBPowerDownController$orderFront);} }
#line 110 "Tweak.xm"
