/*
//
//  @version Subversion: $Id: iTeXMac2.h 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#ifndef __iTeXMac2__
#define __iTeXMac2__

#import <Carbon/Carbon.h>
#import "iTM2Implementation.h"

extern NSString * const iTM2FoundationErrorDomain;

void iTM2Beep();

extern NSInteger iTM2DebugEnabled_FLAGS;
enum{
	iTM2DebugEnabled_traceAllFunctionsMask = 1
};

#define __iTM2_PRETTY_FUNCTION__ [NSString stringWithUTF8String:__PRETTY_FUNCTION__]
#define __iTM2_ERROR_DOMAIN__ ([NSString stringWithFormat:@"%s/%s",__FILE__,__PRETTY_FUNCTION__])
#if __iTM2_DEVELOPMENT__
	#define DIAGNOSTIC4iTM3 if (iTM2DebugEnabled_FLAGS&iTM2DebugEnabled_traceAllFunctionsMask)printf("%s %#x\n", __PRETTY_FUNCTION__, (NSUInteger)self)
// enclose some protion of code with
// iTM2DebugEnabled_FLAGS |= iTM2DebugEnabled_traceAllFunctionsMask;
// and
// iTM2DebugEnabled_FLAGS &= ~iTM2DebugEnabled_traceAllFunctionsMask;
// then the DIAGNOSTIC4iTM3 will print the function name letting you trace you program flow
// this was used to identify EXC_BAD_ACCESS deeply hidden in function calls
	#define START_TRACKING4iTM3 iTM2DebugEnabled_FLAGS |= iTM2DebugEnabled_traceAllFunctionsMask
	#define STOP_TRACKING4iTM3 iTM2DebugEnabled_FLAGS &= ~iTM2DebugEnabled_traceAllFunctionsMask
    #define ASSERT_UNREACHABLE_CODE4iTM3 NSAssert(NO,@"UNREACHABLE CODE")
#else
	#define DIAGNOSTIC4iTM3 //
	#define START_TRACKING4iTM3
	#define STOP_TRACKING4iTM3
    #define ASSERT_UNREACHABLE_CODE4iTM3
#endif

#define START4iTM3 NSLog(@"%s %#x START(%@)", __PRETTY_FUNCTION__, self, [[NSDate date] description])
#define END4iTM3   NSLog(@"%s %#x END", __PRETTY_FUNCTION__, self)
#define LOG4iTM3(DESCRIPTION,...)\
do {\
	NSLog(@"file:%s line:%i", __FILE__, __LINE__);\
	NSLog(@"%s %#x", __PRETTY_FUNCTION__, self);\
	NSLog(DESCRIPTION,##__VA_ARGS__,NULL);\
} while(NO)
#define DEBUGLOG4iTM3(LEVEL,DESCRIPTION,...)\
do {\
    if (iTM2DebugEnabled > LEVEL) {\
        NSLog(@"file:%s line:%i", __FILE__, __LINE__);\
        NSLog(@"%s %#x", __PRETTY_FUNCTION__, self);\
        NSLog(DESCRIPTION,##__VA_ARGS__,NULL);\
    }\
} while(NO)
//	NSLog(DESCRIPTION,##__VA_ARGS__);\

#define STRONG_GETSET4iTM3(source, className, getter, setter)\
- (void)getter;\
{\
    return source;\
}\
- (void)setter:(id)argument;\
{\
    if (![source isEqual:argument])\
    {\
        if (argument && ![argument isKindOfClass:[className class]])\
            [NSException raise:NSInvalidArgumentException format:@"%s bad argument class:%@.",\
                __PRETTY_FUNCTION__, argument];\
        else\
        {\
            [source release];\
            source = [argument retain];\
        }\
    }\
    return;\
}

#define SDC [NSDocumentController sharedDocumentController]
#define SUD [NSUserDefaults standardUserDefaults]
#define DFM [NSFileManager defaultManager]
#define DNC [NSNotificationCenter defaultCenter]
#define DDNC [NSDistributedNotificationCenter defaultCenter]
#define SWS [NSWorkspace sharedWorkspace]
#define WSN [[NSWorkspace sharedWorkspace] notificationCenter]
#define SFM [NSFontManager sharedFontManager]
#define SCP [NSColorPanel sharedColorPanel]

#define INIT_POOL4iTM3
//id _P_O_O_L_ = [[NSAutoreleasePool alloc] init]
#define RELEASE_POOL4iTM3
//[_P_O_O_L_ drain]

extern NSString * const iTM2CurrentVersionNumberKey;
extern NSString * const iTM2DebugEnabledKey;

extern NSInteger iTM2DebugEnabled;

#define DEBUG4iTM3 REPLACE DEBUG4iTM3 iTM2DebugEnabled

#define myBUNDLE self.classBundle4iTM3

#define OUTERROR4iTM3(TAG,STRING,UNDERLYING)\
if (outErrorPtr && ([STRING length] || UNDERLYING)) {\
	*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:TAG\
		userInfo:(UNDERLYING?\
			[NSDictionary dictionaryWithObjectsAndKeys:STRING,NSLocalizedDescriptionKey,UNDERLYING,NSUnderlyingErrorKey,nil]\
				:[NSDictionary dictionaryWithObject:STRING forKey:NSLocalizedDescriptionKey])];\
} else if (UNDERLYING) {\
	LOCALERROR4iTM3(TAG,(STRING),(UNDERLYING));\
}

#define LOCALERROR4iTM3(TAG,STRING,UNDERLYING)\
if (UNDERLYING && ([STRING length] || UNDERLYING)) {\
	LOG4iTM3(@"***  ERROR: %@ (%@)",(STRING),(UNDERLYING));\
} else {\
	LOG4iTM3(@"***  ERROR: %@", STRING);\
}

#define REPORTERROR4iTM3(TAG, STRING, UNDERLYING)\
if ([STRING length] || UNDERLYING) {\
[NSApp presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:(NSInteger)TAG\
		userInfo:(UNDERLYING?\
			[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@\n%@",(STRING),[(NSError *)UNDERLYING localizedDescription]],NSLocalizedDescriptionKey,UNDERLYING,NSUnderlyingErrorKey,nil]\
				:[NSDictionary dictionaryWithObject:STRING forKey:NSLocalizedDescriptionKey])]];LOG4iTM3(@"Reporting error:%i,%@,%@",TAG,(STRING),(UNDERLYING));}

#define REPORTERRORINMAINTHREAD4iTM3(TAG, STRING, UNDERLYING)\
if ([STRING length] || UNDERLYING)\
    [NSApp performSelectorOnMainThread:@selector(presentError:)\
        withObject:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:(NSInteger)(TAG)\
            userInfo:(UNDERLYING?\
                [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@\n%@",(STRING),[(NSError *)UNDERLYING localizedDescription]],NSLocalizedDescriptionKey,UNDERLYING,NSUnderlyingErrorKey,nil]\
                    :[NSDictionary dictionaryWithObject:STRING forKey:NSLocalizedDescriptionKey])]\
                        waitUntilDone:NO]

#define UNREACHABLE_CODE4iTM3 NSAssert2(NO,(@"Unreachable code (%s,%lu)"),__FILE__,__LINE__)
#define RAISE_INCONSISTENCY4iTM3(WHY) NSAssert3(NO,(@"REPORT INCONSISTENCY: %@ (%s,%lu)"),WHY,__FILE__,__LINE__)
#define ASSERT_INCONSISTENCY4iTM3(WHAT) NSAssert2((WHAT),(@"INTERNAL INCONSISTENCY: OUPS! (%s,%lu)"),__FILE__,__LINE__)

//#define HUNTING

#endif

/*!
    @class 		iTM2Application
    @abstract	iTeXMac2 principal class. Please, change the info plist entry!
    @discussion	This subclass will be used to alter the default behaviour.
                No alteration is made by the default implementation.
                Implementors will add their own category overriding the inherited behaviour.
*/
@interface iTM2Application: NSApplication
@end

