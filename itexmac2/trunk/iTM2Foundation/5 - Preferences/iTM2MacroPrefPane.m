/*
//
//  @version Subversion: $Id:$ 
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

#import "iTM2MacroPrefPane.h"
#import "iTM2TreeKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2BundleKit.h"

NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacrosPathExtension = @"iTM2-macros";

/*!
    @class       iTM2MacroTreeRoot
    @superclass  iTM2TreeNode
    @abstract    Main tree
    @discussion  This is the main tree containing the macros.
				 The macros are gathered in one tree, with the various domains at the second level,
				 the various categories at the third level, and the various contexts at the last level.
				 The contexts are the ones which store the repository path.
				 This is consistent because we are not expected to move contexts from repositories to repositories.
				 We jus can copy from repositories to repositories.
				
*/


@interface iTM2MacroController(PRIVATE)
- (id)macroActionForName:(NSString *)actionName;
@end

@interface iTM2MacroAction: NSObject
{
@private
	NSString * description;
}
- (SEL)action;
- (NSComparisonResult)compareDescription:(id)rhs;
@end

@implementation iTM2MacroAction
- (SEL)action;
{
	id name = NSStringFromClass([self class]);
	NSArray * components = [name componentsSeparatedByString:@"iTM2MacroAction_"];
	if([components count] >1)
	{
		name = [components lastObject];
		name = [name mutableCopy];
		name = [name autorelease];
		[name replaceOccurrencesOfString:@"_" withString:@":" options:0 range:NSMakeRange(0,[name length])];
		return NSSelectorFromString(name);		
	}
	return NULL;
}
- (NSString *)description;
{
	return description;
}
- (id)init;
{
	if(self = [super init])
	{
		SEL action = [self action];
		if(action)
		{
			NSString * actionName = NSStringFromSelector([self action]);
			description = NSLocalizedStringFromTableInBundle(actionName, @"iTM2MacroAction", myBUNDLE, "");
			description = [description copy];
			return self;
		}
	}
	[self release];
	return nil;
}
- (NSComparisonResult)compareDescription:(id)rhs;
{
	return [[self description] compare:[rhs description]];
}
@end

@interface iTM2MacroAction_insertMacro_: iTM2MacroAction
@end

@implementation iTM2MacroAction_insertMacro_
@end

@interface iTM2MacroNode: iTM2TreeNode
- (NSString *)ID;
- (NSString *)name;
- (BOOL)canEditName;
- (NSAttributedString *)insertMacroArgument;
@end

