/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 490 2007-05-04 09:05:15Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Tree.h"
#import "iTM2MacroKit_Prefs.h"
#import "iTM2MacroKit_Controller.h"
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2PreferencesKit.h>


#pragma mark =-=-=-=-=-  MACROS
#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@interface iTM2MutableMacroNode(PRIVATE)
- (unsigned)indexOfObjectInAvailableMacros:(id)object;
- (void)removeObjectFromAvailableMacrosAtIndex:(int)index;
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
@end

@implementation iTM2PrefsMacroNode
+ (void)initialize;
{
 	iTM2_INIT_POOL;
    [self setKeys:[NSArray arrayWithObjects:@"insertion",nil]
		triggerChangeNotificationsForDependentKey:@"argument"];
    [self setKeys:[NSArray arrayWithObjects:@"argument",@"shouldShowArgument",nil]
		triggerChangeNotificationsForDependentKey:@"hiddenArgument"];
    [self setKeys:[NSArray arrayWithObjects:@"argument",nil]
		triggerChangeNotificationsForDependentKey:@"mustShowArgument"];
    [self setKeys:[NSArray arrayWithObjects:@"macroID",nil]
		triggerChangeNotificationsForDependentKey:@"isVisible"];
    [self setKeys:[NSArray arrayWithObjects:@"macroID",nil]
		triggerChangeNotificationsForDependentKey:@"actionName"];
    [self setKeys:[NSArray arrayWithObjects:@"actionName",nil]
		triggerChangeNotificationsForDependentKey:@"actionIdentifier"];
	iTM2_RELEASE_POOL;
	return;
}
- (id)owner;
{
	return owner;
}
- (void)setOwner:(id)anOwner;
{
	owner = anOwner;// just a handle on the owner
	return;
}
- (BOOL)isMutable;// bound
{
	return NO;
}
- (BOOL)isVisible;// bound
{
	return ![[self macroID] hasPrefix:@"."];
}
- (BOOL)isMessage;
{
	NSArray * responderMessages = [iTM2RuntimeBrowser responderMessages];
	NSValue * V = [NSValue valueWithPointer:NSSelectorFromString([self macroID])];
	return [responderMessages containsObject:V];
}
- (BOOL)shouldShowArgument;
{
	return shouldShowArgument;
}
- (void)setShouldShowArgument:(BOOL)flag;
{
	shouldShowArgument = flag;
	return;
}
- (BOOL)mustShowArgument;
{
	return [[self insertion] length] != 0;
}
- (BOOL)hiddenArgument;
{
	return ![self mustShowArgument] && ![self shouldShowArgument];
}
- (NSString *)argument;// bound
{
	return [self insertion];
}
- (NSColor *)argumentTextColor;// bound
{
	return [NSColor disabledControlTextColor];
}
- (NSString *)actionName;// bound to the pref pane
{
	/*  The design is not really good,
	    the macroID should not be used as message for cocoa because it is not portable */
	if(![self isVisible])	return nil;
	if([self selector])		return [self selector];
	if([self isMessage])	return [self macroID];
							return @"insertMacro:";
}
- (NSString *)actionIdentifier;// bound to the pref pane
{
	NSString * AN = [self actionName];
	if([AN hasPrefix:@"insertMacro"])
	{
		return @"insertMacro:";
	}
	if([AN isEqual:@"executeAsScript:"] || [AN isEqual:@"executeScriptAtPath:"])
	{
		return AN;
	}
	return @"noop:";
}
- (void)becomeMutable;
{
	if([self isMutable])
	{
		return;
	}
	[self willChangeValueForKey:@"isMutable"];// notify observers, in particular the key bindings with that macro
	iTM2MutableMacroNode * copy = [[[iTM2MutableMacroNode alloc] init] autorelease];
#define COPY(GETTER,SETTER) [copy SETTER:[self GETTER]];
COPY(macroID,setMacroID)
COPY(insertion,setInsertion)
COPY(selector,setSelector)
COPY(name,setName)
COPY(macroDescription,setMacroDescription)
COPY(tooltip,setTooltip)
#undef COPY
	id list = [self owner];
	unsigned int idx = [list indexOfObjectInAvailableMacros:self];
	[list insertObject:copy inAvailableMacrosAtIndex:idx];
	[list setMacroSelectionIndexes:[NSIndexSet indexSetWithIndex:idx]];
	[self didChangeValueForKey:@"isMutable"];// notify observers, in fact the property has not changed, but the observers will have a chance to behave properly
	return;
}
- (NSString *)prettyMacroID;// bound to UI
{
	return [self macroID];
}
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
{
	[super addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context];
}
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
{
	NS_DURING
	[super removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath];
	NS_HANDLER
NSLog(@"EXCEPTION CATCHED IN %@ removeObserver:%@ keyPath:%@",self,observer,keyPath);
	NS_ENDHANDLER
}
@end

@implementation iTM2MutableMacroNode
- (NSXMLElement *)XMLElement;
{
	NSXMLElement * result = [NSXMLElement elementWithName:@"ACTION"];
	if([[self name] length])				[result addChild:[NSXMLElement elementWithName:@"NAME" stringValue:[self name]]];
	if([[self macroDescription] length])	[result addChild:[NSXMLElement elementWithName:@"DESC" stringValue:[self macroDescription]]];
	if([[self tooltip] length])				[result addChild:[NSXMLElement elementWithName:@"TIP"  stringValue:[self tooltip]]];
	if([[self insertion] length])			[result addChild:[NSXMLElement elementWithName:@"INS"  stringValue:[self insertion]]];
											[result addAttribute:[NSXMLNode attributeWithName:@"ID" stringValue:[self macroID]]];
	if([[self selector] length])			[result addAttribute:[NSXMLNode attributeWithName:@"SEL" stringValue:[self selector]]];
	return result;
}
+ (NSData *)XMLDataWithMacros:(NSDictionary *)theMacros;
{
#if 0
	NSMutableString * result = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
@"	<!DOCTYPE MACROS [\n"
@"	<!ELEMENT MACROS (ACTION)*>\n"
@"	<!ELEMENT ACTION (INS?, NAME?, DESC?, TIP?)>\n"
@"	<!ATTLIST ACTION ID CDATA #REQUIRED>\n"
@"	<!ATTLIST ACTION SEL CDATA #IMPLIED>\n"
@"	<!ELEMENT INS (#PCDATA)>\n"
@"	<!ELEMENT NAME (#PCDATA)>\n"
@"	<!ELEMENT DESC (#PCDATA)>\n"
@"	<!ELEMENT TIP (#PCDATA)>\n"
@"]>\n"
@"<MACROS"];
#endif
	id root = [NSXMLElement elementWithName:@"MACROS"];
	NSEnumerator * E = [theMacros objectEnumerator];
	id node;
	while(node = [E nextObject])
	{
		[root addChild:[node XMLElement]];
	}
	id document = [NSXMLDocument documentWithRootElement:root];
	[document setCharacterEncoding:@"UTF-8"];
	return [document XMLDataWithOptions:NSXMLNodePrettyPrint];
}
- (void)setPrettyMacroID:(NSString *)newID;// bound to UI
{
	if([newID length])
	{
		// no change if the newID is void
		[self setMacroID:newID];
	}
	return;
}
- (BOOL)validatePrettyMacroID:(id *)ioValue error:(NSError **)outErrorRef;
{
	if(outErrorRef)
	{
		*outErrorRef = nil;
	}
	if(!ioValue)
	{
		return NO;
	}
    if([[self macroID] isEqual:*ioValue] || [self macroID] == *ioValue)
	{
		return YES;
	}
	if([[[self owner] personalMacros] objectForKey:*ioValue] || [[[self owner] macros] objectForKey:*ioValue])
	{
		if(outErrorRef)
		{
			*outErrorRef = [NSError errorWithDomain:iTM2FoundationErrorDomain code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					NSLocalizedStringFromTableInBundle(@"Setup failure", iTM2LocalizedExtension, [self classBundle], ""), NSLocalizedDescriptionKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"There is already a macro named %@", iTM2LocalizedExtension, [self classBundle], ""), *ioValue], NSLocalizedFailureReasonErrorKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Don't choose %@", iTM2LocalizedExtension, [self classBundle], ""), *ioValue], NSLocalizedRecoverySuggestionErrorKey,
						nil]];
		}
		return NO;
	}
    return YES;
}
- (void)setArgument: (NSString *)argument;
{
	[self setInsertion:argument];
	return;
}
- (void)setActionName:(NSString *)newActionName;
{
	if([@"insertMacro:" isEqual:newActionName] || [@"noop:" isEqual:newActionName] || ![newActionName length])
	{
		self.selector = nil;
	}
	else
	{
		self.selector = newActionName;
	}
	return;
}
- (BOOL)isMutable;
{
	return YES;
}
- (NSColor *)argumentTextColor;// bound
{
	return [NSColor textColor];
}
#pragma mark =-=-=-=-=-  LEAF
- (NSString *)codeNameWithModifiers;
{
	return @"codeNameWithModifiers";
}
@end

