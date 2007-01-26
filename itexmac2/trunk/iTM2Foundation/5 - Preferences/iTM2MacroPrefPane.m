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

#import <iTM2Foundation/iTM2MacroPrefPane.h>
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2KeyBindingsKit.h>
#import <iTM2Foundation/iTM2TreeKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacrosPathExtension = @"iTM2-macros";

/*!
    @class       iTM2MacroTreeRoot
    @superclass  iTM2TreeNode
    @abstract    Main tree
    @discussion  This is the main tree containing the macros.
				 The macros are gathered in one tree, with the various domains at the second level,
				 the various categories at the third level, and the various contexts at the 4th level.
				 The contexts are the ones which store the repository path.
				 This is consistent because we are not expected to move contexts from repositories to repositories.
				 We jus can copy from repositories to repositories.
				
*/


@interface iTM2MacroController(PRIVATE)
- (id)macroActionForName:(NSString *)actionName;
- (NSString *)prettyNameForKeyCodeNumber:(NSNumber *) keyCode;
- (NSArray *)macroKeyStrokePrettyNames;
- (void)setMacroKeyStrokePrettyNames:(NSArray *)macroKeyNames;
- (NSArray *)macroKeyCodes;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
@end


@interface iTM2MacroAction: NSObject
{
@private
	NSString * description;
}
- (SEL)action;
- (NSComparisonResult)compareUsingDescription:(id)rhs;
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
- (NSComparisonResult)compareUsingDescription:(id)rhs;
{
	return [[self description] compare:[rhs description]];
}
@end

@interface iTM2MacroAction_insertMacro_: iTM2MacroAction
@end

@implementation iTM2MacroAction_insertMacro_
@end

@interface iTM2MacroKeyStroke: NSObject <NSCopying>
{
@public
	NSString * codeName;
	NSString * _description;
	NSString * _string;
	BOOL isCommand;
	BOOL isShift;
	BOOL isAlternate;
	BOOL isControl;
	BOOL isFunction;
}
- (NSString *)string;
- (NSString *)description;
- (void)setCodeName:(NSString *)codeName;
@end

@interface iTM2MacroEditNode: iTM2TreeNode
- (NSString *)ID;
- (NSString *)name;
- (BOOL)canEditName;
- (NSAttributedString *)insertMacroArgument;
@end