@implementation iTM2MacroNode
- (id)init;
{
	if(self = [super init])
	{
		[self setValue:[NSMutableDictionary dictionary]];
	}
	return self;
}
- (id)macroAction;
{
	return nil;
}
- (NSAttributedString *)insertMacroArgument;
{
	return nil;
}
- (BOOL)canEditInsertMacroArgument;
{
	return NO;
}
- (NSAttributedString *)macroDescription;
{
	return nil;
}
- (BOOL)canEditMacroDescription;
{
	return NO;
}
- (NSAttributedString *)macroTooltip;
{
	return nil;
}
- (BOOL)canEditMacroTooltip;
{
	return NO;
}
- (NSString *)name;
{
	return [[self valueForKeyPath:@"value.pathComponent"] stringByDeletingPathExtension];
}
- (BOOL)canEditName;
{
	return NO;
}
- (NSString *)ID;
{
	return nil;
}
- (BOOL)canEditID;
{
	return NO;
}
- (NSString *)key;
{
	return nil;
}
- (NSString *)prettyKey;
{
	return nil;
}
- (BOOL)canEditKey;
{
	return NO;
}
- (BOOL)isEdited;
{
	return NO;
}
- (BOOL)isLastNodeLevel;
{
	NSArray * children = [self children];
	return ([children count]>0) && ([[[children lastObject] children] count]==0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildren:
- (void)removeObjectFromChildren:(id)anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	if([anObject valueForKeyPath:@"value.editableXMLElement"])
	{
		[anObject willChangeValueForKey:@"children"];
		[anObject setValue:nil forKeyPath:@"value.editableXMLElement"];
		if(![[self name] length])
		{
			[super removeObjectFromChildren:anObject];
		}
		[anObject didChangeValueForKey:@"children"];
	}
	else
	{
		[super removeObjectFromChildren:anObject];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildrenAtIndex:
- (void)removeObjectFromChildrenAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    // implementation specific code
	id anObject = [self objectInChildrenAtIndex:index];
	if([anObject valueForKeyPath:@"value.editableXMLElement"])
	{
		[anObject willChangeValueForKey:@"children"];
		[anObject setValue:nil forKeyPath:@"value.editableXMLElement"];
		if(![[self name] length])
		{
			[super removeObjectFromChildren:anObject];
		}
		[anObject didChangeValueForKey:@"children"];
	}
	else
	{
		[super removeObjectFromChildren:anObject];
	}
    return;
}
- (int)commandModifierState;
{
	return NSOffState;
}
- (int)shiftModifierState;
{
	return NSOffState;
}
- (int)alternateModifierState;
{
	return NSOffState;
}
- (int)controlModifierState;
{
	return NSOffState;
}
- (int)functionModifierState;
{
	return NSOffState;
}
- (NSString *)macroKey;
{
	return @"";
}
- (void)save;
{
	[[self children] makeObjectsPerformSelector:_cmd];
}
@end

@interface iTM2MacroKeyStroke: NSObject
{
@public
	NSString * macroKey;
	NSString * _prettyString;
	NSString * _string;
	BOOL isCommand;
	BOOL isShift;
	BOOL isAlternate;
	BOOL isControl;
	BOOL isFunction;
}
- (NSString *)string;
- (NSString *)prettyString;
- (void)update;
@end

@implementation iTM2MacroKeyStroke
- (void)dealloc;
{
	[macroKey release];
	[_prettyString release];
	[_string release];
	[super dealloc];
	return;
}
- (void)update;
{
	[_prettyString release];
	_prettyString = nil;
	[_string release];
	_string = nil;
	return;
}
- (NSString *)string;
{
	if(_string)
	{
		return _string;
	}
	if([macroKey length])
	{
		NSString * isCommandString = isCommand?@"@":@"";
		NSString * isShiftString = isShift?@"$":@"";
		NSString * isAlternateString = isAlternate?@"~":@"";
		NSString * isControlString = isControl?@"^":@"";
		NSString * isFunctionString = isFunction?@"&":@"";
		NSString * modifier = [NSString stringWithFormat:@"%@%@%@%@%@",isCommandString, isShiftString, isAlternateString, isControlString, isFunctionString];
		if([modifier length])
		{
			_string = [[NSString stringWithFormat:@"%@->%@",modifier, macroKey] retain];
		}
		else
		{
			_string = [macroKey copy];
		}
	}
	else
	{
		_string = @"";
	}
	return _string;
}
- (NSString *)prettyString;
{
	if(_prettyString)
	{
		return _prettyString;
	}
	if([macroKey length])
	{
		NSMutableString * result = [NSMutableString string];
		if(isCommand)
		{
			[result appendString:[NSString stringWithUTF8String:"⌘"]];
		}
		if(isShift)
		{
			[result appendString:[NSString stringWithUTF8String:"⇧"]];
		}
		if(isAlternate)
		{
			[result appendString:[NSString stringWithUTF8String:"⌥"]];
		}
		if([result length])
		{
			[result appendString:@" "];
		}
		if(isFunction)
		{
			[result appendString:[NSString stringWithUTF8String:"fn "]];
		}
		if(isControl)
		{
			[result appendString:[NSString stringWithUTF8String:"ctrl"]];
		}
		if([macroKey length]<4)
		{
			[result appendString:macroKey];
		}
		else
		{
			[result appendString:[macroKey substringWithRange:NSMakeRange(0,3)]];
		}
		_prettyString = [result copy];
	}
	else
	{
		_prettyString = @"";
	}	
	return _prettyString;
}
@end

@interface NSString(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
@end

@implementation NSString(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	if(![self length])
	{
		return nil;
	}
	iTM2MacroKeyStroke * result = [[[iTM2MacroKeyStroke alloc] init] autorelease];
	NSMutableArray * components = [[[self componentsSeparatedByString:@"->"] mutableCopy] autorelease];
	NSString * component = [components lastObject];
	result -> macroKey = [component copy];
	[components removeLastObject];
	component = [components lastObject];
	unsigned int index = [component length];
	while(index--)
	{
		switch([self characterAtIndex:index])
		{
			case '@':
				result->isCommand = YES;
				break;
			case '$':
				result->isShift = YES;
				break;
			case '~':
				result->isAlternate = YES;
				break;
			case '^':
				result->isControl = YES;
				break;
			case '&':
				result->isFunction = YES;
				break;
		}
	}
	return result;
}
@end

@interface iTM2MacroSourceNode: iTM2MacroNode
{
@public
	iTM2MacroKeyStroke * macroKeyStroke;
}
- (id)editableXMLElement;
- (void)updateMacroKeyStroke;
- (void)updateKey;

@end

@implementation iTM2MacroSourceNode
- (id)init;
{
	if(self = [super init])
	{
		[macroKeyStroke release];
		macroKeyStroke = [[iTM2MacroKeyStroke alloc] init];
	}
	return self;
}
- (id)editableXMLElement;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(element)
	{
		return element;
	}
	[self updateMacroKeyStroke];
	if(element = [self valueForKeyPath:@"value.XMLElement"])
	{
		element = [[element copy] autorelease];
	}
	else
	{
		element = [NSXMLElement elementWithName:@"ACTION"];
	}
	// finding the parent with a list of XML macro documents
	id parent = self;
	while(parent = [parent parent])
	{
		NSString * subpath = [parent valueForKeyPath:@"value.macrosDocumentsPath"];
		if(subpath)
		{
			id editableMacrosDocument = [parent valueForKeyPath:@"value.editableMacrosDocument"];
			if(!editableMacrosDocument)
			{
				NSArray * otherMacrosDocuments = [parent valueForKeyPath:@"value.otherMacrosDocuments"];
				editableMacrosDocument = [otherMacrosDocuments lastObject];
				editableMacrosDocument = [[editableMacrosDocument copy] autorelease];
				NSString * repositoryPath = [[NSBundle mainBundle] pathForSupportDirectory:@"Macros.localized" inDomain:NSUserDomainMask create:YES];
				NSURL * repositoryURL = [NSURL fileURLWithPath:repositoryPath];
				NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
				[editableMacrosDocument setURI:[url absoluteString]];
				[[parent value] setValue:editableMacrosDocument forKeyPath:@"editableMacrosDocument"];
				id root = [editableMacrosDocument rootElement];
				while([root childCount])
				{
					[root removeChildAtIndex:0];
				}
			}
			[[editableMacrosDocument rootElement] addChild:element];
			break;
		}
	}
	[self setValue:element forKeyPath:@"value.editableXMLElement"];
	return element;
}
- (BOOL)canEditInsertMacroArgument;
{
	return [self canEditName];
}
- (NSAttributedString *)insertMacroArgument;
{
	NSMutableAttributedString * AS = [self valueForKeyPath:@"value.insertMacroArgument"];
	if(AS)
	{
		return AS;
	}
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * ARGS = [element elementsForName:@"ARG"];
	element = [ARGS lastObject];
	AS = [[[NSMutableAttributedString alloc] initWithString:(element?[element stringValue]:@"")] autorelease];
	[self setValue:AS forKeyPath:@"value.insertMacroArgument"];
	return AS;
}
- (void)setInsertMacroArgument:(NSAttributedString *)newInsertMacroArgument;
{
	NSAttributedString * oldInsertMacroArgument = [self valueForKeyPath:@"value.insertMacroArgument"];
	if([oldInsertMacroArgument isEqual:newInsertMacroArgument])
	{
		return;
	}
	NSString * S = [newInsertMacroArgument string];
	[self willChangeValueForKey:@"insertMacroArgument"];
	NSXMLElement * element = [self editableXMLElement];
	NSArray * ARGS = [element elementsForName:@"ARG"];
	NSXMLElement * argument = [ARGS lastObject];
	if(argument)
	{
		[argument setStringValue:(S?:@"")];
	}
	else
	{
		argument = [NSXMLElement elementWithName:@"ARG" stringValue:S];
		[element insertChild:argument atIndex:0];
	}
	newInsertMacroArgument = [[newInsertMacroArgument mutableCopy] autorelease];
	[self setValue:newInsertMacroArgument forKeyPath:@"value.insertMacroArgument"];
	[self didChangeValueForKey:@"insertMacroArgument"];
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (NSAttributedString *)macroDescription;
{
	NSMutableAttributedString * AS = [self valueForKeyPath:@"value.macroDescription"];
	if(AS)
	{
		return AS;
	}
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * DESCs = [element elementsForName:@"DESC"];
	element = [DESCs lastObject];
	AS = [[[NSMutableAttributedString alloc] initWithString:(element?[element stringValue]:@"")] autorelease];
	[self setValue:AS forKeyPath:@"value.macroDescription"];
	return AS;
}
- (void)setMacroDescription:(NSAttributedString *)newMacroDescription;
{
	NSAttributedString * oldMacroDescription = [self valueForKeyPath:@"value.insertMacroArgument"];
	if([oldMacroDescription isEqual:newMacroDescription])
	{
		return;
	}
	NSString * S = [newMacroDescription string];
	[self willChangeValueForKey:@"macroDescription"];
	NSXMLElement * element = [self editableXMLElement];
	NSArray * DESCs = [element elementsForName:@"DESC"];
	NSXMLElement * DESC = [DESCs lastObject];
	if(DESC)
	{
		[DESC setStringValue:(S?:@"")];
	}
	else
	{
		DESC = [NSXMLElement elementWithName:@"DESC" stringValue:S];
		[element insertChild:DESC atIndex:0];
	}
	newMacroDescription = [[newMacroDescription mutableCopy] autorelease];
	[self setValue:newMacroDescription forKeyPath:@"value.macroDescription"];
	[self didChangeValueForKey:@"macroDescription"];
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (BOOL)canEditMacroDescription;
{
	return YES;
}
- (NSAttributedString *)macroTooltip;
{
	NSMutableAttributedString * AS = [self valueForKeyPath:@"value.macroTooltip"];
	if(AS)
	{
		return AS;
	}
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * TIPs = [element elementsForName:@"TIP"];
	element = [TIPs lastObject];
	AS = [[[NSMutableAttributedString alloc] initWithString:(element?[element stringValue]:@"")] autorelease];
	[self setValue:AS forKeyPath:@"value.macroTooltip"];
	return AS;
}
- (void)setMacroTooltip:(NSAttributedString *)newMacroTooltip;
{
	NSAttributedString * oldMacroTooltip = [self valueForKeyPath:@"value.insertMacroArgument"];
	if([oldMacroTooltip isEqual:newMacroTooltip])
	{
		return;
	}
	NSString * S = [newMacroTooltip string];
	[self willChangeValueForKey:@"macroTooltip"];
	NSXMLElement * element = [self editableXMLElement];
	NSArray * TIPs = [element elementsForName:@""];
	NSXMLElement * TIP = [TIPs lastObject];
	if(TIP)
	{
		[TIP setStringValue:(S?:@"")];
	}
	else
	{
		TIP = [NSXMLElement elementWithName:@"TIP" stringValue:S];
		[element insertChild:TIP atIndex:0];
	}
	newMacroTooltip = [[newMacroTooltip mutableCopy] autorelease];
	[self setValue:newMacroTooltip forKeyPath:@"value.macroTooltip"];
	[self didChangeValueForKey:@"macroTooltip"];
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (BOOL)canEditMacroTooltip;
{
	return YES;
}
- (NSString *)ID;
{
	return [self valueForKeyPath:@"value.ID"];
}
- (NSString *)key;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	element = (NSXMLElement *)[element attributeForName:@"KEY"];
	return [element stringValue];
}
- (void) setKey:(NSString *)newKey;
{
	NSXMLElement * element = [self editableXMLElement];
	NSXMLElement * attribute = (NSXMLElement *)[element attributeForName:@"KEY"];
	if(attribute)
	{
		NSString * oldKey = [attribute stringValue];
		if([oldKey isEqual:newKey])
		{
			return;
		}
		if([newKey length])
		{
			[self willChangeValueForKey:@"key"];
			[attribute setStringValue:newKey];
			[self didChangeValueForKey:@"key"];
		}
	}
	else
	{
		attribute = [NSXMLNode attributeWithName:@"KEY" stringValue:newKey];
		[element addAttribute:attribute];
	}
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (NSString *)prettyKey;
{
	return [macroKeyStroke prettyString];
}
- (BOOL)canEditKey;
{
	return YES;
}
- (NSString *)name;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * NAMES = [element elementsForName:@"NAME"];
	element = [NAMES lastObject];
	return [element stringValue];
}
- (void)setName:(NSString *) newName;
{
	NSXMLElement * element = [self editableXMLElement];
	NSArray * NAMES = [element elementsForName:@"NAME"];
	NSXMLElement * nameElt = nil;
	if(nameElt = [NAMES lastObject])
	{
		NSString * oldName = [element stringValue];
		if([oldName isEqual:newName])
		{
			return;
		}
		[self willChangeValueForKey:@"name"];
		[nameElt setStringValue:newName];
		[self didChangeValueForKey:@"name"];
	}
	else
	{
		[self willChangeValueForKey:@"name"];
		nameElt = [NSXMLElement elementWithName:@"NAME" stringValue:newName];
		[element insertChild:nameElt atIndex:0];
		[self didChangeValueForKey:@"name"];
	}
	// update the ID automatically, for a default value
	NSString * oldID = [self ID];
	if(![oldID length])
	{
		[self willChangeValueForKey:@"ID"];
		// finding the common ID prefix of all the receivers siblings
		NSMutableArray * children = [[[[self parent] children] mutableCopy] autorelease];
		[children removeObject:self];
		NSEnumerator * E = [children objectEnumerator];
		id child = [E nextObject];
		NSString * common = [child ID];
		if(common)
		{
			while(child = [E nextObject])
			{
				common = [common commonPrefixWithString:[child ID] options:0];
			}
		}
		else
		{
			common = @"";
			NSXMLDocument * macroDocument = [element rootDocument];
			NSString * uri = [macroDocument URI];
			NSURL * url = [NSURL URLWithString:uri];
			if([url isFileURL])
			{
				NSString * path = [url path];
				NSArray * components = [path componentsSeparatedByString:@"Macros.localized"];
				if([components count]>1)
				{
					path = [components lastObject];
					components = [path pathComponents];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = [e nextObject];// @"/"
					component = [e nextObject];// domain: text, pdf, project
					component = [e nextObject];// category: latex, plain, context...
					components = [e allObjects];// everything else
					common = [components componentsJoinedByString:@"-"];
				}
			}
		}
		NSString * newID = [common stringByAppendingString:newName];
		newID = [newID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSXMLNode * IDAttribute = [element attributeForName:@"ID"];
		if(IDAttribute)
		{
			[IDAttribute setStringValue:newID];
		}
		else
		{
			IDAttribute = [NSXMLNode attributeWithName:@"ID" stringValue:newID];
			[element addAttribute:IDAttribute];
		}
		[self takeValue:newID forKeyPath:@"value.ID"];
		[self didChangeValueForKey:@"ID"];
	}
	NSAssert(([[self name] isEqual:newName]),@"ARGH!!!");
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (BOOL)canEditName;
{
	return YES;
}
- (BOOL)isEdited;
{
	return [self valueForKeyPath:@"value.editableXMLElement"] != nil;
}
- (id)macroAction;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	element = (NSXMLElement *)[element attributeForName:@"SEL"];
	NSString * actionName = element?[element stringValue]:@"insertMacro:";
	return [[iTM2MacroController sharedMacroController] macroActionForName:actionName];
}
- (int)commandModifierState;
{
	return macroKeyStroke->isCommand? NSOnState:NSOffState;
}
- (void)setCommandModifierState:(int)state;
{
	macroKeyStroke->isCommand = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)shiftModifierState;
{
	return macroKeyStroke->isShift? NSOnState:NSOffState;
}
- (void)setShiftModifierState:(int)state;
{
	macroKeyStroke->isShift = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)alternateModifierState;
{
	return macroKeyStroke->isAlternate? NSOnState:NSOffState;
}
- (void)setAlternateModifierState:(int)state;
{
	macroKeyStroke->isAlternate = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)controlModifierState;
{
	return macroKeyStroke->isControl? NSOnState:NSOffState;
}
- (void)setControlModifierState:(int)state;
{
	macroKeyStroke->isControl = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)functionModifierState;
{
	return macroKeyStroke->isFunction? NSOnState:NSOffState;
}
- (void)setFunctionModifierState:(int)state;
{
	macroKeyStroke->isFunction = (state == NSOnState);
	[self updateKey];
	return;
}
- (NSString *)macroKey;
{
	return macroKeyStroke->macroKey;
}
- (void) setMacroKey:(NSString *)newKey;
{
	[macroKeyStroke->macroKey release];
	macroKeyStroke->macroKey = [newKey copy];
	[self updateKey];
	return;
}
- (void)updateMacroKeyStroke;
{
	[macroKeyStroke release];
	macroKeyStroke = [[[self key] macroKeyStroke] retain];
	if(!macroKeyStroke)
	{
		macroKeyStroke = [[iTM2MacroKeyStroke alloc] init];
	}
	return;
}
- (void)updateKey;
{
	[macroKeyStroke update];
	[self setKey:[macroKeyStroke string]];
	return;
}
@end

@interface iTM2MacroDocumentNode: iTM2MacroNode
@end

@implementation iTM2MacroDocumentNode
- (void)save;
{
	NSXMLDocument * document = [[self value] objectForKey:@"editableMacrosDocument"];
	NSString * URI = [document URI];
	if([URI length])
	{
		NSURL * url = [NSURL URLWithString:URI];
		if([url isFileURL])
		{
			NSString * directory = [url path];
			directory = [directory stringByDeletingLastPathComponent];
			NSError * localError = nil;
			if([DFM createDeepDirectoryAtPath:directory attributes:nil error:&localError])
			{
				NSData * D = [document XMLDataWithOptions:NSXMLNodePrettyPrint];
				if(![D writeToURL:url options:NSAtomicWrite error:&localError])
				{
					[SDC presentError:localError];
				}
			}
			else
			{
				[SDC presentError:localError];
			}
		}
	}
}
@end

@interface iTM2MacroRunningNode: iTM2MacroNode

@end

@implementation iTM2MacroRunningNode

@end

@interface iTM2MacroActionNode: iTM2MacroNode

@end

@implementation iTM2MacroActionNode

@end

#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@interface iTM2MacroController(PRIVATE)
- (NSDictionary *)macroFunctionKeysDictionary;
@end

@implementation iTM2MacroController

+ (void)initialize
{
	[super initialize];
    iTM2PrettyNameOfMacroKeyTransformer *transformer = [[[iTM2PrettyNameOfMacroKeyTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:nameTransformer forName:@"iTM2PrettyNameOfMacroKey"];
	return;
}

static id _iTM2MacroController = nil;

+ (id)sharedMacroController;
{
	return _iTM2MacroController?:( _iTM2MacroController = [[self alloc] init]);
}

- (id)init;
{
	if(_iTM2MacroController)
	{
		return [_iTM2MacroController retain];
	}
	else if(self = [super init])
	{
		[self setRunningTree:nil];
		[self setSourceTree:nil];
	}
	return _iTM2MacroController = self;
}

#if 0
- (id)storageTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"Macros" ofType:@"localized"];
	NSEnumerator * E0 = [RA objectEnumerator];
	NSString * P0 = nil;
	NSEnumerator * E1 = nil;
	NSString * P1 = nil;
	NSEnumerator * E2 = nil;
	NSString * P2 = nil;
	NSEnumerator * E3 = nil;
	NSString * P3 = nil;
	NSEnumerator * E4 = nil;
	NSString * P4 = nil;
	NSEnumerator * E5 = nil;
	NSString * P5 = nil;
	NSMutableArray * P1s = [NSMutableArray array];// components of the macro files directory repository/domain/category/context/environment are P0/P1/P2/P3/P4
	NSMutableArray * P2s = [NSMutableArray array];// last components of the macro files P5
	while(P0 = [E0 nextObject])
	{
		if((RA = [DFM directoryContentsAtPath:P0]) && [DFM pushDirectory:P0])
		{
			E1 = [RA objectEnumerator];
			while(P1 = [E1 nextObject])
			{
				if((RA = [DFM directoryContentsAtPath:P1]) && [DFM pushDirectory:P1])
				{
					E2 = [RA objectEnumerator];
					while(P2 = [E2 nextObject])
					{
						if((RA = [DFM directoryContentsAtPath:P2]) && [DFM pushDirectory:P2])
						{
							E3 = [RA objectEnumerator];
							while(P3 = [E3 nextObject])
							{
								if((RA = [DFM directoryContentsAtPath:P3]) && [DFM pushDirectory:P3])
								{
									E4 = [RA objectEnumerator];
									while(P4 = [E4 nextObject])
									{
										if((RA = [DFM directoryContentsAtPath:P4]) && [DFM pushDirectory:P4])
										{
											E5 = [RA objectEnumerator];
											while(P5 = [E5 nextObject])
											{
												if([[P5 pathExtension] isEqual:iTM2MacrosPathExtension])
												{
													[P1s addObject:[NSArray arrayWithObjects:P0,P1,P2,P3,P4,nil]];
													[P2s addObject:P5];
												}
											}
										}
										else if([[P4 pathExtension] isEqual:iTM2MacrosPathExtension])
										{
											[P1s addObject:[NSArray arrayWithObjects:P0,P1,P2,P3,@"",nil]];
											[P2s addObject:P4];
										}
									}
								}
								else if([[P3 pathExtension] isEqual:iTM2MacrosPathExtension])
								{
									[P1s addObject:[NSArray arrayWithObjects:P0,P1,P2,@"",@"",nil]];
									[P2s addObject:P3];
								}
							}
						}
						else if([[P2 pathExtension] isEqual:iTM2MacrosPathExtension])
						{
							[P1s addObject:[NSArray arrayWithObjects:P0,P1,@"",@"",@"",nil]];
							[P2s addObject:P2];
						}
					}
				}
				else if([[P1 pathExtension] isEqual:iTM2MacrosPathExtension])
				{
					[P1s addObject:[NSArray arrayWithObjects:P0,@"",@"",@"",@"",nil]];
					[P2s addObject:P1];
				}
			}
		}
	}
	// organize the arrays into a dictionary tree
	// 4 levels of embedded dictionaries, last level corresponds to the file name
	NSMutableDictionary * D0 = [NSMutableDictionary dictionary];
	NSMutableDictionary * D1 = nil
	NSMutableDictionary * D2 = nil
	E1 = [P1s objectEnumerator];
	E2 = [P2s objectEnumerator];
	while(RA = [E1 nextObject])
	{
		D1 = nil;
		D2 = D0;
		E0 = [RA objectEnumerator];
		while(P0 = [E0 nextObject])
		{
			P1 = P0;
			D1 = D2;
			if(!(D2 = [D1 objectForKey:P1]))
			{
				D2 = [NSMutableDictionary dictionary];
				[D1 setObject:D2 forKey:P1];
			}
		}
		[D1 setObject:[E2 nextObject] forKey:P1];
	}
	// turn the dictionary tree into a storage macro tree
	// the tree where everything will be stored
	NSDictionary * D3 = nil
	NSDictionary * D4 = nil
	// root level
	iTM2MacroNode * T0 = [[[iTM2MacroNode alloc] init] autorelease];
	E0 = [D0 keyEnumerator];
	while(P0 = [E0 nextObject])
	{
		// repository level
		iTM2MacroNode * T1 = [[[iTM2MacroNode alloc] initWithParent:T0 value:P0] autorelease];
		D1 = [D0 objectForKey:P0];
		E1 = [D1 keyEnumerator];
		while(P1 = [E1 nextObject])
		{
			// domain level
			iTM2MacroNode * T2 = [[[iTM2MacroNode alloc] initWithParent:T1 value:P1] autorelease];
			D2 = [D1 objectForKey:P1];
			E2 = [D2 keyEnumerator];
			while(P2 = [E2 nextObject])
			{
				// category level
				iTM2MacroNode * T3 = [[[iTM2MacroNode alloc] initWithParent:T2 value:P2] autorelease];
				D3 = [D2 objectForKey:P2];
				E3 = [D3 keyEnumerator];
				while(P3 = [E3 nextObject])
				{
					// context level
					iTM2MacroNode * T4 = [[[iTM2MacroNode alloc] initWithParent:T3 value:P3] autorelease];
					D4 = [D3 objectForKey:P3];
					E4 = [D4 keyEnumerator];
					while(P4 = [E4 nextObject])
					{
						// environment level
						iTM2MacroNode * T5 = [[[iTM2MacroNode alloc] initWithParent:T4 value:P4] autorelease];
						// last path component
						//iTM2MacroNode * T6 = 
						[[[iTM2MacroNode alloc] initWithParent:T5
							value:[NSMutableDictionary dictionaryWithObject:[D4 objectForKey:P4] forKey:@"lastPathComponent"]] autorelease];
					}
				}
			}
		}
	}
	metaSETTER(T0);
	return T0;
}

- (void)setStorageTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	[self setRunningTree:nil];
	[self setSourceTree:nil];
	return;
}
#endif
#if 0
static id RUNNING_TREE = nil;
#undef metaGETTER
#undef metaSETTER
#define metaGETTER RUNNING_TREE
#define metaSETTER(NEW)\
[RUNNING_TREE release];RUNNING_TREE = [NEW retain]
#endif
- (id)runningTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"Macros" ofType:@"localized"];
	NSEnumerator * E0 = [RA objectEnumerator];
	NSString * P0 = nil;
	NSEnumerator * E1 = nil;
	NSString * P1 = nil;
	NSEnumerator * E2 = nil;
	NSString * P2 = nil;
	NSEnumerator * E3 = nil;
	NSString * P3 = nil;
	NSEnumerator * E4 = nil;
	NSString * P4 = nil;
	NSEnumerator * E5 = nil;
	NSString * P5 = nil;
	NSMutableArray * P1s = [NSMutableArray array];// components of the macro files directory domain/category/context/environment are P1/P2/P3/P4
	NSMutableArray * P2s = [NSMutableArray array];// elements are dictionary encoding the extremal components of the macro files P0, P5
	while(P0 = [E0 nextObject])
	{
		if((RA = [DFM directoryContentsAtPath:P0]) && [DFM pushDirectory:P0])
		{
			E1 = [RA objectEnumerator];
			while(P1 = [E1 nextObject])
			{
				if((RA = [DFM directoryContentsAtPath:P1]) && [DFM pushDirectory:P1])
				{
					E2 = [RA objectEnumerator];
					while(P2 = [E2 nextObject])
					{
						if((RA = [DFM directoryContentsAtPath:P2]) && [DFM pushDirectory:P2])
						{
							E3 = [RA objectEnumerator];
							while(P3 = [E3 nextObject])
							{
								if((RA = [DFM directoryContentsAtPath:P3]) && [DFM pushDirectory:P3])
								{
									E4 = [RA objectEnumerator];
									while(P4 = [E4 nextObject])
									{
										if((RA = [DFM directoryContentsAtPath:P4]) && [DFM pushDirectory:P4])
										{
											E5 = [RA objectEnumerator];
											while(P5 = [E5 nextObject])
											{
												if([[P5 pathExtension] isEqual:iTM2MacrosPathExtension])
												{
													[P1s addObject:[NSArray arrayWithObjects:P1,P2,P3,P4,nil]];
													[P2s addObject:[NSMutableDictionary dictionaryWithObject:P5 forKey:P0]];
												}
											}
											[DFM popDirectory];
										}
										else if([[P4 pathExtension] isEqual:iTM2MacrosPathExtension])
										{
											[P1s addObject:[NSArray arrayWithObjects:P1,P2,P3,@"",nil]];
											[P2s addObject:[NSMutableDictionary dictionaryWithObject:P4 forKey:P0]];
										}
									}
									[DFM popDirectory];
								}
								else if([[P3 pathExtension] isEqual:iTM2MacrosPathExtension])
								{
									[P1s addObject:[NSArray arrayWithObjects:P1,P2,@"",@"",nil]];
									[P2s addObject:[NSMutableDictionary dictionaryWithObject:P3 forKey:P0]];
								}
							}
							[DFM popDirectory];
						}
						else if([[P2 pathExtension] isEqual:iTM2MacrosPathExtension])
						{
							[P1s addObject:[NSArray arrayWithObjects:P1,@"",@"",@"",nil]];
							[P2s addObject:[NSMutableDictionary dictionaryWithObject:P2 forKey:P0]];
						}
					}
					[DFM popDirectory];
				}
				else if([[P1 pathExtension] isEqual:iTM2MacrosPathExtension])
				{
					[P1s addObject:[NSArray arrayWithObjects:@"",@"",@"",@"",nil]];
					[P2s addObject:[NSMutableDictionary dictionaryWithObject:P1 forKey:P0]];
				}
			}
			[DFM popDirectory];
		}
	}
	// organize the arrays into a dictionary tree
	// 4 levels of embedded dictionaries, the last level corresponds to the file name
	NSMutableDictionary * D0 = nil;
	NSMutableDictionary * D1 = [NSMutableDictionary dictionary];// here it starts with the domain and not the repository: all the repositories will be merged later
	NSMutableDictionary * D2 = nil;
	E1 = [P1s objectEnumerator];
	E2 = [P2s objectEnumerator];
	while(RA = [E1 nextObject])
	{
		D0 = nil;
		D2 = D1;
		E0 = [RA objectEnumerator];
		while(P0 = [E0 nextObject])
		{
			P1 = P0;
			D0 = D2;
			if(!(D2 = [D0 objectForKey:P1]))
			{
				D2 = [NSMutableDictionary dictionary];
				[D0 setObject:D2 forKey:P1];
			}
		}
		// P1 is now the environment part of the macro path
		[[D2 objectForKey:P1] addEntriesFromDictionary:[E2 nextObject]];
	}
	// turn the dictionary tree into a running macro tree
	// the tree where everything will be stored
	// root level
	NSMutableDictionary * D3 = nil;
	NSMutableDictionary * D4 = nil;
	// repository level
	iTM2MacroNode * T1 = [[[iTM2MacroNode alloc] init] autorelease];
	E1 = [D1 keyEnumerator];
	while(P1 = [E1 nextObject])
	{
		// domain level
		iTM2MacroNode * T2 = [[[iTM2MacroNode alloc] initWithParent:T1] autorelease];
		[[T2 value] setObject:P1 forKey:@"domain"];
		D2 = [D1 objectForKey:P1];
		E2 = [D2 keyEnumerator];
		while(P2 = [E2 nextObject])
		{
			// category level
			iTM2MacroNode * T3 = [[[iTM2MacroNode alloc] initWithParent:T2] autorelease];
			[[T3 value] setObject:P2 forKey:@"category"];
			D3 = [D2 objectForKey:P2];
			E3 = [D3 keyEnumerator];
			while(P3 = [E3 nextObject])
			{
				// context level
				iTM2MacroNode * T4 = [[[iTM2MacroNode alloc] initWithParent:T3] autorelease];
				[[T4 value] setObject:P3 forKey:@"context"];
				D4 = [D3 objectForKey:P3];
				E4 = [D4 keyEnumerator];
				while(P4 = [E4 nextObject])
				{
					// environment level
					iTM2MacroRunningNode * T5 = [[[iTM2MacroRunningNode alloc] initWithParent:T4] autorelease];
					[[T5 value] setObject:P4 forKey:@"environment"];
					[[T5 value] setObject:[D4 objectForKey:P4] forKey:@"repositories"];// all the repositories where we'll find the full macro environment
				}
			}
		}
	}
	metaSETTER(T1);
	return T1;
}

- (void)setRunningTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}

#if 0
static id SOURCE_TREE = nil;
#undef metaGETTER
#undef metaSETTER
#define metaGETTER SOURCE_TREE
#define metaSETTER(NEW)\
[SOURCE_TREE release];SOURCE_TREE = [NEW retain]
#endif
- (id)sourceTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:@"Macros.localized" inDomain:NSUserDomainMask create:YES];
	iTM2MacroNode * root = [[[iTM2MacroNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"Macros" ofType:@"localized"];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	// the first repository corresponds to the Application\ Support
	// it is treated specifically because it is editable
	if(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-macros"])
				{
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					iTM2MacroNode * currentNode = root;
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroNode * node = nil;
					while(component = [e nextObject])
					{
						if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
						{
							currentNode = node;
						}
						else
						{
							currentNode = [[[iTM2MacroNode alloc] initWithParent:currentNode] autorelease];
							[currentNode setValue:component forKeyPath:@"value.pathComponent"];
						}
					}
					component = [subpath lastPathComponent];
					if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
					{
						currentNode = node;
					}
					else
					{
						currentNode = [[[iTM2MacroDocumentNode alloc] initWithParent:currentNode] autorelease];
						[currentNode setValue:component forKeyPath:@"value.pathComponent"];
					}
					// currentNode is now the last node of this tree path
					// it represents a document
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"The macro file might be corrupted at\n%@", url);
					}
					else
					{
						[[currentNode value] setObject:document forKey:@"editableMacrosDocument"];
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							NSString * attribute = [[element attributeForName:@"ID"] stringValue];
							attribute = [attribute stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
							iTM2MacroSourceNode * node = [[[iTM2MacroSourceNode alloc] initWithParent:currentNode] autorelease];
							[node setValue:attribute forKeyPath:@"value.ID"];
							[node setValue:element forKeyPath:@"value.editableXMLElement"];
							[node updateMacroKeyStroke];
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	// the other repositories are treated differently
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-macros"])
				{
					iTM2MacroNode * currentNode = root;
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroNode * node = nil;
					while(component = [e nextObject])
					{
						if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
						{
							currentNode = node;
						}
						else
						{
							currentNode = [[[iTM2MacroNode alloc] initWithParent:currentNode] autorelease];
							[currentNode setValue:component forKeyPath:@"value.pathComponent"];
						}
					}
					component = [subpath lastPathComponent];
					if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
					{
						currentNode = node;
					}
					else
					{
						currentNode = [[[iTM2MacroDocumentNode alloc] initWithParent:currentNode] autorelease];
						[currentNode setValue:component forKeyPath:@"value.pathComponent"];
					}
					// currentNode is now the last node of this tree path
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"The macro file might be corrupted at\n%@", url);
					}
					else
					{
						NSMutableArray * MRA = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.otherMacrosDocuments"];
						if(!MRA)
						{
							MRA = [NSMutableArray array];
							[currentNode setValue:MRA forKeyPath:@"value.otherMacrosDocuments"];
							[currentNode setValue:subpath forKeyPath:@"value.macrosDocumentsPath"];
						}
						[MRA addObject:document];
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							NSString * attribute = [[element attributeForName:@"ID"] stringValue];
							iTM2MacroSourceNode * child = (iTM2MacroSourceNode *)[currentNode objectInChildrenWithValue:attribute forKeyPath:@"value.ID"];
							if(!child)
							{
								iTM2MacroSourceNode * node = [[[iTM2MacroSourceNode alloc] initWithParent:currentNode] autorelease];
								[node setValue:attribute forKeyPath:@"value.ID"];
								[node setValue:element forKeyPath:@"value.XMLElement"];
								[node updateMacroKeyStroke];
							}
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(root);
	return root;
}

- (void)setSourceTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	[self willChangeValueForKey:@"sourceTree"];
	metaSETTER(aTree);
	[self didChangeValueForKey:@"sourceTree"];
	[self setRunningTree:nil];
	return;
}

#if 0
static id SORT_DESCRIPTORS = nil;
#undef metaGETTER
#undef metaSETTER
#define metaGETTER SORT_DESCRIPTORS
#define metaSETTER(NEW)\
[SORT_DESCRIPTORS release];SORT_DESCRIPTORS = [NEW retain]
#endif
- (NSArray *)sortDescriptors;
{
	id result = metaGETTER;
	return result;
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors;
{
	[self willChangeValueForKey:@"sortDescriptors"];
	metaSETTER(sortDescriptors);
	[self didChangeValueForKey:@"sortDescriptors"];
	return;
}

#if 0
static id MACRO_ACTIONS = nil;
#undef metaGETTER
#undef metaSETTER
#define metaGETTER SORT_DESCRIPTORS
#define metaSETTER(NEW)\
[SORT_DESCRIPTORS release];SORT_DESCRIPTORS = [NEW retain]
#endif
- (NSArray *)macroActions;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	NSArray * RA = [iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2MacroAction class]];
	NSEnumerator * E = [RA objectEnumerator];
	Class subclass = Nil;
	while(subclass = [[E nextObject] nonretainedObjectValue])
	{
		id macroAction = [[[subclass allocWithZone:[self zone]] init] autorelease];
		if([[macroAction description] length])
		{
			[result addObject:macroAction];
		}
	}
	[result sortUsingSelector:@selector(compareDescription:)];
	metaSETTER(result);
	return metaGETTER;
}

- (id)macroActionForName:(NSString *)actionName
{
	SEL expectedAction = NSSelectorFromString(actionName);
	NSEnumerator * E = [[self macroActions] objectEnumerator];
	iTM2MacroAction * macroAction = nil;
	while(macroAction = [E nextObject])
	{
		if(expectedAction == [macroAction action])
		{
			break;
		}
	}
	return macroAction;
}
- (NSArray *)macroFunctionKeys;
{
	return [[self macroFunctionKeysDictionary] allKeys];
}
- (NSDictionary *)macroFunctionKeysDictionary;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"iTM2MacroFunctionKeys" ofType:@"plist"];
	if([RA count])
	{
		NSString * path = [RA objectAtIndex:0];
		if(result = [NSDictionary dictionaryWithContentsOfFile:path])
		{
			metaSETTER(result);
			return result;
		}
	}
	result = [NSDictionary dictionary];
	metaSETTER(result);
	return result;
}
- (void)save:(id)sender;
{
	[[self sourceTree] save];
}
@end