@interface NSApplication(iTMFoundationVersion)

/*!
	@method			currentFVersion4iTM3
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			an integer
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSInteger)currentVersion4iTM3;

/*!
	@method			currentFoundationVersion4iTM3
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			an integter
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSInteger)currentFoundationVersion4iTM3;

@end

@interface NSPointerArray(iTeXMac2)
- (void) addPointerIfAbsent4iTM3:(void *)pointer;
@end
@interface NSNumber(iTeXMac2)
- (CGFloat) CGFloatValue4iTM3;
- (NSNumber *) initWithCGFloat4iTM3:(CGFloat)value;
+ (NSNumber *) numberWithCGFloat4iTM3:(CGFloat)value;
@end

//  All the forthcoming NSRange function manage the NSUIntegerMax barrier more appropriately
//  The resulting ranges always satisfy location+length <= NSUIntegerMax

#   define iTM3EqualRanges NSEqualRanges

NS_INLINE NSRange iTM3MakeRange(NSUInteger loc, NSUInteger len) {
    NSRange r;
    r.location = loc;
    if (len<(r.length = NSUIntegerMax-loc)) r.length = len;
    return r;
}

NS_INLINE NSUInteger iTM3MaxRange(NSRange range) {
    return (range.location < NSUIntegerMax - range.length ? range.location + range.length: NSUIntegerMax);
}

NS_INLINE BOOL iTM3LocationInRange(NSUInteger loc, NSRange range) {
    return (loc >= range.location) && (loc - range.location < range.length);
}

FOUNDATION_EXPORT NSRange iTM3UnionRange(NSRange range1, NSRange range2);

FOUNDATION_EXPORT NSRange iTM3IntersectionRange(NSRange range1, NSRange range2);

FOUNDATION_EXPORT NSRange iTM3ProjectionRange(NSRange destinationRange, NSRange range);

FOUNDATION_EXPORT NSRange iTM3ShiftRange(NSRange range, NSInteger off7);

FOUNDATION_EXPORT NSRange iTM3ScaleRange(NSRange range, NSInteger delta);

#define ZER0 ((NSUInteger)0)
#define iTM3UIntegerUndefined NSUIntegerMax
#define iTM3VoidRange iTM3MakeRange(iTM3UIntegerUndefined,ZER0)
#define iTM3FullRange iTM3MakeRange(ZER0,NSUIntegerMax)
#define iTM3NotFoundRange iTM3MakeRange(NSNotFound,ZER0)

/*
(@header|@param|@method|@class|@result|@abstract|@discussion|@protocol) 
*/
