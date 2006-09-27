/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2TeXFoundation/iTM2TeXStyleEditionKit.h>
#import <iTM2TeXFoundation/iTM2TeXStorageKit.h>

#define iTM2TSSMenuItemIndentationLevel [self contextIntegerForKey:@"iTM2TextSyntaxStyleMenuItemIndentationLevel"]
#define TABLE @"TextStyle"
#define BUNDLE [iTM2TeXParserAttributesInspector classBundle]

NSString * const iTM2StyleSymbolsPboardType = @"iTM2StyleSymbolsPboardType";

NSString * const iTM2TeXParserAttributesInspectorType = @"iTM2TeXParserAttributes";

@implementation iTM2TeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXParserAttributesInspectorType;
}
@end

NSString * const iTM2TextAttributesCharacterAttributeName = @"iTM2Character";
NSString * const iTM2TextAttributesModesIdentifier = @"modes";
NSString * const iTM2TextAttributesSymbolsIdentifier = @"symbols";
NSString * const iTM2TextAttributesSymbolIdentifier = @"symbol";
NSString * const iTM2TextAttributesCommandIdentifier = @"command";

@implementation iTM2TeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2TextSyntaxParserAttributesInspector";
}
@end

#import <iTM2Foundation/iTM2KeyBindingsKit.h>
//#import <iTM2Foundation/iTM2CompatibilityChecker.h>

NSString * const iTM2XtdTeXParserSymbolsInspectorMode = @".iTM2XtdTeXParserSymbols";
NSString * const iTM2XtdTeXParserAttributesInspectorType = @"iTM2XtdTeXParserAttributes";

@implementation iTM2XtdTeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdTeXParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    id WC;
    while(WC = [E nextObject])
        if([[[WC class] inspectorMode] isEqualToString:iTM2DefaultInspectorMode])
		{
			while(WC = [E nextObject])
				if([[[WC class] inspectorMode] isEqualToString:iTM2XtdTeXParserSymbolsInspectorMode])
					return;
			[self  inspectorAddedWithMode:iTM2XtdTeXParserSymbolsInspectorMode];
			return;
		}
		else if([[[WC class] inspectorMode] isEqualToString:iTM2XtdTeXParserSymbolsInspectorMode])
		{
			while(WC = [E nextObject])
				if([[[WC class] inspectorMode] isEqualToString:iTM2DefaultInspectorMode])
					return;
			[self  inspectorAddedWithMode:iTM2DefaultInspectorMode];
			return;
		}
	if(![self inspectorAddedWithMode:iTM2DefaultInspectorMode])
	{
		iTM2_LOG(@".........  Code inconsistency 1, report bug");
	}
	if(![self inspectorAddedWithMode:iTM2XtdTeXParserSymbolsInspectorMode])
	{
		iTM2_LOG(@".........  Code inconsistency 2, report bug");
	}
//iTM2_END;
    return;
}
@end

@implementation iTM2XtdTeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdTeXParserAttributesInspectorType;
}
@end

@implementation iTM2XtdTeXParserSymbolsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdTeXParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdTeXParserSymbolsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2XtdTeXParserSymbolsInspector";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithWindow:window])
    {
        [_BuiltInSymbolsSets autorelease];
        _BuiltInSymbolsSets = [[NSMutableDictionary dictionary] retain];
        [_NetworkSymbolsSets autorelease];
        _NetworkSymbolsSets = [[NSMutableDictionary dictionary] retain];
        [_LocalSymbolsSets autorelease];
        _LocalSymbolsSets = [[NSMutableDictionary dictionary] retain];
        [_CustomSymbolsSets autorelease];
        _CustomSymbolsSets = [[NSMutableDictionary dictionary] retain];
        [_CustomObjectsSets autorelease];
        _CustomObjectsSets = [[NSMutableDictionary dictionary] retain];
        [_CustomKeysSets autorelease];
        _CustomKeysSets = [[NSMutableDictionary dictionary] retain];
        [_EditedObjectsSets autorelease];
        _EditedObjectsSets = [[NSMutableDictionary dictionary] retain];
        [_RecycleSymbolsSets autorelease];
        _RecycleSymbolsSets = [[NSMutableDictionary dictionary] retain];
        [_AllSymbolsSets autorelease];
        _AllSymbolsSets = [[NSMutableDictionary dictionary] retain];
    }
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    [_BuiltInSymbolsSets autorelease];
    _BuiltInSymbolsSets = nil;
    [_NetworkSymbolsSets autorelease];
    _NetworkSymbolsSets = nil;
    [_LocalSymbolsSets autorelease];
    _LocalSymbolsSets = nil;
    [_CustomSymbolsSets autorelease];
    _CustomSymbolsSets = nil;
    [_RecycleSymbolsSets autorelease];
    _RecycleSymbolsSets = nil;
    [_CustomObjectsSets autorelease];
    _CustomObjectsSets = nil;
    [_CustomKeysSets autorelease];
    _CustomKeysSets = nil;
    [_EditedObjectsSets autorelease];
    _EditedObjectsSets = nil;
    [_AllSymbolsSets autorelease];
    _AllSymbolsSets = nil;
    [super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentSets
- (NSMutableDictionary *)currentSets;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[_CurrentSetItem representedObject] objectForKey:@"S"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentSetKey
- (NSString *)currentSetKey;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * result = [[_CurrentSetItem representedObject] objectForKey:@"K"];
    return [result length]? result: @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;
/*"For the revert to saved.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = YES;
#warning ERROR
    [_CustomObjectsSets autorelease];
    _CustomObjectsSets = [[NSMutableDictionary dictionary] retain];
    [_CustomKeysSets autorelease];
    _CustomKeysSets = [[NSMutableDictionary dictionary] retain];
    [_EditedObjectsSets autorelease];
    _EditedObjectsSets = [[NSMutableDictionary dictionary] retain];
    [_RecycleSymbolsSets autorelease];
    _RecycleSymbolsSets = [[NSMutableDictionary dictionary] retain];

    NSMutableDictionary * allSymbols = [NSMutableDictionary dictionary];
    
    // [self document] must exists!!
	Class syntaxParserClass = [[[self document] class] syntaxParserClass];

	NSString * style = [syntaxParserClass syntaxParserStyle];
	NSString * variant = [(iTM2TextSyntaxParserAttributesDocument *)[self document] syntaxParserVariant];// lowercase string?
    NSString * variantComponent = [variant stringByAppendingPathExtension:iTM2TextVariantExtension];

	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSEnumerator * E = [[[syntaxParserClass attributesServerClass] builtInStylePaths] objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
//iTM2_LOG(@"Reading built in symbols at path %@", stylePath);
		BOOL isDir = NO;
		NSString * stylePath = [[path stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
		if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
		{
			NSEnumerator * e = [[DFM directoryContentsAtPath:stylePath] objectEnumerator];
			NSString * p;
			while(p = [e nextObject])
				if([[p pathExtension] isEqualToString:iTM2TextAttributesSymbolsExtension])
				{
					NSString * key = [p stringByDeletingPathExtension];
					NSString * path = [stylePath stringByAppendingPathComponent:p];
//iTM2_LOG(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfFile:path];
					[MD setObject:symbolsAttributes forKey:key];
					[allSymbols addEntriesFromDictionary:symbolsAttributes];
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Ignoring path while reading symbols sets: %@", p);
				}            
		}
		else
		{
			NSLog(@"No symbols sets at path %@", stylePath);
		}
	}
	[_BuiltInSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];
	
    // loading the sets from the network
    E = [[[NSBundle mainBundle] pathsForResource:style ofType:iTM2TextStyleExtension inDirectory:iTM2TextStyleComponent domains:NSNetworkDomainMask] objectEnumerator];
	while(path = [E nextObject])
	{
		BOOL isDir = NO;
		NSString * stylePath = [[path stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
		if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
		{
			NSEnumerator * e = [[DFM directoryContentsAtPath:stylePath] objectEnumerator];
			NSString * p;
			while(p = [e nextObject])
				if([[p pathExtension] isEqualToString:iTM2TextAttributesSymbolsExtension])
				{
					NSString * key = [p stringByDeletingPathExtension];
					NSString * path = [stylePath stringByAppendingPathComponent:p];
//iTM2_LOG(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfFile:path];
					[MD setObject:symbolsAttributes forKey:key];
					[allSymbols addEntriesFromDictionary:symbolsAttributes];
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Ignoring path while reading symbols sets: %@", p);
				}            
		}
		else
		{
			NSLog(@"No symbols sets at path %@", stylePath);
		}
	}
    [_NetworkSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];

    // loading the sets from the local domain
	E = [[[NSBundle mainBundle] pathsForResource:style ofType:iTM2TextStyleExtension inDirectory:iTM2TextStyleComponent domains:NSLocalDomainMask] objectEnumerator];
	while(path = [E nextObject])
	{
		BOOL isDir = NO;
		NSString * stylePath = [[path stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
		if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
		{
			NSEnumerator * e = [[DFM directoryContentsAtPath:stylePath] objectEnumerator];
			NSString * p;
			while(p = [e nextObject])
				if([[p pathExtension] isEqualToString:iTM2TextAttributesSymbolsExtension])
				{
					NSString * key = [p stringByDeletingPathExtension];
					NSString * path = [stylePath stringByAppendingPathComponent:p];
//iTM2_LOG(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfFile:path];
					[MD setObject:symbolsAttributes forKey:key];
					[allSymbols addEntriesFromDictionary:symbolsAttributes];
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Ignoring path while reading symbols sets: %@", p);
				}            
		}
		else
		{
			NSLog(@"No symbols sets at path %@", stylePath);
		}
	}
    [_LocalSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];
    
    // loading the sets from the user domain
	E = [[[NSBundle mainBundle] pathsForSupportResource:style ofType:iTM2TextStyleExtension inDirectory:iTM2TextStyleComponent domains:NSUserDomainMask] objectEnumerator];
	while(path = [E nextObject])
	{
		BOOL isDir = NO;
		NSString * stylePath = [[path stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
		if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
		{
			NSEnumerator * e = [[DFM directoryContentsAtPath:stylePath] objectEnumerator];
			NSString * p;
			while(p = [e nextObject])
				if([[p pathExtension] isEqualToString:iTM2TextAttributesSymbolsExtension])
				{
					NSString * key = [p stringByDeletingPathExtension];
					NSString * path = [stylePath stringByAppendingPathComponent:p];
//iTM2_LOG(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfFile:path];
					[MD setObject:symbolsAttributes forKey:key];
					[allSymbols addEntriesFromDictionary:symbolsAttributes];
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Ignoring path while reading symbols sets: %@", p);
				}            
		}
		else
		{
			NSLog(@"No symbols sets at path %@", stylePath);
		}
	}
    [_CustomSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];

	[_AllSymbolsSets setObject:allSymbols forKey:@"K"];
    [self validateWindowContent];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fileName is: %@", fileName);
    // loading the built in symbols sets
    BOOL success = YES;
	// recycling all necessary sets.
	NSEnumerator * E = [_RecycleSymbolsSets keyEnumerator];
	NSString * CSK;
	NSString * fileName = [absoluteURL path];
	while(CSK = [E nextObject])
	{
		int tag;
		NSString * lastPathComponent = [CSK stringByAppendingPathExtension:iTM2TextAttributesSymbolsExtension];
		NSString * fullPath = [fileName stringByAppendingPathComponent:lastPathComponent];
//iTM2_LOG(@"RECYCLING FILE AT PATH: %@", fullPath);
		success = success
			&& (![DFM fileExistsAtPath:fullPath]
				|| [SWS performFileOperation: NSWorkspaceRecycleOperation
						source: fileName
							destination: nil
								files: [NSArray arrayWithObject:lastPathComponent]
									tag: &tag]);
	}
	[_RecycleSymbolsSets autorelease];
	_RecycleSymbolsSets = [[NSMutableDictionary dictionary] retain];
	// saving the other sets.
	NSTextView * TV = [[[NSTextView allocWithZone:[self zone]] initWithFrame:NSMakeRect(0,0,1e7,1e7)] autorelease];
	NSLayoutManager * LM = [TV layoutManager];
	NSTextStorage * TS = [LM textStorage];
	E = [_CustomSymbolsSets keyEnumerator];
	while(CSK = [E nextObject])
	{
//iTM2_LOG(@"CSK: %@", CSK);
		NSEnumerator * EE = [[_CustomKeysSets objectForKey:CSK] objectEnumerator];
        // if no EE is available, it means that the set has not been edited:
        // nothing needs to be saved...
        if(EE)
        {
//iTM2_LOG(@"Something needs to be saved:");
            NSMutableDictionary * DOs = [NSMutableDictionary dictionary];
            NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
            NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
            NSString * command;
            while(command = [EE nextObject])
            {
//iTM2_LOG(@"command: %@", command);
                NSAttributedString * AS = [_EOs objectForKey:command]?:[_Os objectForKey:command];
                if([AS length])
                {
                    id As = [AS attributesAtIndex:0 effectiveRange:nil];
                    NSFont * F = [As objectForKey:NSFontAttributeName]?:[NSFont systemFontOfSize:[NSFont systemFontSize]];
                    [TS beginEditing];
                    [TS setAttributedString:AS];
                    [TS endEditing];
                    NSGlyphInfo * GI = [NSGlyphInfo glyphInfoWithGlyph:[LM glyphAtIndex:0] forFont:F baseString:command];
                    if(GI)
                    {
                        id attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                F, NSFontAttributeName,
                                            GI, NSGlyphInfoAttributeName,
                                        [AS string], iTM2TextAttributesCharacterAttributeName,
                                    [AS attribute:iTM2Text2ndSymbolColorAttributeName atIndex:0 effectiveRange:nil],
                                                iTM2Text2ndSymbolColorAttributeName,
                            nil];
                        NSColor * C = [As objectForKey:NSForegroundColorAttributeName];
                        if(![[NSColor controlTextColor] isEqual:C])
						{
							if(C)
								[attributes setObject:C forKey:NSForegroundColorAttributeName];
							else
								[attributes removeObjectForKey:NSForegroundColorAttributeName];
						}
                        [DOs setObject:attributes forKey:command];
						if(AS)
							[_Os setObject:AS forKey:command];
						else
							[_Os removeObjectForKey:command];
                    }
                }
            }
            [_EditedObjectsSets setObject:[NSMutableDictionary dictionary] forKey:CSK];
    //iTM2_LOG(@"SAVING %@", DOs);
            NSString * lastPathComponent = [CSK stringByAppendingPathExtension:iTM2TextAttributesSymbolsExtension];
            NSString * fullPath = [fileName stringByAppendingPathComponent:lastPathComponent];
            success = [iTM2XtdTeXParserAttributesServer writeSymbolsAttributes:DOs toFile:fullPath];
//iTM2_LOG(@"WRITING\n%@\nAT PATH:\n%@", DOs, fullPath);
        }
    }
    if(success)
        [self readFromURL:absoluteURL ofType:typeName error:outError];
    return success;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowWillLoad];
    [self setWindowFrameAutosaveName:NSStringFromClass(isa)];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    NSCell * C = [[tableView tableColumnWithIdentifier:iTM2TextAttributesSymbolIdentifier] dataCell];
    [C setAllowsEditingTextAttributes:YES];
    [C setImportsGraphics:YES];
    [[self window] setDelegate:self];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent
- (BOOL)validateWindowContent;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super validateWindowContent];
    NSString * CSK = [self currentSetKey];
    if([CSK length] && ![_CustomKeysSets objectForKey:CSK])
    {
        NSMutableDictionary * _Os = [NSMutableDictionary dictionary];
        [_CustomObjectsSets setObject:_Os forKey:CSK];
        NSMutableDictionary * _EOs = [NSMutableDictionary dictionary];
        [_EditedObjectsSets setObject:_EOs forKey:CSK];
        NSDictionary * symbolsAttributes = [[self currentSets] objectForKey:[self currentSetKey]];
        [_CustomKeysSets setObject: [NSMutableArray arrayWithArray:
            [[symbolsAttributes allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]]
                forKey: CSK];
//iTM2_LOG(@"_CustomKeysSets is: %@", _CustomKeysSets);
        float rowHeight = 15;
        NSEnumerator * E = [symbolsAttributes keyEnumerator];
        NSString * K;
        while(K = [E nextObject])
        {
            NSMutableDictionary * symbolAttributes = [symbolsAttributes objectForKey:K];
            if([symbolAttributes isKindOfClass:[NSDictionary class]]
                && [symbolAttributes objectForKey:NSGlyphInfoAttributeName])
            {
                NSString * S = [symbolAttributes objectForKey:iTM2TextAttributesCharacterAttributeName]?: @"-";
                NSMutableAttributedString * MAS = [[[NSMutableAttributedString allocWithZone:[self zone]]
                                initWithString: S attributes: symbolAttributes] autorelease];
                rowHeight = MAX(rowHeight, [MAS size].height);
                NSColor * symbolColor = [symbolAttributes objectForKey:iTM2Text2ndSymbolColorAttributeName];
                NSColor * replacementColor = symbolColor && [symbolColor alphaComponent]>0?
                    [[symbolColor colorWithAlphaComponent:1] blendedColorWithFraction:1 - [symbolColor alphaComponent]
                                        ofColor: [NSColor textColor]]:
                        [NSColor textColor];
                [MAS addAttribute: NSForegroundColorAttributeName value: replacementColor
                    range: NSMakeRange(0, [MAS length])];
                [_Os setObject:MAS forKey:K];
            }
        }
        [tableView setRowHeight:rowHeight];
    }
    [tableView reloadData];
    if([tableView numberOfSelectedRows]==1)
    {
        NSMutableAttributedString * MAS = [self symbolAtRow:[tableView selectedRow]];
        if([MAS length])
        {
            NSFont * oldF = [MAS attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            NSFont * F = [[NSFontManager sharedFontManager] convertFont:oldF];
            [[NSFontManager sharedFontManager] setSelectedFont:F isMultiple:NO];
        }
    }
//iTM2_END;
    return [addSetPanel validateContent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:
        NSLocalizedStringFromTableInBundle(@"%@ - Symbols", TABLE, BUNDLE, "Comment forthcoming"),
        displayName];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setChosen:
- (IBAction)setChosen:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id newItem = [sender selectedItem];
    if(_CurrentSetItem != newItem)
    {
        _CurrentSetItem = newItem;
        [self validateWindowContent];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSetChosen:
- (BOOL)validateSetChosen:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static BOOL firstTime = YES;
    static id customSetMenuItem;
    static id localSetMenuItem;
    static id networkSetMenuItem;
    static id builtInSetMenuItem;
    static id recycleSetMenuItem;
    static id allSymbolsMenuItem;
    if(firstTime)
    {
        firstTime = NO;
        NSMenuItem * MI = [[sender menu] itemWithTag:1];
        if([MI respondsToSelector:@selector(copy)])
            customSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[[sender menu] itemWithTag:2];
        if([MI respondsToSelector:@selector(copy)])
            localSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[[sender menu] itemWithTag:3];
        if([MI respondsToSelector:@selector(copy)])
            networkSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[[sender menu] itemWithTag:4];
        if([MI respondsToSelector:@selector(copy)])
            builtInSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[[sender menu] itemWithTag:5];
        if([MI respondsToSelector:@selector(copy)])
            recycleSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[[sender menu] itemWithTag:6];
        if([MI respondsToSelector:@selector(copy)])
            allSymbolsMenuItem = [MI copy];
    }
    NSFont * italic = [SFM convertFont:[NSFont fontWithName:@"Helvetica" size:[NSFont systemFontSize]]
        toHaveTrait: NSItalicFontMask];
//iTM2_LOG(@"italic is: %@", italic);
    if(!_CurrentSetItem)
    {
        [sender removeAllItems];
        int indentationLevel = iTM2TSSMenuItemIndentationLevel;
        if([_BuiltInSymbolsSets count])
        {
            if(builtInSetMenuItem)
            {
                [[sender menu] addItem:[[builtInSetMenuItem copy] autorelease]];
                id lastItem = [sender lastItem];
                [lastItem setAction:@selector(noop:)];
                [lastItem setTarget:self];
                [lastItem setEnabled:NO];
                [lastItem setState:NSOffState];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = 0;
            NSEnumerator * E = [[[_BuiltInSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] objectEnumerator];
            NSString * key;
            while(key = [E nextObject])
            {
                id lastItem = [[[NSMenuItem allocWithZone:[self zone]] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                [lastItem setRepresentedObject:
                    [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _BuiltInSymbolsSets, @"S", nil]];
                [lastItem setTarget:self];
				[lastItem setIndentationLevel:indentationLevel];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [[sender menu] addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    || !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if([_NetworkSymbolsSets count])
        {
            if(networkSetMenuItem)
            {
                [[sender menu] addItem:[[networkSetMenuItem copy] autorelease]];
                id lastItem = [sender lastItem];
                [lastItem setAction:@selector(noop:)];
                [lastItem setTarget:self];
                [lastItem setEnabled:NO];
                [lastItem setState:NSOffState];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = 0;
            NSEnumerator * E = [[[_NetworkSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] objectEnumerator];
            NSString * key;
            while(key = [E nextObject])
            {
                id lastItem = [[[NSMenuItem allocWithZone:[self zone]] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                [lastItem setRepresentedObject:
                    [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _NetworkSymbolsSets, @"S", nil]];
                [lastItem setTarget:self];
				[lastItem setIndentationLevel:indentationLevel];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [[sender menu] addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    && !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if([_LocalSymbolsSets count])
        {
            if(localSetMenuItem)
            {
                [[sender menu] addItem:[[localSetMenuItem copy] autorelease]];
                id lastItem = [sender lastItem];
                [lastItem setAction:@selector(noop:)];
                [lastItem setTarget:self];
                [lastItem setEnabled:NO];
                [lastItem setState:NSOffState];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = 0;
            NSEnumerator * E = [[[_LocalSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] objectEnumerator];
            NSString * key;
            while(key = [E nextObject])
            {
                id lastItem = [[[NSMenuItem allocWithZone:[self zone]] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                [lastItem setRepresentedObject:
                    [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _LocalSymbolsSets, @"S", nil]];
                [lastItem setTarget:self];
				[lastItem setIndentationLevel:indentationLevel];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [[sender menu] addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    && !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if([_CustomSymbolsSets count])
        {
            if(customSetMenuItem)
            {
                [[sender menu] addItem:[[customSetMenuItem copy] autorelease]];
                id lastItem = [sender lastItem];
                [lastItem setAction:@selector(noop:)];
                [lastItem setTarget:self];
                [lastItem setEnabled:NO];
                [lastItem setState:NSOffState];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = 0;
            NSEnumerator * E = [[[_CustomSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] objectEnumerator];
            NSString * key;
            while(key = [E nextObject])
            {
                id lastItem = [[[NSMenuItem allocWithZone:[self zone]] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                [lastItem setRepresentedObject:
                    [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _CustomSymbolsSets, @"S", nil]];
                [lastItem setTarget:self];
				[lastItem setIndentationLevel:indentationLevel];
                [[sender menu] addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    && !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if([_RecycleSymbolsSets count])
        {
            if(recycleSetMenuItem)
            {
                [[sender menu] addItem:[[recycleSetMenuItem copy] autorelease]];
                id lastItem = [sender lastItem];
                [lastItem setAction:@selector(noop:)];
                [lastItem setTarget:self];
                [lastItem setEnabled:NO];
                [lastItem setState:NSOffState];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = 0;
            NSEnumerator * E = [[[_RecycleSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)] objectEnumerator];
            NSString * key;
            while(key = [E nextObject])
            {
                id lastItem = [[[NSMenuItem allocWithZone:[self zone]] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                [lastItem setRepresentedObject:
                    [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _RecycleSymbolsSets, @"S", nil]];
                [lastItem setTarget:self];
				[lastItem setIndentationLevel:indentationLevel];
                [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                    initWithString: [lastItem title]
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [[sender menu] addItem:lastItem];
            }
        }
        if([_AllSymbolsSets count] && allSymbolsMenuItem)
        {
            [[sender menu] addItem:[[allSymbolsMenuItem copy] autorelease]];
            id lastItem = [sender lastItem];
            [lastItem setAction:@selector(chooseSet:)];
            [lastItem setTarget:self];
            [lastItem setRepresentedObject:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"K", @"K", _AllSymbolsSets, @"S", nil]];
            [lastItem setState:NSOffState];
            [lastItem setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
                initWithString: [lastItem title]
                    attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
			if(!_CurrentSetItem)
				_CurrentSetItem = lastItem;
        }
    }
    [sender selectItem:_CurrentSetItem];
    [[sender menu] update];
//iTM2_END;
    return YES;//[sender numberOfItems] > 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseSet:
- (IBAction)chooseSet:(id)sender;
/*"Message sent from menu items.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_CurrentSetItem != sender)
    {
        _CurrentSetItem = sender;
        [self validateWindowContent];
    }
//iTM2_END;
    return;
}
NSString * _iTM2PRIVATE_NewSetName = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSet:
- (void)addSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self performSelector:@selector(_addSet:) withObject:sender afterDelay:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _addSet:
- (IBAction)_addSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateWindowContent];
    if(![[self window] attachedSheet])
    {
        [NSApp beginSheet: addSetPanel
                modalForWindow: [self window]
                modalDelegate: self
                didEndSelector: @selector(addSetSheetDidEnd:returnCode:contextInfo:)
                contextInfo: nil];
    }
    else
    {
        iTM2_LOG(@"There is already a sheet attached to this window...");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetSheetDidEnd:returnCode:contextInfo:
- (void)addSetSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sheet orderOut:self];
    if((returnCode == NSAlertDefaultReturn) && [_iTM2PRIVATE_NewSetName length])
    {
        NSString * name = [_iTM2PRIVATE_NewSetName autorelease];
        _iTM2PRIVATE_NewSetName = nil;
        if(![_CustomSymbolsSets objectForKey:name])
        {
            [_CustomSymbolsSets setObject:[NSMutableDictionary dictionary] forKey:name];
            [[self document] updateChangeCount:NSChangeDone];
        }
		// we would want to select the menu item of the newly created set, assuming that we are going to edit it.
		// force the validation: the menu items will be created from scratch,
		_CurrentSetItem = nil;
		[self validateWindowContent];
		// normally the "all symbols" menu item should be selected.
		if(_CurrentSetItem)
		{
			id RO = [NSDictionary dictionaryWithObjectsAndKeys:name, @"K", _CustomSymbolsSets, @"S", nil];
			NSEnumerator * E = [[[_CurrentSetItem menu] itemArray] objectEnumerator];
			NSMenuItem * MI;
			while(MI = [E nextObject])
				if([RO isEqual:[MI representedObject]])
				{
					_CurrentSetItem = MI;
					// now we know what menu item should be selected.
					[self validateWindowContent];
					[[tableView window] makeFirstResponder:tableView];
					break;
				}
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetOk:
- (IBAction)addSetOk:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // What is the current style?
    // Sheet is up here.
    [NSApp endSheet:[sender window] returnCode:NSAlertDefaultReturn];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetCancel:
- (IBAction)addSetCancel:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_iTM2PRIVATE_NewSetName autorelease];
    _iTM2PRIVATE_NewSetName = nil;
    [NSApp endSheet:[sender window] returnCode:NSAlertAlternateReturn];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetTitleEdited:
- (IBAction)addSetTitleEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAddSetTitleEdited:
- (BOOL)validateAddSetTitleEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Add a symbols set to style %@", TABLE, BUNDLE, "Comment forthcoming"), [[[[self document] class] syntaxParserClass] prettySyntaxParserStyle]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetNameEdited:
- (IBAction)addSetNameEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG([sender stringValue]);
    [_iTM2PRIVATE_NewSetName autorelease];
    _iTM2PRIVATE_NewSetName = [[sender stringValue] copy];
    _CurrentSetItem = nil;
    [self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSet:
- (IBAction)removeSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSBeginInformationalAlertSheet(
        NSLocalizedStringFromTableInBundle(@"Remove set", TABLE, BUNDLE, "Comment forthcoming"),
        NSLocalizedStringFromTableInBundle(@"OK", TABLE, BUNDLE, "Comment forthcoming"),
        NSLocalizedStringFromTableInBundle(@"Cancel", TABLE, BUNDLE, "Comment forthcoming"),
        nil,
        [sender window],
        self,
        @selector(removeSetSheetDidEnd:returnCode:recycleSet:),
        NULL,
        [self currentSetKey],
        NSLocalizedStringFromTableInBundle(@"Remove symbols set %@?", TABLE, BUNDLE, "Comment forthcoming"),
        [_CurrentSetItem title]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSetSheetDidEnd:returnCode:recycleSet:
- (void)removeSetSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode recycleSet:(NSString *)name;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(returnCode == NSAlertDefaultReturn)
    {
        if(([self currentSets] == _CustomSymbolsSets) && [name length])
        {
            [_RecycleSymbolsSets setObject:[_CustomSymbolsSets objectForKey:name] forKey:name];
            [_CustomSymbolsSets removeObjectForKey:name];
            _CurrentSetItem = nil;
            [[self document] updateChangeCount:NSChangeDone];
//iTM2_LOG(@"[_RecycleSymbolsSets allKeys]: %@", [_RecycleSymbolsSets allKeys]);
//iTM2_LOG(@"[_CustomSymbolsSets allKeys]: %@", [_CustomSymbolsSets allKeys]);
			[self validateWindowContent];
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRemoveSet:
- (BOOL)validateRemoveSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([self currentSets] == _CustomSymbolsSets);
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  TABLEVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  symbolAtRow:
- (id)symbolAtRow:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * CSK = [self currentSetKey];
    NSArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    if((row >= 0) && (row < [_Ks count]))
    {
        NSString * K = [_Ks objectAtIndex:row];
        id result = [_EOs objectForKey:K];
        if(!result)
        {
            result = [_Os objectForKey:K];
            if(!result)
            {
                result = [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:@"?" attributes:[NSDictionary dictionaryWithObject:[NSColor magentaColor] forKey:NSForegroundColorAttributeName]] autorelease];
            }
        }
        if(![result isKindOfClass:[NSMutableAttributedString class]])
        {
            iTM2_LOG(@"CALAMITAS-CALAMITATIS");
        }
        return result;
    }
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[_CustomKeysSets objectForKey:[self currentSetKey]] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id identifier = [tableColumn identifier];
    if([identifier isEqualToString:iTM2TextAttributesCommandIdentifier])
    {
        return ((row >= 0) && (row < [self numberOfRowsInTableView:tv]))?
            [[_CustomKeysSets objectForKey:[self currentSetKey]] objectAtIndex:row]: nil;
    }
    else
    {
        return [self symbolAtRow:row];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:shouldEditTableColumn:row:
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
        return NO;
    if([[tableColumn identifier] isEqualToString:iTM2TextAttributesSymbolIdentifier])
    {
        NSMutableAttributedString * AS = [self symbolAtRow:row];
        if([AS length])
        {
            NSColor * C = [[AS attributesAtIndex:0 effectiveRange:nil] objectForKey:NSForegroundColorAttributeName];
            if(C)
                [[tableColumn dataCell] setTextColor:C];
        }
    }
    else
        [[tableColumn dataCell] setTextColor:[NSColor controlTextColor]];
//iTM2_LOG(@"CONTROL COLOR: %@", [tableColumn identifier]);
//iTM2_LOG(@"symbol path is: %@", [_CurrentSetItem representedObject]);
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SYMBOLS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSymbol:
- (IBAction)addSymbol:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self addSymbolInTableView:tableView];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSymbolInTableView:
- (void)addSymbolInTableView:(NSTableView *)tv;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
    {
		[self validateWindowContent];
        return;
    }
    NSString * CSK = [self currentSetKey];
    NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    int row = [_Ks indexOfObject:@"?"];
    if(row == NSNotFound)
    {
        row = [tv selectedRow];
        if((row<0) || (row >= [_Ks count]))
            row = 0;
        [_Ks insertObject:@"?" atIndex:row];
		id O = [self symbolAtRow:row];
		if(O)
			[_EOs setObject:[[O mutableCopy] autorelease] forKey:@"?"];
		else
			[_EOs removeObjectForKey:@"?"];
        [[self document] updateChangeCount:NSChangeDone];
        [tv reloadData];
    }
	[tv selectRow:row byExtendingSelection:NO];
    [self validateWindowContent];
    if([[tv window] makeFirstResponder:tv])
	{
#if 1
		SEL selector = @selector(editColumn:row:withEvent:select:);
		NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[tv methodSignatureForSelector:selector]];
		[invocation setTarget:tv];
		[invocation setSelector:selector];
		int column = [tv columnWithIdentifier:iTM2TextAttributesCommandIdentifier];
		[invocation setArgument: &column atIndex:2];
		[invocation setArgument: &row atIndex:3];
		id argument = nil;
		[invocation setArgument: &argument atIndex:4];
		BOOL flag = YES;
		[invocation setArgument: &flag atIndex:5];
		[NSTimer scheduledTimerWithTimeInterval:0 invocation:invocation repeats:NO];
#else
        [tv editColumn:[tv columnWithIdentifier:iTM2TextAttributesCommandIdentifier] row:row withEvent:nil select:YES];
#endif
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDuplicateSymbol:
- (BOOL)validateDuplicateSymbol:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([tableView numberOfSelectedRows] == 1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deleteSelectedSymbolsInTableView:
- (IBAction)deleteSelectedSymbolsInTableView:(NSTableView *)tv;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
    {
		[self validateWindowContent];
        return;
    }
    NSString * CSK = [self currentSetKey];
    NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    NSEnumerator * E = [[[tv selectedRowEnumerator] allObjects] reverseObjectEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
    {
        int row = [N intValue];
        if((row >= 0) && (row < [_Ks count]))
        {
            NSString * K = [_Ks objectAtIndex:row];
            [_Os removeObjectForKey:K];
            [_EOs removeObjectForKey:K];
            [_Ks removeObjectAtIndex:row];
            [[self document] updateChangeCount:NSChangeDone];
        }
    }
//    [tv reloadData];
    [self validateWindowContent];
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  COLOR MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertToFactoryColor:
- (IBAction)revertToFactoryColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SCP setColor:[[NSColor whiteColor] colorWithAlphaComponent:0]];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRevertToFactoryColor:
- (BOOL)validateRevertToFactoryColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
        return NO;
    NSEnumerator * E = [tableView selectedRowEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
        if([[self symbolAtRow:[N intValue]] attribute:iTM2Text2ndSymbolColorAttributeName atIndex:0 effectiveRange:nil])
            return YES;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleBackgroundColor:
- (IBAction)toggleBackgroundColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Background = !_Background;
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleBackgroundColor:
- (BOOL)validateToggleBackgroundColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: (_Background? NSOnState:NSOffState)];
//iTM2_END;
    return NO && ([self currentSets] == _CustomSymbolsSets);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)TV setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"HERE");
    NSString * CSK = [self currentSetKey];
    NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    if((row >= 0) && (row < [_Ks count]))
    {
        NSString * K = [_Ks objectAtIndex:row];
//iTM2_LOG(@"K: %@", K);
        if([[tableColumn identifier] isEqualToString:iTM2TextAttributesCommandIdentifier])
        {
            if(![_Ks containsObject:object])
            {
				id O = [_Os objectForKey:K];
                if(O)
					[_Os setObject:O forKey:object];
				else
					[_Os removeObjectForKey:object];
                [_Os removeObjectForKey:K];
                if(O = [_EOs objectForKey:K])
					[_EOs setObject:O forKey:object];
				else
					[_EOs removeObjectForKey:object];
                [_EOs removeObjectForKey:K];
                [_Ks removeObjectAtIndex:row];
                [_Ks addObject:object];
				[_Ks sortUsingSelector:@selector(compare:)];
                [[self document] updateChangeCount:NSChangeDone];
				[self validateWindowContent];
            }
            [TV reloadData];
        }
        else
        {
//iTM2_LOG(@"symbol");
            if(([object isKindOfClass:[NSAttributedString class]]) && ([(NSAttributedString *)object length] == 1))
            {
                NSAttributedString * old = [_Os objectForKey:K];
//iTM2_LOG(@"old: %@", old);
                NSDictionary * oldAttributes = [old length]? [old attributesAtIndex:0 effectiveRange:nil]: nil;
                NSDictionary * attributes = [object attributesAtIndex:0 effectiveRange:nil];
                if([[object string] isEqualToString:[old string]]
                    && [[oldAttributes objectForKey:NSFontAttributeName] isEqual:[attributes objectForKey:NSFontAttributeName]]
                        && [[oldAttributes objectForKey:NSForegroundColorAttributeName] isEqual:[attributes objectForKey:NSForegroundColorAttributeName]])
                {
                    [_EOs removeObjectForKey:K];
                }
                else
                {
                    [_EOs setObject:[[object mutableCopy] autorelease] forKey:K];
                    float rowHeight = [object size].height;
                    if(rowHeight > [TV rowHeight])
                        [TV setRowHeight:rowHeight];
                    [[self document] updateChangeCount:NSChangeDone];
					[self validateWindowContent];
//iTM2_LOG(@"The character? %x", [[object string] characterAtIndex:0]);
//iTM2_LOG(@"attributes? %@", [object attributesAtIndex:0 effectiveRange:nil]);
                }
            }
            else
            {
                iTM2_LOG(@"Ignoring? %@, %@", object, [object class]);
            }
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:changeFont:
- (void)tableView:(NSTableView *)TV changeFont:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
        return;
    NSEnumerator * E = [tableView selectedRowEnumerator];
    NSNumber * N;
    float rowHeight = [tableView rowHeight];
    BOOL isDocumentEdited = NO;
    while(N = [E nextObject])
    {
        NSMutableAttributedString * MAS = [self symbolAtRow:[N intValue]];
        if([MAS length])
        {
            NSFont * oldF = [MAS attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            NSFont * F = [sender convertFont:oldF];
            if([[F coveredCharacterSet] characterIsMember:[[MAS string] characterAtIndex:0]])
            {
                [MAS addAttribute:NSFontAttributeName value:F range:NSMakeRange(0, [MAS length])];
                rowHeight = MAX(rowHeight, [MAS size].height);
                isDocumentEdited = YES;
            }
            else if(oldF)// could not set the font, set the size at least...
            {
                [MAS addAttribute: NSFontAttributeName
                    value: [NSFont fontWithName:[oldF fontName] size:[F pointSize]]
                        range: NSMakeRange(0, [MAS length])];
                rowHeight = MAX(rowHeight, [MAS size].height);
                isDocumentEdited = YES;
            }
        }
    }
    if(isDocumentEdited)
    {
        [[self document] updateChangeCount:NSChangeDone];
        [self validateWindowContent];
    }
    [tableView setRowHeight:rowHeight];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:changeColor:
- (void)tableView:(NSTableView *)TV changeColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
    {
        [self validateWindowContent];
        return;
    }
    NSColor * newC = [sender color];
    if(newC && ![newC alphaComponent])
        newC = nil;
    NSEnumerator * E = [tableView selectedRowEnumerator];
    NSNumber * N;
    BOOL isDocumentEdited = NO;
    if(_Background)
    {
        while(N = [E nextObject])
        {
            NSMutableAttributedString * MAS = [self symbolAtRow:[N intValue]];
            NSColor * oldC = [MAS attribute:NSBackgroundColorAttributeName atIndex:0 effectiveRange:nil];
            if(![oldC isEqual:newC] && (oldC || newC))
            {
                NSRange R = NSMakeRange(0, [MAS length]);
                [MAS addAttribute:NSBackgroundColorAttributeName value:newC range:R];
                isDocumentEdited = YES;
            }
        }
    }
    else
    {
        while(N = [E nextObject])
        {
            NSMutableAttributedString * MAS = [self symbolAtRow:[N intValue]];
            NSColor * oldC = [MAS attribute:iTM2Text2ndSymbolColorAttributeName atIndex:0 effectiveRange:nil];
            if(![oldC isEqual:newC] && (oldC || newC))
            {
                NSRange R = NSMakeRange(0, [MAS length]);
                if(newC && [newC alphaComponent]>0)
                    [MAS addAttribute:iTM2Text2ndSymbolColorAttributeName value:newC range:R];
                else
                    [MAS removeAttribute:iTM2Text2ndSymbolColorAttributeName range:R];
                NSColor * replacementColor = newC && [newC alphaComponent]>0? [[newC colorWithAlphaComponent:1] blendedColorWithFraction:1 - [newC alphaComponent] ofColor:[NSColor textColor]]:[NSColor textColor];
                [MAS addAttribute:NSForegroundColorAttributeName value:replacementColor range:R];
                isDocumentEdited = YES;
            }
        }
    }
    if(isDocumentEdited)
    {
        [[self document] updateChangeCount:NSChangeDone];
        [self validateWindowContent];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRows:toPasteboard:
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray *)rows toPasteboard:(NSPasteboard *)pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * CSK = [self currentSetKey];
    NSArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableArray * MA = [NSMutableArray array];
    NSMutableAttributedString * MAS = [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:@"" attributes:nil] autorelease];
	[MAS beginEditing];
    NSEnumerator * E = [rows objectEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
    {
        int row = [N intValue];
        if((row>=0) && (row<[_Ks count]))
        {
            id O = [self symbolAtRow:row];
            if(O)
            {
                [MA addObject:[[[_Ks objectAtIndex:row] copy] autorelease]];
                [MA addObject:[[O copy] autorelease]];
				[[MAS mutableString] appendString:[_Ks objectAtIndex:row]];
				[MAS appendAttributedString:O];
            }
        }
    }
	[MAS endEditing];
    if([MA count])
    {
        [pboard declareTypes:[NSArray arrayWithObject:iTM2StyleSymbolsPboardType] owner:self];
        [pboard addTypes:[NSArray arrayWithObject:NSRTFPboardType] owner:self];
        return [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:MA] forType:iTM2StyleSymbolsPboardType]
			|| [pboard setData:[NSArchiver archivedDataWithRootObject:MAS] forType:NSRTFPboardType];
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:validateDrop:proposedRow:proposedDropOperation:
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSDragOperationEvery;
    NSPasteboard * pboard = [info draggingPasteboard];
    NSString * type = [pboard availableTypeFromArray:[NSArray arrayWithObjects:iTM2StyleSymbolsPboardType, NSStringPboardType, nil]];
    return [type length]? NSDragOperationEvery: NSDragOperationNone;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:acceptDrop:row:dropOperation:
- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self tableView:tv paste:[info draggingPasteboard]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:paste:
- (BOOL)tableView:(NSTableView*)tv paste:(NSPasteboard *)pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self currentSets] != _CustomSymbolsSets)
    {
        return NO;
    }
    NSString * type = [pboard availableTypeFromArray:[NSArray arrayWithObjects:iTM2StyleSymbolsPboardType, NSStringPboardType, nil]];
//NSLog(@"[pboard types]: %@", [pboard types]);
//NSLog(@"type: %@", type);
//NSLog(@"iTM2StyleSymbolsPboardType: %@", iTM2StyleSymbolsPboardType);
    float rowHeight = [tv rowHeight];
    if([type isEqualToString:iTM2StyleSymbolsPboardType])
    {
        NSArray * RA = [NSKeyedUnarchiver unarchiveObjectWithData:[pboard dataForType:type]];
        NSEnumerator * E = [RA objectEnumerator];
//NSLog(@"RA: %@", RA);
        NSString * CSK = [self currentSetKey];
        NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
        NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
        id K, O;
        while((K = [E nextObject]) && (O = [E nextObject]))
        {
            if(![_Ks containsObject:K])
            {
                [_Ks addObject:K];
                [_EOs setObject:[[O mutableCopy] autorelease] forKey:K];
                rowHeight = MAX(rowHeight, [O size].height);
            }
        }
        [_Ks sortUsingSelector:@selector(compare:)];
        [tv setRowHeight:rowHeight];
        [tv reloadData];
        [[self document] updateChangeCount:NSChangeDone];
		[self validateWindowContent];
        return YES;
    }
    else if([type isEqualToString:NSStringPboardType])
    {
        NSString * CSK = [self currentSetKey];
        NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
        NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
        NSEnumerator * E = [[[pboard stringForType:type] componentsSeparatedByString:@"\r"] objectEnumerator];
        NSString * S;
        while(S = [E nextObject])
        {
            NSEnumerator * e = [[S componentsSeparatedByString:@"\n"] objectEnumerator];
            NSString * s;
            while(s = [e nextObject])
            {
                if([s length] && ![_Ks containsObject:s])
                {
                    [_Ks addObject:s];
                    [_EOs setObject:[[[NSMutableAttributedString allocWithZone:[self zone]]
                        initWithString: @"?" attributes:
                            [NSDictionary dictionaryWithObject:[NSColor redColor]
                                forKey: NSForegroundColorAttributeName]] autorelease]
                        forKey: s];
                }
            }
        }
        [_Ks sortUsingSelector:@selector(compare:)];
        [tv setRowHeight:rowHeight];
        [tv reloadData];
        [[self document] updateChangeCount:NSChangeDone];
		[self validateWindowContent];
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  none:
- (void)none:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  KEY BINDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"Text/Xtd";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useKeyBindingsManager
- (BOOL)useKeyBindingsManager;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeEnter:
- (BOOL)interpretKeyStrokeEnter:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([tableView editedColumn] != -1)
        return NO;
    else if([[self window] firstResponder] == tableView)
    {
        [self addSymbolInTableView:tableView];
//iTM2_END;
        return YES;
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeReturn:
- (BOOL)interpretKeyStrokeReturn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self interpretKeyStrokeEnter: (id) sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeHorizontalTab:
- (BOOL)interpretKeyStrokeHorizontalTab:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
    {
        NSWindow * W = [self window];
        NSScrollView * SV = [tableView enclosingScrollView];
        id NR = [SV nextValidKeyView]?:
                ([SV previousValidKeyView]?:
                ([SV nextKeyView]?:
                [SV previousKeyView]));
//iTM2_LOG(@"NR is: %@", NR);
        return NR? [W makeFirstResponder:SV]: NO;
    }
    int column = [tableView editedColumn];
    if(column == [tableView numberOfColumns] - 1)
    {
        int row = [tableView selectedRow];
        int max = [self numberOfRowsInTableView:tableView];
        if((row<0) || (row >= max - 1))
            row = 0;
        else
            ++row;
        if(row == [tableView selectedRow])
            [tableView deselectAll:self];
        [tableView selectRow:row byExtendingSelection:NO];
        return YES;
    }
    else if(column != -1)
        return NO;
    else if([[self window] firstResponder] == tableView)
    {
        int row = [tableView selectedRow];
        int max = [self numberOfRowsInTableView:tableView];
        if((row<0) || (row >= max))
            row = 0;
        [tableView selectRow:row byExtendingSelection:NO];
        row = [tableView selectedRow];
        int column = 0;
        if([self tableView:tableView shouldEditTableColumn:[[tableView tableColumns] objectAtIndex:column] row:row])
        {        
            SEL selector = @selector(editColumn:row:withEvent:select:);
            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[tableView methodSignatureForSelector:selector]];
            [invocation setTarget:tableView];
            [invocation setSelector:selector];
            [invocation setArgument: &column atIndex:2];
            [invocation setArgument: &row atIndex:3];
            id argument = nil;
            [invocation setArgument: &argument atIndex:4];
            BOOL flag = YES;
            [invocation setArgument: &flag atIndex:5];
            [NSTimer scheduledTimerWithTimeInterval:0 invocation:invocation repeats:NO];
        }
        return YES;
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeDelete:
- (BOOL)interpretKeyStrokeDelete:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([tableView editedColumn] != -1)
        return NO;
    else if([[self window] firstResponder] == tableView)
    {
        [self deleteSelectedSymbolsInTableView:tableView];
//iTM2_END;
        return YES;
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeBackspace:
- (BOOL)interpretKeyStrokeBackspace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([tableView editedColumn] != -1)
        return NO;
    else if([[self window] firstResponder] == tableView)
    {
        [self deleteSelectedSymbolsInTableView:tableView];
//iTM2_END;
        return YES;
    }
//iTM2_END;
    return NO;
}
@end

@interface iTM2TextStyleTableView: NSTableView
@end

@implementation iTM2TextStyleTableView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeFont:
- (void)changeFont:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self delegate] respondsToSelector:@selector(tableView:changeFont:)])
        [[self delegate] tableView:self changeFont:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeColor:
- (void)changeColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self delegate] respondsToSelector:@selector(tableView:changeColor:)])
        [[self delegate] tableView:self changeColor:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  draggingSourceOperationMaskForLocal:
- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSDragOperationEvery;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  MENU ITEMS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  copy:
- (IBAction)copy:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self dataSource] tableView:self writeRows:[[self selectedRowEnumerator] allObjects] toPasteboard:[NSPasteboard generalPasteboard]])
    {
        iTM2_LOG(@"Could not write to the general paste board");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCopy:
- (BOOL)validateCopy:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [self numberOfSelectedRows] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  paste:
- (IBAction)paste:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self dataSource] tableView:self paste:[NSPasteboard generalPasteboard]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePaste:
- (BOOL)validatePaste:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[[NSPasteboard generalPasteboard] availableTypeFromArray:[NSArray arrayWithObjects:iTM2StyleSymbolsPboardType, NSStringPboardType, nil]] length] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delete:
- (IBAction)delete:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self dataSource] deleteSelectedSymbolsInTableView:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDelete:
- (BOOL)validateDelete:(id <NSMenuItem>)menuItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([self numberOfSelectedRows]>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cut:
- (IBAction)cut:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self copy:sender];
    [self delete:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCut:
- (BOOL)validateCut:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [self numberOfSelectedRows] > 0;
}
@end
