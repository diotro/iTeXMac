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

#import <iTM2Foundation/iTM2TextStyleEditionKit.h>
#import <iTM2Foundation/iTM2TextStorageKit.h>

#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2TextDocumentKit.h>
//#import <iTM2Foundation/iTM2CompatibilityChecker.h>
#import <iTM2Foundation/iTM2CursorKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2textFieldKit.h>
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

#define TABLE @"TextStyle"
#define BUNDLE [iTM2TextStyleDocument classBundle]

NSString * const iTM2TextStyleVariantShouldUpdate = @"iTM2TextStyleVariantShouldUpdateNotification";

@interface iTM2TextSyntaxParser(Editor)
+ (void)viewSyntaxParserStyles;
+ (void)editSyntaxParserVariant:(NSString *)variant;
+ (BOOL)canEditSyntaxParserVariant:(NSString *)variant;
+ (void)removeSyntaxParserVariant:(NSString *)variant;
+ (BOOL)canRemoveSyntaxParserVariant:(NSString *)variant;
+ (NSString *)createNewSyntaxParserVariant;
+ (NSString *)sampleString;
@end

/*!
	@class			iTM2TextNewSyntaxParserVariantController
	@superclass		iTM2Inspector
	@abstract		Abstract forthcoming.
	@discussion		This is a modal window to input a styel variant name.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextNewSyntaxParserVariantController: iTM2Inspector
+ (NSString *)createNewSyntaxParserVariantForStyle:(NSString *)style;
- (NSString *)style;
- (void)setStyle:(id)argument;
- (NSString *)variant;
- (void)setVariant:(id)argument;
@end

NSString * const _iTM2TextNewSyntaxParserVariantName = @"_iTM2TextNewSyntaxParserVariantName";

@implementation iTM2TextSyntaxParser(iTM2TextStyleEditionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  viewSyntaxParserStyles
+ (void)viewSyntaxParserStyles;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    Class C = [iTM2TextStyleDocument class];
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    id document;
    while(document = [E nextObject])
    {
        if([document class] == C)
        {
			if([SDC shouldCreateUI])
			{
				[document makeWindowControllers];
				[document showWindows];
			}
            return;
        }
    }
    document = [[[C alloc] init] autorelease];
    [SDC addDocument:document];
	if([SDC shouldCreateUI])
	{
		[document makeWindowControllers];
		[document showWindows];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editSyntaxParserVariant:
+ (void)editSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    Class C = [self attributesDocumentClass];
//iTM2_LOG(@"C is: %@", NSStringFromClass(C));
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    id document;
    while(document = [E nextObject])
    {
        if(([document class] == C) && ([[document syntaxParserVariant] isEqualToString:variant]))
        {
			if([SDC shouldCreateUI])
			{
				[document makeWindowControllers];
				[document showWindows];
			}
            return;
        }
    }
	NSError * localError = nil;
	if(document = [[[C alloc] initWithSyntaxParserVariant:variant error:&localError] autorelease])
	{
		[SDC addDocument:document];
		if([SDC shouldCreateUI])
		{
			[document makeWindowControllers];
			[document showWindows];
		}
	}
	else
	{
		iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Unexpected situation:Unable to create an instance of %@ with variant %@", C, variant]),localError);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canEditSyntaxParserVariant:
+ (BOOL)canEditSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self attributesDocumentClass] != nil
        && [[[self syntaxParserVariantsForStyle:[self syntaxParserStyle]] allKeys] containsObject:[variant lowercaseString]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSyntaxParserVariant:
+ (void)removeSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    if([[variant lowercaseString] isEqualToString:iTM2TextDefaultVariant])
        return;
    // Only local variant can be removed.
    // If there is something at path:
    // $iTM2_HOME/Library/Application\ Support/iTeXMac2/Editor/style.iTM2-Style/Variant.iTM2-Variant
    [self removeAttributesServerWithStyle:[self syntaxParserStyle] variant:variant];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canRemoveSyntaxParserVariant:
+ (BOOL)canRemoveSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![variant length])
        return NO;
    if([[variant lowercaseString] isEqualToString:iTM2TextDefaultVariant])
        return NO;
//iTM2_LOG(@"Variant is: %@ (%@)", variant, iTM2TextDefaultVariant);
    // Only local variant can be removed.
    // If there is something at path:
    // $iTM2_HOME/Library/Application\ Support/iTeXMac2/Editor/style.iTM2-Style/Variant.iTM2-Variant
	NSString * directory = [[iTM2TextStyleComponent stringByAppendingPathComponent:[self syntaxParserStyle]]
									stringByAppendingPathExtension: iTM2TextStyleExtension];
	NSString * stylePath = [[[NSBundle mainBundle] pathsForSupportResource:variant ofType:iTM2TextVariantExtension
		inDirectory: directory domains: NSUserDomainMask] lastObject];
//iTM2_LOG(@"stylePath is: %@", stylePath);
//iTM2_END;
    return [DFM fileExistsAtPath:stylePath];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewSyntaxParserVariant
+ (NSString *)createNewSyntaxParserVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [iTM2TextNewSyntaxParserVariantController createNewSyntaxParserVariantForStyle:[self syntaxParserStyle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesDocumentClass
+ (Class)attributesDocumentClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = [NSStringFromClass(self) stringByAppendingString:@"AttributesDocument"];
    Class result = NSClassFromString(name);
    if([result isSubclassOfClass:[iTM2TextSyntaxParserAttributesDocument class]])
        return result;
    else if(iTM2DebugEnabled)
    {
        iTM2_LOG(@"WARNING: Missing subclass of %@ named %@", [iTM2TextSyntaxParserAttributesDocument class], name);
    }
    return Nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sampleString
+ (NSString *)sampleString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * stylePath = [[self classBundle] pathForResource:iTM2TextStyleComponent ofType:nil];
	stylePath = [stylePath stringByAppendingPathComponent:[self syntaxParserStyle]];
	stylePath = [stylePath stringByAppendingPathExtension: iTM2TextStyleExtension];
	stylePath = [stylePath stringByAppendingPathComponent: @"sample"];
	stylePath = [stylePath stringByAppendingPathExtension: @"txt"];
    NSString * result = [NSString stringWithContentsOfFile:stylePath];
//iTM2_END;
    return result? result: @"Enter some text";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettySyntaxParserStyle
+ (NSString *)prettySyntaxParserStyle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringWithDefaultValue(@"Style", [@"iTM2TextStyle_" stringByAppendingString:[self syntaxParserStyle]], [self classBundle], [self syntaxParserStyle], "pretty syntax parser style");
}
@end

@implementation iTM2TextSyntaxParserAttributesServer(Editor)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettySyntaxParserVariant
- (NSString *)prettySyntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle([self syntaxParserVariant], [@"iTM2TextStyle_" stringByAppendingString:[[isa syntaxParserClass] syntaxParserStyle]], [self classBundle], "pretty syntax parser variant");
}
@end

NSString * const iTM2TextStyleInspectorType = @"TextStyle";

/*!
    @class	iTM2TextStyleDocument
    @abstract	Apstract forthcoming.
    @discussion	Discussion forthcoming.
                Both [self currentStyle] and [self currentVariant] are respectively set in the popUpStyle:and popUpVariant:methods.
                In the corresponding validate methods, if these instance variables are not set (0 length or nil)
                the popUp's menu items are removed and the menus populated with new up to date stuff.
                This is useful when you add a new variant or remove an old one.
*/

@implementation iTM2TextStyleDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextStyleInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayName
- (NSString *)displayName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"Styles";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= newRecentDocument
- (id)newRecentDocument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveDocument:
- (void)saveDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateSaveDocument:
- (BOOL)validateSaveDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveDocumentAs:
- (void)saveDocumentAs:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateSaveDocumentAs:
- (BOOL)validateSaveDocumentAs:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveDocumentTo:
- (void)saveDocumentTo:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateSaveDocumentTo:
- (BOOL)validateSaveDocumentTo:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
@end

@interface iTM2TextStyleInspector(PRIVATE)
- (NSString *)currentStyle;
- (void)setCurrentStyle:(id)argument;
- (NSString *)currentVariant;
- (void)setCurrentVariant:(id)argument;
- (NSTextView *)sampleTextView;
- (void)setSampleTextView:(id)argument;
@end