@interface iTM2MacroTreeController: NSTreeController
+ (id)sharedMacroTreeController;
@end

@interface iTM2MacroKeyEquivalentWindow: NSWindow
@end

@implementation iTM2MacroKeyEquivalentWindow
- (BOOL)canBecomeKeyWindow;
{
	return YES;
}
- (void)keyDown:(NSEvent *)theEvent
{
	unsigned int modifierFlags = [theEvent modifierFlags];
	NSControl * C = nil;
	if(modifierFlags & NSCommandKeyMask)
	{
		C = [[self contentView] viewWithTag:1];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSShiftKeyMask)
	{
		C = [[self contentView] viewWithTag:2];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSAlternateKeyMask)
	{
		C = [[self contentView] viewWithTag:3];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSControlKeyMask)
	{
		C = [[self contentView] viewWithTag:4];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSFunctionKeyMask)
	{
		C = [[self contentView] viewWithTag:5];
		[C performClick:theEvent];
	}
	return;
}
@end

@interface iTM2MacroOutlineView: NSOutlineView
{
@private
	NSView * _KeyEquivalentView;
}
@end

@implementation iTM2MacroOutlineView
- (void)awakeFromNib;
{
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[(id)super awakeFromNib];
	}
	[_KeyEquivalentView retain];
	// resize the columns to have the key column visible;
	// get the size of the view
	[self setAutosaveExpandedItems:YES];
	NSScrollView * ESV = [self enclosingScrollView];
	float W = [ESV documentVisibleRect].size.width;
	NSTableColumn * TC1 = [self tableColumnWithIdentifier:@"Name"];
	NSTableColumn * TC2 = [self tableColumnWithIdentifier:@"Key"];
