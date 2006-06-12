/*
//  iTM2RuntimeBrowser.h
//  iTeXMac2
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


/*!
    @class		iTM2RuntimeBrowser
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
*/
@interface iTM2RuntimeBrowser: NSObject

/*!
    @method		swizzleInstanceMethodSelector:replacement:forClass:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming. Raises exception if paramaters are not consistant.
                See MethodSwizzle on cocoadev to have a description of what this method is doing.
                Beware, the replacement selector is not expected to be used directly, depending on the implementation.
                This is advanced programming that avoids posing as class for very straightforward overriding.
	@param		orig_sel
	@param		alt_sel
	@param		aClass
	@result		A flag indicating whether the change has benn made
*/
+ (BOOL) swizzleInstanceMethodSelector: (SEL) orig_sel replacement: (SEL) alt_sel forClass: (Class) aClass;

/*!
    @method		swizzleClassMethodSelector:replacement:forClass:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming. Raises exception if paramaters are not consistant.
	@param		orig_sel
	@param		alt_sel
	@param		aClass
	@result		A flag indicating whether the change has benn made
*/
+ (BOOL) swizzleClassMethodSelector: (SEL) orig_sel replacement: (SEL) alt_sel forClass: (Class) aClass;

/*!
    @method		allClassReferences
    @abstract	References of all the classes.
    @discussion	Discussion forthcoming.
	@param		None
	@result		An array of NSNumber's containing references to classes
*/
+ (NSArray *) allClassReferences;

/*!
    @method		numberOfClasses
    @abstract	Number of classes registered by the objc runtime system.
    @discussion	Discussion forthcoming.
	@param		None
	@result		An integer
*/
+ (int) numberOfClasses;

/*!
    @method		subclassReferencesOfClass:
    @abstract	Abstract forthcoming.
    @discussion	aClass is not considered as a subclass of itself.
				We return references to avoid sending the +initialize message.
	@param		The class for which subclasses are looked for.
	@result		An array of NSValues's containing references to classes
*/
+ (NSArray *) subclassReferencesOfClass: (Class) aClass;

/*!
    @method		cleanCache:
    @abstract	Clean the cache.
    @discussion	Necessary when new classes or methods are loaded.
	@param		None.
	@result		None
*/
+ (void) cleanCache;

/*!
    @method		isClass:subclassOfClass:
    @abstract	Abstract forthcoming.
    @discussion	No +initialize message is sent to either class.
	@param		lhsClass is the possible descendant.
	@param		rhsClass is the possible ancestor.
	@result		yorn
*/
+ (BOOL) isClass: (Class) lhsClass subclassOfClass: (Class) rhsClass;

/*!
    @method		isClass:subclassOfClassNamed:
    @abstract	Abstract forthcoming.
    @discussion	No +initialize message is sent to either class.
	@param		lhsClass is the possible descendant.
	@param		className is the name of the possible ancestor.
	@result		yorn
*/
+ (BOOL) isClass: (Class) lhsClass subclassOfClassNamed: (const char *) className;

/*!
    @method		instanceSelectorsOfClass:withSuffix:signature:inherited:
    @abstract	An array of the instance selectors of the given class with the given suffix.
    @discussion	Objects are values wrapping SEL's.
	@param		Class is the class.
	@param		suffix is the suffix, it can be nil.
	@param		signature is the signature, it can be nil.
	@param		A flag: No to return only the instance methods and not the inherited ones.
	@result		An array of numbers wrapping selectors
*/
+ (NSArray *) instanceSelectorsOfClass: (Class) Class withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;

/*!
    @method		classSelectorsOfClass:withSuffix:signature:inherited:
    @abstract	An array of the class selectors of the given class with the given suffix.
    @discussion	Objects are values wrapping SEL's.
	@param		Class is the class.
	@param		suffix is the suffix, it can be nil.
	@param		signature is the signature, it can be nil.
	@param		A flag: No to return only the instance methods and not the inherited ones.
	@result		An array of numbers wrapping selectors
*/
+ (NSArray *) classSelectorsOfClass: (Class) Class withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;

/*!
    @method		realInstanceSelectorsOfClass:withSuffix:signature:inherited:
    @abstract	An array of the instance selectors of the given class with the given suffix.
    @discussion	Objects are values wrapping SEL's. The result is not cached by the receiver
				contrary to the non real version.
				The selectors are ordered. All the selectors prefixed with "prepare" are ordered first.
				This makes two categories each one being alphabetically ordered.
	@param		Class is the class.
	@param		suffix is the suffix, it can be nil.
	@param		signature is the signature, it can be nil.
	@param		A flag: No to return only the instance methods and not the inherited ones.
	@result		An array of values wrapping selectors
*/
+ (NSArray *) realInstanceSelectorsOfClass: (Class) Class withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;

/*!
    @method		realClassSelectorsOfClass:withSuffix:signature:inherited:
    @abstract	An array of the class selectors of the given class with the given suffix.
    @discussion	Objects are values wrapping SEL's as pointers. The result is not cached by the receiver
				contrary to the non real version.
	@param		Class is the class.
	@param		suffix is the suffix, it can be nil.
	@param		signature is the signature, it can be nil.
	@param		A flag: No to return only the instance methods and not the inherited ones.
	@result		An array of values wrapping selectors
*/
+ (NSArray *) realClassSelectorsOfClass: (Class) Class withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;

+ (BOOL) disableInstanceMethodSelector: (SEL) orig_sel forClass: (Class) aClass;
+ (BOOL) disableClassMethodSelector: (SEL) orig_sel forClass: (Class) aClass;

@end
