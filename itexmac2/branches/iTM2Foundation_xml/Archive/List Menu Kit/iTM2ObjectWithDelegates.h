/*
//  iTM2ObjectWithDelegates.h
//  CO Tutorial
//
//  Created by jlaurens@users.sourceforge.net on Mon May 14 2001.
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

#import <Cocoa/Cocoa.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ObjectWithDelegates

@interface iTM2ObjectWithDelegates : NSObject
{
@private
    NSDictionary * _Delegates;
    NSString * _MainDelegateKey;
}
/*"Class methods"*/
+ (NSString *) defaultKey;
+ (id) objectWithDelegate: (id) aDelegate;
+ (id) objectWithDelegate: (id) aDelegate forKey: (NSString *) aKey;
+ (id) objectWithDelegates: (NSDictionary *) aDictionary;
/*"Setters and Getters"*/
- (id) delegate;
- (id) delegateForKey: (NSString *) aKey;
- (NSDictionary *) delegates;
- (void) setDelegate: (id) aDelegate forKey: (NSString *) aKey;
- (void) setDelegates: (NSDictionary *) aDictionary;
- (BOOL) isValidKey: (NSString *) aKey;
- (NSArray *) authorizedKeys;
- (BOOL) isValidDelegate: (id) aDelegate forKey: (NSString *) aKey;
- (NSDictionary *) requiredStringSelectors;
- (id) mainDelegate;
- (NSString *) mainDelegateKey;
- (void) setMainDelegateKey: (NSString *) aKey;
/*"Main methods"*/
- (id) initWithDelegate: (id) aDelegate;
- (id) initWithDelegate: (id) aDelegate forKey: (NSString *) aKey;
- (id) initWithDelegates: (NSDictionary *) aDictionary;
/*"Overriden methods"*/
- (NSString *) description;
- (void) dealloc;
- (id) safePerformSelector: (SEL) aSelector;
- (id) safePerformSelector: (SEL) aSelector withObject: (id) anObject;
- (id) safePerformSelector: (SEL) aSelector withObject: (id) anObject1 withObject: (id) anObject2;
- (NSMethodSignature *) methodSignatureForSelector: (SEL) aSelector;
- (void) forwardInvocation: (NSInvocation *) anInvocation;
- (BOOL) respondsToSelector: (SEL) aSelector;
- (BOOL) isMemberOfClass: (Class) aClass;
- (BOOL) isKindOfClass: (Class) aClass;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ObjectWithDelegates