@implementation iTM2TextStyleInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextStyleInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentStyle
- (NSString *)currentStyle;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentStyle:
- (void)setCurrentStyle:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentVariant
- (NSString *)currentVariant;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentVariant:
- (void)setCurrentVariant:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sampleTextView
- (NSTextView *)sampleTextView;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSampleTextView:
- (void)setSampleTextView:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad:
- (void)windowDidLoad;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
	// replaceing the textstorage
    // now changing for an iTM2TextStorage!!!
	NSTextView * STV = [self sampleTextView];
    NSLayoutManager * LM = [STV layoutManager];
    NSTextStorage * oldTS = [LM textStorage];
    if(![oldTS isKindOfClass:[iTM2TextStorage class]])
	{
		iTM2TextStorage * TS = [[[iTM2TextStorage allocWithZone:[self zone]] initWithString:[oldTS string]] autorelease];
        [LM replaceTextStorage:TS];
	}
    // now validating the user interface
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
    BOOL result = [super validateWindowContent];
    // and after we set the correct style and variant for the text storage
    // at this point thet [self currentStyle] and currentVGariant are consistent
    // as set by other validate methods.
    iTM2TextStorage * TS = (iTM2TextStorage *)[[[self sampleTextView] layoutManager] textStorage];
    if([TS isKindOfClass:[iTM2TextStorage class]])
        [TS setSyntaxParserStyle:[self currentStyle] variant:[self currentVariant]];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpStyle:
- (IBAction)popUpStyle:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * new = [[sender selectedItem] representedObject];
    if(new && ![new isEqual:[self currentStyle]])
    {
        [self setCurrentStyle:new];
        [self setCurrentVariant:nil];
        [self validateWindowContent];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePopUpStyle:
- (BOOL)validatePopUpStyle:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        if(![[self currentStyle] length])
        {
            [sender removeAllItems];
            NSEnumerator * E = [iTM2TextSyntaxParser syntaxParserClassEnumerator];
            id C;
            while(C = [E nextObject])
            {
                [sender addItemWithTitle:[C prettySyntaxParserStyle]];
                [[sender lastItem] setRepresentedObject:[[C syntaxParserStyle] lowercaseString]];
            }
            if([sender numberOfItems])
            {
                [sender selectItemAtIndex:0];
                [self popUpStyle:sender];// beware, possible recursion here if no represented object is available
            }
        }
    //iTM2_END;
        return [sender numberOfItems] > 1;
    }
    else
        return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpVariant:
- (IBAction)popUpVariant:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * new = [[sender selectedItem] representedObject];
    if(![new isEqual:[self currentVariant]])
    {
        [self setCurrentVariant:new];
        [self validateWindowContent];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePopUpVariant:
- (BOOL)validatePopUpVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		NSString * variant = [self currentVariant];
        if([variant length])
		{
			variant = [variant lowercaseString];
			int index = [sender indexOfItemWithRepresentedObject:variant];
			if(index<0)
			{
                [sender selectItemAtIndex:0];
                [self popUpVariant:sender];
			}
			else
			{
                [sender selectItemAtIndex:index];
			}
		}
		else
        {
            [sender removeAllItems];
            NSEnumerator * E1 = [[iTM2TextSyntaxParser syntaxParserVariantsForStyle:[self currentStyle]] objectEnumerator];
            while(variant = [E1 nextObject])
            {
                [sender addItemWithTitle:variant];
				variant = [variant lowercaseString];
                [[sender lastItem] setRepresentedObject:variant];
            }
            if([sender numberOfItems])
            {
                [sender selectItemAtIndex:0];
                [self popUpVariant:sender];
            }
        }
        return [sender numberOfItems] > 1;
    }
    else
        return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editVariant:
- (IBAction)editVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2TextSyntaxParser syntaxParserClassForStyle:[self currentStyle]] editSyntaxParserVariant:[self currentVariant]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditVariant:
- (BOOL)validateEditVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[iTM2TextSyntaxParser syntaxParserClassForStyle:[self currentStyle]] canEditSyntaxParserVariant:[self currentVariant]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeVariant:
- (IBAction)removeVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self currentVariant] length])
	{
		[[iTM2TextSyntaxParser syntaxParserClassForStyle:[self currentStyle]] removeSyntaxParserVariant:[self currentVariant]];
		[self setCurrentVariant:nil];
		[self validateWindowContent];
		[INC postNotificationName:iTM2TextStyleVariantShouldUpdate object:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRemoveVariant:
- (BOOL)validateRemoveVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[iTM2TextSyntaxParser syntaxParserClassForStyle:[self currentStyle]] canRemoveSyntaxParserVariant:[self currentVariant]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newVariant:
- (IBAction)newVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    NSString * newVariant = [[iTM2TextSyntaxParser syntaxParserClassForStyle:[self currentStyle]] createNewSyntaxParserVariant];
	[INC postNotificationName:iTM2TextStyleVariantShouldUpdate object:nil];
    [self setCurrentVariant:nil];
    [self validateWindowContent];
    [self setCurrentVariant:newVariant];
    [self validateWindowContent];
    return;
}
@end

#define iTM2TSSMenuItemIndentationLevel [self contextIntegerForKey:@"iTM2TextSyntaxStyleMenuItemIndentationLevel" domain:iTM2ContextAllDomainsMask]

static NSMutableArray * _giTM2TextSyntaxMenus;
static NSMenu * _giTM2TextSyntaxMenu;
static NSMenuItem * _giTM2TextSyntaxMenuItemName;
static NSMenuItem * _giTM2TextSyntaxMenuItemVariant;
static NSString * _giTM2TextSyntaxFormat;

@implementation iTM2MainInstaller(TextSyntaxMenu)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextSyntaxMenuCompleteInstallation
+ (void)iTM2TextSyntaxMenuCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_giTM2TextSyntaxMenuItemName autorelease];
	_giTM2TextSyntaxMenuItemName = nil;
	[_giTM2TextSyntaxMenuItemVariant autorelease];
	_giTM2TextSyntaxMenuItemVariant = nil;
	[_giTM2TextSyntaxFormat autorelease];
	_giTM2TextSyntaxFormat = nil;
    // retrieving the menu item owning the menu item with action textStyleEdit:
    SEL action = @selector(textStyleEdit:);
    if(_giTM2TextSyntaxMenu = [[[[NSApp mainMenu] deepItemWithAction:action] menu] retain])
    {
		NSMenu * supermenu = [_giTM2TextSyntaxMenu supermenu];
        id MI = [supermenu itemAtIndex:[supermenu indexOfItemWithSubmenu:_giTM2TextSyntaxMenu]];
		[MI setRepresentedObject:@"Text Syntax Styles"];
		// completing the menu for consistency
		action = @selector(textStyleName:);
		_giTM2TextSyntaxMenuItemName = [[_giTM2TextSyntaxMenu deepItemWithAction:action] retain];
		if(_giTM2TextSyntaxMenuItemName)
		{
			[_giTM2TextSyntaxMenu removeItem:_giTM2TextSyntaxMenuItemName];
			[_giTM2TextSyntaxMenuItemName setAction:NULL];
		}
		else
		{
			iTM2_LOG(@"WARNING: Missing a  a text syntax parser style menu item with action: %@", NSStringFromSelector(action));
			_giTM2TextSyntaxMenuItemName = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
				initWithTitle: @"Style:" action: action keyEquivalent: @""];
		}
		action = @selector(textStyleVariant:);
		_giTM2TextSyntaxMenuItemVariant = [[_giTM2TextSyntaxMenu deepItemWithAction:action] retain];
		if(_giTM2TextSyntaxMenuItemVariant)
		{
			[_giTM2TextSyntaxMenu removeItem:_giTM2TextSyntaxMenuItemVariant];
			[_giTM2TextSyntaxMenuItemVariant setAction:NULL];
		}
		else
		{
			iTM2_LOG(@"WARNING: Missing a  a text syntax parser style menu item with action: %@", NSStringFromSelector(action));
			_giTM2TextSyntaxMenuItemVariant = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
				initWithTitle: @"Variant:" action: action keyEquivalent: @""];
		}
		action = @selector(textStyleFormat:);
		id mi = [_giTM2TextSyntaxMenu deepItemWithAction:action];
		_giTM2TextSyntaxFormat = [mi title];
		if([[_giTM2TextSyntaxFormat componentsSeparatedByString:@"%@"] count] != 3)
		{
			iTM2_LOG(@"Bad name for a text syntax parser style menu item with action: %@,\nexample \"%%@ (%%@ variant)\"", NSStringFromSelector(action));
			_giTM2TextSyntaxFormat = @"%@ (%@ variant)";
		}
		else
		{
			[_giTM2TextSyntaxFormat retain];
		}
		if(mi)
		{
			[_giTM2TextSyntaxMenu removeItem:mi];
			mi = nil;
		}
		action = @selector(textStyleToggleEnabled:);
		if(![_giTM2TextSyntaxMenu deepItemWithAction:action])
		{
			iTM2_LOG(@"WARNING: Missing a  a text syntax parser style menu item with action: %@", NSStringFromSelector(action));
			[_giTM2TextSyntaxMenu addItemWithTitle:@"Styles Text" action:action keyEquivalent:@""];
		}
        // replacing the menu by a new one
        [[MI menu] setSubmenu:[[[iTM2TextSyntaxMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease]
                forItem: MI];
		[[MI submenu] update];// Why is it necessary:Tiger is not cool! Panther was!
    }
    else
    {
        iTM2_LOG(@"WARNING: Missing a  a menu item with %@ action", NSStringFromSelector(action));
    }
    if(!_giTM2TextSyntaxMenus)
    {
        _giTM2TextSyntaxMenus = [[NSMutableArray array] retain];
        [INC addObserver:[iTM2TextSyntaxMenu class]
            selector: @selector(syntaxAttributesDidChangeNotified:)
                name: iTM2TextAttributesDidChangeNotification object: nil];
    }
//iTM2_END;
    return;
}
@end