@implementation iTM2MacroList
+ (void)initialize;
{
 	iTM2_INIT_POOL;
	[super initialize];
	[self setKeys:[NSArray arrayWithObjects:@"customOnly",nil]
			triggerChangeNotificationsForDependentKey:@"availableMacros"];
	iTM2_RELEASE_POOL;
	return;
}
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey;
{
	BOOL result = ![theKey isEqualToString:@"availableMacros"] && [super automaticallyNotifiesObserversForKey:theKey];
//iTM2_LOG(@"theKey:%@->%@",theKey,(result?@"yes":@"no"));
    return result;
}
- (id)initWithParent:(id)parent;
{
	if(self = [super initWithParent:parent])
	{
		NSURL * personalUrl = [parent personalURL];
		NSMutableDictionary * MD = [NSMutableDictionary dictionary];
		NSError * localError =  nil;
		NSData * data;
		NSDictionary * D;
		if([personalUrl isFileURL] && [DFM fileExistsAtPath:[personalUrl path]])
		{
			data = [NSData dataWithContentsOfURL:personalUrl options:0 error:&localError];
			if(localError)
			{
				iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", personalUrl,localError);
			}
			if(D = [iTM2MutableMacroNode macrosWithData:data owner:self])
			{
				[MD addEntriesFromDictionary:D];
			}
		}
		[self setPersonalMacros:MD];
		MD = [NSMutableDictionary dictionary];
		NSEnumerator * E = [[parent valueForKeyPath:@"value.URLsPromise"] objectEnumerator];
		NSURL * url;
		while(url = [E nextObject])
		{
			if(![url isEqual:personalUrl])
			{
				localError = nil;
				data = [NSData dataWithContentsOfURL:url options:0 error:&localError];
				if(localError)
				{
					iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
				}
				if(D = [iTM2PrefsMacroNode macrosWithData:data owner:self])
				{
					[MD addEntriesFromDictionary:D];
				}
			}
		}
		[self setMacros:MD];
	}
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableScripts
- (NSArray *)_X_availableScripts;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [self valueForKeyPath:@"value.availableScripts"];
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	id parent = [self parent];
	NSString * category = [parent valueForKeyPath:@"value.category"];
	parent = [parent parent];
	NSString * subpath = [parent valueForKeyPath:@"value.domain"];
	subpath = [subpath stringByAppendingPathComponent:category];
	subpath = [subpath stringByAppendingPathComponent:iTM2MacroScriptsComponent];
	NSBundle * MB = [NSBundle mainBundle];
	NSArray * RA = [MB allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		if([DFM pushDirectory:path])
		{
			if([DFM pushDirectory:subpath])
			{
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:@"."];
				while(path = [DE nextObject])
				{
					BOOL flag;
					if([path hasPrefix:@"."])
					{
						// do nothing, this is a hidden file
					}
					else if([path hasPrefix:@"."])// missing finder test (kIsVisibleFlag?)
					{
						// do nothing, this is a hidden file here too
					}
					else if([DFM fileExistsAtPath:path isDirectory:&flag] && flag)
					{
						// do nothing, this is a directory
					}
					else
					{
						[result addObject:path];
					}
				}
				[DFM popDirectory];
			}
			else if([DFM fileExistsAtPath:subpath isDirectory:nil])
			{
				iTM2_LOG(@"*** SILENT Error: could not push \"%@/%@\"",[DFM currentDirectoryPath],subpath);
			}
			[DFM popDirectory];
		}
		else
		{
			iTM2_LOG(@"*** SILENT Error: could not push \"%@\"",path);
		}
	}
	[result sortUsingSelector:@selector(compare:)];
	[self setValue:result forKeyPath:@"value.availableScripts"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableScripts
- (unsigned int)countOfAvailableScripts;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableScripts] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableScriptsAtIndex:
- (id)objectInAvailableScriptsAtIndex:(int) index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableScripts] objectAtIndex:index];
}
- (NSMutableDictionary *)macros;
{
	return [self valueForKeyPath:@"value.macros"];
}
- (void)setMacros:(NSMutableDictionary *)macros;
{
	[self setValue:macros forKeyPath:@"value.macros"];
}
- (NSMutableDictionary *)personalMacros;
{
	return [self valueForKeyPath:@"value.personalMacros"];
}
- (void)setPersonalMacros:(NSMutableDictionary *)macros;
{
	[self setValue:macros forKeyPath:@"value.personalMacros"];
}
- (NSIndexPath *)indexPath;
{
	return nil;
}
- (id)nextSibling;
{
	return nil;
}
- (id)nextParentSibling;
{
	return nil;
}
- (id)macroWithID:(NSString *)ID;
{
	return [[self personalMacros] objectForKey:ID]?:[[self macros] objectForKey:ID];
}
#pragma mark =-=-=-=-=-  MACROS
- (BOOL)customOnly;
{
	return [[self valueForKeyPath:@"value.customOnly"] boolValue];
}
- (BOOL)canCustomOnly;
{
	return YES;
}
- (void)setCustomOnly:(BOOL)argument;
{
	[self setValue:[NSNumber numberWithBool:argument] forKeyPath:@"value.customOnly"];
	[self willChangeValueForKey:@"availableMacros"];
	[self setValue:nil forKeyPath:@"value.availableMacros"];
	[self didChangeValueForKey:@"availableMacros"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableMacros
- (NSMutableArray *)_X_availableMacros;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [self valueForKeyPath:@"value.availableMacros"];
	if(result)
	{
		return result;
	}
	if([self customOnly])
	{
		result = [self personalMacros];
	}
	else
	{
		result = [NSMutableDictionary dictionaryWithDictionary:[self macros]];
		[result addEntriesFromDictionary:[self personalMacros]];
	}
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(SELF BEGINSWITH \".\")"];
	id Ks = [[result allKeys] filteredArrayUsingPredicate:predicate];
	result = [result objectsForKeys:Ks notFoundMarker:[NSNull null]];
	Ks = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"macroID" ascending:YES] autorelease]];
	result = [[result sortedArrayUsingDescriptors:Ks] mutableCopy];
	[self setValue:result forKeyPath:@"value.availableMacros"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableMacros
- (unsigned int)countOfAvailableMacros;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableMacros] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableMacrosAtIndex:
- (id)objectInAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableMacros] objectAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableMacrosWithID:
- (id)objectInAvailableMacrosWithID:(NSString *)ID;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString *attributeName = @"macroID";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE '%@'",attributeName, ID];
	NSArray * result = [self _X_availableMacros];
	result = [result filteredArrayUsingPredicate:predicate];
	if(![result count])
	{
		result = [self _X_availableMacros];
		NSEnumerator * E = [result objectEnumerator];
		result = [NSMutableArray array];
		id node;
		while(node = [E nextObject])
		{
			if([ID isEqual:[node macroID]])
			{
				[(NSMutableArray *)result addObject:node];
			}
		}
	}
	result = [result lastObject];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromAvailableMacrosAtIndex:
- (void)removeObjectFromAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * availableMacros = [self _X_availableMacros];
	id O = [[[availableMacros objectAtIndex:index] retain] autorelease];
	[[self personalMacros] removeObjectForKey:[O macroID]];
	[O setOwner:nil];
	id ON = [[self macros] objectForKey:[O macroID]];
	if(ON)
	{
		[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableMacros"];
		[availableMacros replaceObjectAtIndex:index withObject:ON];
		[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableMacros"];
	}
	else
	{
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableMacros"];
		[availableMacros removeObjectAtIndex:index];
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableMacros"];
	}
	[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inAvailableMacrosAtIndex:
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * ID = [object macroID];
	NSArray * IDs = [[self personalMacros] allKeys];
	if([IDs containsObject:ID])
	{
		// do nothing, this is already there
		return;
	}
	IDs = [self availableIDs];// personal and other macros
	if(![ID length])
	{
		ID = @"macro";
		if([IDs containsObject:ID])
		{
			unsigned idx = 0;
			do
			{
				ID = [NSString stringWithFormat:@"macro %i",++idx];
			}
			while([IDs containsObject:ID]);
		}
		[object setMacroID:ID];
	}
	[[self personalMacros] setObject:object forKey:ID];
	[object setOwner:self];
	id old = [[self macros] objectForKey:ID];
	id AMs = [self _X_availableMacros];
	unsigned idx = [AMs indexOfObject:old];
	if(idx != NSNotFound)
	{
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:idx] forKey:@"availableMacros"];
		[AMs removeObjectAtIndex:idx];
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:idx] forKey:@"availableMacros"];
		[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:idx] forKey:@"availableMacros"];
		[AMs insertObject:object atIndex:idx];
		[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:idx] forKey:@"availableMacros"];
	}
	else
	{
		[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableMacros"];
		[AMs insertObject:object atIndex:index];
		[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableMacros"];
	}
	[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
	IDs = [self availableIDs];// updated
	if(![IDs containsObject:ID])
	{
		iTM2_LOG(@"***  THE MACRO WAS NOT ADDED");
	}
//iTM2_END;
    return;
}
- (unsigned)indexOfObjectInAvailableMacros:(id)object;
{
	return [[self _X_availableMacros] indexOfObject:object];
}
- (NSArray *)availableIDs;
{
	return [[[self personalMacros] allKeys] arrayByAddingObjectsFromArray:[[self macros] allKeys]];
}
- (NSIndexSet *)macroSelectionIndexes;
{
	return [self valueForKeyPath:@"value.macroSelectionIndexes"];
}
- (void)setMacroSelectionIndexes:(NSIndexSet *)indexes;
{
	[self setValue:indexes forKeyPath:@"value.macroSelectionIndexes"];
	return;
}
@end

@implementation iTM2MacroAbstractContextNode(Preferences)
- (Class)listClass;
{
	NSAssert1(NO,@"****  ERROR: You must override %@",NSStringFromSelector(_cmd));
	return Nil;
}
/*" This is the editor used by the prefs
"*/
- (id)list;
{
	id result = [self valueForKeyPath:@"value.list"];
	if(!result)
	{
		result = [[[[self listClass] allocWithZone:[self zone]] initWithParent:self] autorelease];
		[self setValue:result forKeyPath:@"value.list"];
		result = [self valueForKeyPath:@"value.list"];
	}
	return result;
}
@end

@implementation iTM2MacroContextNode(Preferences)
- (Class)listClass;
{
	return [iTM2MacroList class];
}
- (NSData *)personalDataForSaving;
{
	return [iTM2MutableMacroNode XMLDataWithMacros:[[self list] personalMacros]];
}
@end

@interface iTM2MacroArrayController: NSArrayController
@end

@implementation iTM2MacroArrayController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  canRemove
- (BOOL)canRemove;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSIndexSet * indexSet = [self selectionIndexes];
	NSArray * RA = [self arrangedObjects];
	unsigned int index = [indexSet firstIndex];
	while(index != NSNotFound)
	{
		id O = [RA objectAtIndex:index];
		if([O respondsToSelector:@selector(isMutable)] && [O isMutable])
		{
			return YES;
		}
		index = [indexSet indexGreaterThanIndex:index];
	}
	RA = [self content];
//iTM2_END;
    return NO;
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  KE* BINDINGS

@interface iTM2KeyStroke(Preferences)
- (BOOL)isShift;
- (BOOL)isControl;
- (BOOL)isCommand;
- (BOOL)isAlternate;
//- (BOOL)isFunction;
- (BOOL)isHelp;
- (BOOL)isAlphaShift;
- (BOOL)isNumericPad;
- (void)setIsShift:(BOOL)newFlag;
- (void)setIsControl:(BOOL)newFlag;
- (void)setIsCommand:(BOOL)newFlag;
//- (void)setIsFunction:(BOOL)newFlag;
- (void)setIsAlternate:(BOOL)newFlag;
- (void)setIsHelp:(BOOL)newFlag;
- (void)setIsAlphaShift:(BOOL)newFlag;
- (void)setIsNumericPad:(BOOL)newFlag;
@end

@implementation iTM2KeyStroke(Preferences)
#define DEFINE(GETTER,SETTER,CAN,FLAG)\
- (BOOL)GETTER;{return (modifierFlags & FLAG) > 0;}\
- (void)SETTER:(BOOL)yorn;{modifierFlags = (yorn?modifierFlags | FLAG:modifierFlags &~ FLAG);}\
- (BOOL)CAN;{return [codeName length]>0;}
DEFINE(isShift,setIsShift,canShift,NSShiftKeyMask)
DEFINE(isControl,setIsControl,canControl,NSControlKeyMask)
DEFINE(isCommand,setIsCommand,canCommand,NSCommandKeyMask)
//DEFINE(isFunction,setIsFunction,canFunction,NSFunctionKeyMask)
DEFINE(isAlternate,setIsAlternate,canAlternate,NSAlternateKeyMask)
DEFINE(isHelp,setIsHelp,canHelp,NSHelpKeyMask)
DEFINE(isAlphaShift,setIsAlphaShift,canAlphaShift,NSAlphaShiftKeyMask)
DEFINE(isNumericPad,setIsNumericPad,canNumericPad,NSNumericPadKeyMask)
#undef DEFINE
@end

@interface iTM2PrefsKeyBindingNode(PRIVATE)
- (void)setMacro:(id)new;
- (void)setMacroID:(NSString *)newID;
- (void)setPrettyMacroID:(NSString *)newID;// bound to UI
@end

@interface iTM2MutableKeyBindingNode(PRIVATE)
- (unsigned)indexOfObjectInAvailableKeyBindings:(id)object;
- (void)removeObjectFromAvailableKeyBindingsAtIndex:(int)index;
- (void)insertObject:(id)object inAvailableKeyBindingsAtIndex:(int)index;
- (id)objectInAvailableKeyBindingsAtIndexPath:(NSIndexPath *) indexPath;
@end

@interface iTM2MacroController(Prefs)
- (id)mutableMacroRunningNodeForID:(NSString *)ID context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
@end

@implementation iTM2PrefsKeyBindingNode
+ (void)initialize;
{
	iTM2_INIT_POOL;
	[super initialize];
    [self setKeys:[NSArray arrayWithObjects:@"modifierFlags",
		@"isShift",@"isControl",@"isCommand",@"isAlternate",@"isHelp",@"isAlphaShift",@"isNumericPad",//@"isFunction",
			@"codeName",@"altCodeName",nil]
		triggerChangeNotificationsForDependentKey:@"key"];
    [self setKeys:[NSArray arrayWithObjects:@"key",nil] triggerChangeNotificationsForDependentKey:@"prettyKey"];
	[self setKeys:[NSArray arrayWithObject:@"availableKeyBindings"] triggerChangeNotificationsForDependentKey:@"prettyMacroID"];
	[self setKeys:[NSArray arrayWithObject:@"macroID"] triggerChangeNotificationsForDependentKey:@"prettyMacroID"];
	[self setKeys:[NSArray arrayWithObject:@"prettyMacroID"] triggerChangeNotificationsForDependentKey:@"macro"];
	[self setKeys:[NSArray arrayWithObject:@"prettyMacroID"] triggerChangeNotificationsForDependentKey:@"isVisible"];
	iTM2_RELEASE_POOL;
}
- (BOOL)customOnly;// not yet bound
{
	return NO;
}
- (BOOL)canCustomOnly;
{
	return NO;
}
- (id) init;
{
	if(self = [super init])
	{
		[value autorelease];
		value = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherNode
- (id)otherNode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
- (BOOL)isMutable;// bound
{
	return NO;
}
- (NSString *)prettyModifiers;// only function, control, command
{
	NSMutableString * result = [NSMutableString string];
#if 0
	if([self isFunction])
	{
		[result appendString:@"fn "];
	}
#endif
	if([self isControl])
	{
		[result appendString:[NSString stringWithUTF8String:"ctrl "]];
	}
	if([self isCommand])
	{
		[result appendString:@"\xE2\x8C\x98"];//⌘
	}
	return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)prettyAltModifiers;// shift and alt if any
{
	NSMutableString * result = [NSMutableString string];
	if([self isShift])
	{
		[result appendString:@"\xE2\x87\xA7"];//⇧
	}
	if([self isAlternate])
	{
		[result appendString:@"\xE2\x8C\xA5"];//⌥
	}
	return result;
}
- (NSString *)prettyCodeName;
{
	return [KCC localizedNameForCodeName:[self codeName]];
}
- (NSString *)prettyKey;
{
	NSString * prettyKey = [[NSString stringWithFormat:@"%@ %@ %@",[self prettyModifiers],[self prettyAltModifiers],[self prettyCodeName]]
								stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString * altCodeName = [self altCodeName];
	if([altCodeName length])
	{
		prettyKey = [NSString stringWithFormat:@"%@ (%@)",prettyKey,altCodeName];
	}
	return [[prettyKey componentsSeparatedByString:@"  "] componentsJoinedByString:@" "];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableKeyBindings
- (NSArray *)_X_availableKeyBindings;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * result = [self valueForKeyPath:@"value.availableKeyBindings"];
	if(result)
	{
		return result;
	}
	NSString *attributeName = @"macroID";
	NSString *attributeValue = @"noop:";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(%K LIKE '%@')",
        attributeName, attributeValue];
	result = [[self children] filteredArrayUsingPredicate:predicate];
	[self setValue:result forKeyPath:@"value.availableKeyBindings"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableKeyBindings
- (unsigned int)countOfAvailableKeyBindings;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableKeyBindings] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indexOfObjectInAvailableKeyBindings:
- (unsigned int)indexOfObjectInAvailableKeyBindings:(id)object;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableKeyBindings] indexOfObject:object];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableKeyBindingsAtIndex:
- (id)objectInAvailableKeyBindingsAtIndex:(int) index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * KBs = [self _X_availableKeyBindings];
//iTM2_END;
    return index<[KBs count]?[KBs objectAtIndex:index]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableKeyBindingsAtIndexPath:
- (id)objectInAvailableKeyBindingsAtIndexPath:(NSIndexPath *) indexPath;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int length = [indexPath length];
	unsigned int position = 0;
	id result = self;
	while(position < length)
	{
		result = [result objectInAvailableKeyBindingsAtIndex:[indexPath indexAtPosition:position++]];
	}
//iTM2_END;
    return result;
}
- (id)macro;// bound to UI
{
	return [self valueForKeyPath:@"value.macro"];
}
- (void)setMacro:(id)new;
{
	id old = [self valueForKeyPath:@"value.macro"];
	if(![new isEqual:old] && (new != old))
	{
		[self willChangeValueForKey:@"macro"];
		[old removeObserver:self forKeyPath:@"isMutable"];
		[self setValue:new forKeyPath:@"value.macro"];
		[new addObserver:self forKeyPath:@"isMutable" options:0 context:self];
		[self didChangeValueForKey:@"macro"];
	}
}
- (void)setMacroID:(NSString *)newID;
{
	id oldID = [self macroID];
	if(![oldID isEqual:newID] && (oldID != newID))
	{
		[super setMacroID:newID];
		[self setMacro:[SMC mutableMacroRunningNodeForID:newID context:[self macroContext] ofCategory:[self macroCategory] inDomain:[self macroDomain]]];
		[self setPrettyMacroID:nil];
	}
	return;
}
- (NSString *)prettyMacroID;// bound to UI
{
	NSString * result = [self valueForKeyPath:@"value.prettyMacroID"];
	if(!result)
	{
		result = ([self countOfAvailableKeyBindings]?@"":[self macroID]);
		[self setValue:result forKeyPath:@"value.prettyMacroID"];
	}
	return result;
}
- (void)setPrettyMacroID:(NSString *)newID;// bound to UI
{
	[self setValue:newID forKeyPath:@"value.prettyMacroID"];
	if([newID length])
	{
		id oldID = [self macroID];
		if(![oldID isEqual:newID] && (oldID != newID))
		{
			[self setMacroID:newID];
		}
	}
	return;
}
- (void)becomeMutable;
{
	if([self isMutable])
	{
		return;
	}
	[self willChangeValueForKey:@"isMutable"];
	NSMutableArray * KSs = [NSMutableArray array];
	id parent = self;
	do
	{
		[KSs addObject:parent];
		parent = [self parent];
		// this loop stops the first time it enconters a void code name
		// the parent should be the 'otherNode' of the key bindings list
	}
	while([parent isKindOfClass:[iTM2PrefsKeyBindingNode class]] && [parent codeName]);
	id list = [parent parent];
	parent = list;
	// now parent is the root mutable key binding node, aka a key binding list and the keyBindingEditor
	unsigned int idx;
	id KS;
	NSEnumerator * E = [KSs reverseObjectEnumerator];
	while(KS = [E nextObject])
	{
		idx = [parent indexOfObjectInAvailableKeyBindings:KS];
		if(idx == NSNotFound)
		{
			iTM2MutableKeyBindingNode * copy;
makeACopyOfKS:
			copy = [[[iTM2MutableKeyBindingNode alloc] init] autorelease];
#define COPY(GETTER,SETTER) [copy SETTER:[KS GETTER]];
COPY(altCodeName,setAltCodeName)
COPY(codeName,setCodeName)
COPY(modifierFlags,setModifierFlags)
#undef COPY
			if([[KS children] count] == 0)
			{
				[copy setMacroID:[KS macroID]];
			}
			[parent insertObject:copy inAvailableKeyBindingsAtIndex:0];
			parent = copy;
		}
		else
		{
			KS = [parent objectInAvailableKeyBindingsAtIndex:idx];
			if([KS isMutable])
			{
				parent = KS;
			}
			else
			{
				goto makeACopyOfKS;
			}
		}
	}
	// now parent is a mutated copy of self
	// I have to manage the selection
	self = parent;
	KSs = [NSMutableArray array];
	do
	{
		[KSs addObject:parent];
		parent = [self parent];
		// this loop stops the first time it enconters a void code name
		// the parent should be the key bindings list
	}
	while([parent isKindOfClass:[iTM2PrefsKeyBindingNode class]] && [parent codeName]);
	NSIndexPath * indexPath = [[[NSIndexPath alloc] init] autorelease];
	E = [KSs reverseObjectEnumerator];
	while(KS = [E nextObject])
	{
		indexPath = [indexPath indexPathByAddingIndex:[parent indexOfObjectInAvailableKeyBindings:KS]];
		parent = KS;
	}
	[list setKeyBindingSelectionIndexPaths:[NSArray arrayWithObject:indexPath]];
	[self didChangeValueForKey:@"isMutable"];
	return;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	if(context == self)
	{
		if([keyPath isEqual:@"isMutable"])
		{
			[self setMacro:[SMC mutableMacroRunningNodeForID:[self macroID] context:[self macroContext] ofCategory:[self macroCategory] inDomain:[self macroDomain]]];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	return;
}
- (void)dealloc;
{
	[self setMacro:nil];// cleans bindings
	[value autorelease];
	value = nil;
	[super dealloc];
}
@end

@interface iTM2MutableKeyBindingNode(XML)
- (void)feedXMLElement:(NSXMLElement *)element;// element is the parent
@end

@implementation iTM2MutableKeyBindingNode
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey;
{
	BOOL result =
		![theKey isEqualToString:@"availableKeyBindings"]
			&& [super automaticallyNotifiesObserversForKey:theKey];
//iTM2_LOG(@"theKey:%@->%@",theKey,(result?@"yes":@"no"));
    return result;
}
- (void)becomeMutable;
{
	return;
}
- (BOOL)customOnly;
{
	return [[self valueForKeyPath:@"value.customOnly"] boolValue];
}
- (BOOL)canCustomOnly;
{
	return YES;
}
- (void)setCustomOnly:(BOOL)argument;
{
	[self setValue:[NSNumber numberWithBool:argument] forKeyPath:@"value.customOnly"];
	[self willChangeValueForKey:@"availableKeyBindings"];
	[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
	[self didChangeValueForKey:@"availableKeyBindings"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyOtherNode
- (id)lazyOtherNode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(([self parent] == nil || [[self parent] isKindOfClass:[iTM2MutableKeyBindingNode class]]),@"The parent must be a iTM2MutableKeyBindingNode...");
//iTM2_END;
	return [[(iTM2MutableKeyBindingNode *)[self parent] otherNode] objectInChildrenWithKeyStroke:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherNode
- (id)otherNode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!otherNode)
	{
		otherNode = [[self lazyOtherNode] retain];
	}
//iTM2_END;
    return otherNode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOtherNode
- (void)setOtherNode:(id)theOtherNode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[otherNode autorelease];
	otherNode = [theOtherNode retain];
//iTM2_END;
    return;
}
- (void)dealloc;
{
	[self setOtherNode:nil];
	[super dealloc];
}
- (void)feedElementWithChildren:(NSXMLElement *)element;
{
	NSEnumerator * E = [[self children] objectEnumerator];
	id child;
	while(child = [E nextObject])
	{
		[child feedXMLElement:element];
	}
	return;
}
- (void)feedXMLElement:(NSXMLElement *)element;// element is the parent
{
	if(([[self codeName] length] == 0) && ([self parent] != nil))// only the root is allowed not to have a KEY attribute
	{
		return;
	}
	NSXMLElement * me = [NSXMLElement elementWithName:@"BIND"];
	[me addAttribute:[NSXMLNode attributeWithName:@"KEY" stringValue:[self key]]];
	id K = [self altCodeName];
	if([K length] && ![K isEqual:[self codeName]])
	{
		[me addAttribute:[NSXMLNode attributeWithName:@"ALT" stringValue:K]];
	}
	K = [self macroID];
	if([K length])
	{
		[me addAttribute:[NSXMLNode attributeWithName:@"ID" stringValue:K]];
	}
	[element addChild:me];
	[self feedElementWithChildren:me];
	return;
}
- (NSData *)XMLData;
{
#if 0
	NSMutableString * result = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
@"	<!DOCTYPE BINDINGS [\n"
@"	<!ELEMENT BINDINGS (BIND)*>\n"
@"	<!ELEMENT BIND (BIND)*>\n"
@"	<!ATTLIST BIND KEY CDATA #REQUIRED>\n"
@"	<!ATTLIST BIND ID CDATA #IMPLIED>\n"
@"	<!ATTLIST BIND ALT CDATA #IMPLIED>\n"
@"]>\n"
@"<BINDINGS"];
#endif
	NSXMLElement * root = [NSXMLElement elementWithName:@"BINDINGS"];
	[self feedElementWithChildren:root];
	id document = [NSXMLDocument documentWithRootElement:root];
	[document setCharacterEncoding:@"UTF-8"];
	return [document XMLDataWithOptions:NSXMLNodePrettyPrint|NSXMLNodeCompactEmptyElement];
}
- (void)updateKeyStroke;
{
	if([self otherNode])
	{
		// we can only change the key stroke of mutable nodes with no immutable counterpart
		// this is due to binding internals
		return;
	}
	NSEvent * E = [NSApp currentEvent];
	if([E type] != NSKeyDown && [E type] != NSKeyUp)
	{
		return;
	}
	iTM2KeyStroke * KS = [iTM2KeyStroke keyStrokeWithEvent:E];
	if([[self parent] objectInChildrenWithKeyStroke:KS])
	{
		// there is already such a keystroke
		return;
	}
	if([[(id)[self parent] otherNode] objectInChildrenWithKeyStroke:KS])
	{
		// there is already such a keystroke
		return;
	}
	[self setCodeName:[KS codeName]];
	[self setAltCodeName:[KS altCodeName]];
	[self setModifierFlags:[KS modifierFlags]];
	return;
}
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@(%#x):%@(%i)>",NSStringFromClass([self class]),self,[self macroID],[[self children] count]];
}
- (BOOL)isMutable;
{
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableKeyBindings
- (NSMutableArray *)_X_availableKeyBindings;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [self valueForKeyPath:@"value.availableKeyBindings"];
	if(result)
	{
		return result;
	}
	NSMutableSet * candidates = [NSMutableSet setWithArray:[[self otherNode] children]];
	[candidates addObjectsFromArray:[self children]];
	NSString *attributeName = @"macroID";
	NSString *attributeValue = @"noop:";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(%K LIKE '%@')",
        attributeName, attributeValue];
	result = [[[candidates allObjects] filteredArrayUsingPredicate:predicate] mutableCopy];
	[self setValue:result forKeyPath:@"value.availableKeyBindings"];
	[result autorelease];// balancing the mutableCopy above
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inAvailableKeyBindingsAtIndex:
- (void)insertObject:(id)object inAvailableKeyBindingsAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// maybe the object is not inserted
	if(!object)
	{
		return;
	}
	id old = [self objectInChildrenWithKeyStroke:object];
	if(old)
	{
		// do nothing, this is already there
		// it should be selected
		return;
	}
	[self insertObject:object inChildrenAtIndex:0];
	id already = [[self otherNode] objectInChildrenWithKeyStroke:object];
	if(already)
	{
		[object setOtherNode:already];
		unsigned alreadyIndex = [self indexOfObjectInAvailableKeyBindings:already];
		if(alreadyIndex != NSNotFound)
		{
			[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:alreadyIndex] forKey:@"availableKeyBindings"];
			[[self _X_availableKeyBindings] replaceObjectAtIndex:alreadyIndex withObject:object];
			[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:alreadyIndex] forKey:@"availableKeyBindings"];
		}
		else
		{
			// the previous node was not exposed, so do insert a new one
			[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
			[[self _X_availableKeyBindings] insertObject:object atIndex:index];
			[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
		}
	}
	else
	{
		[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
		[[self _X_availableKeyBindings] insertObject:object atIndex:index];
		[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
	}
	if(![self objectInChildrenWithKeyStroke:object])
	{
		iTM2_LOG(@"***  THE KEY WAS NOT ADDED");
	}
	[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
	[self setPrettyMacroID:@""];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromAvailableKeyBindingsAtIndex:
- (void)removeObjectFromAvailableKeyBindingsAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id O = [[[self objectInAvailableKeyBindingsAtIndex:index] retain] autorelease];
	id ON = [O otherNode];
	if(ON)
	{
		[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
		[[self _X_availableKeyBindings] replaceObjectAtIndex:index withObject:ON];
		[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
	}
	else
	{
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
		[[self _X_availableKeyBindings] removeObjectAtIndex:index];
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"availableKeyBindings"];
	}
	[(NSMutableArray *)[self children] removeObject:O];
	[O setParent:nil];//
	[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
	[self setPrettyMacroID:([self countOfAvailableKeyBindings]?@"":[self macroID])];
//iTM2_END;
    return;
}
- (id)objectInKeyBindingsWithKeyStroke:(iTM2KeyStroke *)keyStroke;
{
	// this is where the preferences are catched
	return [self objectInChildrenWithKeyStroke:keyStroke]?:[[self otherNode] objectInChildrenWithKeyStroke:keyStroke];
}
@end

@implementation iTM2KeyBindingList
- (id)initWithParent:(id)parent;
{
	if(self = [super initWithParent:parent])
	{
		/*  Only the personal URL can be customized */
		NSURL * personalUrl = [parent personalURL];
		NSError * localError =  nil;
		NSData * data;
		if([personalUrl isFileURL] && [DFM fileExistsAtPath:[personalUrl path]])
		{
			data = [NSData dataWithContentsOfURL:personalUrl options:0 error:&localError];
			if(localError)
			{
				iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", personalUrl,localError);
			}
			[self parseData:data uniqueKey:YES];
		}
		iTM2PrefsKeyBindingNode * MKB = [[[iTM2PrefsKeyBindingNode alloc] initWithParent:self] autorelease];// not mutable!!
		NSEnumerator * E = [[parent valueForKeyPath:@"value.URLsPromise"] objectEnumerator];
		NSURL * url;
		while(url = [E nextObject])
		{
			if(![url isEqual:personalUrl])
			{
				localError = nil;
				data = [NSData dataWithContentsOfURL:url options:0 error:&localError];
				if(localError)
				{
					iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
				}
				[MKB parseData:data uniqueKey:YES];
			}
		}
		[self setOtherNode:MKB];
	}
	return self;
}
- (void)dealloc;
{
	[self setKeyBindingSelectionIndexPaths:nil];
	[super dealloc];
	return;
}
- (NSArray *)keyBindingSelectionIndexPaths;// bound to the key bindings controller
{
	return selectionIndexPaths;
}
- (void)setKeyBindingSelectionIndexPaths:(NSArray *)indexPaths;
{
	[selectionIndexPaths autorelease];
	selectionIndexPaths = [indexPaths copy];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyOtherNode
- (id)lazyOtherNode;
/*"Overriden, the inherited method is lazy, this one is not.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hasSubKeys
- (BOOL)hasSubKeys;
/*"Whether the receiver has subkeys...
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Sep 29 10:24:16 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self countOfAvailableKeyBindings]>0;
}
@end

@interface iTM2KeyBindingTreeController: NSTreeController
@end

@implementation iTM2KeyBindingTreeController
@end

@implementation iTM2KeyBindingContextNode(Preferences)
- (Class)listClass;
{
	return [iTM2KeyBindingList class];
}
- (NSData *)personalDataForSaving;
{
	return [[self list] XMLData];
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  THE USER INTERFACE

/*!
	@class			The macros and key bindings preference pane.
	@abstract		Managing the macro preferences.
	@discussion		The preferences are more difficult to manage because we must read and write data.
					
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroPrefPane: iTM2PreferencePane
- (void)setSelectedMode:(NSString *)mode;
@end

@interface iTM2HumanReadableActionNameValueTransformer: NSValueTransformer
+ (NSArray *)actionNames;
@end

@interface iTM2TabViewItemIdentifierForActionValueTransformer: NSValueTransformer
@end

@implementation iTM2MacroPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Overriden value.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 26 19:11:40 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"3.Macro";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"The receiver is the delegate of the iTM2MacroTableView where all the macros are displayed.
This method ensures that the selected row is visible.
This is necessary when the row was selected programatically.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 26 19:11:40 UTC 2008
To Do List:
"*/
{
	NSTableView * TV = [notification object];
	if([TV numberOfSelectedRows] == 1)
	{
		[TV scrollRowToVisible:[TV selectedRow]];
	}
	return;
}
#pragma mark =-=-=-=-=-  BINDINGS
- (NSArray *)availableActionNames;
{
	return [iTM2HumanReadableActionNameValueTransformer actionNames];
}
- (NSArray *)orderedCodeNames;
{
	return [KCC orderedCodeNames];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableDomains
- (NSArray *)availableDomains;
/*"Ask the shared macro controller for the macro tree and key binding tree.

Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	id macroTree = [SMC macroTree];
	id keyBindingTree = [SMC keyBindingTree];
	id macroAvailableDomains = [macroTree availableDomains];
	NSMutableSet * macroSet = [NSMutableSet setWithArray:macroAvailableDomains];
	id keyAvailableDomains = [keyBindingTree availableDomains];
	NSMutableSet * keySet = [NSMutableSet setWithArray:keyAvailableDomains];
	NSSet * temp = [NSSet setWithSet:macroSet];
	[macroSet minusSet:keySet];
	[keySet minusSet:temp];
	NSString * mode;
	NSEnumerator * E = [[keySet allObjects] objectEnumerator];
	while(mode = [E nextObject])
	{
		[[[iTM2MacroDomainNode alloc] initWithParent:macroTree domain:mode] autorelease];
	}
	E = [[macroSet allObjects] objectEnumerator];
	while(mode = [E nextObject])
	{
		[[[iTM2MacroDomainNode alloc] initWithParent:keyBindingTree domain:mode] autorelease];
	}
    return [[SMC macroTree] availableDomains];
}
NSString * const iTM2MacroEditorSelectionKey = @"iTM2MacroEditorSelection";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedDomain
- (NSString *)selectedDomain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MD = [self contextDictionaryForKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	NSString * key = @".";
	id result = [MD objectForKey:key];
//iTM2_END;
    return result?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableModes
- (NSArray *)availableModes;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * domain = [self selectedDomain];
	iTM2MacroRootNode * root = [SMC macroTree];
	id macroNode = [root objectInChildrenWithDomain:domain];
	root = [SMC keyBindingTree];
	id keyNode = [root objectInChildrenWithDomain:domain];
	id macroAvailableModes = [macroNode availableCategories];
	NSMutableSet * macroSet = [NSMutableSet setWithArray:macroAvailableModes];
	id keyAvailableModes = [keyNode availableCategories];
	NSMutableSet * keySet = [NSMutableSet setWithArray:keyAvailableModes];
	NSSet * temp = [NSSet setWithSet:macroSet];
	[macroSet minusSet:keySet];
	[keySet minusSet:temp];
	NSString * category;
	NSEnumerator * E = [[keySet allObjects] objectEnumerator];
	while(category = [E nextObject])
	{
		[[[iTM2MacroCategoryNode alloc] initWithParent:macroNode category:category] autorelease];
	}
	E = [[macroSet allObjects] objectEnumerator];
	while(category = [E nextObject])
	{
		[[[iTM2MacroCategoryNode alloc] initWithParent:keyNode category:category] autorelease];
	}
//iTM2_END;
    return [macroNode availableCategories];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedMode
- (NSString *)selectedMode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [self selectedDomain];// side effect: the selected domain should be safe before anything else is used
	id MD = [self contextDictionaryForKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	id result = [MD objectForKey:key];
//iTM2_END;
    return result?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroEditor
- (id)macroEditor;
/*"The macro editor is used by the prefs management.
It is set as the list of a context node in the macro tree.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self selectedMode];// side effect: the selected domain and selected mode should be safe before anything else is used
	id node = [self valueForKey:@"macroEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroEditor:
- (void)setMacroEditor:(id)new;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self valueForKey:@"macroEditor_meta"];
	if(![old isEqual:new] && (old != new))
	{
		[old removeObserver:self forKeyPath:@"macroSelectionIndexes"];
		[[old retain] autorelease];
		[self setValue:new forKey:@"macroEditor_meta"];
		[new addObserver:self forKeyPath:@"macroSelectionIndexes" options:0 context:self];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingEditor
- (id)keyBindingEditor;
/*"The key binding editor is used by the prefs management.
It is set as the list of a context node in the key binding tree.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self selectedMode];
	id node = [self valueForKey:@"keyBindingEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setKeyBindingEditor:
- (void)setKeyBindingEditor:(id)new;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self valueForKey:@"keyBindingEditor_meta"];
	if(![old isEqual:new] && (old != new))
	{
		[old removeObserver:self forKeyPath:@"keyBindingSelectionIndexPaths"];
		[[old retain] autorelease];
		[self setValue:new forKey:@"keyBindingEditor_meta"];
		[new addObserver:self forKeyPath:@"keyBindingSelectionIndexPaths" options:0 context:self];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedMode:
- (void)setSelectedMode:(NSString *)newMode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * domain = [self selectedDomain];
	NSString * oldMode = [self selectedMode];
	[[oldMode retain] autorelease];// why should I retain this? the observer is notified that there will be a change
	id MD = [self contextDictionaryForKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	MD = MD?[[MD mutableCopy] autorelease]:[NSMutableDictionary dictionary];
	[MD setValue:newMode forKey:domain];
	[self setContextValue:MD forKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	// change the editors
	if(newMode)
	{
		id editor = [SMC macroTree];
		editor = [editor objectInChildrenWithDomain:domain]?:
				[[[iTM2MacroDomainNode alloc] initWithParent:editor domain:domain] autorelease];
		editor = [editor objectInChildrenWithCategory:newMode]?:
				[[[iTM2MacroCategoryNode alloc] initWithParent:editor category:newMode] autorelease];
		editor = [editor objectInChildrenWithContext:@""]?:
				[[[iTM2MacroContextNode alloc] initWithParent:editor context:@""] autorelease];
		[self setMacroEditor:[editor list]];// the macro editor MUST be changed first because key bindings use macros
		editor = [SMC keyBindingTree];
		editor = [editor objectInChildrenWithDomain:domain]?:
				[[[iTM2MacroDomainNode alloc] initWithParent:editor domain:domain] autorelease];
		editor = [editor objectInChildrenWithCategory:newMode]?:
				[[[iTM2MacroCategoryNode alloc] initWithParent:editor category:newMode] autorelease];
		editor = [editor objectInChildrenWithContext:@""]?:
				[[[iTM2KeyBindingContextNode alloc] initWithParent:editor context:@""] autorelease];
		[self setKeyBindingEditor:[editor list]];
	}
	else
	{
		[self setMacroEditor:nil];
		[self setKeyBindingEditor:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedDomain:
- (void)setSelectedDomain:(NSString *)newDomain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setSelectedMode:nil];
	[self willChangeValueForKey:@"availableModes"];
	NSString * key = @".";
	id MD = [self contextDictionaryForKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	MD = MD?[[MD mutableCopy] autorelease]:[NSMutableDictionary dictionary];
	[MD setValue:newDomain forKey:key];
	[self setContextValue:MD forKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	[self didChangeValueForKey:@"availableModes"];
	NSString * newMode = [MD objectForKey:newDomain];
	NSArray * availableModes = [self availableModes];
	if(![availableModes containsObject:newMode])
	{
		newMode = [availableModes lastObject];
	}
	[self setSelectedMode:newMode];
//iTM2_END;
    return;
}
-(id)macrosArrayController;// nib outlets won't accept kvc (10.4)
{
	return metaGETTER;
}
-(void)setMacrosArrayController:(id)argument;
{
	id old = metaGETTER;
	if([old isEqual:argument] || old==argument)
	{
		return;
	}
	metaSETTER(argument);
	return;
}
-(id)macroSortDescriptors;// nib outlets won't accept kvc (10.4)
{
	return metaGETTER;
}
-(void)setMacroSortDescriptors:(id)argument;
{
	id old = metaGETTER;
	if([old isEqual:argument] || old==argument)
	{
		return;
	}
	metaSETTER(argument);
	return;
}
-(id)keysTreeController;
{
	return metaGETTER;
}
-(void)setKeysTreeController:(id)argument;
{
	id old = metaGETTER;
	if([old isEqual:argument] || old==argument)
	{
		return;
	}
	metaSETTER(argument);
	return;
}
-(unsigned int)masterTabViewItemIndex;
{
	return [SUD integerForKey:@"iTM2MacroMasterTabViewItemIndex"];
}
-(void)setMasterTabViewItemIndex:(unsigned int)newIndex;// the macro/key tabView
{
	unsigned int oldIndex = [SUD integerForKey:@"iTM2MacroMasterTabViewItemIndex"];
	if(oldIndex != newIndex)
	{
		[SUD setInteger:newIndex forKey:@"iTM2MacroMasterTabViewItemIndex"];
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroTestView
- (id)macroTestView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroTestView:
- (void)setMacroTestView:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER(argument);
	return;
}
#pragma mark =-=-=-=-=-  MACROS
#warning edit: and browse: message support// is missing (the 2 square buttons to edit external scripts)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  apply
- (IBAction)apply:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// did the argument text view saved its content?
	NSWindow * W = [sender window];
	NSResponder * firstResponder = [W firstResponder];
	[W makeFirstResponder:nil]; // in order to synchronize
	id node = [SMC macroTree];
	[SMC saveTree:node];
	node = [SMC keyBindingTree];
	[SMC saveTree:node];
	if([firstResponder acceptsFirstResponder])
	{
		[W makeFirstResponder:firstResponder];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canApply
- (BOOL)canApply;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel
- (IBAction)cancel:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// revert all the values to the default
	[SMC setMacroTree:nil];
	[SMC setKeyBindingTree:nil];
	[self setSelectedDomain:[self selectedDomain]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCancel
- (BOOL)canCancel;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if ([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
//	[self addObserver:self forKeyPath:@"masterTabViewItemIndex_meta" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	[self setMasterTabViewItemIndex:[SUD integerForKey:@"iTM2MacroMasterTabViewItemIndex"]];// otherwise the segmented control is not properly highlighted
//iTM2_END;
    return;
}
#warning FAILED missing canAddKeyBinding and canAddChildKeyBinding
- (BOOL)canAddKeyBinding;
{
	return YES;
#if 0
	NSTreeController * KTC = [self keysTreeController];
	NSArray * SOs = [KTC selectedObjects];
	if([SOs count] > 1)
	{
		return NO;
	}
	iTM2KeyBindingNode * node = nil;
	if([SOs count] == 0)
	{
		// can I add at the topmost level?
		node = [self keyBindingEditor];
	}
	else
	{
		node = [SOs lastObject];
		node = [node parent];// this line will not appear in the method below
	}
	node = [node objectInAvailableKeyBindingsWithKeyStroke:[iTM2KeyStroke keyStrokeWithKey:@""]];
	return node == nil;
#endif
}
- (BOOL)canAddChildKeyBinding;
{
	return YES;
#if 0
	NSTreeController * KTC = [self keysTreeController];
	NSArray * SOs = [KTC selectedObjects];
	if([SOs count] > 1)
	{
		return NO;
	}
	iTM2KeyBindingNode * node = nil;
	if([SOs count] == 0)
	{
		// can I add at the topmost level?
		node = [self keyBindingEditor];
	}
	else
	{
		node = [SOs lastObject];// not its parent!
		if([node valueForKey:@"keyStroke"] == nil)
		{
			return NO;
		}
	}
	node = [node objectInAvailableKeyBindingsWithKey:@""];
	return node == nil;
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMainView
- (NSView *) loadMainView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2KeyCodesController sharedController];// needed to have a value transformer registered
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableActionName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableActionNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableActionName"];
	}
	if(![NSValueTransformer valueTransformerForName:@"iTM2TabViewItemIdentifierForAction"])
	{
		iTM2TabViewItemIdentifierForActionValueTransformer * transformer = [[[iTM2TabViewItemIdentifierForActionValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2TabViewItemIdentifierForAction"];
	}
	// initialize the domains and modes
	id MD = [self contextDictionaryForKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[self setContextValue:MD forKey:iTM2MacroEditorSelectionKey domain:iTM2ContextAllDomainsMask];
	}
	NSString * selectedDomain = [self selectedDomain];
	NSArray * availableDomains = [self availableDomains];
	if(![availableDomains containsObject:selectedDomain])
	{
		selectedDomain = [availableDomains lastObject];
	}
	[self setSelectedDomain:selectedDomain];// this will cascade all the initialization	
//iTM2_END;
    return [super loadMainView];
}
- (BOOL)useMenuShortcuts;
{
	return [[self valueForKey:@"useMenuShortcuts_meta"] boolValue];
}
- (void)setUseMenuShortcuts:(BOOL)flag;
{
	[self setValue:[NSNumber numberWithBool:flag] forKey:@"useMenuShortcuts_meta"];
	return;
}
#pragma mark =-=-=-=-=-  KVO
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  observeValueForKeyPath:ofObject:change:context:
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(context == self)
	{
		id RA;
		NSEnumerator * E;
		id O;
		id macroID;
		if([keyPath isEqual:@"keyBindingSelectionIndexPaths"])
		{
			RA = [NSMutableArray array];
			E = [[[self keyBindingEditor] keyBindingSelectionIndexPaths] objectEnumerator];
			while(O = [E nextObject])
			{
				if(macroID = [[[self keyBindingEditor] objectInAvailableKeyBindingsAtIndexPath:O] macroID])
				{
					[RA addObject:macroID];
				}
			}
			E = [[NSSet setWithArray:RA] objectEnumerator];
			RA = [NSMutableIndexSet indexSet];
			while(macroID = [E nextObject])
			{
				if(O = [[[self macroEditor] personalMacros] objectForKey:macroID])
				{
					unsigned idx;
here:
					idx = [[self macroEditor] indexOfObjectInAvailableMacros:O];
					if(idx!=NSNotFound)// unless exception raised
					{
						[RA addIndex:idx];
					}
				}
				else if(O = [[[self macroEditor] macros] objectForKey:macroID])
				{
					goto here;
				}
			}
			if([RA count])
			{
				[[self macroEditor] setMacroSelectionIndexes:RA];
			}
			return;
		}
		else if([keyPath isEqual:@"macroSelectionIndexes"])
		{
			return;// do nothing yet
		}
		else if([keyPath isEqual:@"keyBindingSelection.prettyKey"])
		{
			[self willChangeValueForKey:@"canAddKeyBinding"];
			[self didChangeValueForKey:@"canAddKeyBinding"];
			[self willChangeValueForKey:@"canAddChildKeyBinding"];
			[self didChangeValueForKey:@"canAddChildKeyBinding"];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bindingsDealloc
- (void)bindingsDealloc;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setMacrosArrayController:nil];
	[self setKeysTreeController:nil];
	[self setKeyBindingEditor:nil];
	[self setMacroEditor:nil];
//	[self removeObserver:self forKeyPath:@"masterTabViewItemIndex_meta"];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  Completion
- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)indexRef;
{
	if([control tag] == 0)
	{
		return nil;
	}
	NSString * prefix = [[textView string] substringWithRange:charRange];
	id editor = [self macroEditor];
	id MD = [NSMutableDictionary dictionaryWithDictionary:[editor macros]];
	[MD addEntriesFromDictionary:[editor personalMacros]];
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(SELF BEGINSWITH \".\")"];
	id RA = [[MD allKeys] filteredArrayUsingPredicate:predicate];
	RA = [MD objectsForKeys:RA notFoundMarker:[NSNull null]];
	RA = [RA valueForKey:@"macroID"];
	predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",prefix];
	RA = [RA filteredArrayUsingPredicate:predicate];
//iTM2_END;
	if(indexRef)
	{
		*indexRef = 0;
	}
	return RA;
}
@end

/*"Description forthcoming."*/
@interface iTM2MacroTableView:NSTableView
@end

@implementation iTM2MacroTableView
#if 0
- (void)copy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			NSMutableDictionary * copy = [NSMutableDictionary dictionary];
			NSMutableArray * IDs = [NSMutableArray array];
			[copy setObject:IDs forKey:@"IDs"];
			id node = [selectedObjects lastObject];
			node = [node parent];// the list
			node = [node parent];// the context
			NSString * context = [node valueForKeyPath:@"value.context"];
			node = [node parent];
			NSString * category = [node valueForKeyPath:@"value.category"];
			node = [node parent];
			NSString * domain = [node valueForKeyPath:@"value.domain"];
			[copy setObject:domain forKey:@"domain"];
			[copy setObject:category forKey:@"category"];
			[copy setObject:context forKey:@"context"];
			NSEnumerator * E = [selectedObjects objectEnumerator];
			while(node = [E nextObject])
			{
				NSString * ID = [node ID];
				[IDs addObject:ID];
			}
			NSPasteboard * GP = [NSPasteboard generalPasteboard];
			NSString * type = @"iTM2MacroPBoard";
			NSArray * newTypes = [NSArray arrayWithObject:type];
			[GP declareTypes:newTypes owner:nil];
			[GP setPropertyList:copy forType:type];
		}
	}
	return;
}
- (BOOL)validateCopy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			return YES;
		}
	}
	return NO;
}
- (void)paste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	if(!availableType)
	{
		return;
	}
	NSDictionary * copies = [GP propertyListForType:availableType];
	NSString * domain = [copies objectForKey:@"domain"];
	NSString * category = [copies objectForKey:@"category"];
	NSString * context = [copies objectForKey:@"context"];
	NSArray * IDs = [copies objectForKey:@"IDs"];
	NSEnumerator * E = [IDs objectEnumerator];
	NSString * ID;
	id sourceTree = [SMC macroTree];
	sourceTree = [sourceTree objectInChildrenWithDomain:domain];
	sourceTree = [sourceTree objectInChildrenWithCategory:category];
	sourceTree = [sourceTree objectInChildrenWithContext:context];
	sourceTree = [sourceTree list];
	id targetTree = [[self delegate] macroEditor];
	id node, alreadyNode;
	while(ID = [E nextObject])
	{
		if(node = [sourceTree objectInChildrenWithID:ID])
		{
			node = [node copy];
			if(alreadyNode = [targetTree objectInChildrenWithID:ID])
			{
				//The only thing I have to do is connect the last mutableXMLElement;
				NSURL * url = [targetTree personalURL];
				NSXMLDocument * personalDocument = [targetTree documentForURL:url];
				NSXMLElement * personalRootElement = [personalDocument rootElement];
				NSMutableArray * alreadyMutableXMLElements = [alreadyNode mutableXMLElements];
				NSXMLElement * element = [alreadyMutableXMLElements lastObject];
				if(element)
				{
					NSString * XPath = [NSString stringWithFormat:@"/@ID=\"%@\"",ID];
					NSArray * RA = [personalRootElement nodesForXPath:XPath error:nil];
					id elt;
					NSEnumerator * EE = [RA objectEnumerator];
					while(elt = [EE nextObject])
					{
						[elt detach];
					}
					NSXMLDocument * rootDocument = [element rootDocument];
					if([personalDocument isEqual:rootDocument])
					{
						[alreadyMutableXMLElements removeLastObject];
					}
					[element detach];
				}
				element = [node XMLElement];
				if(!element)
				{
					element = [NSXMLElement elementWithName:@"ACTION"];
					NSXMLNode * attribute = [NSXMLNode attributeWithName:@"ID" stringValue:ID];
					[element addAttribute:attribute];
				}
				[element detach];
				[personalRootElement addChild:element];
				[alreadyNode addMutableXMLElement:element];
			}
			else
			{
				[targetTree insertObject:node inAvailableMacrosAtIndex:0];
			}
		}
		else
		{
			iTM2_LOG(@"No macro with domain:%@, category:%@, context:%@, ID:%@",
				domain,category,context,ID);
		}
	}
	return;
}
- (BOOL)validatePaste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	return availableType != nil;
}
#endif
@end

#import <iTM2Foundation/iTM2KeyBindingsKit.h>

@interface iTM2KeyBindingOutlineView:NSOutlineView
@end

@implementation iTM2KeyBindingOutlineView
#if 0
- (void)keyDown:(NSEvent *)theEvent;
{
	unsigned int modifierFlags = [theEvent modifierFlags];
	modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
	if(((modifierFlags&NSFunctionKeyMask)==0) && [self numberOfSelectedRows]==1)
	{
//		if((modifierFlags&NSFunctionKeyMask)==0)
		{
#if 0
			// this does not work
			int selectedRow = [self selectedRow];
			id item = [self itemAtRow:selectedRow];
			iTM2_LOG(@"item:%@",item);
#endif
			// see http://svn.sourceforge.net/viewvc/redshed/trunk/cocoa/NSTableView%2BCocoaBindingsDeleteKey/NSTableView%2BCocoaBindingsDeleteKey.m?view=markup
			NSArray *columns = [self tableColumns];
			unsigned columnIndex = 0, columnCount = [columns count];
			NSDictionary *valueBindingDict = nil;
			for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
				valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
			}
			id treeController = [valueBindingDict objectForKey:NSObservedObjectKey];
			if ([treeController isKindOfClass:[NSTreeController class]]) {
				//	Found a column bound to a tree controller.
				NSArray * selectedObjects = [treeController selectedObjects];
				id selection = [selectedObjects lastObject];
				// first turn the event into a key stroke object
				iTM2MacroKeyStroke * keyStroke = [theEvent macroKeyStroke];
				NSString * key = [keyStroke string];
				// is this key already used by the selection?
				if([key isEqual:[selection key]])
				{
					iTM2_LOG(@"No change: it is the same key.");
					return;
				}
				// is there already a binding with that key
				id parent = [selection parent];
				id alreadyBinding = [parent objectInAvailableKeyBindingsWithCodeName:key];
				NSError * error = nil;
				if(alreadyBinding)
				{
					// do they have the same ID
					NSString * ID = [selection ID];
					NSString * alreadyID = [alreadyBinding ID];
					if([ID isEqual:alreadyID])
					{
						iTM2_LOG(@"No change: this binding already exists.");
						return;
					}
					#warning Change the selection of the outline view
					if([alreadyBinding beMutable] && [alreadyBinding validateID:&key error:&error])
					{
						[alreadyBinding setID:ID];// only now: before the object was not mutable and could not change its ID
						if([[selection XMLElements] lastObject])
						{
							[selection beMutable];
							[selection setID:@"noop:"];
						}
						else
						{
							unsigned index = [parent indexOfObjectInAvailableKeyBindings:selection];
							[parent removeObjectFromAvailableKeyBindingsAtIndex:index];
						}
						NSIndexPath * IP = [alreadyBinding indexPath];
						[treeController setSelectionIndexPath:IP];
						return;
					}
				}
				else if([selection beMutable] && [selection validateKey:&key error:&error])
				{
					[selection setKey:key];// only now: before the object was not mutable and could not change its key
					return;
				}
				iTM2_LOG(@"error:%@",error);
				return;
			}
		}
	}
	[super keyDown:theEvent];
	return;
}
#endif
@end

@interface iTM2MacroPopUpButton:NSPopUpButton
@end

@implementation iTM2MacroPopUpButton
- (void)awakeFromNib;
{
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	NSView * superview = [self superview];
	[self retain];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self positioned:NSWindowBelow relativeTo:nil];
	return;
}
@end

@implementation iTM2MacroController(Prefs)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mutableMacroRunningNodeForID:context:ofCategory:inDomain:
- (id)mutableMacroRunningNodeForID:(NSString *)ID context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
	iTM2MacroList * list = [contextNode list];
	iTM2MacroNode * macro = [[list personalMacros] objectForKey:ID];//
	if(!macro)
	{
		macro = [[list macros] objectForKey:ID];
	}
	if(!macro)
	{
		macro = [[[iTM2MutableMacroNode alloc] init] autorelease];
		[macro setMacroID:ID];
		[list willChangeValueForKey:@"availableMacros"];
		[[list personalMacros] setObject:macro forKey:ID];
		[list didChangeValueForKey:@"availableMacros"];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"No macro with ID: %@ forContext:%@ ofCategory:%@ inDomain:%@",ID,context,category,domain);
			iTM2_LOG(@"[rootNode countOfChildren]:%i",[rootNode countOfChildren]);
			iTM2_LOG(@"[domainNode countOfChildren]:%i",[domainNode countOfChildren]);
			iTM2_LOG(@"[categoryNode countOfChildren]:%i",[categoryNode countOfChildren]);
			iTM2_LOG(@"[contextNode countOfChildren]:%i",[contextNode countOfChildren]);
		}
	}