@implementation iTM2MacroEditNode
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
	if([anObject valueForKeyPath:@"value.editableElement"])
	{
		[anObject willChangeValueForKey:@"children"];
		[anObject setValue:nil forKeyPath:@"value.editableElement"];
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
	if([anObject valueForKeyPath:@"value.editableElement"])
	{
		[anObject willChangeValueForKey:@"children"];
		[anObject setValue:nil forKeyPath:@"value.editableElement"];
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
- (void)save;
{
	[[self children] makeObjectsPerformSelector:_cmd];
}
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	return nil;
}
- (iTM2MacroKeyStroke *)unmodifiedMacroKeyStroke;
{
	return nil;
}
- (BOOL)isShift;
{
	return NO;
}
- (BOOL)isControl;
{
	return NO;
}
- (BOOL)isCommand;
{
	return NO;
}
- (BOOL)isAlternate;
{
	return NO;
}
- (BOOL)canEditKeyStroke;
{
	return NO;
}
@end


@implementation iTM2MacroKeyStroke
- (id)initWithCodeName:(NSString*)newCodeName;
{
	if(self = [super init])
	{
		[self setCodeName:newCodeName];
	}
	return self;
}
- (void)dealloc;
{
	[self setCodeName:nil];
	[super dealloc];
	return;
}
- (void)update;
{
	[_description autorelease];
	_description = nil;
	[_string autorelease];
	_string = nil;
	return;
}
- (void)setCodeName:(NSString *)newCodeName;
{
	[self->codeName autorelease];
	self->codeName = [newCodeName copy];
	return;
}
- (NSString *)string;
{
	if(_string)
	{
		return _string;
	}
	if(codeName)
	{
		NSString * isCommandString = isCommand?@"@":@"";
		NSString * isShiftString = isShift?@"$":@"";
		NSString * isAlternateString = isAlternate?@"~":@"";
		NSString * isControlString = isControl?@"^":@"";
		NSString * isFunctionString = isFunction?@"&":@"";
		NSString * modifier = [NSString stringWithFormat:@"%@%@%@%@%@",isCommandString, isShiftString, isAlternateString, isControlString, isFunctionString];
		if([modifier length])
		{
			_string = [[NSString stringWithFormat:@"%@->%@",modifier, codeName] retain];
		}
		else
		{
			_string = [codeName copy];
		}
	}
	else
	{
		_string = @"";
	}
	return _string;
}
- (NSString *)description;
{
	if(_description)
	{
		return _description;
	}
	if(codeName)
	{
		NSMutableString * result = [NSMutableString string];
		if(isShift)
		{
			[result appendString:[NSString stringWithUTF8String:"⇧"]];
		}
		if(isControl)
		{
			[result appendString:[NSString stringWithUTF8String:" ctrl "]];
		}
		if(isAlternate)
		{
			[result appendString:[NSString stringWithUTF8String:"⌥"]];
		}
		if(isCommand)
		{
			[result appendString:[NSString stringWithUTF8String:"⌘"]];
		}
		if(isFunction)
		{
			[result appendString:[NSString stringWithUTF8String:" fn "]];
		}
		[result appendString:@" "];
		NSString * localized = [KCC localizedNameForCodeName:codeName];
		[result appendString:localized];
		[result replaceOccurrencesOfString:@"  " withString:@" " options:0 range:NSMakeRange(0,[result length])];
		_description = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		_description = [_description copy];
	}
	else
	{
		_description = @"";
	}	
	return _description;
}
- (id)copyWithZone:(NSZone *)zone;
{
	iTM2MacroKeyStroke * result = [[[self class] alloc] initWithCodeName:self->codeName];
	result->isCommand = self->isCommand;
	result->isShift = self->isShift;
	result->isAlternate = self->isAlternate;
	result->isControl = self->isControl;
	result->isFunction = self->isFunction;
	return result;
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
	NSMutableArray * components = [[[self componentsSeparatedByString:@"->"] mutableCopy] autorelease];
	NSString * component = [components lastObject];
	iTM2MacroKeyStroke * result = [[[iTM2MacroKeyStroke alloc] initWithCodeName:component] autorelease];
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

@interface iTM2MacroSourceLeafNode: iTM2MacroEditNode
{
@public
	iTM2MacroKeyStroke * macroKeyStroke;
	iTM2MacroKeyStroke * unmodifiedMacroKeyStroke;
}
- (id)editableElement;
- (void)setMacroKeyStroke:(iTM2MacroKeyStroke *)newStroke;
- (void)willChangeMacroKeyStroke;
- (void)didChangeMacroKeyStroke;

@end

@implementation iTM2MacroSourceLeafNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element editable:(BOOL)isEditable;
{
	if(self = [super initWithParent:(iTM2TreeNode *)parent])
	{
		[self setValue:ID forKeyPath:@"value.ID"];
		[self setValue:element forKeyPath:(isEditable?@"value.editableElement":@"value.element")];
		
		element = (NSXMLElement *)[element attributeForName:@"KEY"];
		NSString * key = [element stringValue];
		[macroKeyStroke release];
		macroKeyStroke = [[key macroKeyStroke] copy];
		[unmodifiedMacroKeyStroke release];
		unmodifiedMacroKeyStroke = macroKeyStroke?[[iTM2MacroKeyStroke alloc] initWithCodeName:macroKeyStroke->codeName]:nil;
	}
	return self;
}
- (void)dealloc;
{
	[macroKeyStroke release];
	macroKeyStroke = nil;
	[unmodifiedMacroKeyStroke release];
	unmodifiedMacroKeyStroke = nil;
	[super dealloc];
	return;
}
- (id)editableElement;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableElement"];
	if(element)
	{
		return element;
	}
	if(element = [self valueForKeyPath:@"value.element"])
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
				
				NSString * repositoryPath = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:YES];
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
	[self setValue:element forKeyPath:@"value.editableElement"];
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
	NSXMLElement * element = [self valueForKeyPath:@"value.editableElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.element"];
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
	NSXMLElement * element = [self editableElement];
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
	NSXMLElement * element = [self valueForKeyPath:@"value.editableElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.element"];
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
	NSXMLElement * element = [self editableElement];
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
	NSXMLElement * element = [self valueForKeyPath:@"value.editableElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.element"];
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
	NSXMLElement * element = [self editableElement];
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
- (void) setKey:(NSString *)newKey;
{
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (NSString *)prettyKey;
{
	return [macroKeyStroke description];
}
- (BOOL)canEditKey;
{
	return YES;
}
- (NSString *)name;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.element"];
	}
	NSArray * NAMES = [element elementsForName:@"NAME"];
	element = [NAMES lastObject];
	return [element stringValue];
}
- (void)setName:(NSString *) newName;
{
	NSXMLElement * element = [self editableElement];
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
				NSArray * components = [path componentsSeparatedByString:iTM2MacroServerComponent];
				if([components count]>1)
				{
					path = [components lastObject];
					components = [path pathComponents];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = [e nextObject];// iTM2PathComponentsSeparator
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
		[self setValue:newID forKeyPath:@"value.ID"];
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
	return [self valueForKeyPath:@"value.editableElement"] != nil;
}
- (id)macroAction;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.element"];
	}
	element = (NSXMLElement *)[element attributeForName:@"SEL"];
	NSString * actionName = element?[element stringValue]:@"insertMacro:";
	return [SMC macroActionForName:actionName];
}
- (void)willChangeMacroKeyStroke;
{
	[self willChangeValueForKey:@"isEdited"];
	[self willChangeValueForKey:@"prettyKey"];
	[self willChangeValueForKey:@"macroKeyStroke"];
	[self willChangeValueForKey:@"unmodifiedMacroKeyStroke"];
	[self willChangeValueForKey:@"isControl"];
	[self willChangeValueForKey:@"isShift"];
	[self willChangeValueForKey:@"isAlternate"];
	[self willChangeValueForKey:@"isCommand"];
	return;
}
- (void)didChangeMacroKeyStroke;
{
	[macroKeyStroke update];
	NSString * newKey = [macroKeyStroke string];
	NSXMLElement * element = [self editableElement];
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
			[self willChangeValueForKey:@"isEdited"];
			[attribute setStringValue:newKey];
		}
	}
	else
	{
		[self willChangeValueForKey:@"isEdited"];
		attribute = [NSXMLNode attributeWithName:@"KEY" stringValue:newKey];
		[element addAttribute:attribute];
	}
	[self didChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"prettyKey"];
	[self didChangeValueForKey:@"macroKeyStroke"];
	[self didChangeValueForKey:@"unmodifiedMacroKeyStroke"];
	[self didChangeValueForKey:@"isControl"];
	[self didChangeValueForKey:@"isShift"];
	[self didChangeValueForKey:@"isAlternate"];
	[self didChangeValueForKey:@"isCommand"];
	return;
}
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	return macroKeyStroke;
}
- (void)setMacroKeyStroke:(iTM2MacroKeyStroke *)newStroke;
{
	if([newStroke isKindOfClass:[iTM2MacroKeyStroke class]])
	{
		[self willChangeMacroKeyStroke];
		[macroKeyStroke release];
		macroKeyStroke = [newStroke copy];
		[unmodifiedMacroKeyStroke autorelease];
		unmodifiedMacroKeyStroke = [[iTM2MacroKeyStroke alloc] initWithCodeName:macroKeyStroke->codeName];
		[self didChangeMacroKeyStroke];
	}
	return;
}
- (iTM2MacroKeyStroke *)unmodifiedMacroKeyStroke;
{
	return unmodifiedMacroKeyStroke;
}
- (void)setUnmodifiedMacroKeyStroke:(iTM2MacroKeyStroke *)newStroke;
{
	if([newStroke isKindOfClass:[iTM2MacroKeyStroke class]])
	{
		[self willChangeMacroKeyStroke];
		[unmodifiedMacroKeyStroke release];
		unmodifiedMacroKeyStroke = [newStroke copy];
		[macroKeyStroke setCodeName:unmodifiedMacroKeyStroke->codeName];
		[self didChangeMacroKeyStroke];
	}
	return;
}
- (BOOL)isShift;
{
	return macroKeyStroke?macroKeyStroke->isShift:NO;
}
- (BOOL)isControl;
{
	return macroKeyStroke?macroKeyStroke->isControl:NO;
}
- (BOOL)isCommand;
{
	return macroKeyStroke?macroKeyStroke->isCommand:NO;
}
- (BOOL)isAlternate;
{
	return macroKeyStroke?macroKeyStroke->isAlternate:NO;
}
- (void)setIsShift:(BOOL)yorn;
{
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isShift = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsControl:(BOOL)yorn;
{
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isControl = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsCommand:(BOOL)yorn;
{
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isCommand = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsAlternate:(BOOL)yorn;
{
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isAlternate = yorn;
	[self didChangeMacroKeyStroke];
}
- (BOOL)canEditKeyStroke;
{
	return YES;
}
@end

@interface iTM2MacroEditDocumentNode: iTM2MacroEditNode
@end

@implementation iTM2MacroEditDocumentNode
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

@interface iTM2MacroRunningNode: iTM2MacroEditNode

@end

@implementation iTM2MacroRunningNode

@end

@interface iTM2MacroActionNode: iTM2MacroEditNode

@end

@implementation iTM2MacroActionNode

@end

#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@interface iTM2MacroRootNode: iTM2TreeNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
@end

@implementation iTM2MacroRootNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
{
	return [self objectInChildrenWithValue:domain forKeyPath:@"value.domain"];
}
@end

@interface iTM2MacroDomainNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
- (id)objectInChildrenWithCategory:(NSString *)category;
@end

@implementation iTM2MacroDomainNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:domain forKeyPath:@"value.domain"];
	}
	return self;
}
- (id)objectInChildrenWithCategory:(NSString *)category;
{
	return [self objectInChildrenWithValue:category forKeyPath:@"value.category"];
}
@end