//	NSTableColumn * TC3 = [self tableColumnWithIdentifier:@"ID"];
	if(W<=[TC1 width])
	{
		// the Key column is not visible
		if(W>[TC2 width])
		{
			W -= [TC2 width];
			[TC1 setWidth:W];
			[self sizeToFit];
		}
	}
	return;
}
- (void)dealloc;
{
	[_KeyEquivalentView release];
	[super dealloc];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent * )event
/*"Description Forthcoming
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    if([event clickCount]>1)
    {
//NSLog(@"[event clickCount]: %i", [event clickCount]);
        [super mouseDown:event];
		if([self isEqual:[[self window] firstResponder]])
		{
			NSPoint P = [event locationInWindow];
			P = [self convertPoint:P fromView:nil];
			int clickedColumn = [self columnAtPoint:P];
			NSTableColumn * clickedTableColumn = [[self tableColumns] objectAtIndex:clickedColumn];
			NSTableColumn * OTC = [self outlineTableColumn];
			if([OTC isEqual:clickedTableColumn])
			{
				int clickedRow = [self rowAtPoint:P];
				id clickedItem = [self itemAtRow:clickedRow];
				if(![self isExpandable:clickedItem])
				{
					[self editColumn:clickedColumn row:clickedRow withEvent:event select:NO];
				}
			}
		}
    }
    else
        [super mouseDown:event];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editColumn:row:withEvent:select:
- (void)editColumn:(int)column row:(int)row withEvent:(NSEvent *)theEvent select:(BOOL)select;
/*"Description Forthcoming
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
	int keyColumn = [self columnWithIdentifier:@"Key"];
	if(keyColumn == column)
	{
		NSRect contentRect = [_KeyEquivalentView frame];
		NSRect cellFrame = [self frameOfCellAtColumn:column row:row];
		cellFrame = [self convertRect:cellFrame toView:nil];
		cellFrame.origin = [[self window] convertBaseToScreen:cellFrame.origin];
		cellFrame.size = contentRect.size;
		// create the window
		NSWindow * W = [[iTM2MacroKeyEquivalentWindow alloc] initWithContentRect:cellFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		NSView * oldContentView = [W contentView];
		[W setContentView:_KeyEquivalentView];
		[W setLevel:NSModalPanelWindowLevel];
		[W setHasShadow:YES];
		[[self window] addChildWindow:W ordered:NSWindowAbove];
//		[W setFrameOrigin:cellFrame.origin];
//		[W setFrameTopLeftPoint:aPoint];
		[W makeKeyAndOrderFront:self];
		[NSApp runModalForWindow:W];
		[[self window] removeChildWindow:W];
		[W setContentView:oldContentView];
		[W release];
	}
	else
	{
		[super editColumn:(int)column row:(int)row withEvent:(NSEvent *)theEvent select:(BOOL)select];
	}
    return;
}
- (void)stopKeyEditing:(id)sender;
{
	[NSApp stopModalWithCode:0];
	return;
}
@end

#import "iTM2PreferencesKit.h"
#import "iTeXMac2.h"

@interface iTM2MacroPrefPane: iTM2PreferencePane
@end

@implementation iTM2MacroPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"3.Macro";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super willUnselect];
    return;
}
@end

@implementation iTM2MacroTreeController

static id _iTM2MacroTreeController = nil;

+ (id)sharedMacroTreeController;
{
	return _iTM2MacroTreeController?:( _iTM2MacroTreeController = [[self alloc] init]);
}

- (id)init;
{
	if(_iTM2MacroTreeController)
	{
		return [_iTM2MacroTreeController retain];
	}
	else if(self = [super init])
	{
	}
	return _iTM2MacroTreeController = self;
}
- (void)awakeFromNib;
{// the + button is not up to date, force the UI widget bound to canIinsert to be updated
	[self willChangeValueForKey:@"canInsert"];
	[self didChangeValueForKey:@"canInsert"];
	return;
}
#if 0
- (void)add:(id)sender;
{
	id selection = [self selection];
	return;
}
- (void)remove:(id)sender;
{
	id selection = [self selection];
	return;
}
- (void)insert:(id)sender;
{
	id selection = [self selection];
	return;
}
- (BOOL)canInsert;
- (BOOL)canInsertChild;
- (BOOL)canAddChild;
#endif
@end

@interface iTM2PrettyNameOfMacroKeyTransformer: NSValueTransformer
@end
@implementation iTM2PrettyNameOfMacroKeyTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }
- (id)transformedValue:(id)value;
{
    return value?[[[iTM2MacroController sharedMacroController] macroFunctionKeysDictionary] objectForKey:value]:value;
}
- (id)reverseTransformedValue:(id)value;
{
    return value?[[[[iTM2MacroController sharedMacroController] macroFunctionKeysDictionary] allKeysForObject:value] lastObject]:value;
}
@end
