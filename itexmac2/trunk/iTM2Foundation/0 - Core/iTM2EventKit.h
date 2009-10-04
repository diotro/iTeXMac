/*
//  list menu controller tutorial
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/



#import <Carbon/Carbon.h>

/*!
    @const      iTM2FlagsChangedNotification
    @abstract   (description)
    @discussion (description)
*/
extern NSString * const iTM2FlagsDidChangeNotification;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2EventObserver

@interface iTM2EventObserver : NSObject
/*"Class methods"*/
/*"Setters and Getters"*/
/*"Main methods"*/
+ (BOOL)isAlternateKeyDown;
+ (BOOL)isKeyDown:(char)keyNumber;
/*"Overriden methods"*/
@end

@interface iTM2IdleTimer: NSObject
{
@private
	EventLoopTimerRef timer;
	id target;
	id info;
}
- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)inInterval target:(id)target userInfo:(id)userInfo;
-(id)userInfo;
@property EventLoopTimerRef timer;
@property (retain,getter=userInfo) id info;
@end

@interface NSObject(iTM2IdleTimerTarget)
-(void) idleTimerStarted:(iTM2IdleTimer *)idleTime;
-(void) idleTimerIdling:(iTM2IdleTimer *)idleTime;
-(void) idleTimerStopped:(iTM2IdleTimer *)idleTime;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2EventObserver