@interface iTM2MacroCategoryNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent category:(NSString *)category;
- (id)objectInChildrenWithContext:(NSString *)context;
@end

@implementation iTM2MacroCategoryNode
- (id)initWithParent:(iTM2TreeNode *)parent category:(NSString *)category;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:category forKeyPath:@"value.category"];
	}
	return self;
}
- (id)objectInChildrenWithContext:(NSString *)context;
{
	return [self objectInChildrenWithValue:context forKeyPath:@"value.context"];
}
@end

@interface iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
- (id)objectInChildrenWithID:(NSString *)ID;
@end

@implementation iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
	}
	return self;
}
- (id)objectInChildrenWithID:(NSString *)ID;
{
	return [self objectInChildrenWithValue:ID forKeyPath:@"value.ID"];
}
@end

@interface iTM2MacroLeafNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element;
- (NSString *)name;
- (SEL)action;
- (NSString *)argument;
- (NSString *)description;
- (NSString *)tooltip;
@end

@implementation iTM2MacroLeafNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:ID forKeyPath:@"value.ID"];
		[self setValue:element forKeyPath:@"value.element"];
	}
	return self;
}
- (NSString *)description;
{
	return [NSString stringWithFormat:@"%@(%@)",[super description],[self valueForKeyPath:@"value.ID"]];
}
- (NSString *)name;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"NAME" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no name.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No name available";
	}
}
- (NSString *)macroDescription;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"DESC" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no description.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No description available";
	}
}
- (NSString *)tooltip;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"TIP" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no tooltip.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No name tooltip";
	}
}
- (SEL)action;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSXMLNode * node = [element attributeForName:@"SEL"];
	if(node)
	{
		return NSSelectorFromString([node stringValue]);
	}
	else
	{
		return NULL;
	}
}
- (NSString *)argument;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"ARG" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no arguments.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return nil;
	}
}
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@implementation iTM2MacroController

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
		[self setValue:nil forKey:@"sourceTree"];// dirty trick to avoid header declaration
	}
	return _iTM2MacroController = self;
}

