/*
//
//  @version Subversion: $Id$ 
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

extern NSString * const iTM2FoundationErrorDomain;

BOOL iTM2IsClassObject(id O);
void iTM2Beep();

extern int iTM2DebugEnabled_FLAGS;
enum{
	iTM2DebugEnabled_traceAllFunctionsMask = 1
};

#if __iTM2_DEVELOPMENT__
	#define iTM2_DIAGNOSTIC if(iTM2DebugEnabled_FLAGS&iTM2DebugEnabled_traceAllFunctionsMask)printf("%s %#x\n", __PRETTY_FUNCTION__, (int)self)
// enclose some protion of code with
// iTM2DebugEnabled_FLAGS |= iTM2DebugEnabled_traceAllFunctionsMask;
// and
// iTM2DebugEnabled_FLAGS &= ~iTM2DebugEnabled_traceAllFunctionsMask;
// then the iTM2_DIAGNOSTIC will print the function name letting you trace you program flow
// this was used to identify EXC_BAD_ACCESS deeply hidden in function calls
	#define iTM2_START_TRACKING iTM2DebugEnabled_FLAGS |= iTM2DebugEnabled_traceAllFunctionsMask
	#define iTM2_STOP_TRACKING iTM2DebugEnabled_FLAGS &= ~iTM2DebugEnabled_traceAllFunctionsMask
#else
	#define iTM2_DIAGNOSTIC //
	#define iTM2_START_TRACKING
	#define iTM2_STOP_TRACKING
#endif


#if 1
#define iTM2_START NSLog(@"%s %#x START(%@)", __PRETTY_FUNCTION__, self, [[NSDate date] description])
#define iTM2_END   NSLog(@"%s %#x END", __PRETTY_FUNCTION__, self)
#define iTM2_LOG   NSLog(@"%s %#x", __PRETTY_FUNCTION__, self);NSLog
#else
#define iTM2_START NSLog(@"%s %@ START(%@)", __PRETTY_FUNCTION__, self, [[NSDate date] description])
#define iTM2_END   NSLog(@"%s %@ END", __PRETTY_FUNCTION__, self)
#define iTM2_LOG   NSLog(@"%s %@", __PRETTY_FUNCTION__, self);NSLog
#endif

#define iTM2_STRONG_GETSET(source, className, getter, setter)\
- (void)getter;\
{\
    return source;\
}\
- (void)setter:(id)argument;\
{\
    if(![source isEqual:argument])\
    {\
        if(argument && ![argument isKindOfClass:[className class]])\
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

#define iTM2_INIT_POOL id _P_O_O_L_ = [[NSAutoreleasePool alloc] init]
#define iTM2_RELEASE_POOL [_P_O_O_L_ release]

extern NSString * const iTM2CurrentVersionNumberKey;
extern NSString * const iTM2DebugEnabledKey;

extern int iTM2DebugEnabled;

#define iTM2_DEBUG REPLACE iTM2_DEBUG iTM2DebugEnabled

#define myBUNDLE [self classBundle]

#define iTM2_OUTERROR(TAG, STRING, UNDERLYING)\
if(outError)\
{\
	*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:TAG\
		userInfo:(UNDERLYING?\
			[NSDictionary dictionaryWithObjectsAndKeys:STRING,NSLocalizedDescriptionKey,UNDERLYING,NSUnderlyingErrorKey,nil]\
				:[NSDictionary dictionaryWithObject:STRING forKey:NSLocalizedDescriptionKey])];\
}\
else if(UNDERLYING)\
{\
	iTM2_LOCALERROR(TAG,(STRING),(UNDERLYING));\
}

#define iTM2_LOCALERROR(TAG, STRING, UNDERLYING)\
if(UNDERLYING)\
{\
	iTM2_LOG(@"***  ERROR: %@ (%@)", STRING, UNDERLYING);\
}\
else\
{\
	iTM2_LOG(@"***  ERROR: %@", STRING);\
}

#define iTM2_REPORTERROR(TAG, STRING, UNDERLYING)\
[NSApp presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:TAG\
		userInfo:(UNDERLYING?\
			[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@\n%@",(STRING),[UNDERLYING localizedDescription]],NSLocalizedDescriptionKey,UNDERLYING,NSUnderlyingErrorKey,nil]\
				:[NSDictionary dictionaryWithObject:STRING forKey:NSLocalizedDescriptionKey])]]


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
	@method			currentFVersion
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			an integer
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (int)currentVersion;

/*!
	@method			currentFoundationVersion
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			an integter
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (int)currentFoundationVersion;

@end

/*
(@header|@param|@method|@class|@result|@abstract|@discussion|@protocol) 
*/