//iTM2_LOG(@"%@",macro);
//iTM2_END;
	return macro;
}
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@interface iTM2MacroTestView:iTM2TextEditor
@end

#import "iTM2MacroKit_Action.h"

@implementation iTM2MacroTestView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= testMacro:
- (void)testMacro:(id)sender;// the sender is the table view sometimes
{
	//sender is an array of selected objects
	NSEnumerator * E = [sender objectEnumerator];
	while(sender = [E nextObject])
	{
		if([sender respondsToSelector:@selector(executeMacroWithTarget:selector:substitutions:)])// for macro nodes
		{
			[sender executeMacroWithTarget:self selector:NULL substitutions:nil];
		}
		else if([sender isKindOfClass:[iTM2KeyBindingNode class]] && ![sender countOfAvailableKeyBindings])// for key binding nodes
		{
			[self executeMacroWithID:[sender macroID]];
		}
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroWithID:
- (id)macroWithID:(NSString *)ID;
{
	// this will be overriden by the text view used for testing macros and key bindings in the prefs pane
	return	[SMC mutableMacroRunningNodeForID:ID context:[self macroContext] ofCategory:[self macroCategory] inDomain:[self macroDomain]]?:
			[SMC macroRunningNodeForID:ID context:[self macroContext] ofCategory:[self macroCategory] inDomain:[self macroDomain]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
	// the delegate of the receiver is an iTM2MacroPrefPane
    return [[self delegate] selectedDomain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [[self delegate] selectedMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rootKeyBindings
- (id)rootKeyBindings;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [SMC keyBindingTree];
	NSString * key = [self macroDomain];
	result = [result objectInChildrenWithDomain:key];
	key = [self macroCategory];
	result = [result objectInChildrenWithCategory:key];
#warning NO context mode supported
	key = @"";//[self macroContext];
	result = [result objectInChildrenWithContext:key];
	return [result list];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= completionsForPartialWordRange:indexOfSelectedItem:
- (NSArray *)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)indexRef;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * prefix = [[self string] substringWithRange:charRange];
	id editor = [[self delegate] macroEditor];
	id MD = [NSMutableDictionary dictionaryWithDictionary:[editor macros]];
	[MD addEntriesFromDictionary:[editor personalMacros]];
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(SELF BEGINSWITH \".\")"];
	id RA = [[MD allKeys] filteredArrayUsingPredicate:predicate];
	RA = [MD objectsForKeys:RA notFoundMarker:[NSNull null]];
	RA = [RA valueForKey:@"macroID"];
	predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",prefix];
	RA = [RA filteredArrayUsingPredicate:predicate];
//iTM2_END;
	if(indexRef)
	{
		*indexRef = 0;
	}
	return [RA count]?RA:[super completionsForPartialWordRange:charRange indexOfSelectedItem:indexRef];
}
@end

#import <iTM2Foundation/iTM2BundleKit.h>

static id iTM2HumanReadableActionNames = nil;
@implementation iTM2HumanReadableActionNameValueTransformer
+ (void)initialize;
{
 	iTM2_INIT_POOL;
	[super initialize];
	if(!iTM2HumanReadableActionNames)
	{
		iTM2HumanReadableActionNames = [[NSMutableDictionary dictionary] retain];
		NSBundle * MB = [NSBundle mainBundle];
		NSArray * RA = [MB allPathsForResource:@"iTM2HumanReadableActionNames" ofType:@"plist"];
		NSEnumerator * E = [RA objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
			if(D)
			{
				[iTM2HumanReadableActionNames addEntriesFromDictionary:D];
			}
		}
	}
	iTM2_RELEASE_POOL;
	return;
}
+ (NSArray *)actionNames;
{
	return [iTM2HumanReadableActionNames allKeys];
}
+ (BOOL)allowsReverseTransformation;
{
	return YES;
}
- (id)transformedValue:(id)value;
{
	id result = nil;
	if([value isKindOfClass:[NSArray class]])
	{
		result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id transformedValue = [self transformedValue:value];
			[result addObject:(transformedValue?:value)];
		}
		return result;
	}
	if(result = [iTM2HumanReadableActionNames objectForKey:value])
	{
		return result;
	}
	return value;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id reverseTransformedValue = [self reverseTransformedValue:value];
			[result addObject:(reverseTransformedValue?:value)];
		}
		return result;
	}
	id result = [iTM2HumanReadableActionNames allKeysForObject:value];
	return [result lastObject]?:value;
}
@end

@implementation iTM2TabViewItemIdentifierForActionValueTransformer
+ (BOOL)allowsReverseTransformation;
{
	return NO;
}
- (id)transformedValue:(NSString *)value;
{
	return [value hasSuffix:@"Path:"]?@"path":@"macro";
}
- (id)reverseTransformedValue:(id)value;
{
	return value;
}
@end

@interface NSResponder(iTM2EventCatcher)
- (BOOL)iTM2_catchEvent:(NSEvent *)event;
@end

@implementation NSTextView(iTM2EventCatcher)
- (BOOL)iTM2_catchEvent:(NSEvent *)event;
{
	id V = self;
	while(V = [V superview])
	{
		if([V iTM2_catchEvent:event])
		{
			return YES;
		}
	}
	return NO;
}
@end

@interface iTM2KeyBindingField: NSTextField
@end

@implementation iTM2KeyBindingField
// setCellClass does not work on leopard at least, most probably because when dearchived, the control does not assume that its own cell class should change.
// in 3.x nibs, just change the class of the cell
- (BOOL)iTM2_catchEvent:(NSEvent *)event;
{
	switch([event type])
	{
		case NSKeyUp:
		{
			NSDictionary * D = [self infoForBinding:@"value"];
			id O = [D objectForKey:NSObservedObjectKey];
			NSString * observedKeyPath = [D objectForKey:NSObservedKeyPathKey];
			O = [O valueForKeyPath:[observedKeyPath stringByDeletingPathExtension]];
			NS_DURING
			[O valueForKey:@"updateKeyStroke"];// just in case it does not work
			[self setStringValue:[O valueForKey:[observedKeyPath pathExtension]]];// update with the observed value,
			[self selectText:nil];
			NS_HANDLER
			NS_ENDHANDLER
		}
		case NSKeyDown: return YES;
		default: return [super  iTM2_catchEvent:event];
	}
}
@end

#if 0
textView:completions:forPartialWordRange:indexOfSelectedItem:. Subclasses may control the list by overriding completionsForPartialWordRange:indexOfSelectedItem:.
completionsForPartialWordRange:indexOfSelectedItem:
#endif