- (id)runningTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained later
	// list all the *.iTM2-macros files
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
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
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					iTM2MacroContextNode * contextNode = nil;
					if(component = [e nextObject])
					{
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if(component = [e nextObject])
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if(component = [e nextObject])
							{
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
							}
							else
							{
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
							}
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
						}
					}
					else
					{
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						contextNode = [categoryNode objectInChildrenWithContext:component]?:
								[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
					}
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"url:%@",url);
					}
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"The macro file might be corrupted at\n%@", url);
					}
					else
					{
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							[element detach];// no longer belongs to the document
							NSString * ID = [[element attributeForName:@"ID"] stringValue];
							iTM2MacroLeafNode * child = (iTM2MacroLeafNode *)[contextNode objectInChildrenWithID:ID];
							if(!child)
							{
								//iTM2MacroLeafNode * node = 
								[[[iTM2MacroLeafNode alloc] initWithParent:contextNode ID:ID element:element] autorelease];
							}
							if(iTM2DebugEnabled)
							{
								child = (iTM2MacroLeafNode *)[contextNode objectInChildrenWithID:ID];
								iTM2_LOG(@"child:%@",child);
							}
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroRunningNodeForID:context:ofCategory:inDomain:
- (id)macroRunningNodeForID:(NSString *)ID context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self runningTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
	iTM2MacroLeafNode * leafNode = [contextNode objectInChildrenWithID:ID];
	if(!leafNode)
	{
		iTM2_LOG(@"No macro with ID: %@ forContext:%@ ofCategory:%@ inDomain:%@",ID,context,category,domain);
	}
//iTM2_END;
	return leafNode;
}
- (id)menuTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-menu"])
				{
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					// for menus there are only two levels
					// no level for the context depth
					if(component = [e nextObject])
					{
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if(component = [e nextObject])
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if(component = [E nextObject])
							{
								component = [subpath lastPathComponent];
								component = [component stringByDeletingPathExtension];
							}
						}
					}
					else
					{
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
					}
					component = [subpath lastPathComponent];
					component = [component stringByDeletingPathExtension];
					iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:component];
					if(!menuNode)
					{
						iTM2MacroMenuNode * menuNode = [[[iTM2MacroMenuNode alloc] initWithParent:categoryNode context:component] autorelease];
						NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
						[menuNode setValue:url forKeyPath:@"value.URL"];
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
}

- (void)setMenuTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuForContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self menuTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:context];
	NSMenu * M = [menuNode valueForKeyPath:@"value.menu"];
	if(!M)
	{
		NSURL * url = [menuNode valueForKeyPath:@"value.URL"];
		if(url)
		{
			NSError * localError = nil;
			NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
			if(localError)
			{
				[SDC presentError:localError];
			}
			NSXMLElement * rootElement = [xmlDoc rootElement];
			M = [self macroMenuWithXMLElement:rootElement forContext:context ofCategory:category inDomain:domain error:&localError];
			[menuNode setValue:M forKeyPath:@"value.menu"];
		}
	}
