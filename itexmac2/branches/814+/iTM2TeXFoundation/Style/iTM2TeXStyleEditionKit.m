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

#define iTM2TSSMenuItemIndentationLevel [self context4iTM3IntegerForKey:@"iTM2TextSyntaxStyleMenuItemIndentationLevel" domain:iTM2ContextAllDomainsMask]
#define TABLE @"TextStyle"
#define BUNDLE [iTM2TeXParserAttributesInspector classBundle4iTM3]

NSString * const iTM2StyleSymbolsPboardType = @"iTM2StyleSymbolsPboardType";

NSString * const iTM2TeXParserAttributesInspectorType = @"iTM2TeXParserAttributes";

@implementation iTM2TeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXParserAttributesInspectorType;
}
@end

NSString * const iTM2TextAttributesSymbolIdentifier = @"symbol";
NSString * const iTM2TextAttributesCommandIdentifier = @"command";

@implementation iTM2TeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"iTM2TextSyntaxParserAttributesInspector";
}
@end

#import <iTM2Foundation/iTM2KeyBindingsKit.h>
//#import <iTM2Foundation/iTM2CompatibilityChecker.h>

NSString * const iTM2XtdTeXParserSymbolsInspectorMode = @".iTM2XtdTeXParserSymbols";
NSString * const iTM2XtdTeXParserAttributesInspectorType = @"iTM2XtdTeXParserAttributes";

@implementation iTM2XtdTeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdTeXParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSEnumerator * E = [self.windowControllers objectEnumerator];
    id WC;
    while(WC = E.nextObject)
        if([[[WC class] inspectorMode] isEqualToString:iTM2DefaultInspectorMode])
		{
			while(WC = E.nextObject)
				if([[[WC class] inspectorMode] isEqualToString:iTM2XtdTeXParserSymbolsInspectorMode])
					return;
			[self  inspectorAddedWithMode:iTM2XtdTeXParserSymbolsInspectorMode];
			return;
		}
		else if([[[WC class] inspectorMode] isEqualToString:iTM2XtdTeXParserSymbolsInspectorMode])
		{
			while(WC = E.nextObject)
				if([[[WC class] inspectorMode] isEqualToString:iTM2DefaultInspectorMode])
					return;
			[self  inspectorAddedWithMode:iTM2DefaultInspectorMode];
			return;
		}
	if(![self inspectorAddedWithMode:iTM2DefaultInspectorMode])
	{
		LOG4iTM3(@".........  Code inconsistency 1, report bug");
	}
	if(![self inspectorAddedWithMode:iTM2XtdTeXParserSymbolsInspectorMode])
	{
		LOG4iTM3(@".........  Code inconsistency 2, report bug");
	}
//END4iTM3;
    return;
}
@end

@implementation iTM2XtdTeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdTeXParserAttributesInspectorType;
}
@end

@implementation iTM2XtdTeXParserSymbolsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdTeXParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdTeXParserSymbolsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"iTM2XtdTeXParserSymbolsInspector";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self = [super initWithWindow:window])
    {
        _BuiltInSymbolsSets = [NSMutableDictionary dictionary];
        _NetworkSymbolsSets = [NSMutableDictionary dictionary];
        _LocalSymbolsSets = [NSMutableDictionary dictionary];
        _CustomSymbolsSets = [NSMutableDictionary dictionary];
        _CustomObjectsSets = [NSMutableDictionary dictionary];
        _CustomKeysSets = [NSMutableDictionary dictionary];
        _EditedObjectsSets = [NSMutableDictionary dictionary];
        _RecycleSymbolsSets = [NSMutableDictionary dictionary];
        _AllSymbolsSets = [NSMutableDictionary dictionary];
    }
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentSets
- (NSMutableDictionary *)currentSets;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[_CurrentSetItem representedObject] objectForKey:@"S"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentSetKey
- (NSString *)currentSetKey;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * result = [[_CurrentSetItem representedObject] objectForKey:@"K"];
    return result.length? result: @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"For the revert to saved.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = YES;