@implementation iTM2TextSyntaxMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:1], @"iTM2TextSyntaxStyleMenuItemIndentationLevel", nil]];
	[INC addObserver:self selector:@selector(textStyleVariantShouldUpdateNotified:) name:iTM2TextStyleVariantShouldUpdate object:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleVariantShouldUpdateNotified:
+ (void)textStyleVariantShouldUpdateNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 04/06/06
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MI = [[NSApp mainMenu] deepItemWithRepresentedObject:@"Text Syntax Styles"];
	NSMenu * M = [[[iTM2TextSyntaxMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
	[[MI menu] setSubmenu:M forItem:MI];
	[[MI submenu] update];// Why is it necessary:Tiger is not cool! Panther was!
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxAttributesDidChangeNotified:
+ (void)syntaxAttributesDidChangeNotified:(NSNotification *)aNotification;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [_giTM2TextSyntaxMenus objectEnumerator];
    NSMenu * M;
    while(M = (NSMenu *)[[E nextObject] nonretainedObjectValue])
        while([M numberOfItems])
            [M removeItemAtIndex:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithTitle:
- (id)initWithTitle:(NSString *)aString;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithTitle:aString])
        [_giTM2TextSyntaxMenus addObject:[NSValue valueWithNonretainedObject:self]];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithCoder:aDecoder])
    {
        [_giTM2TextSyntaxMenus addObject:[NSValue valueWithNonretainedObject:self]];
        while([self numberOfItems])
            [self removeItemAtIndex:0];
    }
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_giTM2TextSyntaxMenus removeObject:[NSValue valueWithNonretainedObject:self]];
    [super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= update
- (void)update;
/*"Designated updater.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![self numberOfItems])
    {
		[self addItem:[[_giTM2TextSyntaxMenuItemName copy] autorelease]];
        SEL selector = @selector(textStyleToggle:);
        NSMutableDictionary * variants = [NSMutableDictionary dictionary];
        NSMutableDictionary * pretties = [NSMutableDictionary dictionary];
        NSEnumerator * E = [iTM2TextSyntaxParser syntaxParserClassEnumerator];
		NSDictionary * styles = nil;
		NSString * style = nil;
        id C;
        while(C = [E nextObject])
        {
//iTM2_LOG(@"C is: %@", C);
            style = [C syntaxParserStyle];
			styles = [iTM2TextSyntaxParser syntaxParserVariantsForStyle:style];
            [variants setObject:styles forKey:style];// problem here with app
			id key = [C prettySyntaxParserStyle];
            [pretties setObject:style forKey:key];
        }
        E = [[[pretties allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
        NSString * pretty;
        while(pretty = [E nextObject])
        {
            style = [pretties objectForKey:pretty];
			styles = [variants objectForKey:style];
			NSArray * RA = [[styles allKeys] sortedArrayUsingSelector:@selector(compare:)];
            if([RA count]>1)
            {
                id MI = [self addItemWithTitle:pretty action:NULL keyEquivalent:@""];
				[MI setIndentationLevel:iTM2TSSMenuItemIndentationLevel];
                [MI setRepresentedObject:pretty];
                NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
                [self setSubmenu:M forItem:MI];
				[M addItem:[[_giTM2TextSyntaxMenuItemVariant copyWithZone:[NSMenu menuZone]] autorelease]];
				[[[M itemArray] lastObject] setAction:NULL];
				NSEnumerator * e = [RA objectEnumerator];
				NSString * variant;
				while(variant = [e nextObject])
				{
					NSString * prettyVariant = [styles objectForKey:variant];
					id mi = [M addItemWithTitle:prettyVariant action:selector keyEquivalent:@""];
					[mi setIndentationLevel:iTM2TSSMenuItemIndentationLevel];
					[mi setRepresentedObject:[NSDictionary dictionaryWithObjectsAndKeys:
						[NSDictionary dictionaryWithObjectsAndKeys:variant, @"V",
							[style lowercaseString], @"S", nil], @"SV",
						variant, @"T", nil]];
				}
            }
            else if([RA count])
            {
                NSString * variant = [RA lastObject];
                id MI = [self addItemWithTitle:pretty action:selector keyEquivalent:@""];
				[MI setIndentationLevel:iTM2TSSMenuItemIndentationLevel];
                [MI setRepresentedObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSDictionary dictionaryWithObjectsAndKeys:variant, @"V",
						[style lowercaseString], @"S", nil],
					@"SV", nil]];
            }
        }
        if([_giTM2TextSyntaxMenu numberOfItems])
        {
            if([self numberOfItems])
                [self addItem:[NSMenuItem separatorItem]];
            E = [[_giTM2TextSyntaxMenu itemArray] objectEnumerator];
            id MI;
            while(MI = [E nextObject])
                [self addItem:[[MI copy] autorelease]];
        }
    }
    [super update];
    NSEnumerator * E = [[self itemArray] objectEnumerator];
    id MI;
    while(MI = [E nextObject])
    {
        NSString * title = [MI representedObject];
        if(title && [MI hasSubmenu])
        {
            NSEnumerator * EE = [[[MI submenu] itemArray] objectEnumerator];
            id mi;
            ici:
            if(mi = [EE nextObject])
            {
                [[NSApp targetForAction:[mi action] to:[mi target] from:mi] validateMenuItem:mi];
                if([mi state] == NSOnState)
                {
                    [MI setState:NSOnState];
                    [MI setTitle:[NSString stringWithFormat:_giTM2TextSyntaxFormat, title, [[mi representedObject] objectForKey:@"T"]]];
					[MI setIndentationLevel:iTM2TSSMenuItemIndentationLevel];
                    goto la;
                }
                else
                    goto ici;
            }
            [MI setState:NSOffState];
			[MI setIndentationLevel:iTM2TSSMenuItemIndentationLevel];
            [MI setTitle:title];
            la:;
        }
    }
    return;
}
@end

/*!
    @class	iTM2TextStyleTextView
    @abstract	Apstract forthcoming.
    @discussion	Discussion forthcoming.
*/

#warning THIS MIGHT LIVE IN THE iTM2TextDocumentKit, at least partly

@implementation NSTextView(iTM2TextStyleEditionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSTextView_iTM2MessageCatcher:
- (void)NSTextView_iTM2MessageCatcher:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
@end
@interface iTM2TextStyleResponder(PRIVATE)
- (id)textStorageTarget;
- (IBAction)textStyleEdit:(id)sender;
- (IBAction)textStyleToggleEnable:(id)sender;
@end
@implementation iTM2TextStyleResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager:
- (id)contextManager;
/*"Returns the contextManager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START
    NSTextStorage * TS = [self textStorageTarget];
    return TS?  [TS contextManager]:([NSApp keyWindow]?:[super contextManager]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggleEnabled:
- (IBAction)textStyleToggleEnabled:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask];
	id TS = [self textStorageTarget];
	iTM2TextInspector * WC = [[[[[[[TS layoutManagers] lastObject] textContainers] lastObject] textView] window] windowController];
	if([WC isKindOfClass:[iTM2TextInspector class]])
	{
		[[WC retain] autorelease];
		id document = [WC document];
		[document removeWindowController:WC];
		[document replaceInspectorMode:[[WC class] inspectorMode] variant:[WC inspectorVariant]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTextStyleToggleEnabled:
- (BOOL)validateTextStyleToggleEnabled:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self textStorageTarget] is:%@", [self textStorageTarget]);
	[sender setState:([self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask]?
		NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggle:
- (IBAction)textStyleToggle:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = [self textStorageTarget];
	if([TS isKindOfClass:[iTM2TextStorage class]])
	{
		NSDictionary * D = [[sender representedObject] objectForKey:@"SV"];
		[TS replaceSyntaxParserStyle:[D objectForKey:@"S"] variant:[D objectForKey:@"V"]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTextStyleToggle:
- (BOOL)validateTextStyleToggle:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = [self textStorageTarget];
	[sender setState:([TS isKindOfClass:[iTM2TextStorage class]] && [[[sender representedObject] objectForKey:@"SV"] isEqual:[NSDictionary dictionaryWithObjectsAndKeys:[[[[TS syntaxParser] attributesServer] syntaxParserVariant] lowercaseString], @"V", [[[[TS syntaxParser] class] syntaxParserStyle] lowercaseString], @"S", nil]]? NSOnState:NSOffState)];
//iTM2_END;
	return [TS isKindOfClass:[iTM2TextStorage class]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleEdit:
- (IBAction)textStyleEdit:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2TextSyntaxParser viewSyntaxParserStyles];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTextStyleEdit:
- (BOOL)validateTextStyleEdit:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStorageTarget
- (id)textStorageTarget;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id target = [NSApp targetForAction:@selector(NSTextView_iTM2MessageCatcher:)];
	id TS = (iTM2TextStorage *)[[target layoutManager] textStorage];
	if(TS) return TS;
    target = [SDC currentDocument];
    if([target respondsToSelector:@selector(textStorage)])
        return [target textStorage];
//iTM2_END;
    return nil;
}
@end

@interface iTM2TextStyleTextView: NSTextView
{
@private
    BOOL _SameXHeight;
}
- (void)setFont:(NSFont *)newF atIndex:(unsigned)location;
- (void)syntaxParserAttributesDidChange;
@end

enum {
	iTM2TSPTextAttributesMode=0,
	iTM2TSPTextBackgroundColorMode,
	iTM2TSPSelectionForegroundColorMode,
	iTM2TSPSelectionBackgroundColorMode,
	iTM2TSPInsertionPointColorMode,
	iTM2TSPViewBackgroundColorMode
};
@implementation iTM2TextStyleTextView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super awakeFromNib];
	iTM2TextStorage * TS = [[[iTM2TextStorage allocWithZone:[self zone]] init] autorelease];
    [[self layoutManager] replaceTextStorage:TS];
	[TS setAttributesChangeDelegate:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertText:
- (void)insertText:(id)insertString;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	if([TS isKindOfClass:[iTM2TextStorage class]])
	{
		id ACD = [TS attributesChangeDelegate];
		[TS setAttributesChangeDelegate:nil];
		[super insertText:insertString];
		[TS setAttributesChangeDelegate:ACD];
//iTM2_END;
		return;
	}
	[super insertText:insertString];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserAttributesDidChange
- (void)syntaxParserAttributesDidChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	if([TS isKindOfClass:[iTM2TextStorage class]])
	{
		iTM2TextSyntaxParser * SP = [TS syntaxParser];
		[SP setUpAllTextViews];
	}
	NSArray * LMs = [TS layoutManagers];
	NSEnumerator * E = [LMs objectEnumerator];
	NSLayoutManager * LM;
	NSRange range = NSMakeRange(0, [TS length]);
	while(LM = [E nextObject])
	{
		range.length = [LM firstUnlaidCharacterIndex];
		[LM invalidateGlyphsForCharacterRange:range changeInLength:0 actualCharacterRange:nil];
		[LM invalidateLayoutForCharacterRange:range isSoft:NO actualCharacterRange:nil];
	}
	NSWindow * W = [self window];
	NSWindowController * WC = [W windowController];
	NSDocument * D = [WC document];
	[D updateChangeCount:NSChangeDone];
	[WC validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage:wouldSetAttributes:range:
- (void)textStorage:(iTM2TextStorage *)TS wouldSetAttributes:(id)attributes range:(NSRange)range;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	if(![attributes isEqual:oldD])
	{
		NSMutableDictionary * newD = [[attributes mutableCopy] autorelease];
		NSString * mode = [oldD objectForKey:iTM2TextModeAttributeName];
		[newD setValue:mode forKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self performSelector:@selector(syntaxParserAttributesDidChange) withObject:nil afterDelay:0];
	}	
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage:wouldAddAttribute:value:range:
- (void)textStorage:(iTM2TextStorage *)TS wouldAddAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	id oldValue = [oldD objectForKey:name];
	if(![value isEqual:oldValue])
	{
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setValue:value forKey:name];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self performSelector:@selector(syntaxParserAttributesDidChange) withObject:nil afterDelay:0];
	}	
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedRange:affinity:stillSelecting:
- (void)setSelectedRange:(NSRange)charRange affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setSelectedRange:charRange affinity:affinity stillSelecting:stillSelectingFlag];
    [[[self window] windowController] validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeAttributes:
- (void)changeAttributes:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange range = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSDictionary * newD = [sender convertAttributes:oldD];
	if(![oldD isEqual:newD])
	{
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self syntaxParserAttributesDidChange];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeDocumentBackgroundColor:
- (void)changeDocumentBackgroundColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
	NSDictionary * oldD = [[SP attributesServer] attributesForMode:mode];
	id oldValue = [oldD objectForKey:NSBackgroundColorAttributeName];
	id value = [sender color];
	if(![value isEqual:oldValue])
	{
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setValue:value forKey:NSBackgroundColorAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self syntaxParserAttributesDidChange];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeFont:
- (void)changeFont:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSRange range = [self selectedRange];
    float xHeight = [[sender convertFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]] xHeight];
    if(range.length)
    {
        unsigned top = NSMaxRange(range);
        do
        {
            NSFont * oldF = [[SP attributesAtIndex:range.location effectiveRange:&range]
                objectForKey: NSFontAttributeName];
            NSFont * newF;
            newF = [sender convertFont:oldF];
            if(_SameXHeight)
                newF = [NSFont fontWithName:[newF fontName] size:[newF pointSize]/[newF xHeight]*xHeight];
            [self setFont:newF atIndex:range.location];
            range.location += MAX(1, range.length);
        }
        while(range.location < top);
    }
    else
    {
        if(range.location)
            --range.location;
        NSFont * oldF = [[SP attributesAtIndex:range.location effectiveRange:nil] objectForKey:NSFontAttributeName];
        NSFont * newF = [sender convertFont:oldF];
        if(_SameXHeight)
            newF = [NSFont fontWithName:[newF fontName] size:[newF pointSize]/[newF xHeight]*xHeight];
        [self setFont:newF atIndex:range.location];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFont:atIndex:
- (void)setFont:(NSFont *)newF atIndex:(unsigned)location;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSDictionary * D = [SP attributesAtIndex:location effectiveRange:nil];
    NSFont * oldF = [D objectForKey:NSFontAttributeName];
    if(![oldF isEqual:newF])
    {
        NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
		if(newF)
			[MD setObject:newF forKey:NSFontAttributeName];
		else
			[MD removeObjectForKey:NSFontAttributeName];
        D = [NSDictionary dictionaryWithDictionary:MD];
		NSString * mode = [D objectForKey:iTM2TextModeAttributeName];
        [[SP attributesServer] setAttributes:D forMode:mode];
		[self syntaxParserAttributesDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultColor:
- (void)defaultColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SCP setColor:[[NSColor whiteColor] colorWithAlphaComponent:0]];
    [[[self window] windowController] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subscript:
- (void)subscript:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange selectedRange = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSNumber * N = [oldD objectForKey:NSSuperscriptAttributeName];
	int level = [N intValue];
	--level;
	N = [NSNumber numberWithInt:level];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:N forKey:NSSuperscriptAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[[SP attributesServer] setAttributes:newD forMode:mode];
	[self syntaxParserAttributesDidChange];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  superscript:
- (void)superscript:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange selectedRange = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSNumber * N = [oldD objectForKey:NSSuperscriptAttributeName];
	int level = [N intValue];
	++level;
	N = [NSNumber numberWithInt:level];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:N forKey:NSSuperscriptAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[[SP attributesServer] setAttributes:newD forMode:mode];
	[self syntaxParserAttributesDidChange];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  underline:
- (void)underline:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange selectedRange = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSNumber * N = [NSNumber numberWithInt:1];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:N forKey:NSUnderlineStyleAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[[SP attributesServer] setAttributes:newD forMode:mode];
	[self syntaxParserAttributesDidChange];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unscript:
- (void)unscript:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange selectedRange = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:nil forKey:NSSuperscriptAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[[SP attributesServer] setAttributes:newD forMode:mode];
	[self syntaxParserAttributesDidChange];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignCenter:
- (void)alignCenter:(id)sender
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange range = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if(!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if([oldParagraphStyle alignment] != NSCenterTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSCenterTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self syntaxParserAttributesDidChange];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignLeft:
- (void)alignLeft:(id)sender
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange range = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if(!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if([oldParagraphStyle alignment] != NSLeftTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSLeftTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self syntaxParserAttributesDidChange];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignRight:
- (void)alignRight:(id)sender
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange range = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if(!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if([oldParagraphStyle alignment] != NSRightTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSRightTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self syntaxParserAttributesDidChange];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignJustified:
- (void)alignJustified:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange range = [self selectedRange];
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if(!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if([oldParagraphStyle alignment] != NSJustifiedTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSJustifiedTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[[SP attributesServer] setAttributes:newD forMode:mode];
		[self syntaxParserAttributesDidChange];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSameXHeight:
- (IBAction)toggleSameXHeight:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _SameXHeight = !_SameXHeight;
    [[[self window] windowController] validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSameXHeight:
- (BOOL)validateToggleSameXHeight:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:(_SameXHeight? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectedModeColor:
- (IBAction)toggleSelectedModeColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[sender window] isKeyWindow])
        return;
    NSColor * newVisibleC = [sender color];
//iTM2_LOG(@"newVisibleC is: %@", newVisibleC);
    if(newVisibleC && ![newVisibleC alphaComponent])
        newVisibleC = [NSColor textColor];
    NSColor * newC = [newVisibleC isEqual:[NSColor textColor]]? nil:newVisibleC;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSDictionary * D = [SP attributesAtIndex:[self selectedRange].location effectiveRange:nil];
    NSColor * oldC = [D objectForKey:NSForegroundColorAttributeName];
//iTM2_LOG(@"oldC is: %@", oldC);
//iTM2_LOG(@"newC is: %@", newC);
//iTM2_LOG(@"mode is: %@", [D objectForKey:iTM2TextModeAttributeName]);
    if(![oldC isEqual:newC] && (newC || oldC))
    {
//iTM2_LOG(@"REPLACING");
        NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
		[MD setValue:newC forKey:NSForegroundColorAttributeName];
        D = [NSDictionary dictionaryWithDictionary:MD];
        NSString * mode = [D objectForKey:iTM2TextModeAttributeName];
        if(![mode length])
        {
            iTM2_LOG(@"Don't know what is the mode!");
            return;
        }
        [[SP attributesServer] setAttributes:D forMode:[D objectForKey:iTM2TextModeAttributeName]];
		[self syntaxParserAttributesDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectedModeColor:
- (BOOL)validateToggleSelectedModeColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    NSRange charRange = [self selectedRange];
    NSColor * C = [NSColor textColor];
    if(charRange.location <= [TS length])
    {
        NSColor * c = [TS attribute:NSForegroundColorAttributeName atIndex:charRange.location effectiveRange:nil];
        if(c && [c alphaComponent])// BEWARE [C alphaComponent] != 0 even if C==nil
            C = c;
    }
    if(![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//iTM2_END;
    return [[sender window] isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectedModeBackgroundColor:
- (IBAction)toggleSelectedModeBackgroundColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[sender window] isKeyWindow])
        return;
    NSColor * newVisibleC = [sender color];
    if(!newVisibleC || ![newVisibleC alphaComponent])
        newVisibleC = [NSColor textBackgroundColor];
    NSColor * newC = [newVisibleC isEqual:[NSColor textBackgroundColor]]? nil:newVisibleC;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSRange selectedRange = [self selectedRange];
    NSDictionary * D = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
    NSColor * oldC = [D objectForKey:NSBackgroundColorAttributeName];
//iTM2_LOG(@"oldC is: %@", oldC);
//iTM2_LOG(@"newC is: %@", newC);
//iTM2_LOG(@"mode is: %@", [D objectForKey:iTM2TextModeAttributeName]);
    if(![oldC isEqual:newC] && (newC || oldC))
    {
        NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
		[MD setValue:newC forKey:NSBackgroundColorAttributeName];
        D = [NSDictionary dictionaryWithDictionary:MD];
        [[SP attributesServer] setAttributes:D forMode:[D objectForKey:iTM2TextModeAttributeName]];
		[self syntaxParserAttributesDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectedModeBackgroundColor:
- (BOOL)validateToggleSelectedModeBackgroundColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    NSRange charRange = [self selectedRange];
    NSColor * C = [NSColor textBackgroundColor];
    if(charRange.location <= [TS length])
    {
        NSColor * c = [TS attribute:NSBackgroundColorAttributeName atIndex:charRange.location effectiveRange:nil];
        if(c && [c alphaComponent])// BEWARE [C alphaComponent] != 0 even if C==nil
            C = c;
    }
    if(![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//iTM2_END;
    return [[sender window] isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectionColor:
- (IBAction)toggleSelectionColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[sender window] isKeyWindow])
        return;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSColor * newVisibleC = [sender color];
    NSColor * newC = [newVisibleC isEqual:[NSColor selectedTextColor]]? nil:newVisibleC;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[self selectedTextAttributes]];
//iTM2_LOG(@"OLD [self selectedTextAttributes] are:%@", [self selectedTextAttributes]);
    [MD addEntriesFromDictionary:[[SP attributesServer] attributesForMode:iTM2TextSelectionSyntaxModeName]];
    NSString * key = NSForegroundColorAttributeName;
    NSColor * oldC = [MD objectForKey:key];
    if(![oldC isEqual:newC] && (newC || oldC))
    {
		[MD setValue:newC forKey:key];
//        [MD setObject:[NSNumber numberWithInt:1] forKey:NSUnderlineStyleAttributeName];
        NSDictionary * D = [NSDictionary dictionaryWithDictionary:MD];
        [[SP attributesServer] setAttributes:D forMode:iTM2TextSelectionSyntaxModeName];
		[self syntaxParserAttributesDidChange];
//iTM2_LOG(@"NEW [self selectedTextAttributes] are:%@", [self selectedTextAttributes]);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectionColor:
- (BOOL)validateToggleSelectionColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSColor * C = [[self selectedTextAttributes] objectForKey:NSForegroundColorAttributeName];
    if(!C || ![C alphaComponent])
        C = [NSColor selectedTextColor];
    if(![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//iTM2_END;
    return [[sender window] isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectionBackgroundColor:
- (IBAction)toggleSelectionBackgroundColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[sender window] isKeyWindow])
        return;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSColor * newVisibleC = [sender color];
    NSColor * newC = [newVisibleC isEqual:[NSColor selectedTextBackgroundColor]]? nil:newVisibleC;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[self selectedTextAttributes]];
    [MD addEntriesFromDictionary:[[SP attributesServer] attributesForMode:iTM2TextSelectionSyntaxModeName]];
    NSString * key = NSBackgroundColorAttributeName;
    NSColor * oldC = [MD objectForKey:key];
    if(![oldC isEqual:newC] && (newC || oldC))
    {
		[MD setValue:newC forKey:key];
        NSDictionary * D = [NSDictionary dictionaryWithDictionary:MD];
        [[SP attributesServer] setAttributes:D forMode:iTM2TextSelectionSyntaxModeName];
		[self syntaxParserAttributesDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectionBackgroundColor:
- (BOOL)validateToggleSelectionBackgroundColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSColor * C = [[self selectedTextAttributes] objectForKey:NSBackgroundColorAttributeName];
    if(!C || ![C alphaComponent])
        C = [NSColor selectedTextBackgroundColor];
    if(![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//iTM2_END;
    return [[sender window] isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleInsertionColor:
- (IBAction)toggleInsertionColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[sender window] isKeyWindow])
        return;
    NSString * key = NSForegroundColorAttributeName;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSColor * newVisibleC = [sender color];
    NSColor * newC = ([newVisibleC isEqual:[NSColor textColor]]? nil:newVisibleC);
    NSString * mode = iTM2TextInsertionSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:
                                        [[SP attributesServer] attributesForMode:mode]];
    NSColor * oldC = [MD objectForKey:key];
    if(![oldC isEqual:newC] && (newC || oldC))
    {
		[MD setValue:newC forKey:key];
        [[SP attributesServer] setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
		[self syntaxParserAttributesDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleInsertionColor:
- (BOOL)validateToggleInsertionColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self insertionPointColor] is:%@", [self insertionPointColor]);
    NSColor * C = [self insertionPointColor];
    if(!C || ![C alphaComponent])
        C = [NSColor textColor];
    if(![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//iTM2_END;
    return [[sender window] isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTextViewBackgroundColor:
- (IBAction)toggleTextViewBackgroundColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[sender window] isKeyWindow])
        return;
    NSString * key = NSBackgroundColorAttributeName;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSColor * newVisibleC = [sender color];
    if(newVisibleC && ![newVisibleC alphaComponent])
        newVisibleC = [NSColor textBackgroundColor];
    NSColor * newC = ([newVisibleC isEqual:[NSColor textBackgroundColor]]? nil:newVisibleC);
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:
                                    [[SP attributesServer] attributesForMode:mode]];
    NSColor * oldC = [MD objectForKey:key];
    if(![oldC isEqual:newC] && (newC || oldC))
    {
		if(newC)
			[MD setObject:newC forKey:key];
		else
			[MD removeObjectForKey:key];
        [[SP attributesServer] setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
		[self syntaxParserAttributesDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTextViewBackgroundColor:
- (BOOL)validateToggleTextViewBackgroundColor:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self backgroundColor] is:%@", [self backgroundColor]);
    NSString * key = NSBackgroundColorAttributeName;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
	NSDictionary * attributes = [[SP attributesServer] attributesForMode:mode];
    NSColor * C = [attributes objectForKey:key];
    if(!C || ![C alphaComponent])
        C = [NSColor textBackgroundColor];
    if(![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//iTM2_END;
    return [[sender window] isKeyWindow] && ![[attributes objectForKey:iTM2NoBackgroundAttributeName] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editModeName:
- (IBAction)editModeName:(id)sender;
/*"Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	//this is just a message catcher
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditModeName:
- (BOOL)validateEditModeName:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * mode = @"";
    NSRange range = [self selectedRange];
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
	NSDictionary * D = nil;
    if(range.length)
    {
        unsigned top = NSMaxRange(range);
        D = [SP attributesAtIndex:range.location effectiveRange:&range];
        mode = [D objectForKey:iTM2TextModeAttributeName];
next:
        range.location += range.length;
        if(top > range.location)
        {
            D = [SP attributesAtIndex:range.location effectiveRange:&range];
            NSString * m = [D objectForKey:iTM2TextModeAttributeName];
            if([m isEqualToString:mode])
                goto next;
            else
			{
                mode = NSLocalizedStringFromTableInBundle(@"Multiple modes", TABLE, BUNDLE, "Description forthcoming");
				[sender setStringValue:mode];
				return YES;
			}
        }
    }
	else
	{
		unsigned start,contentsEnd;
		[TS getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:range];
		if(range.location<contentsEnd)
		{
			D = [SP attributesAtIndex:range.location effectiveRange:nil];
		}
		else if(range.location>start)
		{
			D = [SP attributesAtIndex:range.location-1 effectiveRange:nil];
		}
		else
		{
			D = [SP attributesAtIndex:range.location effectiveRange:nil];
		}
		mode = [D objectForKey:iTM2TextModeAttributeName];
	}
	if([mode length])
	{
		mode = NSLocalizedStringFromTableInBundle(mode, [@"iTM2TextStyle_" stringByAppendingString:[[SP class] syntaxParserStyle]], [SP classBundle], "Description forthcoming");
	}
	else
	{
		mode = NSLocalizedStringFromTableInBundle(@"No mode", TABLE, BUNDLE, "Description forthcoming");
	}
    [sender setStringValue:mode];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNoBackground:
- (IBAction)toggleNoBackground:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:
                                    [[SP attributesServer] attributesForMode:mode]];
    BOOL oldFlag = [[MD objectForKey:iTM2NoBackgroundAttributeName] boolValue];
    [MD setObject:[NSNumber numberWithBool:!oldFlag] forKey:iTM2NoBackgroundAttributeName];
    [[SP attributesServer] setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
    [SP setUpAllTextViews];
    NSWindowController * WC = [[self window] windowController];
    [[WC document] updateChangeCount:NSChangeDone];
    [WC validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNoBackground:
- (BOOL)validateToggleNoBackground:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    BOOL oldFlag = [[[[SP attributesServer] attributesForMode:mode] objectForKey:iTM2NoBackgroundAttributeName] boolValue];
    [sender setState:(oldFlag? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCursorIsWhite:
- (IBAction)toggleCursorIsWhite:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[[SP attributesServer] attributesForMode:mode]];
    BOOL was = [[MD objectForKey:iTM2CursorIsWhiteAttributeName] boolValue];
    [MD setObject:[NSNumber numberWithBool:!was] forKey:iTM2CursorIsWhiteAttributeName];
    [[SP attributesServer] setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
    [SP setUpAllTextViews];
    NSWindowController * WC = [[self window] windowController];
    [[WC document] updateChangeCount:NSChangeDone];
    [WC validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCursorIsWhite:
- (BOOL)validateToggleCursorIsWhite:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? [TS syntaxParser]:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[[SP attributesServer] attributesForMode:mode]];
    BOOL cursorIsWhite = [[MD objectForKey:iTM2CursorIsWhiteAttributeName] boolValue];
    [sender setState:(cursorIsWhite? NSOnState:NSOffState)];
    NSClipView * CV = (NSClipView *)[self superview];
    if([CV isKindOfClass:[NSClipView class]])
    {
        [CV setDocumentCursor:(cursorIsWhite? [NSCursor whiteIBeamCursor]:[NSCursor IBeamCursor])];
        [[self window] invalidateCursorRectsForView:self];
    }
    return YES;
}
@end
#if 0
APPKIT_EXTERN NSString *NSFontAttributeName;             // NSFont, default Helvetica 12
APPKIT_EXTERN NSString *NSParagraphStyleAttributeName;   // NSParagraphStyle, default defaultParagraphStyle
APPKIT_EXTERN NSString *NSForegroundColorAttributeName;  // NSColor, default blackColor
APPKIT_EXTERN NSString *NSUnderlineStyleAttributeName;   // int, default 0: no underline
APPKIT_EXTERN NSString *NSSuperscriptAttributeName;      // int, default 0
APPKIT_EXTERN NSString *NSBackgroundColorAttributeName;  // NSColor, default nil: no background
APPKIT_EXTERN NSString *NSAttachmentAttributeName;       // NSTextAttachment, default nil
APPKIT_EXTERN NSString *NSLigatureAttributeName;         // int, default 1: default ligatures, 0: no ligatures, 2: all ligatures
APPKIT_EXTERN NSString *NSBaselineOffsetAttributeName;   // float, in points; offset from baseline, default 0
APPKIT_EXTERN NSString *NSKernAttributeName;             // float, amount to modify default kerning, if 0, kerning off
APPKIT_EXTERN NSString *NSLinkAttributeName;		 // NSURL (preferred) or NSString

APPKIT_EXTERN NSString *NSStrokeWidthAttributeName		AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // float, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
APPKIT_EXTERN NSString *NSStrokeColorAttributeName		AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSColor, default nil: same as foreground color */
APPKIT_EXTERN NSString *NSUnderlineColorAttributeName		AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSColor, default nil: same as foreground color */
APPKIT_EXTERN NSString *NSStrikethroughStyleAttributeName	AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // int, default 0: no strikethrough */
APPKIT_EXTERN NSString *NSStrikethroughColorAttributeName	AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSColor, default nil: same as foreground color */
APPKIT_EXTERN NSString *NSShadowAttributeName			AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSShadow, default nil: no shadow */
APPKIT_EXTERN NSString *NSObliquenessAttributeName		AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // float; skew to be applied to glyphs, default 0: no skew */
APPKIT_EXTERN NSString *NSExpansionAttributeName		AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // float; log of expansion factor to be applied to glyphs, default 0: no expansion */
APPKIT_EXTERN NSString *NSCursorAttributeName			AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSCursor, default IBeamCursor */
APPKIT_EXTERN NSString *NSToolTipAttributeName			AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSString, default nil: no tooltip */

/* An integer value.  The value is interpreted as Apple Type Services kCharacterShapeType selector + 1.
 * default is 0 (disable). 1 is kTraditionalCharactersSelector and so on.
 * Refer to <ATS/SFNTLayoutTypes.h>
 */
APPKIT_EXTERN NSString *NSCharacterShapeAttributeName;

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
/* An NSGlyphInfo object.  This provides a means to override the standard glyph generation.  NSLayoutManager will assign the glyph specified by this glyph info to the entire attribute range, provided that its contents match the specified base string, and that the specified glyph is available in the font specified by NSFontAttributeName.
*/
APPKIT_EXTERN NSString *NSGlyphInfoAttributeName;
#endif

/* This defines currently supported values for NSUnderlineStyleAttributeName and NSStrikethroughAttributeName, as of Mac OS X version 10.3.  The style, pattern, and optionally by-word mask are or'd together to produce the value.  The previous constants are still supported, but deprecated (except for NSUnderlineByWordMask); including NSUnderlineStrikethroughMask in the underline style will still produce a strikethrough, but that is deprecated in favor of setting NSStrikethroughStyleAttributeName using the values described here.
*/
enum {
    NSUnderlineStyleNone		= 0x00,
    NSUnderlineStyleSingle		= 0x01,
    NSUnderlineStyleThick		= 0x02,
    NSUnderlineStyleDouble		= 0x09
};

enum {
    NSUnderlinePatternSolid		= 0x0000,
    NSUnderlinePatternDot		= 0x0100,
    NSUnderlinePatternDash		= 0x0200,
    NSUnderlinePatternDashDot		= 0x0300,
    NSUnderlinePatternDashDotDot	= 0x0400
};

APPKIT_EXTERN unsigned NSUnderlineByWordMask; 
#endif

@interface iTM2TextSyntaxParserAttributesDocument(PRIVATE)
- (void)setSyntaxParserVariant:(NSString *)SPV;
@end

NSString * const iTM2TextSyntaxParserAttributesInspectorType = @"TextSyntaxParserAttributes";

@implementation iTM2TextSyntaxParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextSyntaxParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserClass
+ (Class)syntaxParserClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = NSStringFromClass(self);
    NSAssert1([name hasSuffix:@"AttributesDocument"],
        @"Attributes server class %@ is not suffixed with \"AttributesDocument\"", name);
    name = [name substringWithRange:NSMakeRange(0, [name length] - 18)];
    Class result = NSClassFromString(name);
    if(iTM2DebugEnabled)
    {
        NSAssert1(result, @"Missing syntax parser class named %@", name);
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSyntaxParserVariant
- (void)setSyntaxParserVariant:(NSString *)SPV;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(SPV);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithSyntaxParserVariant:error:
- (id)initWithSyntaxParserVariant:(NSString *)variant error:(NSError **)outErrorPtr;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![variant length])
    {
        [self dealloc];
        return nil;
    }
    else if(self = [super init])
    {
		[self setSyntaxParserVariant:variant];
        [self setFileType:@"iTeXMac2 private document"];
		[self setFileName:
			[[[[[[NSBundle mainBundle] pathForSupportDirectory:iTM2TextStyleComponent inDomain:NSUserDomainMask create:YES]
				stringByAppendingPathComponent: [[isa syntaxParserClass] syntaxParserStyle]] 
					stringByAppendingPathExtension: iTM2TextStyleExtension]
						stringByAppendingPathComponent: [self syntaxParserVariant]]
							stringByAppendingPathExtension: iTM2TextVariantExtension]];
		[self readFromURL:[self fileURL] ofType:[self fileType] error:outErrorPtr];
    }
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayName
- (NSString *)displayName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:
        NSLocalizedStringFromTableInBundle(@"Style: %@ (%@)", TABLE, BUNDLE, "Comment forthcoming"),
        [[[self class] syntaxParserClass] syntaxParserStyle], [self syntaxParserVariant]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggle:
- (IBAction)textStyleToggle:(id)sender;
/*"Designated initializer. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleEdit:
- (IBAction)textStyleEdit:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(NSStringFromSelector([sender action]));
    SEL A = [sender action];
    if((A == @selector(textStyleToggle:))
            || (A == @selector(textStyleEdit:)))
        return NO;
    else if(A == @selector(saveDocument:))
        return [self isDocumentEdited];
    else if(A == @selector(revertDocumentToSaved:))
        return [self isDocumentEdited];
    return [super validateMenuItem:(id) sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertDocumentToSaved:
- (void)revertDocumentToSaved:(id)sender;
/*"Description forthcoming.
Subclassers will prepend their own stuff
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * stylePath =
		[[[[[[NSBundle mainBundle] pathForSupportDirectory:iTM2TextStyleComponent inDomain:NSUserDomainMask create:YES]
			stringByAppendingPathComponent: [[isa syntaxParserClass] syntaxParserStyle]] 
				stringByAppendingPathExtension: iTM2TextStyleExtension]
					stringByAppendingPathComponent: [self syntaxParserVariant]]
						stringByAppendingPathExtension: iTM2TextVariantExtension];
	[self setFileName:stylePath];
	[super revertDocumentToSaved:sender];
    [self validateWindowsContents];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (void)saveDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * style = [[isa syntaxParserClass] syntaxParserStyle];
	NSString * variant = [self syntaxParserVariant];
    NSString * stylePath =
		[[[[[[NSBundle mainBundle] pathForSupportDirectory:iTM2TextStyleComponent inDomain:NSUserDomainMask create:YES]
			stringByAppendingPathComponent: style] 
				stringByAppendingPathExtension: iTM2TextStyleExtension]
					stringByAppendingPathComponent: variant]
						stringByAppendingPathExtension: iTM2TextVariantExtension];
//iTM2_LOG(@"stylePath is: %@", stylePath);
    // preparing the storing location
	NSError * localError = nil;
    BOOL isDirectory;
    if([DFM fileExistsAtPath:stylePath isDirectory:&isDirectory])
    {
        if(isDirectory)
            goto save;
        else
        {
#if 0
#warning DEBUGGGGGGGINNNNNGGGGGGG =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#else
            if(![[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation
                source: [stylePath stringByDeletingLastPathComponent]
                    destination: @""
                        files: [NSArray arrayWithObject:[stylePath lastPathComponent]]
                            tag: nil])
#endif
            {
                iTM2_LOG(@"Something weird at path: %@, cannot recycle", stylePath);
                NSBeep();
                [[NSWorkspace sharedWorkspace] selectFile:stylePath inFileViewerRootedAtPath:[stylePath stringByDeletingLastPathComponent]];
    #warning THIS DOES NOT WORK!!!
                NSAppleScript * AS = [[[NSAppleScript allocWithZone:[self zone]]
                    initWithSource: [NSString stringWithFormat:@"tell application \"Finder\"\ractivate\rdisplay dialog \"Could not recycle %@\" buttons {\"OK\"} default button 1\rend tell", [stylePath lastPathComponent]]] autorelease];
                [AS executeAndReturnError:nil];
                return;
            }
            goto save;
        }
    }
    else if([DFM createDeepDirectoryAtPath:stylePath attributes:nil error:&localError])
	{
		goto save;
	}
    else if(localError)
	{
		[SDC presentError:localError];
        return;
	}
	else
    {
        iTM2_LOG(@"Could not create the directory at path: %@", stylePath);
        return;
    }
	save:
	[self setFileName:stylePath];
    BOOL result = YES;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    id WC;
	NSString * type = [self fileType];
	NSURL * URL = [self fileURL];
    while(WC = [E nextObject])
	{
        if([WC respondsToSelector:@selector(writeToURL:ofType:error:)])
		{
			result = result && [WC writeToURL:URL ofType:type error:&localError];// only the last error is recorded
		}
	}
//iTM2_END;
	if(result)
	{
		[self updateChangeCount:NSChangeCleared];
		[INC postNotificationName:iTM2TextAttributesDidChangeNotification object:nil userInfo:
			[NSDictionary dictionaryWithObjectsAndKeys:style, @"style", variant, @"variant", nil]];
	}
    else if(iTM2DebugEnabled)
    {
        iTM2_LOG(@"Problem in saving the document...");
    }
	return;
}
#warning DEBUG
- (void)updateChangeCount:(NSDocumentChangeType)change;
{
	[super updateChangeCount:(NSDocumentChangeType)change];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL:ofType:error:
//- (BOOL) readFromFile: (NSString *) fileName ofType: (NSString *) type;
- (BOOL)dataCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fileName: %@", fileName);
	if(![absoluteURL isFileURL])
		return NO;
	[self makeWindowControllers];
    BOOL result = YES;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    id WC;
    while(WC = [E nextObject])
	{
//iTM2_LOG(@"WC is: %@", WC);
        if([WC respondsToSelector:@selector(readFromURL:ofType:error:)])
		{
			result = result && [WC readFromURL:absoluteURL ofType:typeName error:outErrorPtr];// only the last error will be recorded
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= newRecentDocument
- (id)newRecentDocument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;// it should not appear in the recent docs list
}
@end

@interface iTM2TextSyntaxParserAttributesInspector(PRIVATE)
- (id)attributesServer;
- (void)setAttributesServer:(id)argument;
- (NSTextView *)textView;
- (void)setTextView:(id)argument;
- (void)doPasteAllModes:(NSDictionary *)dictionary;
@end

@implementation iTM2TextSyntaxParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextSyntaxParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (NSTextView *)textView;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return (metaGETTER?: ([self window], metaGETTER));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextView:
- (void)setTextView:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
	[argument setDelegate:self];// for debugging purpose
//iTM2_END;
	return;
}
#if 0
- (void)textDidChange:(NSNotification *)notification;
{
	NSTextStorage * TS = [[self textView] textStorage];
	NSLog(@"TS is: <%@> (<%@>)", TS, [TS string]);
	return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesServer:
- (id)attributesServer;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributesServer:
- (void)setAttributesServer:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
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
    [[self window] setDelegate:self];
    [self validateWindowContent];
    [[self window] makeKeyAndOrderFront:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeKey:
- (void)windowDidBecomeKey:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSFontManager sharedFontManager] orderFrontFontPanel:self];
    [SCP setShowsAlpha:YES];
    [NSApp orderFrontColorPanel:self];
    return;
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
        NSLocalizedStringFromTableInBundle(@"%@ - Modes", TABLE, BUNDLE, "Comment forthcoming"),
        displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
//- (BOOL) readFromFile: (NSString *) fileName ofType: (NSString *) type;
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"For the revert to saved.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		return YES;
	}
    // make a copy of the attributes server, in order not to edit the shared attributes server
    iTM2TextStorage * TS = (iTM2TextStorage *)[[self textView] textStorage];
//iTM2_LOG(@"TS is: <%@>", TS);
    if([TS isKindOfClass:[iTM2TextStorage class]])
    {
		id document = [self document];
        NSString * style = [[[document class] syntaxParserClass] syntaxParserStyle];
		NSString * variant = [document syntaxParserVariant];
    	[TS setSyntaxParserStyle:style variant:variant];
        id old = [[TS syntaxParser] attributesServer];
		[self setAttributesServer:[[[[old class] allocWithZone:[old zone]]
            initWithVariant: [document syntaxParserVariant]] autorelease]];
        [[TS syntaxParser] replaceAttributesServer:[self attributesServer]];
		NSString * sampleString = [self valueForKey:@"sampleString_meta"];
		if(!sampleString)
		{
			sampleString = [[[TS syntaxParser] class] sampleString];
		}
        [[self textView] setString:sampleString];
    }
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
//- (BOOL) writeToFile: (NSString *) fileName ofType: (NSString *) type;
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		return YES;
	}
	NSString * fileName = [absoluteURL path];
    NSString * stylePath = [[fileName stringByAppendingPathComponent:iTM2TextAttributesModesComponent] stringByAppendingPathExtension:iTM2TextAttributesPathExtension];
	iTM2TextSyntaxParserAttributesServer * AS = [self attributesServer];
	NSDictionary * modesAttributes = [AS modesAttributes];
	NSString * sampleString = [[self textView] string];
	[self setValue:sampleString forKeyPath:@"sampleString_meta"];
	if(![[AS class] writeModesAttributes:modesAttributes toFile:stylePath error:outErrorPtr])
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Could not write the modes attributes at path:%@", stylePath]),nil);
//iTM2_END;
		return NO;
	}
	else
		return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  copyAllModes:
- (IBAction)copyAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * modes = [[self attributesServer] modesAttributes];
	if([modes count])
	{
		NSPasteboard * pboard = [NSPasteboard generalPasteboard];
		if([pboard changeCount] !=
				[pboard declareTypes:[NSArray arrayWithObject:@"iTM2TextStyleModesPboardType"] owner:nil])
		{
			[pboard setData:[NSArchiver archivedDataWithRootObject:modes] forType:@"iTM2TextStyleModesPboardType"];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCopyAllModes:
- (BOOL)validateCopyAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * modes = [[self attributesServer] modesAttributes];
//iTM2_END;
	return [modes count] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pasteAllModes:
- (IBAction)pasteAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSPasteboard * pboard = [NSPasteboard generalPasteboard];
	NSString * dataType = [pboard availableTypeFromArray:[NSArray arrayWithObject:@"iTM2TextStyleModesPboardType"]];
	if(dataType)
	{
		NSData * D = [pboard dataForType:dataType];
		if(D)
		{
			NSDictionary * DICT = [NSUnarchiver unarchiveObjectWithData:D];
			if([DICT isKindOfClass:[NSDictionary class]])
			{
				[self doPasteAllModes:DICT];
			}
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doPasteAllModes:
- (void)doPasteAllModes:(NSDictionary *)dictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id AS = [self attributesServer];
	[[[self undoManager] prepareWithInvocationTarget:self]doPasteAllModes:[AS modesAttributes]];
	NSEnumerator * E = [[AS modesAttributes] keyEnumerator];
	NSString * mode;
	while(mode = [E nextObject])
	{
		id attributes = [dictionary objectForKey:mode];
		if(attributes)
			[AS setAttributes:attributes forMode:mode];
	}
	// force to update the view when we paste
	NSString * style = [[[[self document] class] syntaxParserClass] syntaxParserStyle];
	[INC postNotificationName:iTM2TextAttributesDidChangeNotification object:nil userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:style, @"style", [AS variant], @"variant", nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePasteAllModes:
- (BOOL)validatePasteAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[NSPasteboard generalPasteboard] availableTypeFromArray:[NSArray arrayWithObject:@"iTM2TextStyleModesPboardType"]] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggle:
- (IBAction)textStyleToggle:(id)sender;
/*"Designated initializer. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTextStyleToggle:
- (BOOL)validateTextStyleToggle:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleEdit:
- (IBAction)textStyleEdit:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// this is just a message catcher
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTextStyleEdit:
- (BOOL)validateTextStyleEdit:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextAttributesKit

@implementation iTM2TextNewSyntaxParserVariantController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  style
- (NSString *)style;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStyle:
- (void)setStyle:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  variant
- (NSString *)variant;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setVariant:
- (void)setVariant:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewSyntaxParserVariantForStyle:
+ (NSString *)createNewSyntaxParserVariantForStyle:(NSString *)aStyle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TextNewSyntaxParserVariantController * controller = nil;
	if(controller = [[[self alloc] initWithWindowNibName:NSStringFromClass(self)] autorelease])
    {
        [controller setStyle:[[aStyle copy] autorelease]];
		[controller setWindowFrameAutosaveName:NSStringFromClass(self)];
        NSWindow * W = [controller window];
        if(W)
        {
			[controller validateWindowContent];
            [W makeKeyAndOrderFront:controller];
            if([NSApp runModalForWindow:W] == 1)
			{
				NSString * variant = [controller variant];
				if([variant length])
				{
					[iTM2TextSyntaxParser createAttributesServerWithStyle:[controller style] variant:variant];
					[W orderOut:controller];
					return variant;
				}
			}
            [W orderOut:controller];
        }
    }
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  styleEdited:
- (IBAction)styleEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStyleEdited:
- (BOOL)validateStyleEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue:([[iTM2TextSyntaxParser syntaxParserClassForStyle:[self style]] prettySyntaxParserStyle]?:@"")];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  variantEdited:
- (IBAction)variantEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = [sender stringValue];
	NSString * variant = [self variant];
    if(![variant pathIsEqual:name])
    {
		NSString * style = [self style];
		NSDictionary * variants = [iTM2TextSyntaxParser syntaxParserVariantsForStyle:style];
		NSArray * lowerKeys = [variants valueForKeyPath:@"allKeys.@lowercaseString"];
		NSString * lowerName = [name lowercaseString];
        if(![lowerKeys containsObject:lowerName])
        {
			name = [[name copy] autorelease];
            [self setVariant:name];
            [NSApp stopModalWithCode:1];
        }
    }
	NSWindow * W = [sender window];
    [W validateContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateVariantEdited:
- (BOOL)validateVariantEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue:([[self variant] length]? [self variant]:@"")];
    if(self != [sender delegate])
        [sender setDelegate:self];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  controlTextDidChange:
- (void)controlTextDidChange:(NSNotification *)aNotification
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [[aNotification userInfo] objectForKey:@"NSFieldEditor"];
    if(![[self variant] length])
    {
        [self setVariant:[[[TV string] copy] autorelease]];
		[self validateWindowContent];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[sender window] makeFirstResponder:nil];// force the text filed to end editing and send its message
//    [NSApp stopModalWithCode:1];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOK:
- (BOOL)validateOK:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ([[self variant] length]>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp stopModalWithCode:0];
//iTM2_END;
    return;
}
@end

@interface NSApplication(iTMEStyleMenuItem)
@end

@implementation NSApplication(iTMEStyleMenuItem)
- (IBAction)styleMenuItem:(id)sender;
{
	return;// message catcher
}
- (BOOL)validateStyleMenuItem:(id)sender;
{
	[sender setAction:@selector(submenuAction:)];
	if(![sender image])
	{
		NSString * identifier = @"iTM2FontsAndColors";
		NSString * name = [NSString stringWithFormat:@"iTM2:%@", identifier];
		NSImage * I = [NSImage imageNamed:name];
		if(!I)
		{
			NSString * path = [[iTM2Implementation classBundle] pathForImageResource:identifier];
			I = [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path];
			I = [I copy];
			[I setName:name];
			[I setScalesWhenResized:YES];
			[I setSize:NSMakeSize(16,16)];
		}
		[sender setImage:I];//size
	}
	return YES;// message catcher
}
@end
