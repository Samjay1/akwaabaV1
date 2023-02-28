#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "OpenMailAppPlugin.h"

FOUNDATION_EXPORT double open_mail_appVersionNumber;
FOUNDATION_EXPORT const unsigned char open_mail_appVersionString[];