#warning ERROR
    _CustomObjectsSets = [NSMutableDictionary dictionary];
    _CustomKeysSets = [NSMutableDictionary dictionary];
    _EditedObjectsSets = [NSMutableDictionary dictionary];
    _RecycleSymbolsSets = [NSMutableDictionary dictionary];

    NSMutableDictionary * allSymbols = [NSMutableDictionary dictionary];
    
    // self.document must exists!!
	Class syntaxParserClass = [[self.document class] syntaxParserClass];

	NSString * style = [syntaxParserClass syntaxParserStyle];
	NSString * variant = [(iTM2TextSyntaxParserAttributesDocument *)self.document syntaxParserVariant];// lowercase string?
    NSString * variantComponent = [variant stringByAppendingPathExtension:iTM2TextVariantExtension];

	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSURL * url = nil;
	BOOL isDir = NO;
	for(url in [[syntaxParserClass attributesServerClass] builtInStyleURLs]) {
//LOG4iTM3(@"Reading built in symbols at path %@", stylePath);
		url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory:&isDir] && isDir) {
			for(url in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:ZER0 error:outErrorPtr])
				if([url.pathExtension isEqualToFileName4iTM3:iTM2TextAttributesPathExtension]) {
//LOG4iTM3(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfURL:url];
					if(symbolsAttributes) {
                        [MD setObject:symbolsAttributes forKey:url.lastPathComponent.stringByDeletingPathExtension];
						[allSymbols addEntriesFromDictionary:symbolsAttributes];
					}
				} else {
					DEBUGLOG4iTM3(0,@"Ignoring path while reading symbols sets: %@", url);
				}            
		} else {
			LOG4iTM3(@"No symbols sets at path %@", url);
		}
	}
	[_BuiltInSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];
	
    // loading the sets from the network
    for(url in [[NSBundle mainBundle] URLsForSupportResource4iTM3:style withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent domains:NSNetworkDomainMask]) {
		url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory: &isDir] && isDir)
		{
			for(url in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:ZER0 error:outErrorPtr]) {
				if([url.pathExtension isEqualToFileName4iTM3:iTM2TextAttributesPathExtension]) {
//LOG4iTM3(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfURL:url];
					if(symbolsAttributes) {
						[MD setObject:symbolsAttributes forKey:url.lastPathComponent.stringByDeletingPathExtension];
						[allSymbols addEntriesFromDictionary:symbolsAttributes];
					}
				} else {
					DEBUGLOG4iTM3(0,@"Ignoring path while reading symbols sets: %@", url);
				}
			}
		} else {
			LOG4iTM3(@"No symbols sets at path %@", url);
		}
	}
    [_NetworkSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];
    // loading the sets from the local domain
    for(url in [[NSBundle mainBundle] URLsForSupportResource4iTM3:style withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent domains:NSLocalDomainMask]) {
		url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory: &isDir] && isDir)
		{
			for(url in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:ZER0 error:outErrorPtr]) {
				if([url.pathExtension isEqualToFileName4iTM3:iTM2TextAttributesPathExtension]) {
//LOG4iTM3(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfURL:url];
					if(symbolsAttributes) {
						[MD setObject:symbolsAttributes forKey:url.lastPathComponent.stringByDeletingPathExtension];
						[allSymbols addEntriesFromDictionary:symbolsAttributes];
					}
				} else {
					DEBUGLOG4iTM3(0,@"Ignoring path while reading symbols sets: %@", url);
				}
			}
		} else {
			LOG4iTM3(@"No symbols sets at path %@", url);
		}
	}
    [_LocalSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];
    
    // loading the sets from the user domain
    for(url in [[NSBundle mainBundle] URLsForSupportResource4iTM3:style withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent domains:NSUserDomainMask]) {
		url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory: &isDir] && isDir)
		{
			for(url in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:ZER0 error:outErrorPtr]) {
				if([url.pathExtension isEqualToFileName4iTM3:iTM2TextAttributesPathExtension]) {
//LOG4iTM3(@"Reading at path %@", path);
					id symbolsAttributes = [iTM2XtdTeXParserAttributesServer symbolsAttributesWithContentsOfURL:url];
					if(symbolsAttributes) {
						[MD setObject:symbolsAttributes forKey:url.lastPathComponent.stringByDeletingPathExtension];
						[allSymbols addEntriesFromDictionary:symbolsAttributes];
					}
				} else {
					DEBUGLOG4iTM3(0,@"Ignoring path while reading symbols sets: %@", url);
				}
			}
		} else {
			LOG4iTM3(@"No symbols sets at path %@", url);
		}
	}
    [_CustomSymbolsSets setDictionary:MD];
	MD = [NSMutableDictionary dictionary];

	[_AllSymbolsSets setObject:allSymbols forKey:@"K"];
    self.validateWindowContent4iTM3;
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fileName is: %@", fileName);
    // loading the built in symbols sets
    BOOL success = YES;
	// recycling all necessary sets.
	NSString * CSK;
	for (CSK in [_RecycleSymbolsSets keyEnumerator]) {
//LOG4iTM3(@"RECYCLING FILE AT PATH: %@", fullPath);
		success = success
			&& (![DFM fileExistsAtPath:[absoluteURL URLByAppendingPathComponent:CSK].path]
				|| [SWS performFileOperation:NSWorkspaceRecycleOperation
						source: absoluteURL.path
							destination: nil
								files:[NSArray arrayWithObject:CSK]
									tag:NULL]);
	}
	_RecycleSymbolsSets = [NSMutableDictionary dictionary];
	// saving the other sets.
	NSTextView * TV = [[[NSTextView alloc] initWithFrame:NSMakeRect(0,0,1e7,1e7)] autorelease];
	NSLayoutManager * LM = TV.layoutManager;
	NSTextStorage * TS = LM.textStorage;
	for (CSK in _CustomSymbolsSets.keyEnumerator) {
//LOG4iTM3(@"CSK: %@", CSK);
		NSEnumerator * EE = [[_CustomKeysSets objectForKey:CSK] objectEnumerator];
        // if no EE is available, it means that the set has not been edited:
        // nothing needs to be saved...
        if(EE) {
//LOG4iTM3(@"Something needs to be saved:");
            NSMutableDictionary * DOs = [NSMutableDictionary dictionary];
            NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
            NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
            for (NSString * command in EE) {
//LOG4iTM3(@"command: %@", command);
                NSAttributedString * AS = [_EOs objectForKey:command]?:[_Os objectForKey:command];
                if(AS.length)
                {
                    id As = [AS attributesAtIndex:ZER0 effectiveRange:nil];
                    NSFont * F = [As objectForKey:NSFontAttributeName]?:[NSFont systemFontOfSize:[NSFont systemFontSize]];
                    TS.beginEditing;
                    [TS setAttributedString:AS];
                    TS.endEditing;
                    NSGlyphInfo * GI = [NSGlyphInfo glyphInfoWithGlyph:[LM glyphAtIndex:ZER0] forFont:F baseString:command];
                    if (GI) {
                        id attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					F, NSFontAttributeName,
				GI, NSGlyphInfoAttributeName,
			[AS string], iTM2TextAttributesCharacterAttributeName,
		[AS attribute:iTM2Text2ndSymbolColorAttributeName atIndex:ZER0 effectiveRange:NULL], iTM2Text2ndSymbolColorAttributeName,
                            nil];
                        NSColor * C = [As objectForKey:NSForegroundColorAttributeName];
                        if(![[NSColor controlTextColor] isEqual:C]) {
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
    //LOG4iTM3(@"SAVING %@", DOs);
            NSString * lastPathComponent = [CSK stringByAppendingPathExtension:iTM2TextAttributesPathExtension];
            success = ![lastPathComponent isEqual:[iTM2TextAttributesModesComponent stringByAppendingPathExtension:iTM2TextAttributesPathExtension]]
				&& [iTM2XtdTeXParserAttributesServer writeSymbolsAttributes:DOs toURL:[absoluteURL URLByAppendingPathComponent:lastPathComponent]];
        }
    }
    if(success) {
        [self readFromURL:absoluteURL ofType:typeName error:outErrorPtr];
	}
    return success;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowWillLoad];
    [self setWindowFrameAutosaveName:NSStringFromClass(self.class)];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    NSCell * C = [[tableView tableColumnWithIdentifier:iTM2TextAttributesSymbolIdentifier] dataCell];
    [C setAllowsEditingTextAttributes:YES];
    [C setImportsGraphics:YES];
    self.window.delegate = self;
    self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent4iTM3
- (BOOL)validateWindowContent4iTM3;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super validateWindowContent4iTM3];
    NSString * CSK = self.currentSetKey;
    if(CSK.length && ![_CustomKeysSets objectForKey:CSK])
    {
        NSMutableDictionary * _Os = [NSMutableDictionary dictionary];
        [_CustomObjectsSets setObject:_Os forKey:CSK];
        NSMutableDictionary * _EOs = [NSMutableDictionary dictionary];
        [_EditedObjectsSets setObject:_EOs forKey:CSK];
        NSDictionary * symbolsAttributes = [self.currentSets objectForKey:self.currentSetKey];
        [_CustomKeysSets setObject: [NSMutableArray arrayWithArray:
            [[symbolsAttributes allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]]
                forKey: CSK];
//LOG4iTM3(@"_CustomKeysSets is: %@", _CustomKeysSets);
        CGFloat rowHeight = 15;
        NSEnumerator * E = symbolsAttributes.keyEnumerator;
        NSString * K;
        while(K = E.nextObject)
        {
            NSMutableDictionary * symbolAttributes = [symbolsAttributes objectForKey:K];
            if([symbolAttributes isKindOfClass:[NSDictionary class]]
                && [symbolAttributes objectForKey:NSGlyphInfoAttributeName])
            {
                NSString * S = [symbolAttributes objectForKey:iTM2TextAttributesCharacterAttributeName]?: @"-";
                NSMutableAttributedString * MAS = [[[NSMutableAttributedString alloc]
                                initWithString: S attributes: symbolAttributes] autorelease];
                rowHeight = MAX(rowHeight, [MAS size].height);
                NSColor * symbolColor = [symbolAttributes objectForKey:iTM2Text2ndSymbolColorAttributeName];
                NSColor * replacementColor = symbolColor && [symbolColor alphaComponent]?
                    [[symbolColor colorWithAlphaComponent:1] blendedColorWithFraction:1 - [symbolColor alphaComponent]
                                        ofColor: [NSColor textColor]]:
                        [NSColor textColor];
                [MAS addAttribute:NSForegroundColorAttributeName value:replacementColor
                    range:iTM3MakeRange(ZER0,MAS.length)];
                [_Os setObject:MAS forKey:K];
            }
        }
        [tableView setRowHeight:rowHeight];
    }
    [tableView reloadData];
    if([tableView numberOfSelectedRows]==1)
    {
        NSMutableAttributedString * MAS = [self symbolAtRow:[tableView selectedRow]];
        if(MAS.length)
        {
            NSFont * oldF = [MAS attribute:NSFontAttributeName atIndex:ZER0 effectiveRange:nil];
            NSFont * F = [[NSFontManager sharedFontManager] convertFont:oldF];
            [[NSFontManager sharedFontManager] setSelectedFont:F isMultiple:NO];
        }
    }
//END4iTM3;
    return [addSetPanel validateContent4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id newItem = [sender selectedItem];
    if(_CurrentSetItem != newItem)
    {
        _CurrentSetItem = newItem;
        self.validateWindowContent4iTM3;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSetChosen:
- (BOOL)validateSetChosen:(id)theSender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static BOOL firstTime = YES;
    static id customSetMenuItem;
    static id localSetMenuItem;
    static id networkSetMenuItem;
    static id builtInSetMenuItem;
    static id recycleSetMenuItem;
    static id allSymbolsMenuItem;
    if(firstTime)
    {
        #define sender ((NSMenuItem *)theSender)
        firstTime = NO;
        NSMenuItem * MI = [sender.menu itemWithTag:1];
        if([MI respondsToSelector:@selector(copy)])
            customSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[sender.menu itemWithTag:2];
        if([MI respondsToSelector:@selector(copy)])
            localSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[sender.menu itemWithTag:3];
        if([MI respondsToSelector:@selector(copy)])
            networkSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[sender.menu itemWithTag:4];
        if([MI respondsToSelector:@selector(copy)])
            builtInSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[sender.menu itemWithTag:5];
        if([MI respondsToSelector:@selector(copy)])
            recycleSetMenuItem = [MI copy];
        MI = (NSMenuItem *)[sender.menu itemWithTag:6];
        if([MI respondsToSelector:@selector(copy)])
            allSymbolsMenuItem = [MI copy];
    }
    NSFont * italic = [SFM convertFont:[NSFont fontWithName:@"Helvetica" size:[NSFont systemFontSize]]
        toHaveTrait: NSItalicFontMask];
//LOG4iTM3(@"italic is: %@", italic);
    #undef sender
    #define sender ((NSPopUpButton *)theSender)
    if(!_CurrentSetItem)
    {
        [sender removeAllItems];
        NSInteger indentationLevel = iTM2TSSMenuItemIndentationLevel;
        if(_BuiltInSymbolsSets.count)
        {
            if(builtInSetMenuItem)
            {
                [sender.menu addItem:[[builtInSetMenuItem copy] autorelease]];
                NSMenuItem * lastItem = [sender lastItem];
                lastItem.action = @selector(noop:);
                lastItem.target = self;// lastItem item belongs to the receivers window
                [lastItem setEnabled:NO];
                lastItem.state = NSOffState;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = ZER0;
            for (NSString * key in [[_BuiltInSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
                NSMenuItem * lastItem = [[[NSMenuItem alloc] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                lastItem.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _BuiltInSymbolsSets, @"S", nil];
                lastItem.target = self;// lastItem item belongs to the receivers window
				lastItem.indentationLevel = indentationLevel;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [sender.menu addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    || !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if(_NetworkSymbolsSets.count)
        {
            if(networkSetMenuItem)
            {
                [sender.menu addItem:[[networkSetMenuItem copy] autorelease]];
                NSMenuItem * lastItem = [sender lastItem];
                lastItem.action = @selector(noop:);
                lastItem.target = self;// lastItem item belongs to the receivers window
                [lastItem setEnabled:NO];
                lastItem.state = NSOffState;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = ZER0;
            for(NSString * key in [[_NetworkSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
                NSMenuItem * lastItem = [[[NSMenuItem alloc] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                lastItem.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _NetworkSymbolsSets, @"S", nil];
                lastItem.target = self;// lastItem item belongs to the receivers window
				lastItem.indentationLevel = indentationLevel;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [sender.menu addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    && !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if(_LocalSymbolsSets.count)
        {
            if(localSetMenuItem)
            {
                [sender.menu addItem:[[localSetMenuItem copy] autorelease]];
                NSMenuItem * lastItem = [sender lastItem];
                lastItem.action = @selector(noop:);
                lastItem.target = self;// lastItem item belongs to the receivers window
                [lastItem setEnabled:NO];
                lastItem.state = NSOffState;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = ZER0;
            for (NSString * key in [[_LocalSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
                NSMenuItem * lastItem = [[[NSMenuItem alloc] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                lastItem.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _LocalSymbolsSets, @"S", nil];
                lastItem.target = self;// lastItem item belongs to the receivers window
				lastItem.indentationLevel = indentationLevel;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [sender.menu addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    && !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if(_CustomSymbolsSets.count)
        {
            if(customSetMenuItem)
            {
                [sender.menu addItem:[[customSetMenuItem copy] autorelease]];
                NSMenuItem * lastItem = [sender lastItem];
                lastItem.action = @selector(noop:);
                lastItem.target = self;// lastItem item belongs to the receivers window
                [lastItem setEnabled:NO];
                lastItem.state = NSOffState;
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = ZER0;
            for (NSString * key in [[_CustomSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
                NSMenuItem * lastItem = [[[NSMenuItem alloc] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                lastItem.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _CustomSymbolsSets, @"S", nil];
                lastItem.target = self;// lastItem item belongs to the receivers window
				lastItem.indentationLevel = indentationLevel;
                [sender.menu addItem:lastItem];
                if(([key caseInsensitiveCompare:iTM2TextDefaultVariant] == NSOrderedSame)
                    && !_CurrentSetItem )
                    _CurrentSetItem = lastItem;
            }
        }
        if(_RecycleSymbolsSets.count)
        {
            if(recycleSetMenuItem)
            {
                [sender.menu addItem:[[recycleSetMenuItem copy] autorelease]];
                NSMenuItem * lastItem = [sender lastItem];
                lastItem.action = @selector(noop:);
                lastItem.target = self;// lastItem item belongs to the receivers window
                [lastItem setEnabled:NO];
                lastItem.state = NSOffState;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                indentationLevel = iTM2TSSMenuItemIndentationLevel;
            }
            else
                indentationLevel = ZER0;
            for (NSString * key in [[_RecycleSymbolsSets allKeys]
                sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
                NSMenuItem * lastItem = [[[NSMenuItem alloc] initWithTitle: key
                    action: @selector(chooseSet:) keyEquivalent: @""] autorelease];
                lastItem.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:key, @"K", _RecycleSymbolsSets, @"S", nil];
                lastItem.target = self;// lastItem item belongs to the receivers window
				lastItem.indentationLevel = indentationLevel;
                [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                    initWithString: lastItem.title
                        attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
                [sender.menu addItem:lastItem];
            }
        }
        if(_AllSymbolsSets.count && allSymbolsMenuItem)
        {
            [sender.menu addItem:[[allSymbolsMenuItem copy] autorelease]];
            NSMenuItem * lastItem = [sender lastItem];
            lastItem.action = @selector(chooseSet:);
            lastItem.target = self;// lastItem item belongs to the receivers window
            lastItem.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:@"K", @"K", _AllSymbolsSets, @"S", nil];
            lastItem.state = NSOffState;
            [lastItem setAttributedTitle:[[[NSAttributedString alloc]
                initWithString: lastItem.title
                    attributes: [NSDictionary dictionaryWithObjectsAndKeys:italic, NSFontAttributeName, nil]] autorelease]];
			if(!_CurrentSetItem)
				_CurrentSetItem = lastItem;
        }
    }
    [sender selectItem:_CurrentSetItem];
    [sender.menu update];
#undef sender
        //END4iTM3;
    return YES;//[sender numberOfItems] > 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseSet:
- (IBAction)chooseSet:(id)sender;
/*"Message sent from menu items.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(_CurrentSetItem != sender)
    {
        _CurrentSetItem = sender;
        self.validateWindowContent4iTM3;
    }
//END4iTM3;
    return;
}
NSString * _iTM2PRIVATE_NewSetName = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  manageSet:
- (IBAction)manageSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self performSelector:@selector(_addSet:) withObject:sender afterDelay:0.0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSet:
- (IBAction)addSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self performSelector:@selector(_addSet:) withObject:sender afterDelay:0.0];
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAddSet:
- (IBAction)validateAddSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _addSet:
- (IBAction)_addSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.validateWindowContent4iTM3;
    if(![self.window attachedSheet])
    {
        [NSApp beginSheet:addSetPanel
                modalForWindow:self.window
                modalDelegate:self
                didEndSelector:@selector(addSetSheetDidEnd:returnCode:contextInfo:)
                contextInfo:nil];
    } else {
        LOG4iTM3(@"There is already a sheet attached to this window...");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetSheetDidEnd:returnCode:contextInfo:
- (void)addSetSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sheet orderOut:self];
    if((returnCode == NSAlertDefaultReturn) && _iTM2PRIVATE_NewSetName.length)
    {
        NSString * name = [_iTM2PRIVATE_NewSetName autorelease];
        _iTM2PRIVATE_NewSetName = nil;
        if(![_CustomSymbolsSets objectForKey:name])
        {
            [_CustomSymbolsSets setObject:[NSMutableDictionary dictionary] forKey:name];
            [self.document updateChangeCount:NSChangeDone];
        }
		// we would want to select the menu item of the newly created set, assuming that we are going to edit it.
		// force the validation: the menu items will be created from scratch,
		_CurrentSetItem = nil;
		self.validateWindowContent4iTM3;
		// normally the "all symbols" menu item should be selected.
		if(_CurrentSetItem)
		{
			id RO = [NSDictionary dictionaryWithObjectsAndKeys:name, @"K", _CustomSymbolsSets, @"S", nil];
			NSEnumerator * E = [_CurrentSetItem.menu.itemArray objectEnumerator];
			NSMenuItem * MI;
			while(MI = E.nextObject)
				if([RO isEqual:[MI representedObject]])
				{
					_CurrentSetItem = MI;
					// now we know what menu item should be selected.
					self.validateWindowContent4iTM3;
					if([tableView acceptsFirstResponder])
					{
						[tableView.window makeFirstResponder:tableView];
					}
					break;
				}
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetOk:
- (IBAction)addSetOk:(NSControl *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // What is the current style?
    // Sheet is up here.
    [NSApp endSheet:sender.window returnCode:NSAlertDefaultReturn];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetCancel:
- (IBAction)addSetCancel:(NSControl *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [_iTM2PRIVATE_NewSetName autorelease];
    _iTM2PRIVATE_NewSetName = nil;
    [NSApp endSheet:sender.window returnCode:NSAlertAlternateReturn];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetTitleEdited:
- (IBAction)addSetTitleEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAddSetTitleEdited:
- (BOOL)validateAddSetTitleEdited:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Add a symbols set to style %@", TABLE, BUNDLE, "Comment forthcoming"), [[[self.document class] syntaxParserClass] prettySyntaxParserStyle]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSetNameEdited:
- (IBAction)addSetNameEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3([sender stringValue]);
    [_iTM2PRIVATE_NewSetName autorelease];
    _iTM2PRIVATE_NewSetName = [[sender stringValue] copy];
    _CurrentSetItem = nil;
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSet:
- (IBAction)removeSet:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSBeginInformationalAlertSheet(
        NSLocalizedStringFromTableInBundle(@"Remove set", TABLE, BUNDLE, "Comment forthcoming"),
        NSLocalizedStringFromTableInBundle(@"OK", TABLE, BUNDLE, "Comment forthcoming"),
        NSLocalizedStringFromTableInBundle(@"Cancel", TABLE, BUNDLE, "Comment forthcoming"),
        nil,
        sender.window,
        self,
        @selector(removeSetSheetDidEnd:returnCode:recycleSet:),
        NULL,
        self.currentSetKey,
        NSLocalizedStringFromTableInBundle(@"Remove symbols set %@?", TABLE, BUNDLE, "Comment forthcoming"),
        _CurrentSetItem.title);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSetSheetDidEnd:returnCode:recycleSet:
- (void)removeSetSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode recycleSet:(NSString *)name;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(returnCode == NSAlertDefaultReturn)
    {
        if((self.currentSets == _CustomSymbolsSets) && name.length)
        {
            [_RecycleSymbolsSets setObject:[_CustomSymbolsSets objectForKey:name] forKey:name];
            [_CustomSymbolsSets removeObjectForKey:name];
            _CurrentSetItem = nil;
            [self.document updateChangeCount:NSChangeDone];
//LOG4iTM3(@"[_RecycleSymbolsSets allKeys]: %@", [_RecycleSymbolsSets allKeys]);
//LOG4iTM3(@"[_CustomSymbolsSets allKeys]: %@", [_CustomSymbolsSets allKeys]);
			self.validateWindowContent4iTM3;
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRemoveSet:
- (BOOL)validateRemoveSet:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (self.currentSets == _CustomSymbolsSets);
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  TABLEVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  symbolAtRow:
- (id)symbolAtRow:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * CSK = self.currentSetKey;
    NSArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    if((row >= ZER0) && (row < _Ks.count))
    {
        NSString * K = [_Ks objectAtIndex:row];
        id result = [_EOs objectForKey:K];
        if(!result)
        {
            result = [_Os objectForKey:K];
            if(!result)
            {
                result = [[[NSMutableAttributedString alloc] initWithString:@"?" attributes:[NSDictionary dictionaryWithObject:[NSColor magentaColor] forKey:NSForegroundColorAttributeName]] autorelease];
            }
        }
        if(![result isKindOfClass:[NSMutableAttributedString class]])
        {
            LOG4iTM3(@"CALAMITAS-CALAMITATIS");
        }
        return result;
    }
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[_CustomKeysSets objectForKey:self.currentSetKey] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id identifier = [tableColumn identifier];
    if([identifier isEqualToString:iTM2TextAttributesCommandIdentifier])
    {
        return ((row >= ZER0) && (row < [self numberOfRowsInTableView:tv]))?
            [[_CustomKeysSets objectForKey:self.currentSetKey] objectAtIndex:row]: nil;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:shouldEditTableColumn:row:
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
        return NO;
    if([[tableColumn identifier] isEqualToString:iTM2TextAttributesSymbolIdentifier])
    {
        NSMutableAttributedString * AS = [self symbolAtRow:row];
        if(AS.length)
        {
            NSColor * C = [[AS attributesAtIndex:ZER0 effectiveRange:NULL] objectForKey:NSForegroundColorAttributeName];
            if(C)
                [[tableColumn dataCell] setTextColor:C];
        }
    }
    else
        [[tableColumn dataCell] setTextColor:[NSColor controlTextColor]];
//LOG4iTM3(@"CONTROL COLOR: %@", [tableColumn identifier]);
//LOG4iTM3(@"symbol path is: %@", [_CurrentSetItem representedObject]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
    {
		self.validateWindowContent4iTM3;
        return;
    }
    NSString * CSK = self.currentSetKey;
    NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    NSInteger row = [_Ks indexOfObject:@"?"];
    if(row == NSNotFound)
    {
        row = [tv selectedRow];
        if((row<0) || (row >= _Ks.count))
            row = ZER0;
        [_Ks insertObject:@"?" atIndex:row];
		id O = [self symbolAtRow:row];
		if(O)
			[_EOs setObject:[[O mutableCopy] autorelease] forKey:@"?"];
		else
			[_EOs removeObjectForKey:@"?"];
        [self.document updateChangeCount:NSChangeDone];
        [tv reloadData];
    }
	[tv selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    self.validateWindowContent4iTM3;
    if([tv acceptsFirstResponder] && [tv.window makeFirstResponder:tv])
	{
#if 1
		SEL selector = @selector(editColumn:row:withEvent:select:);
		NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[tv methodSignatureForSelector:selector]];
		invocation.target = tv;
		[invocation setSelector:selector];
		NSInteger column = [tv columnWithIdentifier:iTM2TextAttributesCommandIdentifier];
		[invocation setArgument: &column atIndex:2];
		[invocation setArgument: &row atIndex:3];
		id argument = nil;
		[invocation setArgument: &argument atIndex:4];
		BOOL flag = YES;
		[invocation setArgument: &flag atIndex:5];
		[NSTimer scheduledTimerWithTimeInterval:0.0 invocation:invocation repeats:NO];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ([tableView numberOfSelectedRows] == 1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deleteSelectedSymbolsInTableView:
- (IBAction)deleteSelectedSymbolsInTableView:(NSTableView *)tv;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
    {
		self.validateWindowContent4iTM3;
        return;
    }
    NSString * CSK = self.currentSetKey;
    NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
	NSIndexSet * indexes = [tv selectedRowIndexes];
	NSInteger row = [indexes lastIndex];
	while(row!=NSNotFound)
	{
        if((row >= ZER0) && (row < _Ks.count))
        {
            NSString * K = [_Ks objectAtIndex:row];
            [_Os removeObjectForKey:K];
            [_EOs removeObjectForKey:K];
            [_Ks removeObjectAtIndex:row];
            [self.document updateChangeCount:NSChangeDone];
        }
		row = [indexes indexLessThanIndex:row];
	}
//    [tv reloadData];
    self.validateWindowContent4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SCP setColor:[[NSColor whiteColor] colorWithAlphaComponent:0]];
    self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRevertToFactoryColor:
- (BOOL)validateRevertToFactoryColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
        return NO;
	NSIndexSet * set = [tableView selectedRowIndexes];
	NSInteger row = [set firstIndex];
	while(row != NSNotFound) {
		if([[self symbolAtRow:row] attribute:iTM2Text2ndSymbolColorAttributeName atIndex:ZER0 effectiveRange:NULL])
            return YES;
		row = [set indexGreaterThanIndex:row];
	}
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleBackgroundColor:
- (IBAction)toggleBackgroundColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _Background = !_Background;
    self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleBackgroundColor:
- (BOOL)validateToggleBackgroundColor:(NSButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = (_Background? NSOnState:NSOffState);
//END4iTM3;
    return NO && (self.currentSets == _CustomSymbolsSets);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)TV setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"HERE");
    NSString * CSK = self.currentSetKey;
    NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableDictionary * _Os = [_CustomObjectsSets objectForKey:CSK];
    NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
    if((row >= ZER0) && (row < _Ks.count))
    {
        NSString * K = [_Ks objectAtIndex:row];
//LOG4iTM3(@"K: %@", K);
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
                [self.document updateChangeCount:NSChangeDone];
				self.validateWindowContent4iTM3;
            }
            [TV reloadData];
        }
        else
        {
//LOG4iTM3(@"symbol");
            if(([object isKindOfClass:[NSAttributedString class]]) && ([(NSAttributedString *)object length] == 1))
            {
                NSAttributedString * old = [_Os objectForKey:K];
//LOG4iTM3(@"old: %@", old);
                NSDictionary * oldAttributes = old.length? [old attributesAtIndex:ZER0 effectiveRange:NULL]: nil;
                NSDictionary * attributes = [object attributesAtIndex:ZER0 effectiveRange:NULL];
                if([[object string] isEqualToString:[old string]]
                    && [[oldAttributes objectForKey:NSFontAttributeName] isEqual:[attributes objectForKey:NSFontAttributeName]]
                        && [[oldAttributes objectForKey:NSForegroundColorAttributeName] isEqual:[attributes objectForKey:NSForegroundColorAttributeName]])
                {
                    [_EOs removeObjectForKey:K];
                }
                else
                {
                    [_EOs setObject:[[object mutableCopy] autorelease] forKey:K];
                    CGFloat rowHeight = [object size].height;
                    if(rowHeight > [TV rowHeight])
                        [TV setRowHeight:rowHeight];
                    [self.document updateChangeCount:NSChangeDone];
					self.validateWindowContent4iTM3;
//LOG4iTM3(@"The character? %x", [[object string] characterAtIndex);
//LOG4iTM3(@"attributes? %@", [object attributesAtIndexeffectiveRange:nil]);
                }
            }
            else
            {
                LOG4iTM3(@"Ignoring? %@, %@", object, [object class]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
        return;
    CGFloat rowHeight = [tableView rowHeight];
    BOOL isDocumentEdited = NO;
	NSIndexSet * IS = [tableView selectedRowIndexes];
	NSInteger row = [IS firstIndex];
	while(row != NSNotFound) {
        NSMutableAttributedString * MAS = [self symbolAtRow:row];
        if(MAS.length)
        {
            NSFont * oldF = [MAS attribute:NSFontAttributeName atIndex:ZER0 effectiveRange:nil];
            NSFont * F = [sender convertFont:oldF];
            if([[F coveredCharacterSet] characterIsMember:[[MAS string] characterAtIndex:ZER0]])
            {
                [MAS addAttribute:NSFontAttributeName value:F range:iTM3MakeRange(ZER0,MAS.length)];
                rowHeight = MAX(rowHeight, [MAS size].height);
                isDocumentEdited = YES;
            }
            else if(oldF)// could not set the font, set the size at least...
            {
                [MAS addAttribute: NSFontAttributeName
                    value: [NSFont fontWithName:[oldF fontName] size:[F pointSize]]
                        range: iTM3MakeRange(ZER0,MAS.length)];
                rowHeight = MAX(rowHeight, [MAS size].height);
                isDocumentEdited = YES;
            }
        }
		row = [IS indexGreaterThanIndex:row];
	}
    if(isDocumentEdited)
    {
        [self.document updateChangeCount:NSChangeDone];
        self.validateWindowContent4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
    {
        self.validateWindowContent4iTM3;
        return;
    }
    NSColor * newC = [sender color];
    if(newC && ![newC alphaComponent])
        newC = nil;
	NSIndexSet * IS = [tableView selectedRowIndexes];
	NSInteger row = [IS firstIndex];
	BOOL isDocumentEdited = NO;
    if(_Background)
    {
		while(row != NSNotFound) {
            NSMutableAttributedString * MAS = [self symbolAtRow:row];
            NSColor * oldC = [MAS attribute:NSBackgroundColorAttributeName atIndex:ZER0 effectiveRange:nil];
            if(![oldC isEqual:newC] && (oldC || newC))
            {
                NSRange R = iTM3MakeRange(ZER0,MAS.length);
                [MAS addAttribute:NSBackgroundColorAttributeName value:newC range:R];
                isDocumentEdited = YES;
            }
			row = [IS indexGreaterThanIndex:row];
        }
    }
    else
    {
		while(row != NSNotFound) {
            NSMutableAttributedString * MAS = [self symbolAtRow:row];
            NSColor * oldC = [MAS attribute:iTM2Text2ndSymbolColorAttributeName atIndex:ZER0 effectiveRange:nil];
            if(![oldC isEqual:newC] && (oldC || newC))
            {
                NSRange R = iTM3MakeRange(ZER0,MAS.length);
                if(newC && [newC alphaComponent]>0)
                    [MAS addAttribute:iTM2Text2ndSymbolColorAttributeName value:newC range:R];
                else
                    [MAS removeAttribute:iTM2Text2ndSymbolColorAttributeName range:R];
                NSColor * replacementColor = newC && [newC alphaComponent]>0? [[newC colorWithAlphaComponent:1] blendedColorWithFraction:1 - [newC alphaComponent] ofColor:[NSColor textColor]]:[NSColor textColor];
                [MAS addAttribute:NSForegroundColorAttributeName value:replacementColor range:R];
                isDocumentEdited = YES;
            }
			row = [IS indexGreaterThanIndex:row];
        }
    }
    if(isDocumentEdited)
    {
        [self.document updateChangeCount:NSChangeDone];
        self.validateWindowContent4iTM3;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRowsWithIndexes:toPasteboard:
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * CSK = self.currentSetKey;
    NSArray * _Ks = [_CustomKeysSets objectForKey:CSK];
    NSMutableArray * MA = [NSMutableArray array];
    NSMutableAttributedString * MAS = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil] autorelease];
	[MAS beginEditing];
	NSInteger row = [rowIndexes firstIndex];
	while(row != NSNotFound)
	{
        if((row>=ZER0) && (row<_Ks.count))
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
		row = [rowIndexes indexGreaterThanIndex:row];
	}
	[MAS endEditing];
    if(MA.count)
    {
        [pboard declareTypes:[NSArray arrayWithObject:iTM2StyleSymbolsPboardType] owner:self];
        [pboard addTypes:[NSArray arrayWithObject:NSRTFPboardType] owner:self];
        return [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:MA] forType:iTM2StyleSymbolsPboardType]
			|| [pboard setData:[NSArchiver archivedDataWithRootObject:MAS] forType:NSRTFPboardType];
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:validateDrop:proposedRow:proposedDropOperation:
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSDragOperationEvery;
    NSPasteboard * pboard = [info draggingPasteboard];
    NSString * type = [pboard availableTypeFromArray:[NSArray arrayWithObjects:iTM2StyleSymbolsPboardType, NSStringPboardType, nil]];
    return type.length? NSDragOperationEvery: NSDragOperationNone;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:acceptDrop:row:dropOperation:
- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self tableView:tv paste:[info draggingPasteboard]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:paste:
- (BOOL)tableView:(NSTableView*)tv paste:(NSPasteboard *)pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self.currentSets != _CustomSymbolsSets)
    {
        return NO;
    }
    NSString * type = [pboard availableTypeFromArray:[NSArray arrayWithObjects:iTM2StyleSymbolsPboardType, NSStringPboardType, nil]];
//NSLog(@"[pboard types]: %@", [pboard types]);
//NSLog(@"type: %@", type);
//NSLog(@"iTM2StyleSymbolsPboardType: %@", iTM2StyleSymbolsPboardType);
    CGFloat rowHeight = [tv rowHeight];
    if([type isEqualToString:iTM2StyleSymbolsPboardType])
    {
        NSArray * RA = [NSKeyedUnarchiver unarchiveObjectWithData:[pboard dataForType:type]];
        NSEnumerator * E = RA.objectEnumerator;
//NSLog(@"RA: %@", RA);
        NSString * CSK = self.currentSetKey;
        NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
        NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
        id K, O;
        while((K = E.nextObject) && (O = E.nextObject))
        {
			NSString * key = K;
			NSUInteger index = ZER0;
			while([_Ks containsObject:key])
			{
				key = [K stringByAppendingFormat:@"-%u",++index];
			}
            [_Ks addObject:key];
			[_EOs setObject:[[O mutableCopy] autorelease] forKey:key];
			rowHeight = MAX(rowHeight, [O size].height);
        }
        [_Ks sortUsingSelector:@selector(compare:)];
        [tv setRowHeight:rowHeight];
        [tv reloadData];
        [self.document updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
        return YES;
    }
    else if([type isEqualToString:NSStringPboardType])
    {
        NSString * CSK = self.currentSetKey;
        NSMutableArray * _Ks = [_CustomKeysSets objectForKey:CSK];
        NSMutableDictionary * _EOs = [_EditedObjectsSets objectForKey:CSK];
        NSEnumerator * E = [[[pboard stringForType:type] componentsSeparatedByString:@"\r"] objectEnumerator];
        NSString * S;
        while(S = E.nextObject)
        {
            NSEnumerator * e = [[S componentsSeparatedByString:@"\n"] objectEnumerator];
            NSString * s;
            while(s = e.nextObject)
            {
                if(s.length)
                {
					NSString * key = s;
					NSUInteger index = ZER0;
					while([_Ks containsObject:key])
					{
						key = [s stringByAppendingFormat:@"-%u",++index];
					}
                    [_Ks addObject:key];
					id MAS = [[[NSMutableAttributedString alloc]
                        initWithString: @"?" attributes:
                            [NSDictionary dictionaryWithObject:[NSColor redColor]
                                forKey: NSForegroundColorAttributeName]] autorelease];
                    [_EOs setObject:MAS forKey: key];
                }
            }
        }
        [_Ks sortUsingSelector:@selector(compare:)];
        [tv setRowHeight:rowHeight];
        [tv reloadData];
        [self.document updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Text/Xtd";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useKeyBindingsManager
- (BOOL)useKeyBindingsManager;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeEnter:
- (BOOL)interpretKeyStrokeEnter:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([tableView editedColumn] != -1)
        return NO;
    else if(self.window.firstResponder == tableView)
    {
        [self addSymbolInTableView:tableView];
//END4iTM3;
        return YES;
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeReturn:
- (BOOL)interpretKeyStrokeReturn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self interpretKeyStrokeEnter: (id) sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeHorizontalTab:
- (BOOL)interpretKeyStrokeHorizontalTab:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
    {
        NSWindow * W = self.window;
        NSScrollView * SV = tableView.enclosingScrollView;
        id NR = [SV nextValidKeyView]?:
                ([SV previousValidKeyView]?:
                ([SV nextKeyView]?:
                [SV previousKeyView]));
//LOG4iTM3(@"NR is: %@", NR);
        return (NR != nil) && [SV acceptsFirstResponder] && [W makeFirstResponder:SV];
    }
    NSInteger column = [tableView editedColumn];
    if(column == [tableView numberOfColumns] - 1)
    {
        NSInteger row = [tableView selectedRow];
        NSInteger max = [self numberOfRowsInTableView:tableView];
        if((row<0) || (row >= max - 1))
            row = ZER0;
        else
            ++row;
        if(row == [tableView selectedRow])
            [tableView deselectAll:self];
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        return YES;
    }
    else if(column != -1)
        return NO;
    else if(self.window.firstResponder == tableView)
    {
        NSInteger row = [tableView selectedRow];
        NSInteger max = [self numberOfRowsInTableView:tableView];
        if((row<0) || (row >= max))
            row = ZER0;
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        row = [tableView selectedRow];
        NSInteger column = ZER0;
        if([self tableView:tableView shouldEditTableColumn:[[tableView tableColumns] objectAtIndex:column] row:row])
        {
			NSInvocation * I;
			[[NSInvocation getInvocation4iTM3:&I withTarget:tableView retainArguments:NO]
				editColumn:column row:row withEvent:nil select:YES];
            [NSTimer scheduledTimerWithTimeInterval:0.0 invocation:I repeats:NO];
        }
        return YES;
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeDelete:
- (BOOL)interpretKeyStrokeDelete:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([tableView editedColumn] != -1)
        return NO;
    else if(self.window.firstResponder == tableView)
    {
        [self deleteSelectedSymbolsInTableView:tableView];
//END4iTM3;
        return YES;
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeBackspace:
- (BOOL)interpretKeyStrokeBackspace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([tableView editedColumn] != -1)
        return NO;
    else if(self.window.firstResponder == tableView)
    {
        [self deleteSelectedSymbolsInTableView:tableView];
//END4iTM3;
        return YES;
    }
//END4iTM3;
    return NO;
}
@synthesize tableView;
@synthesize addSetPanel;
@synthesize _BuiltInSymbolsSets;
@synthesize _NetworkSymbolsSets;
@synthesize _LocalSymbolsSets;
@synthesize _CustomSymbolsSets;
@synthesize _CustomObjectsSets;
@synthesize _CustomKeysSets;
@synthesize _EditedObjectsSets;
@synthesize _RecycleSymbolsSets;
@synthesize _AllSymbolsSets;
@synthesize _CurrentSetItem;
@synthesize _Background;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([self.delegate respondsToSelector:@selector(tableView:changeFont:)])
        [(id)self.delegate tableView:self changeFont:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeColor:
- (void)changeColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([self.delegate respondsToSelector:@selector(tableView:changeColor:)])
        [(id)self.delegate tableView:self changeColor:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  draggingSourceOperationMaskForLocal:
- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![self.dataSource tableView:self writeRowsWithIndexes:self.selectedRowIndexes toPasteboard:[NSPasteboard generalPasteboard]]) {
        LOG4iTM3(@"Could not write to the general paste board");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return self.numberOfSelectedRows > ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  paste:
- (IBAction)paste:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [(id)self.dataSource tableView:self paste:[NSPasteboard generalPasteboard]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePaste:
- (BOOL)validatePaste:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [[[NSPasteboard generalPasteboard] availableTypeFromArray:[NSArray arrayWithObjects:iTM2StyleSymbolsPboardType, NSStringPboardType, nil]] length] > ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delete:
- (IBAction)delete:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [(id)self.dataSource deleteSelectedSymbolsInTableView:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDelete:
- (BOOL)validateDelete:(NSMenuItem *)menuItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (self.numberOfSelectedRows>ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cut:
- (IBAction)cut:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return self.numberOfSelectedRows > ZER0;
}
@end