//iTM2_END;
	return M;
}

#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"MENU"])
	{
		NSString * prefix = [[element attributeForName:@"ID"] stringValue];
		if(!prefix)
			prefix = @"";
		if([element childCount])
		{
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
			id child = [element childAtIndex:0];
			do
			{
				NSMenuItem * MI = [self macroMenuItemWithXMLElement:child forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
				if(MI)
					[M addItem:MI];
			}
			while(child = [child nextSibling]);
			return M;
		}
	}
	else if(element)
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuItemWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"SEP"])
	{
		return [NSMenuItem separatorItem];
	}
	else if([name isEqualToString:@"ITEM"])
	{
		NSString * ID = [[element attributeForName:@"ID"] stringValue];
		iTM2MacroLeafNode * leafNode = [[iTM2MacroController sharedMacroController] macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
		name = [leafNode name];
		if(!leafNode)
		{
			name = ID;
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle:name action:NULL keyEquivalent: @""] autorelease];
		[MI setToolTip:[leafNode tooltip]];
		id submenuList = [[element elementsForName:@"MENU"] lastObject];
		NSMenu * M = [self macroMenuWithXMLElement:submenuList forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
		[MI setSubmenu:M];
		if([ID length])
		{
			[MI setRepresentedObject:[NSArray arrayWithObjects:ID, context, category, domain, nil]];
			SEL action = [leafNode action];
			if(!leafNode || action == @selector(noop:) || !action && ![leafNode argument])
			{
				// no action;
				if(!M)
				{
					[MI setAction:@selector(___catch:)];
					[MI setTarget:self];
				}
			}
			else
			{
				[MI setAction:@selector(___insertMacro:)];
				[MI setTarget:self];
			}
		}
		return MI;
	}
	else
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
- (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:20], @"iTM2NumberOfRecentMacros", nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___catch:
- (void)___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && [RA count])
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if([RA count] > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if([RA count] > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if([RA count] > 1)
				{
					context = @"";
					domain = [RA objectAtIndex:1];
				}
				else
				{
					domain = @"";
				}
			}
		}
		if([ID length])
		{
			[[iTM2MacroController sharedMacroController] executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain];
			NSMenu * recentMenu = [self macroMenuForContext:context ofCategory:@"Recent" inDomain:domain error:nil];
			int index = [recentMenu indexOfItemWithTitle:[sender title]];
			if(index!=-1)
			{
				[recentMenu removeItemAtIndex:index];
			}
			NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:[sender title] action:[sender action] keyEquivalent:@""] autorelease];
			[MI setTarget:self];
			[MI setRepresentedObject:RA];
			[recentMenu insertItem:MI atIndex:1];
			NSMutableDictionary * MD = [NSMutableDictionary dictionary];
			index = 0;
			int max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
			while([recentMenu numberOfItems] > max)
			{
				[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
			}
			while(++index < [recentMenu numberOfItems])
			{ 
				MI = [recentMenu itemAtIndex:index];
				RA = [MI  representedObject];
				if(RA)
				{
					[MD setObject:RA forKey:[MI title]];
				}
			}
			[SUD setObject:MD forKey:[NSString pathWithComponents:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
		}
	}
	else if(RA)
	{
		iTM2_LOG(@"Unknown design [sender representedObject]:%@", RA);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && ([RA count] > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if([ID length])
			return YES;
	}
	iTM2_LOG(@"sender is:%@",sender);
//iTM2_END;
    return [sender hasSubmenu];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithID:forContext:ofCategory:inDomain:
- (BOOL)executeMacroWithID:(NSString *)ID forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroLeafNode * leafNode = [self macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
	SEL action = [leafNode action];
	if(!action)
	{
		action = NSSelectorFromString(@"insertMacro:");
	}
	id argument = [leafNode argument];
	if(argument)
	{
		if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:argument]
			|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:argument])
		{
			return YES;
		}
		else
		{
			iTM2_LOG(@"No target for %@ with argument %@", NSStringFromSelector(action), argument);
		}
	}
	if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:nil]
		|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:nil])
	{
		return YES;
	}
	else
	{
		iTM2_LOG(@"No target for %@ with no argument", NSStringFromSelector(action));
	}
//iTM2_END;
    return NO;
}

@end

@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= domain
+ (NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"Text";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= category
+ (NSString *)category;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"LaTeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= menu
+ (NSMenu *)menu;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromClass(self);
	NSRange R1 = [name rangeOfString:@"Script"];
	if(R1.length)
	{
		NSRange R2 = [name rangeOfString:@"Button"];
		if(R2.length && (R1.location += R1.length, (R2.location > R1.location)))
		{
			R1.length = R2.location - R1.location;
			NSString * context = [name substringWithRange:R1];
			NSString * category = [self category];
			NSString * domain = [self domain];
			NSMenu * M = [[iTM2MacroController sharedMacroController] macroMenuForContext:context ofCategory:category inDomain:domain error:nil];
			M = [[M deepCopy] autorelease];
			// insert a void item for the title
			[M insertItem:[[[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease] atIndex:0];// for the title
			return M;
		}
	}
//iTM2_END;
    return [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[iTM2GenericScriptButton superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[[self retain] autorelease];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
	[self setMenu:[[self class] menu]];
	[[self cell] setAutoenablesItems:YES];
//iTM2_END;
    return;
}
@end

#pragma mark -

@interface iTM2PrettyNameOfKeyCodeTransformer: NSValueTransformer
@end

@interface iTM2PrettyNamesOfKeyCodesTransformer: NSValueTransformer
@end

@interface iTM2MacroController(EDIT)
/*!
    @method     sourceTree
    @abstract   The macro source tree
    @discussion Lazy initializer.
    @result     The macro source tree
*/
- (id)sourceTree;

/*!
    @method     setSourceTree:
    @abstract   Set the macro source tree
    @discussion Designated setter.
    @param      aTree
    @result     None
*/
- (void)setSourceTree:(id)aTree;

- (NSArray *)macroKeyCodes;
- (void)setMacroKeyCodes:(NSArray *)array;

@end

@implementation iTM2MacroController(EDIT)

- (id)sourceTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:YES];
	iTM2MacroEditNode * root = [[[iTM2MacroEditNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
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
					iTM2MacroEditNode * currentNode = root;
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroEditNode * node = nil;
					while(component = [e nextObject])
					{
						if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
						{
							currentNode = node;
						}
						else
						{
							currentNode = [[[iTM2MacroEditNode alloc] initWithParent:currentNode] autorelease];
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
						currentNode = [[[iTM2MacroEditDocumentNode alloc] initWithParent:currentNode] autorelease];
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
							//iTM2MacroSourceLeafNode * node = 
							[[[iTM2MacroSourceLeafNode alloc] initWithParent:currentNode ID:attribute element:element editable:YES] autorelease];
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
					iTM2MacroEditNode * currentNode = root;
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroEditNode * node = nil;
					while(component = [e nextObject])
					{
						if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
						{
							currentNode = node;
						}
						else
						{
							currentNode = [[[iTM2MacroEditNode alloc] initWithParent:currentNode] autorelease];
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
						currentNode = [[[iTM2MacroEditDocumentNode alloc] initWithParent:currentNode] autorelease];
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
							iTM2MacroSourceLeafNode * child = (iTM2MacroSourceLeafNode *)[currentNode objectInChildrenWithValue:attribute forKeyPath:@"value.ID"];
							if(!child)
							{
								//iTM2MacroSourceLeafNode * node = 
								[[[iTM2MacroSourceLeafNode alloc] initWithParent:currentNode ID:attribute element:element editable:NO] autorelease];
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
	[result sortUsingSelector:@selector(compareUsingDescription:)];
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
- (NSArray *)macroKeyCodes;
{
	//lazy initializer
	id MFKs = metaGETTER;
	if(MFKs)
	{
		return MFKs;
	}
	MFKs = [NSMutableArray array];
	metaSETTER(MFKs);
//	[iTM2KeyCodesController sharedController];
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"iTM2MacroKeyCodes" ofType:@"xml"];
	if([RA count])
	{
		NSString * path = [RA objectAtIndex:0];
		NSURL * url = [NSURL fileURLWithPath:path];
		NSError * localError = nil;
		NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
		if(localError)
		{
			[SDC presentError:localError];
		}
		else
		{
			NSArray * nodes = [doc nodesForXPath:@"/*/KEY" error:&localError];
			if(localError)
			{
				[SDC presentError:localError];
			}
			else
			{
				NSEnumerator * E = [nodes objectEnumerator];
				id node = nil;
				while(node = [E nextObject])
				{
					NSString * KEY = [node stringValue];
					if([KEY length])
					{
						iTM2MacroKeyStroke * MKS = [[[iTM2MacroKeyStroke alloc] initWithCodeName:KEY] autorelease];
						[MFKs addObject:MKS];
					}
					#if 0
					this was for a separator menu item
					else
					{
						[MFKs addObject:[NSNull null]];
					}
					#endif
				}
			}
		}
	}
	return MFKs;
}
- (void)setMacroKeyCodes:(NSArray *)array;
{
	[self willChangeValueForKey:@"macroKeyCodes"];
	metaSETTER(array);
	[self didChangeValueForKey:@"macroKeyCodes"];
	return;
}
- (NSString *)prettyNameForKeyCodeNumber:(NSNumber *) keyCode;
{
	if([keyCode isKindOfClass:[NSNull class]])
	{
		return @"";
	}
	int intCode = [keyCode intValue];
	NSString * key = [NSString stringWithFormat:(intCode>0xFF?@"%#x":@"%0#4x"),intCode];
	key = [key lowercaseString];
	NSString * result = NSLocalizedStringWithDefaultValue(key, @"iTM2MacroKeyStrokes", [NSBundle bundleForClass:[self class]], @"NO LOCALIZATION", "");
	if(![result isEqual:@"NO LOCALIZATION"])
	{
		return result;
	}
	unichar uniCode = intCode;
	result = [NSString stringWithCharacters:&uniCode length:1];
	if([result length])
	{
		return result;
	}
	return key;
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
{
	iTM2MacroKeyStroke * macroKeyStroke;
}
@end

@implementation iTM2MacroKeyEquivalentWindow
- (void)dealloc;
{
	[macroKeyStroke autorelease];
	macroKeyStroke = nil;
	[super dealloc];
	return;
}
- (BOOL)canBecomeKeyWindow;
{
	return YES;
}
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent;
{
	unsigned int modifierFlags = [theEvent modifierFlags];
	if(modifierFlags&NSDeviceIndependentModifierFlagsMask)
	{
		[self keyDown:theEvent];
		return YES;
	}
	return [super performKeyEquivalent:theEvent];
}
#if 0
- (void)flagsChanged:(NSEvent *)theEvent
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
#endif
- (void)keyDown:(NSEvent *)theEvent
{
	NSString * charactersIgnoringModifiers = [theEvent charactersIgnoringModifiers];
	if([charactersIgnoringModifiers length])
	{
		charactersIgnoringModifiers = [charactersIgnoringModifiers substringToIndex:1];
		unichar uchar = [charactersIgnoringModifiers characterAtIndex:0];
		if(uchar>='a' && uchar<='z')
		{
			charactersIgnoringModifiers = [charactersIgnoringModifiers uppercaseString];
		}
		uchar = [charactersIgnoringModifiers characterAtIndex:0];
		unsigned int modifierFlags = [theEvent modifierFlags];
		if((uchar == '\r' || uchar == '\n' || uchar == 3) && !(modifierFlags&NSDeviceIndependentModifierFlagsMask))
		{
			// please register the good thing!
			// it is automagically done by binding
			[super keyDown:theEvent];
			return;
		}
		NSString * codeName = [KCC nameForKeyCode:uchar];
		iTM2MacroTreeController * SMTC = [iTM2MacroTreeController sharedMacroTreeController];
		id selection = [SMTC selection];
		iTM2MacroKeyStroke * MKS = [[[iTM2MacroKeyStroke alloc] initWithCodeName:codeName] autorelease];
		MKS->isShift = (modifierFlags & NSShiftKeyMask)>0;
		MKS->isControl = (modifierFlags & NSControlKeyMask)>0;
		MKS->isCommand = (modifierFlags & NSCommandKeyMask)>0;
		MKS->isAlternate = (modifierFlags & NSAlternateKeyMask)>0;
		[selection setValue:MKS forKey:@"macroKeyStroke"];
		[SMC setMacroKeyCodes:nil];
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
	float w1 = [TC1 width];
	NSTableColumn * TC2 = [self tableColumnWithIdentifier:@"Key"];
	float w2 = [TC2 width];
//	NSTableColumn * TC3 = [self tableColumnWithIdentifier:@"ID"];
//	float w3 = [TC3 width];
	if(W<w1+w2)
	{
		// the Key column is not visible, assuming the is scrolled to the most left part
		if(W>w2)
		{
			W -= w2;
			[TC1 setWidth:W];
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
Version history: jlaurens AT users.sourceforge.net
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
			NSTableColumn * CTC = [self outlineTableColumn];
			if([CTC isEqual:clickedTableColumn])
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
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
	int keyColumn = [self columnWithIdentifier:@"Key"];
	if(keyColumn == column)
	{
		// trick to see if the currently selected item is expandable
		// I am missing a better exposes API for that purpose
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
		// It is not possible to catch all the events because it is not like in a mouse down/drag operation
		// there is a problem of windows not ordering front (at least) when we switch apps
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
- (void)expandItem:(id)item expandChildren:(BOOL)expandChildren;
{
	NSTableColumn * CTC = [self outlineTableColumn];
	float oldWidth =  [CTC width];
	[super expandItem:item expandChildren:expandChildren];
	[CTC setWidth:oldWidth];
	[self sizeToFit];
	return;
}
- (void)collapseItem:(id)item collapseChildren:(BOOL)collapseChildren;
{
	NSTableColumn * CTC = [self outlineTableColumn];
	float oldWidth =  [CTC width];
	[super collapseItem:item collapseChildren:collapseChildren];
	[CTC setWidth:oldWidth];
	[self sizeToFit];
	return;
}
@end

#import <iTM2Foundation/iTM2PreferencesKit.h>
#import <iTM2Foundation/iTeXMac2.h>

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
#if 0
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
#endif
#pragma mark =-=-=-=-=-  OUTLINE VIEW DELEGATE
// may be we should use bindings instead of delegation
// unfortunately, bindings are opaque
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
{
	NSOutlineView * OLV = [notification object];
	NSTableColumn * TC = [OLV tableColumnWithIdentifier:@"Key"];
	NSTableView * TV = [TC tableView];
	NSLog(@"%i",[TV selectedRowIndexes]);
}
#if 0
// all these methods tend to catch the first column size change
// the first column will not be able to change its witdh
- (void)outlineViewItemWillExpand:(NSNotification *)notification;
{
	return;
}
- (void)outlineViewItemDidExpand:(NSNotification *)notification;
{
	return;
}
- (void)outlineViewItemWillCollapse:(NSNotification *)notification;
{
	return;
}
- (void)outlineViewItemDidCollapse:(NSNotification *)notification;
{
	return;
}
#endif
@end

#pragma mark -
@implementation iTM2MacroTreeController

+ (void)initialize
{
	[super initialize];
    iTM2PrettyNameOfKeyCodeTransformer *transformer = [[[iTM2PrettyNameOfKeyCodeTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:transformer forName:@"iTM2PrettyNameOfKeyCode"];
    iTM2PrettyNamesOfKeyCodesTransformer *transformers = [[[iTM2PrettyNamesOfKeyCodesTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:transformers forName:@"iTM2PrettyNamesOfKeyCodes"];
	return;
}

static id _iTM2MacroTreeController = nil;

+ (id)sharedMacroTreeController;
{
	return _iTM2MacroTreeController?:( _iTM2MacroTreeController = [[self alloc] init]);
}

- (id)init;
{
	if(self == _iTM2MacroTreeController)
	{
		return self;
	}
	else if(_iTM2MacroTreeController)
	{
		[self dealloc];
		return [_iTM2MacroTreeController retain];
	}
	else if(self = [super init])
	{
		// nothing to do yet
	}
	return _iTM2MacroTreeController = self;
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	if(self == _iTM2MacroTreeController)
	{
		return self;
	}
	else if(_iTM2MacroTreeController)
	{
		[self dealloc];
		return [_iTM2MacroTreeController retain];
	}
	else if(self = [super initWithCoder:aDecoder])
	{
		// nothing to do yet
	}
	return _iTM2MacroTreeController = self;
}
- (void)awakeFromNib;
{// the + button is not up to date, force the UI widget bound to canInsert to be updated
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

@implementation iTM2PrettyNamesOfKeyCodesTransformer
+ (Class)transformedValueClass { return [NSArray class]; }
+ (BOOL)allowsReverseTransformation { return YES; }
- (id)transformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * transformedValue = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		id N = nil;
		while(N = [E nextObject])
		{
			[transformedValue addObject:([N isKindOfClass:[NSNull class]]?(id)N:
				([KCC localizedNameForCodeName:N]?:(id)[NSNull null]))];
		}
		return transformedValue;
	}
    return nil;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * reverseTransformedValue = [NSMutableArray array];
		NSEnumerator * e = [value objectEnumerator];
		NSString * name = nil;
		while(name = [e nextObject])
		{
			NSEnumerator * E = [[SMC macroKeyCodes] objectEnumerator];
			NSNumber * N = nil;
			while(N = [E nextObject])
			{
				if([name isEqual:[SMC prettyNameForKeyCodeNumber:N]])
				{
					[reverseTransformedValue addObject:N];
					break;
				}
			}
		}
	}
    return nil;
}
@end

@implementation iTM2PrettyNameOfKeyCodeTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }
- (id)transformedValue:(id)value;
{
	if([value isKindOfClass:[NSNumber class]])
	{
		return [SMC prettyNameForKeyCodeNumber:value];
	}
    return nil;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSString class]])
	{
		NSEnumerator * E = [[SMC macroKeyCodes] objectEnumerator];
		NSNumber * N = nil;
		while(N = [E nextObject])
		{
			if([value isEqual:[SMC prettyNameForKeyCodeNumber:N]])
			{
				return N;
			}
		}
	}
    return nil;
}
@end

@implementation NSArray(MacroPrefPane)
- (NSNumber *)countNumber;
{
	return [NSNumber numberWithInt:[self count]];
}
@end

@interface iTM2KeyTableColumnController: NSObject
{
	id tableColumn;
}
@end

@implementation iTM2KeyTableColumnController

@end