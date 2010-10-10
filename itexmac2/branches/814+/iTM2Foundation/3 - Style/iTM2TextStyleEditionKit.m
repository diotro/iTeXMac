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

#import "iTM2TextStyleEditionKit.h"
#import "iTM2TextStorageKit.h"

#import "iTM2PathUtilities.h"
#import "iTM2BundleKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2ContextKit.h"
#import "iTM2MenuKit.h"
#import "iTM2StringKit.h"
#import "iTM2MiscKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2TextDocumentKit.h"
//#import "iTM2CompatibilityChecker.h"
#import "iTM2CursorKit.h"
#import "iTM2WindowKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2textFieldKit.h"
#import "iTM2ImageKit.h"

#define TABLE @"TextStyle"
#define BUNDLE [iTM2TextStyleDocument classBundle4iTM3]

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
@interface iTM2TextNewSyntaxParserVariantController: iTM2Inspector <NSTextFieldDelegate>
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    Class C = [iTM2TextStyleDocument class];
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    id document;
    while(document = E.nextObject)
    {
        if ([document class] == C)
        {
			[document makeWindowControllers];
			[document showWindows];
            return;
        }
    }
    document = [[[C alloc] init] autorelease];
    [SDC addDocument:document];
	[document makeWindowControllers];
	[document showWindows];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editSyntaxParserVariant:
+ (void)editSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    Class C = self.attributesDocumentClass;
//LOG4iTM3(@"C is: %@", NSStringFromClass(C));
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    id document;
    while(document = E.nextObject)
    {
        if (([document class] == C) && ([[document syntaxParserVariant] isEqualToString:variant]))
        {
			[document makeWindowControllers];
			[document showWindows];
            return;
        }
    }
	NSError * localError = nil;
	if (document = [[[C alloc] initWithSyntaxParserVariant:variant error:&localError] autorelease])
	{
		[SDC addDocument:document];
		[document makeWindowControllers];
		[document showWindows];
	}
	else
	{
		REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Unexpected situation:Unable to create an instance of %@ with variant %@", C, variant]),localError);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canEditSyntaxParserVariant:
+ (BOOL)canEditSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.attributesDocumentClass != nil
        && [[[self syntaxParserVariantsForStyle:self.syntaxParserStyle] allKeys] containsObject:[variant lowercaseString]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSyntaxParserVariant:
+ (void)removeSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    if ([[variant lowercaseString] isEqualToString:iTM2TextDefaultVariant])
        return;
    // Only local variant can be removed.
    // If there is something at path:
    // $HOME4iTM3/Library/Application\ Support/iTeXMac2/Editor/style.iTM2-Style/Variant.iTM2-Variant
    [self removeAttributesServerWithStyle:self.syntaxParserStyle variant:variant];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canRemoveSyntaxParserVariant:
+ (BOOL)canRemoveSyntaxParserVariant:(NSString *)variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!variant.length)
        return NO;
    if ([[variant lowercaseString] isEqualToString:iTM2TextDefaultVariant])
        return NO;
//LOG4iTM3(@"Variant is: %@ (%@)", variant, iTM2TextDefaultVariant);
    // Only local variant can be removed.
    // If there is something at path:
    // $HOME4iTM3/Library/Application\ Support/iTeXMac2/Editor/style.iTM2-Style/Variant.iTM2-Variant
	NSString * directory = [[iTM2TextStyleComponent stringByAppendingPathComponent:self.syntaxParserStyle]
									stringByAppendingPathExtension: iTM2TextStyleExtension];
	NSURL * styleURL = [[[NSBundle mainBundle] URLsForSupportResource4iTM3:variant withExtension:iTM2TextVariantExtension
		subdirectory: directory domains: NSUserDomainMask] lastObject];
//LOG4iTM3(@"styleURL is: %@", styleURL);
//END4iTM3;
    return [DFM fileExistsAtPath:styleURL.path];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewSyntaxParserVariant
+ (NSString *)createNewSyntaxParserVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [iTM2TextNewSyntaxParserVariantController createNewSyntaxParserVariantForStyle:self.syntaxParserStyle];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesDocumentClass
+ (Class)attributesDocumentClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = [NSStringFromClass(self) stringByAppendingString:@"AttributesDocument"];
    Class result = NSClassFromString(name);
    if ([result isSubclassOfClass:[iTM2TextSyntaxParserAttributesDocument class]])
        return result;
    else if (iTM2DebugEnabled)
    {
        LOG4iTM3(@"WARNING: Missing subclass of %@ named %@", [iTM2TextSyntaxParserAttributesDocument class], name);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * stylePath = [self.classBundle4iTM3 pathForResource:iTM2TextStyleComponent ofType:nil];
	stylePath = [stylePath stringByAppendingPathComponent:self.syntaxParserStyle];
	stylePath = [stylePath stringByAppendingPathExtension: iTM2TextStyleExtension];
	stylePath = [stylePath stringByAppendingPathComponent: @"sample"];
	stylePath = [stylePath stringByAppendingPathExtension: @"txt"];
    NSString * result = [NSString stringWithContentsOfFile:stylePath usedEncoding:nil error:nil];
//END4iTM3;
    return result? result: @"Enter some text";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettySyntaxParserStyle
+ (NSString *)prettySyntaxParserStyle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSLocalizedStringWithDefaultValue(@"Style", [@"iTM2TextStyle_" stringByAppendingString:self.syntaxParserStyle], self.classBundle4iTM3, self.syntaxParserStyle, "pretty syntax parser style");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSLocalizedStringFromTableInBundle(self.syntaxParserVariant, [@"iTM2TextStyle_" stringByAppendingString:[[self.class syntaxParserClass] syntaxParserStyle]], self.classBundle4iTM3, "pretty syntax parser variant");
}
@end

NSString * const iTM2TextStyleInspectorType = @"TextStyle";

/*!
    @class	iTM2TextStyleDocument
    @abstract	Apstract forthcoming.
    @discussion	Discussion forthcoming.
                Both self.currentStyle and self.currentVariant are respectively set in the popUpStyle:and popUpVariant:methods.
                In the corresponding validate methods, if these instance variables are not set (0 length or nil)
                the popUp's menu items are removed and the menus populated with new up to date stuff.
                This is useful when you add a new variant or remove an old one.
*/

@implementation iTM2TextStyleDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextStyleInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayName
- (NSString *)displayName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Styles";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= newRecentDocument
- (id)newRecentDocument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveDocument:
- (void)saveDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateSaveDocument:
- (BOOL)validateSaveDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveDocumentAs:
- (void)saveDocumentAs:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateSaveDocumentAs:
- (BOOL)validateSaveDocumentAs:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveDocumentTo:
- (void)saveDocumentTo:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateSaveDocumentTo:
- (BOOL)validateSaveDocumentTo:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextStyleInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentStyle
- (NSString *)currentStyle;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentStyle:
- (void)setCurrentStyle:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentVariant
- (NSString *)currentVariant;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentVariant:
- (void)setCurrentVariant:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sampleTextView
- (NSTextView *)sampleTextView;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSampleTextView:
- (void)setSampleTextView:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad:
- (void)windowDidLoad;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowDidLoad];
	// replaceing the textstorage
    // now changing for an iTM2TextStorage!!!
	NSTextView * STV = self.sampleTextView;
    NSLayoutManager * LM = [STV layoutManager];
    NSTextStorage * oldTS = [LM textStorage];
    if (![oldTS isKindOfClass:[iTM2TextStorage class]])
	{
		iTM2TextStorage * TS = [[[iTM2TextStorage alloc] initWithString:[oldTS string]] autorelease];
        [LM replaceTextStorage:TS];
	}
    // now validating the user interface
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
    BOOL result = [super validateWindowContent4iTM3];
    // and after we set the correct style and variant for the text storage
    // at this point thet self.currentStyle and currentVGariant are consistent
    // as set by other validate methods.
    iTM2TextStorage * TS = (iTM2TextStorage *)[[self.sampleTextView layoutManager] textStorage];
    if ([TS isKindOfClass:[iTM2TextStorage class]])
        [TS setSyntaxParserStyle:self.currentStyle variant:self.currentVariant];
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpStyle:
- (IBAction)popUpStyle:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * new = [[sender selectedItem] representedObject];
    if (new && ![new isEqual:self.currentStyle])
    {
        [self setCurrentStyle:new];
        [self setCurrentVariant:nil];
        self.validateWindowContent4iTM3;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePopUpStyle:
- (BOOL)validatePopUpStyle:(NSPopUpButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([sender isKindOfClass:[NSPopUpButton class]]) {
        if (!self.currentStyle.length)
        {
            sender.removeAllItems;
            for (Class C in [iTM2TextSyntaxParser syntaxParserClassEnumerator]) {
                [sender addItemWithTitle:[C prettySyntaxParserStyle]];
                sender.lastItem.representedObject = [[C syntaxParserStyle] lowercaseString];
            }
            if (sender.numberOfItems) {
                [sender selectItemAtIndex:0];
                [self popUpStyle:sender];// beware, possible recursion here if no represented object is available
            }
        }
    //END4iTM3;
        return sender.numberOfItems > 1;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * new = [[sender selectedItem] representedObject];
    if (![new isEqual:self.currentVariant])
    {
        [self setCurrentVariant:new];
        self.validateWindowContent4iTM3;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePopUpVariant:
- (BOOL)validatePopUpVariant:(NSPopUpButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([sender isKindOfClass:[NSPopUpButton class]]) {
		NSString * variant = self.currentVariant;
        if (variant.length) {
			variant = [variant lowercaseString];
			NSInteger index = [sender indexOfItemWithRepresentedObject:variant];
			if (index<0) {
                [sender selectItemAtIndex:0];
                [self popUpVariant:sender];
			} else {
                [sender selectItemAtIndex:index];
			}
		} else {
            sender.removeAllItems;
            for (variant in [iTM2TextSyntaxParser syntaxParserVariantsForStyle:self.currentStyle]) {
                [sender addItemWithTitle:variant];
				variant = [variant lowercaseString];
                sender.lastItem.representedObject = variant;
            }
            if (sender.numberOfItems) {
                [sender selectItemAtIndex:0];
                [self popUpVariant:sender];
            }
        }
        return sender.numberOfItems > 1;
    } else {
        return YES;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editVariant:
- (IBAction)editVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2TextSyntaxParser syntaxParserClassForStyle:self.currentStyle] editSyntaxParserVariant:self.currentVariant];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditVariant:
- (BOOL)validateEditVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[iTM2TextSyntaxParser syntaxParserClassForStyle:self.currentStyle] canEditSyntaxParserVariant:self.currentVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeVariant:
- (IBAction)removeVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.currentVariant.length) {
		[[iTM2TextSyntaxParser syntaxParserClassForStyle:self.currentStyle] removeSyntaxParserVariant:self.currentVariant];
		[self setCurrentVariant:nil];
		self.validateWindowContent4iTM3;
		[INC postNotificationName:iTM2TextStyleVariantShouldUpdate object:nil];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRemoveVariant:
- (BOOL)validateRemoveVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[iTM2TextSyntaxParser syntaxParserClassForStyle:self.currentStyle] canRemoveSyntaxParserVariant:self.currentVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newVariant:
- (IBAction)newVariant:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    NSString * newVariant = [[iTM2TextSyntaxParser syntaxParserClassForStyle:self.currentStyle] createNewSyntaxParserVariant];
	[INC postNotificationName:iTM2TextStyleVariantShouldUpdate object:nil];
    [self setCurrentVariant:nil];
    self.validateWindowContent4iTM3;
    [self setCurrentVariant:newVariant];
    self.validateWindowContent4iTM3;
    return;
}
@end

#define iTM2TSSMenuItemIndentationLevel [self contextIntegerForKey:@"iTM2TextSyntaxStyleMenuItemIndentationLevel" domain:iTM2ContextAllDomainsMask]

static NSHashTable * _gVarTextSyntaxMenus4iTM3;
static NSMenu * _gVarTextSyntaxMenu4iTM3;
static NSMenuItem * _gVarTextSyntaxMenuItemName4iTM3;
static NSMenuItem * _gVarTextSyntaxMenuItemVariant4iTM3;
static NSString * _gVarTextSyntaxFormat4iTM3;

@implementation iTM2MainInstaller(TextSyntaxMenu)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextSyntaxMenuCompleteInstallation4iTM3
+ (void)iTM2TextSyntaxMenuCompleteInstallation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[_gVarTextSyntaxMenuItemName4iTM3 autorelease];
	_gVarTextSyntaxMenuItemName4iTM3 = nil;
	[_gVarTextSyntaxMenuItemVariant4iTM3 autorelease];
	_gVarTextSyntaxMenuItemVariant4iTM3 = nil;
	[_gVarTextSyntaxFormat4iTM3 autorelease];
	_gVarTextSyntaxFormat4iTM3 = nil;
    // retrieving the menu item owning the menu item with action textStyleEdit:
    SEL action = @selector(textStyleEdit:);
    if (_gVarTextSyntaxMenu4iTM3 = [[[[NSApp mainMenu] deepItemWithAction4iTM3:action] menu] retain]) {
		NSMenu * supermenu = [_gVarTextSyntaxMenu4iTM3 supermenu];
        NSMenuItem * MI = [supermenu itemAtIndex:[supermenu indexOfItemWithSubmenu:_gVarTextSyntaxMenu4iTM3]];
		MI.representedObject = @"Text Syntax Styles";
		// completing the menu for consistency
		action = @selector(textStyleName:);
		_gVarTextSyntaxMenuItemName4iTM3 = [[_gVarTextSyntaxMenu4iTM3 deepItemWithAction4iTM3:action] retain];
		if (_gVarTextSyntaxMenuItemName4iTM3) {
			[_gVarTextSyntaxMenu4iTM3 removeItem:_gVarTextSyntaxMenuItemName4iTM3];
			_gVarTextSyntaxMenuItemName4iTM3.action = NULL;
		} else {
			LOG4iTM3(@"WARNING: Missing a  a text syntax parser style menu item with action: %@", NSStringFromSelector(action));
			_gVarTextSyntaxMenuItemName4iTM3 = [[NSMenuItem alloc]
				initWithTitle: @"Style:" action: action keyEquivalent: @""];
		}
		action = @selector(textStyleVariant:);
		_gVarTextSyntaxMenuItemVariant4iTM3 = [[_gVarTextSyntaxMenu4iTM3 deepItemWithAction4iTM3:action] retain];
		if (_gVarTextSyntaxMenuItemVariant4iTM3) {
			[_gVarTextSyntaxMenu4iTM3 removeItem:_gVarTextSyntaxMenuItemVariant4iTM3];
			_gVarTextSyntaxMenuItemVariant4iTM3.action = NULL;
		} else {
			LOG4iTM3(@"WARNING: Missing a  a text syntax parser style menu item with action: %@", NSStringFromSelector(action));
			_gVarTextSyntaxMenuItemVariant4iTM3 = [[NSMenuItem alloc]
				initWithTitle: @"Variant:" action: action keyEquivalent: @""];
		}
		action = @selector(textStyleFormat:);
		NSMenuItem * mi = [_gVarTextSyntaxMenu4iTM3 deepItemWithAction4iTM3:action];
		_gVarTextSyntaxFormat4iTM3 = mi.title;
		if ([[_gVarTextSyntaxFormat4iTM3 componentsSeparatedByString:@"%@"] count] != 3) {
			LOG4iTM3(@"Bad name for a text syntax parser style menu item with action: %@,\nexample \"%%@ (%%@ variant)\"", NSStringFromSelector(action));
			_gVarTextSyntaxFormat4iTM3 = @"%@ (%@ variant)";
		} else {
			[_gVarTextSyntaxFormat4iTM3 retain];
		}
		if (mi) {
			[_gVarTextSyntaxMenu4iTM3 removeItem:mi];
			mi = nil;
		}
		action = @selector(textStyleToggleEnabled:);
		if (![_gVarTextSyntaxMenu4iTM3 deepItemWithAction4iTM3:action]) {
			LOG4iTM3(@"WARNING: Missing a  a text syntax parser style menu item with action: %@", NSStringFromSelector(action));
			[_gVarTextSyntaxMenu4iTM3 addItemWithTitle:@"Styles Text" action:action keyEquivalent:@""];
		}
        // replacing the menu by a new one
        [MI.menu setSubmenu:[[[iTM2TextSyntaxMenu alloc] initWithTitle:MI.title] autorelease] forItem: MI];
		[[MI submenu] update];// Why is it necessary:Tiger is not cool! Panther was!
    } else {
        LOG4iTM3(@"WARNING: Missing a  a menu item with %@ action", NSStringFromSelector(action));
    }
    if (!_gVarTextSyntaxMenus4iTM3) {
        _gVarTextSyntaxMenus4iTM3 = [NSHashTable hashTableWithWeakObjects];
        [INC addObserver:[iTM2TextSyntaxMenu class]
            selector: @selector(syntaxAttributesDidChangeNotified:)
                name: iTM2TextAttributesDidChangeNotification object: nil];
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];// ?
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInteger:1], @"iTM2TextSyntaxStyleMenuItemIndentationLevel", nil]];
	[INC addObserver:self selector:@selector(textStyleVariantShouldUpdateNotified:) name:iTM2TextStyleVariantShouldUpdate object:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleVariantShouldUpdateNotified:
+ (void)textStyleVariantShouldUpdateNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 04/06/06
To Do List: NYI
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenuItem * MI = [[NSApp mainMenu] deepItemWithRepresentedObject4iTM3:@"Text Syntax Styles"];
	NSMenu * M = [[[iTM2TextSyntaxMenu alloc] initWithTitle:MI.title] autorelease];
	[MI.menu setSubmenu:M forItem:MI];
	MI.submenu.update;// Why is it necessary:Tiger is not cool! Panther was!
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxAttributesDidChangeNotified:
+ (void)syntaxAttributesDidChangeNotified:(NSNotification *)aNotification;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    for(NSMenu * M in _gVarTextSyntaxMenus4iTM3)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithTitle:aString])
        [_gVarTextSyntaxMenus4iTM3 addObject:self];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithCoder:aDecoder]) {
        [_gVarTextSyntaxMenus4iTM3 addObject:self];
        while (self.numberOfItems) [self removeItemAtIndex:0];
    }
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= finalize
- (void)finalize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [_gVarTextSyntaxMenus4iTM3 removeObject:self];
    [super finalize];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= update
- (void)update;
/*"Designated updater.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.numberOfItems) {
		[self addItem:[[_gVarTextSyntaxMenuItemName4iTM3 copy] autorelease]];
        SEL selector = @selector(textStyleToggle:);
        NSMutableDictionary * variants = [NSMutableDictionary dictionary];
        NSMutableDictionary * pretties = [NSMutableDictionary dictionary];
        NSDictionary * styles = nil;
		NSString * style = nil;
        for(Class C in [iTM2TextSyntaxParser syntaxParserClassEnumerator]) {
//LOG4iTM3(@"C is: %@", C);
            style = [C syntaxParserStyle];
			styles = [iTM2TextSyntaxParser syntaxParserVariantsForStyle:style];
            [variants setObject:styles forKey:style];// problem here with app
			id key = [C prettySyntaxParserStyle];
            [pretties setObject:style forKey:key];
        }
        for (NSString * pretty in [[pretties allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
            style = [pretties objectForKey:pretty];
			styles = [variants objectForKey:style];
			NSArray * RA = [[styles allKeys] sortedArrayUsingSelector:@selector(compare:)];
            if (RA.count>1) {
                NSMenuItem * MI = [self addItemWithTitle:pretty action:NULL keyEquivalent:@""];
				MI.indentationLevel = iTM2TSSMenuItemIndentationLevel;
                MI.representedObject = pretty;
                NSMenu * M = [[[NSMenu alloc] initWithTitle:MI.title] autorelease];
                [self setSubmenu:M forItem:MI];
				[M addItem:[[_gVarTextSyntaxMenuItemVariant4iTM3 copy] autorelease]];
				[M.itemArray.lastObject setAction:NULL];
				for (NSString * variant in RA) {
					NSString * prettyVariant = [styles objectForKey:variant];
					NSMenuItem * mi = [M addItemWithTitle:prettyVariant action:selector keyEquivalent:@""];
					mi.indentationLevel = iTM2TSSMenuItemIndentationLevel;
					mi.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSDictionary dictionaryWithObjectsAndKeys:variant, @"V",
							[style lowercaseString], @"S", nil], @"SV",
						variant, @"T", nil];
				}
            } else if (RA.count) {
                NSString * variant = RA.lastObject;
                NSMenuItem * MI = [self addItemWithTitle:pretty action:selector keyEquivalent:@""];
				MI.indentationLevel = iTM2TSSMenuItemIndentationLevel;
                MI.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:
					[NSDictionary dictionaryWithObjectsAndKeys:variant, @"V",
						[style lowercaseString], @"S", nil],
					@"SV", nil];
            }
        }
        if ([_gVarTextSyntaxMenu4iTM3 numberOfItems]) {
            if (self.numberOfItems) {
                [self addItem:[NSMenuItem separatorItem]];
            }
            for (NSMenuItem * MI in _gVarTextSyntaxMenu4iTM3.itemArray) {
                [self addItem:[[MI copy] autorelease]];
            }
        }
    }
    [super update];
    for (NSMenuItem * MI in self.itemArray) {
        NSString * title = [MI representedObject];
        if (title && [MI hasSubmenu]) {
            NSEnumerator * EE = MI.submenu.itemArray.objectEnumerator;
            NSMenuItem * mi;
ici:
            if (mi = EE.nextObject) {
                [[NSApp targetForAction:mi.action to:mi.target from:mi] validateMenuItem:mi];
                if ([mi state] == NSOnState) {
                    MI.state = NSOnState;
                    [MI setTitle:[NSString stringWithFormat:_gVarTextSyntaxFormat4iTM3, title, [[mi representedObject] objectForKey:@"T"]]];
					MI.indentationLevel = iTM2TSSMenuItemIndentationLevel;
                    goto la;
                } else {
                    goto ici;
                }
            }
            MI.state = NSOffState;
			MI.indentationLevel = iTM2TSSMenuItemIndentationLevel;
            MI.title = title;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3
    NSTextStorage * TS = self.textStorageTarget;
    return TS?  [TS contextManager]:([NSApp keyWindow]?:[super contextManager]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggleEnabled:
- (IBAction)textStyleToggleEnabled:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask];
	id TS = self.textStorageTarget;
	iTM2TextInspector * WC = [[[[[[[TS layoutManagers] lastObject] textContainers] lastObject] textView] window] windowController];
	if ([WC isKindOfClass:[iTM2TextInspector class]]) {
		[[WC retain] autorelease];
		id document = WC.document;
		[document removeWindowController:WC];
		[document replaceInspectorMode:[[WC class] inspectorMode] variant:[WC inspectorVariant]];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTextStyleToggleEnabled:
- (BOOL)validateTextStyleToggleEnabled:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.textStorageTarget is:%@", self.textStorageTarget);
	[sender setState:([self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask]?
		NSOnState: NSOffState)];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggle:
- (IBAction)textStyleToggle:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = self.textStorageTarget;
	if ([TS isKindOfClass:[iTM2TextStorage class]]) {
		NSDictionary * D = [sender.representedObject objectForKey:@"SV"];
		[TS replaceSyntaxParserStyle:[D objectForKey:@"S"] variant:[D objectForKey:@"V"]];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTextStyleToggle:
- (BOOL)validateTextStyleToggle:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = self.textStorageTarget;
	sender.state = ([TS isKindOfClass:[iTM2TextStorage class]] && [[[sender representedObject] objectForKey:@"SV"] isEqual:[NSDictionary dictionaryWithObjectsAndKeys:[[[TS.syntaxParser attributesServer] syntaxParserVariant] lowercaseString], @"V", [[[TS.syntaxParser class] syntaxParserStyle] lowercaseString], @"S", nil]]? NSOnState:NSOffState);
//END4iTM3;
	return [TS isKindOfClass:[iTM2TextStorage class]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleEdit:
- (IBAction)textStyleEdit:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStorageTarget
- (id)textStorageTarget;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = (NSTextView *)[NSApp targetForAction:@selector(NSTextView_iTM2MessageCatcher:)];
	if (TV.textStorage) return TV.textStorage;
    id target = [SDC currentDocument];
    if ([target respondsToSelector:@selector(textStorage)]) {
        return [target textStorage];
    }
//END4iTM3;
    return nil;
}
@end

@interface iTM2TextStyleTextView: NSTextView
{
@private
    BOOL _SameXHeight;
}
- (void)setFont:(NSFont *)newF atIndex:(NSUInteger)location;
- (void)syntaxParserAttributesDidChange;
@property BOOL _SameXHeight;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
	iTM2TextStorage * TS = [[[iTM2TextStorage alloc] init] autorelease];
    [self.layoutManager replaceTextStorage:TS];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	if ([TS isKindOfClass:[iTM2TextStorage class]])
	{
		id ACD = [TS attributesChangeDelegate];
		[TS setAttributesChangeDelegate:nil];
		[super insertText:insertString];
		[TS setAttributesChangeDelegate:ACD];
//END4iTM3;
		return;
	}
	[super insertText:insertString];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserAttributesDidChange
- (void)syntaxParserAttributesDidChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	if ([TS isKindOfClass:[iTM2TextStorage class]])
	{
		iTM2TextSyntaxParser * SP = TS.syntaxParser;
		[SP setUpAllTextViews];
	}
	NSRange range = iTM3MakeRange(0, TS.length);
	for (NSLayoutManager * LM in TS.layoutManagers) {
		range.length = [LM firstUnlaidCharacterIndex];
		[LM invalidateGlyphsForCharacterRange:range changeInLength:0 actualCharacterRange:nil];
		[LM invalidateLayoutForCharacterRange:range isSoft:NO actualCharacterRange:nil];
	}
	NSWindowController * WC = self.window.windowController;
	[WC.document updateChangeCount:NSChangeDone];
	WC.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage:wouldSetAttributes:range:
- (void)textStorage:(iTM2TextStorage *)TS wouldSetAttributes:(id)attributes range:(NSRange)range;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	if (![attributes isEqual:oldD])
	{
		NSMutableDictionary * newD = [[attributes mutableCopy] autorelease];
		NSString * mode = [oldD objectForKey:iTM2TextModeAttributeName];
		[newD setValue:mode forKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		[self performSelector:@selector(syntaxParserAttributesDidChange) withObject:nil afterDelay:0];
	}	
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage:wouldAddAttribute:value:range:
- (void)textStorage:(iTM2TextStorage *)TS wouldAddAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	id oldValue = [oldD objectForKey:name];
	if (![value isEqual:oldValue])
	{
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setValue:value forKey:name];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		[self performSelector:@selector(syntaxParserAttributesDidChange) withObject:nil afterDelay:0];
	}	
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedRange:affinity:stillSelecting:
- (void)setSelectedRange:(NSRange)charRange affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super setSelectedRange:charRange affinity:affinity stillSelecting:stillSelectingFlag];
    [self.window.windowController validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeAttributes:
- (void)changeAttributes:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange range = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSDictionary * newD = [sender convertAttributes:oldD];
	if (![oldD isEqual:newD])
	{
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		self.syntaxParserAttributesDidChange;
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeDocumentBackgroundColor:
- (void)changeDocumentBackgroundColor:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
	NSDictionary * oldD = [SP.attributesServer attributesForMode:mode];
	id oldValue = [oldD objectForKey:NSBackgroundColorAttributeName];
	id value = [sender color];
	if (![value isEqual:oldValue])
	{
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setValue:value forKey:NSBackgroundColorAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		self.syntaxParserAttributesDidChange;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeFont:
- (void)changeFont:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSRange range = self.selectedRange;
    float xHeight = [[sender convertFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]] xHeight];
    if (range.length)
    {
        NSUInteger top = iTM3MaxRange(range);
        do
        {
            NSFont * oldF = [[SP attributesAtIndex:range.location effectiveRange:&range]
                objectForKey: NSFontAttributeName];
            NSFont * newF;
            newF = [sender convertFont:oldF];
            if (_SameXHeight)
                newF = [NSFont fontWithName:[newF fontName] size:[newF pointSize]/[newF xHeight]*xHeight];
            [self setFont:newF atIndex:range.location];
            range.location += MAX(1, range.length);
        }
        while(range.location < top);
    }
    else
    {
        if (range.location)
            --range.location;
        NSFont * oldF = [[SP attributesAtIndex:range.location effectiveRange:nil] objectForKey:NSFontAttributeName];
        NSFont * newF = [sender convertFont:oldF];
        if (_SameXHeight)
            newF = [NSFont fontWithName:[newF fontName] size:[newF pointSize]/[newF xHeight]*xHeight];
        [self setFont:newF atIndex:range.location];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFont:atIndex:
- (void)setFont:(NSFont *)newF atIndex:(NSUInteger)location;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSDictionary * D = [SP attributesAtIndex:location effectiveRange:nil];
    NSFont * oldF = [D objectForKey:NSFontAttributeName];
    if (![oldF isEqual:newF])
    {
        NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
		if (newF)
			[MD setObject:newF forKey:NSFontAttributeName];
		else
			[MD removeObjectForKey:NSFontAttributeName];
        D = [NSDictionary dictionaryWithDictionary:MD];
		NSString * mode = [D objectForKey:iTM2TextModeAttributeName];
        [SP.attributesServer setAttributes:D forMode:mode];
		self.syntaxParserAttributesDidChange;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SCP setColor:[[NSColor whiteColor] colorWithAlphaComponent:0]];
    [self.window.windowController validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subscript:
- (void)subscript:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange selectedRange = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSNumber * N = [oldD objectForKey:NSSuperscriptAttributeName];
	NSInteger level = [N integerValue];
	--level;
	N = [NSNumber numberWithInteger:level];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:N forKey:NSSuperscriptAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[SP.attributesServer setAttributes:newD forMode:mode];
	self.syntaxParserAttributesDidChange;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  superscript:
- (void)superscript:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange selectedRange = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSNumber * N = [oldD objectForKey:NSSuperscriptAttributeName];
	NSInteger level = [N integerValue];
	++level;
	N = [NSNumber numberWithInteger:level];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:N forKey:NSSuperscriptAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[SP.attributesServer setAttributes:newD forMode:mode];
	self.syntaxParserAttributesDidChange;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  underline:
- (void)underline:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange selectedRange = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSNumber * N = [NSNumber numberWithInteger:1];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:N forKey:NSUnderlineStyleAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[SP.attributesServer setAttributes:newD forMode:mode];
	self.syntaxParserAttributesDidChange;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unscript:
- (void)unscript:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange selectedRange = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
	NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
	[newD setValue:nil forKey:NSSuperscriptAttributeName];
	NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
	[SP.attributesServer setAttributes:newD forMode:mode];
	self.syntaxParserAttributesDidChange;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignCenter:
- (void)alignCenter:(id)sender
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange range = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if (!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if ([oldParagraphStyle alignment] != NSCenterTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSCenterTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		self.syntaxParserAttributesDidChange;
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignLeft:
- (void)alignLeft:(id)sender
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange range = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if (!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if ([oldParagraphStyle alignment] != NSLeftTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSLeftTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		self.syntaxParserAttributesDidChange;
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignRight:
- (void)alignRight:(id)sender
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange range = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if (!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if ([oldParagraphStyle alignment] != NSRightTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSRightTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		self.syntaxParserAttributesDidChange;
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alignJustified:
- (void)alignJustified:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange range = self.selectedRange;
	NSDictionary * oldD = [SP attributesAtIndex:range.location effectiveRange:nil];
	NSParagraphStyle * oldParagraphStyle = [oldD objectForKey:NSParagraphStyleAttributeName];
	if (!oldParagraphStyle)
	{
		oldParagraphStyle = [NSParagraphStyle defaultParagraphStyle];
	}
	if ([oldParagraphStyle alignment] != NSJustifiedTextAlignment)
	{
		NSMutableParagraphStyle *newParagraphStyle = [[oldParagraphStyle mutableCopy] autorelease];
		[newParagraphStyle setAlignment:NSJustifiedTextAlignment];
		NSMutableDictionary * newD = [[oldD mutableCopy] autorelease];
		[newD setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
		NSString * mode = [newD objectForKey:iTM2TextModeAttributeName];
		[SP.attributesServer setAttributes:newD forMode:mode];
		self.syntaxParserAttributesDidChange;
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSameXHeight:
- (IBAction)toggleSameXHeight:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _SameXHeight = !_SameXHeight;
    [self.window.windowController validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSameXHeight:
- (BOOL)validateToggleSameXHeight:(NSButton *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = (_SameXHeight? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectedModeColor:
- (IBAction)toggleSelectedModeColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![sender.window isKeyWindow])
        return;
    NSColor * newVisibleC = [sender color];
//LOG4iTM3(@"newVisibleC is: %@", newVisibleC);
    if (newVisibleC && ![newVisibleC alphaComponent])
        newVisibleC = [NSColor textColor];
    NSColor * newC = [newVisibleC isEqual:[NSColor textColor]]? nil:newVisibleC;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSDictionary * D = [SP attributesAtIndex:self.selectedRange.location effectiveRange:nil];
    NSColor * oldC = [D objectForKey:NSForegroundColorAttributeName];
//LOG4iTM3(@"oldC is: %@", oldC);
//LOG4iTM3(@"newC is: %@", newC);
//LOG4iTM3(@"mode is: %@", [D objectForKey:iTM2TextModeAttributeName]);
    if (![oldC isEqual:newC] && (newC || oldC))
    {
//LOG4iTM3(@"REPLACING");
        NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
		[MD setValue:newC forKey:NSForegroundColorAttributeName];
        D = [NSDictionary dictionaryWithDictionary:MD];
        NSString * mode = [D objectForKey:iTM2TextModeAttributeName];
        if (!mode.length)
        {
            LOG4iTM3(@"Don't know what is the mode!");
            return;
        }
        [SP.attributesServer setAttributes:D forMode:[D objectForKey:iTM2TextModeAttributeName]];
		self.syntaxParserAttributesDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectedModeColor:
- (BOOL)validateToggleSelectedModeColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    NSRange charRange = self.selectedRange;
    NSColor * C = [NSColor textColor];
    if (charRange.location <= TS.length)
    {
        NSColor * c = [TS attribute:NSForegroundColorAttributeName atIndex:charRange.location effectiveRange:nil];
        if (c && [c alphaComponent])// BEWARE [C alphaComponent] != 0 even if C==nil
            C = c;
    }
    if (![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if ([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//END4iTM3;
    return [sender.window isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectedModeBackgroundColor:
- (IBAction)toggleSelectedModeBackgroundColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![sender.window isKeyWindow])
        return;
    NSColor * newVisibleC = [sender color];
    if (!newVisibleC || ![newVisibleC alphaComponent])
        newVisibleC = [NSColor textBackgroundColor];
    NSColor * newC = [newVisibleC isEqual:[NSColor textBackgroundColor]]? nil:newVisibleC;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSRange selectedRange = self.selectedRange;
    NSDictionary * D = [SP attributesAtIndex:selectedRange.location effectiveRange:nil];
    NSColor * oldC = [D objectForKey:NSBackgroundColorAttributeName];
//LOG4iTM3(@"oldC is: %@", oldC);
//LOG4iTM3(@"newC is: %@", newC);
//LOG4iTM3(@"mode is: %@", [D objectForKey:iTM2TextModeAttributeName]);
    if (![oldC isEqual:newC] && (newC || oldC))
    {
        NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
		[MD setValue:newC forKey:NSBackgroundColorAttributeName];
        D = [NSDictionary dictionaryWithDictionary:MD];
        [SP.attributesServer setAttributes:D forMode:[D objectForKey:iTM2TextModeAttributeName]];
		self.syntaxParserAttributesDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectedModeBackgroundColor:
- (BOOL)validateToggleSelectedModeBackgroundColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    NSRange charRange = self.selectedRange;
    NSColor * C = [NSColor textBackgroundColor];
    if (charRange.location <= TS.length)
    {
        NSColor * c = [TS attribute:NSBackgroundColorAttributeName atIndex:charRange.location effectiveRange:nil];
        if (c && [c alphaComponent])// BEWARE [C alphaComponent] != 0 even if C==nil
            C = c;
    }
    if (![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if ([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//END4iTM3;
    return [sender.window isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectionColor:
- (IBAction)toggleSelectionColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![sender.window isKeyWindow])
        return;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSColor * newVisibleC = [sender color];
    NSColor * newC = [newVisibleC isEqual:[NSColor selectedTextColor]]? nil:newVisibleC;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:self.selectedTextAttributes];
//LOG4iTM3(@"OLD self.selectedTextAttributes are:%@", self.selectedTextAttributes);
    [MD addEntriesFromDictionary:[SP.attributesServer attributesForMode:iTM2TextSelectionSyntaxModeName]];
    NSString * key = NSForegroundColorAttributeName;
    NSColor * oldC = [MD objectForKey:key];
    if (![oldC isEqual:newC] && (newC || oldC))
    {
		[MD setValue:newC forKey:key];
//        [MD setObject:[NSNumber numberWithInteger:1] forKey:NSUnderlineStyleAttributeName];
        NSDictionary * D = [NSDictionary dictionaryWithDictionary:MD];
        [SP.attributesServer setAttributes:D forMode:iTM2TextSelectionSyntaxModeName];
		self.syntaxParserAttributesDidChange;
//LOG4iTM3(@"NEW self.selectedTextAttributes are:%@", self.selectedTextAttributes);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectionColor:
- (BOOL)validateToggleSelectionColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSColor * C = [self.selectedTextAttributes objectForKey:NSForegroundColorAttributeName];
    if (!C || ![C alphaComponent])
        C = [NSColor selectedTextColor];
    if (![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if ([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//END4iTM3;
    return [sender.window isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSelectionBackgroundColor:
- (IBAction)toggleSelectionBackgroundColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![sender.window isKeyWindow])
        return;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSColor * newVisibleC = [sender color];
    NSColor * newC = [newVisibleC isEqual:[NSColor selectedTextBackgroundColor]]? nil:newVisibleC;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:self.selectedTextAttributes];
    [MD addEntriesFromDictionary:[SP.attributesServer attributesForMode:iTM2TextSelectionSyntaxModeName]];
    NSString * key = NSBackgroundColorAttributeName;
    NSColor * oldC = [MD objectForKey:key];
    if (![oldC isEqual:newC] && (newC || oldC))
    {
		[MD setValue:newC forKey:key];
        NSDictionary * D = [NSDictionary dictionaryWithDictionary:MD];
        [SP.attributesServer setAttributes:D forMode:iTM2TextSelectionSyntaxModeName];
		self.syntaxParserAttributesDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSelectionBackgroundColor:
- (BOOL)validateToggleSelectionBackgroundColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSColor * C = [self.selectedTextAttributes objectForKey:NSBackgroundColorAttributeName];
    if (!C || ![C alphaComponent])
        C = [NSColor selectedTextBackgroundColor];
    if (![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if ([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//END4iTM3;
    return [sender.window isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleInsertionColor:
- (IBAction)toggleInsertionColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![sender.window isKeyWindow])
        return;
    NSString * key = NSForegroundColorAttributeName;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSColor * newVisibleC = [sender color];
    NSColor * newC = ([newVisibleC isEqual:[NSColor textColor]]? nil:newVisibleC);
    NSString * mode = iTM2TextInsertionSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:
                                        [SP.attributesServer attributesForMode:mode]];
    NSColor * oldC = [MD objectForKey:key];
    if (![oldC isEqual:newC] && (newC || oldC))
    {
		[MD setValue:newC forKey:key];
        [SP.attributesServer setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
		self.syntaxParserAttributesDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleInsertionColor:
- (BOOL)validateToggleInsertionColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.insertionPointColor is:%@", self.insertionPointColor);
    NSColor * C = self.insertionPointColor;
    if (!C || ![C alphaComponent])
        C = [NSColor textColor];
    if (![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if ([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//END4iTM3;
    return [sender.window isKeyWindow];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTextViewBackgroundColor:
- (IBAction)toggleTextViewBackgroundColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![sender.window isKeyWindow])
        return;
    NSString * key = NSBackgroundColorAttributeName;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSColor * newVisibleC = [sender color];
    if (newVisibleC && ![newVisibleC alphaComponent])
        newVisibleC = [NSColor textBackgroundColor];
    NSColor * newC = ([newVisibleC isEqual:[NSColor textBackgroundColor]]? nil:newVisibleC);
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:
                                    [SP.attributesServer attributesForMode:mode]];
    NSColor * oldC = [MD objectForKey:key];
    if (![oldC isEqual:newC] && (newC || oldC))
    {
		if (newC)
			[MD setObject:newC forKey:key];
		else
			[MD removeObjectForKey:key];
        [SP.attributesServer setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
		self.syntaxParserAttributesDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTextViewBackgroundColor:
- (BOOL)validateToggleTextViewBackgroundColor:(NSColorWell *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.backgroundColor is:%@", self.backgroundColor);
    NSString * key = NSBackgroundColorAttributeName;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
	NSDictionary * attributes = [SP.attributesServer attributesForMode:mode];
    NSColor * C = [attributes objectForKey:key];
    if (!C || ![C alphaComponent])
        C = [NSColor textBackgroundColor];
    if (![[sender color] isEqual:C])
    {
        [sender setColor:C];
        if ([sender isActive] && ![[SCP color] isEqual:C])
            [SCP setColor:C];
    }
//END4iTM3;
    return [sender.window isKeyWindow] && ![[attributes objectForKey:iTM2NoBackgroundAttributeName] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editModeName:
- (IBAction)editModeName:(id)sender;
/*"Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	//this is just a message catcher
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditModeName:
- (BOOL)validateEditModeName:(NSTextField *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * mode = @"";
    NSRange range = self.selectedRange;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
	NSDictionary * D = nil;
    if (range.length) {
        NSUInteger top = iTM3MaxRange(range);
        D = [SP attributesAtIndex:range.location effectiveRange:&range];
        mode = [D objectForKey:iTM2TextModeAttributeName];
next:
        range.location += range.length;
        if (top > range.location) {
            D = [SP attributesAtIndex:range.location effectiveRange:&range];
            NSString * m = [D objectForKey:iTM2TextModeAttributeName];
            if ([m isEqualToString:mode]) {
                goto next;
            } else {
                mode = NSLocalizedStringFromTableInBundle(@"Multiple modes", TABLE, BUNDLE, "Description forthcoming");
				sender.stringValue = mode;
				return YES;
			}
        }
    } else {
		NSUInteger start,contentsEnd;
		[TS getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:range];
		if (range.location<contentsEnd) {
			D = [SP attributesAtIndex:range.location effectiveRange:nil];
		} else if (range.location>start) {
			D = [SP attributesAtIndex:range.location-1 effectiveRange:nil];
		} else {
			D = [SP attributesAtIndex:range.location effectiveRange:nil];
		}
		mode = [D objectForKey:iTM2TextModeAttributeName];
	}
	if (mode.length) {
		mode = NSLocalizedStringFromTableInBundle(mode, [@"iTM2TextStyle_" stringByAppendingString:[[SP class] syntaxParserStyle]], [SP classBundle4iTM3], "Description forthcoming");
	} else {
		mode = NSLocalizedStringFromTableInBundle(@"No mode", TABLE, BUNDLE, "Description forthcoming");
	}
    sender.stringValue = mode;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNoBackground:
- (IBAction)toggleNoBackground:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:
                                    [SP.attributesServer attributesForMode:mode]];
    BOOL oldFlag = [[MD objectForKey:iTM2NoBackgroundAttributeName] boolValue];
    [MD setObject:[NSNumber numberWithBool:!oldFlag] forKey:iTM2NoBackgroundAttributeName];
    [SP.attributesServer setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
    [SP setUpAllTextViews];
    NSWindowController * WC = self.window.windowController;
    [WC.document updateChangeCount:NSChangeDone];
    [WC validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNoBackground:
- (BOOL)validateToggleNoBackground:(NSButton *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    BOOL oldFlag = [[[SP.attributesServer attributesForMode:mode] objectForKey:iTM2NoBackgroundAttributeName] boolValue];
    sender.state = (oldFlag? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCursorIsWhite:
- (IBAction)toggleCursorIsWhite:(id)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[SP.attributesServer attributesForMode:mode]];
    BOOL was = [[MD objectForKey:iTM2CursorIsWhiteAttributeName] boolValue];
    [MD setObject:[NSNumber numberWithBool:!was] forKey:iTM2CursorIsWhiteAttributeName];
    [SP.attributesServer setAttributes:[NSDictionary dictionaryWithDictionary:MD] forMode:mode];
    [SP setUpAllTextViews];
    NSWindowController * WC = self.window.windowController;
    [WC.document updateChangeCount:NSChangeDone];
    [WC validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCursorIsWhite:
- (BOOL)validateToggleCursorIsWhite:(NSButton *)sender;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
    iTM2TextSyntaxParser * SP = [TS isKindOfClass:[iTM2TextStorage class]]? TS.syntaxParser:nil;
    NSString * mode = iTM2TextBackgroundSyntaxModeName;
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[SP.attributesServer attributesForMode:mode]];
    BOOL cursorIsWhite = [[MD objectForKey:iTM2CursorIsWhiteAttributeName] boolValue];
    sender.state = (cursorIsWhite? NSOnState:NSOffState);
    NSClipView * CV = (NSClipView *)self.superview;
    if ([CV isKindOfClass:[NSClipView class]])
    {
        [CV setDocumentCursor:(cursorIsWhite? [NSCursor whiteIBeamCursor]:[NSCursor IBeamCursor])];
        [self.window invalidateCursorRectsForView:self];
    }
    return YES;
}
@synthesize _SameXHeight;
@end
#if 0
APPKIT_EXTERN NSString *NSFontAttributeName;                // NSFont, default Helvetica 12
APPKIT_EXTERN NSString *NSParagraphStyleAttributeName;      // NSParagraphStyle, default defaultParagraphStyle
APPKIT_EXTERN NSString *NSForegroundColorAttributeName;     // NSColor, default blackColor
APPKIT_EXTERN NSString *NSUnderlineStyleAttributeName;      // NSNumber containing integer, default 0: no underline
APPKIT_EXTERN NSString *NSSuperscriptAttributeName;         // NSNumber containing integer, default 0
APPKIT_EXTERN NSString *NSBackgroundColorAttributeName;     // NSColor, default nil: no background
APPKIT_EXTERN NSString *NSAttachmentAttributeName;          // NSTextAttachment, default nil
APPKIT_EXTERN NSString *NSLigatureAttributeName;            // NSNumber containing integer, default 1: default ligatures, 0: no ligatures, 2: all ligatures
APPKIT_EXTERN NSString *NSBaselineOffsetAttributeName;      // NSNumber containing floating point value, in points; offset from baseline, default 0
APPKIT_EXTERN NSString *NSKernAttributeName;                // NSNumber containing floating point value, in points; amount to modify default kerning, if 0, kerning off
APPKIT_EXTERN NSString *NSLinkAttributeName;                // NSURL (preferred) or NSString

APPKIT_EXTERN NSString *NSStrokeWidthAttributeName          AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
APPKIT_EXTERN NSString *NSStrokeColorAttributeName          AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSColor, default nil: same as foreground color
APPKIT_EXTERN NSString *NSUnderlineColorAttributeName       AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSColor, default nil: same as foreground color
APPKIT_EXTERN NSString *NSStrikethroughStyleAttributeName   AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSNumber containing integer, default 0: no strikethrough
APPKIT_EXTERN NSString *NSStrikethroughColorAttributeName   AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSColor, default nil: same as foreground color
APPKIT_EXTERN NSString *NSShadowAttributeName               AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSShadow, default nil: no shadow
APPKIT_EXTERN NSString *NSObliquenessAttributeName          AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
APPKIT_EXTERN NSString *NSExpansionAttributeName            AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
APPKIT_EXTERN NSString *NSCursorAttributeName               AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSCursor, default IBeamCursor
APPKIT_EXTERN NSString *NSToolTipAttributeName              AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;  // NSString, default nil: no tooltip

/* An NSNumber containing an integer value.  The value is interpreted as Apple Type Services kCharacterShapeType selector + 1.  Default is 0 (disabled), 1 is kTraditionalCharactersSelector and so on.  Refer to <ATS/SFNTLayoutTypes.h>
 */
APPKIT_EXTERN NSString *NSCharacterShapeAttributeName;

/* An NSGlyphInfo object.  This provides a means to override the standard glyph generation.  NSLayoutManager will assign the glyph specified by this glyph info to the entire attribute range, provided that its contents match the specified base string, and that the specified glyph is available in the font specified by NSFontAttributeName.
*/
APPKIT_EXTERN NSString *NSGlyphInfoAttributeName            AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER;  // NSGlyphInfo specifying glyph for the associated attribute range

/* An NSArray of NSNumbers.  This provides a means to override the default bidi algorithm, equivalent to the use of bidi control characters LRE, RLE, LRO, or RLO paired with PDF, as a higher-level attribute.  This is the NSAttributedString equivalent of HTML's dir attribute and/or BDO element.  The array represents nested embeddings or overrides, in order from outermost to innermost.  The values of the NSNumbers should be 0, 1, 2, or 3, for LRE, RLE, LRO, or RLO respectively; these should be regarded as NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft plus NSTextWritingDirectionEmbedding or NSTextWritingDirectionOverride.
*/
APPKIT_EXTERN NSString *NSWritingDirectionAttributeName            AVAILABLE_MAC_OS_X_VERSION_10_6_AND_LATER;  // NSArray of NSNumbers, whose values should be NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft plus NSTextWritingDirectionEmbedding or NSTextWritingDirectionOverride

/* Clause segment index NSNumber (integerValue). This attribute is used in marked text indicating clause segments.
*/
APPKIT_EXTERN NSString *NSMarkedClauseSegmentAttributeName AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER;

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

APPKIT_EXTERN NSUInteger NSUnderlineByWordMask; 
#endif

@interface iTM2TextSyntaxParserAttributesDocument(PRIVATE)
- (void)setSyntaxParserVariant:(NSString *)SPV;
@end

NSString * const iTM2TextSyntaxParserAttributesInspectorType = @"TextSyntaxParserAttributes";

@implementation iTM2TextSyntaxParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextSyntaxParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserClass
+ (Class)syntaxParserClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = NSStringFromClass(self);
    NSAssert1([name hasSuffix:@"AttributesDocument"],
        @"Attributes server class %@ is not suffixed with \"AttributesDocument\"", name);
    name = [name substringWithRange:iTM3MakeRange(0, name.length - 18)];
    Class result = NSClassFromString(name);
    if (iTM2DebugEnabled)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSyntaxParserVariant
- (void)setSyntaxParserVariant:(NSString *)SPV;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(SPV);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithSyntaxParserVariant:error:
- (id)initWithSyntaxParserVariant:(NSString *)variant error:(NSError **)outErrorPtr;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!variant.length)
    {
        return nil;
    }
    else if (self = [super init])
    {
		[self setSyntaxParserVariant:variant];
        [self setFileType:@"iTeXMac2 private document"];
		[self setFileURL:
			[[[[[[NSBundle mainBundle] URLForSupportDirectory4iTM3:iTM2TextStyleComponent inDomain:NSUserDomainMask create:YES]
				URLByAppendingPathComponent: [[self.class syntaxParserClass] syntaxParserStyle]] 
					URLByAppendingPathExtension: iTM2TextStyleExtension]
						URLByAppendingPathComponent: self.syntaxParserVariant]
							URLByAppendingPathExtension: iTM2TextVariantExtension]];
		[self readFromURL:self.fileURL ofType:self.fileType error:outErrorPtr];
    }
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayName
- (NSString *)displayName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSString stringWithFormat:
        NSLocalizedStringFromTableInBundle(@"Style: %@ (%@)", TABLE, BUNDLE, "Comment forthcoming"),
        [[self.class syntaxParserClass] syntaxParserStyle], self.syntaxParserVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggle:
- (IBAction)textStyleToggle:(id)sender;
/*"Designated initializer. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleEdit:
- (IBAction)textStyleEdit:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL)validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(NSStringFromSelector(sender.action));
    SEL A = sender.action;
    if ((A == @selector(textStyleToggle:))
            || (A == @selector(textStyleEdit:)))
        return NO;
    else if (A == @selector(saveDocument:))
        return self.isDocumentEdited;
    else if (A == @selector(revertDocumentToSaved:))
        return self.isDocumentEdited;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * styleURL =
		[[[[[[NSBundle mainBundle] URLForSupportDirectory4iTM3:iTM2TextStyleComponent inDomain:NSUserDomainMask create:YES]
			URLByAppendingPathComponent: [[self.class syntaxParserClass] syntaxParserStyle]] 
				URLByAppendingPathExtension: iTM2TextStyleExtension]
					URLByAppendingPathComponent: self.syntaxParserVariant]
						URLByAppendingPathExtension: iTM2TextVariantExtension];
	[self setFileURL:styleURL];
	[super revertDocumentToSaved:sender];
    self.validateWindowsContents4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (void)saveDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * style = [[self.class syntaxParserClass] syntaxParserStyle];
	NSString * variant = self.syntaxParserVariant;
    NSURL * styleURL =
		[[[[[[NSBundle mainBundle] URLForSupportDirectory4iTM3:iTM2TextStyleComponent inDomain:NSUserDomainMask create:YES]
			URLByAppendingPathComponent: style] 
				URLByAppendingPathExtension: iTM2TextStyleExtension]
					URLByAppendingPathComponent: variant]
						URLByAppendingPathExtension: iTM2TextVariantExtension];
//LOG4iTM3(@"stylePath is: %@", stylePath);
    // preparing the storing location
	NSError * localError = nil;
    BOOL isDirectory;
    if ([DFM fileExistsAtPath:styleURL.path isDirectory:&isDirectory]) {
        if (isDirectory) {
            goto save;
        } else {
            if (![SWS performFileOperation:NSWorkspaceRecycleOperation
                source: styleURL.path.stringByDeletingLastPathComponent
                    destination: @""
                        files: [NSArray arrayWithObject:styleURL.lastPathComponent]
                            tag: nil])
            {
                LOG4iTM3(@"Something weird at path: %@, cannot recycle", styleURL.path);
                NSBeep();
                [[NSWorkspace sharedWorkspace] selectFile:styleURL.path inFileViewerRootedAtPath:styleURL.path.stringByDeletingLastPathComponent];
#warning THIS DOES NOT WORK!!!
                NSAppleScript * AS = [[[NSAppleScript alloc]
                    initWithSource: [NSString stringWithFormat:@"tell application \"Finder\"\ractivate\rdisplay dialog \"Could not recycle %@\" buttons {\"OK\"} default button 1\rend tell", styleURL.lastPathComponent]] autorelease];
                [AS executeAndReturnError:nil];
                return;
            }
            goto save;
        }
    } else if ([DFM createDirectoryAtPath:styleURL.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
		goto save;
	} else if (localError) {
		[SDC presentError:localError];
        return;
	} else {
        LOG4iTM3(@"Could not create the directory at url: %@", styleURL);
        return;
    }
save:
	[self setFileURL:styleURL];
    BOOL result = YES;
    NSString * type = self.fileType;
	for (id WC in self.windowControllers) {
        if ([WC respondsToSelector:@selector(writeToURL:ofType:error:)]) {
			result = result && [WC writeToURL:styleURL ofType:type error:&localError];// only the last error is recorded
		}
	}
//END4iTM3;
	if (result) {
		[self updateChangeCount:NSChangeCleared];
		[INC postNotificationName:iTM2TextAttributesDidChangeNotification object:nil userInfo:
			[NSDictionary dictionaryWithObjectsAndKeys:style, @"style", variant, @"variant", nil]];
	} else if (iTM2DebugEnabled) {
        LOG4iTM3(@"Problem in saving the document...");
    }
	return;
}
#warning DEBUG
- (void)updateChangeCount:(NSDocumentChangeType)change;
{
	[super updateChangeCount:(NSDocumentChangeType)change];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL4iTM3:ofType:error:
//- (BOOL) readFromFile: (NSString *) fileName ofType: (NSString *) type;
- (BOOL)dataCompleteReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fileName: %@", fileName);
	if (!absoluteURL.isFileURL)
		return NO;
	self.makeWindowControllers;
    BOOL result = YES;
    NSEnumerator * E = [self.windowControllers objectEnumerator];
    id WC;
    while(WC = E.nextObject)
	{
//LOG4iTM3(@"WC is: %@", WC);
        if ([WC respondsToSelector:@selector(readFromURL:ofType:error:)])
		{
			result = result && [WC readFromURL:absoluteURL ofType:typeName error:outErrorPtr];// only the last error will be recorded
		}
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= newRecentDocument
- (id)newRecentDocument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;// it should not appear in the recent docs list
}
@end

@interface iTM2TextSyntaxParserAttributesInspector(PRIVATE)
- (id)attributesServer;
- (void)setAttributesServer:(id)argument;
- (NSTextView *)textView;
- (void)setTextView:(NSTextView *)argument;
- (void)doPasteAllModes:(NSDictionary *)dictionary;
@end

@implementation iTM2TextSyntaxParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextSyntaxParserAttributesInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (NSTextView *)textView;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return (metaGETTER?: (self.window, metaGETTER));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextView:
- (void)setTextView:(NSTextView *)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
	argument.delegate = self;// for debugging purpose
//END4iTM3;
	return;
}
#if 0
- (void)textDidChange:(NSNotification *)notification;
{
	NSTextStorage * TS = [self.textView textStorage];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributesServer:
- (void)setAttributesServer:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
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
    self.window.delegate = self;
    self.validateWindowContent4iTM3;
    [self.window makeKeyAndOrderFront:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeKey:
- (void)windowDidBecomeKey:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL)
	{
		return YES;
	}
    // make a copy of the attributes server, in order not to edit the shared attributes server
    iTM2TextStorage * TS = (iTM2TextStorage *)[self.textView textStorage];
//LOG4iTM3(@"TS is: <%@>", TS);
    if ([TS isKindOfClass:[iTM2TextStorage class]])
    {
		id document = self.document;
        NSString * style = [[[document class] syntaxParserClass] syntaxParserStyle];
		NSString * variant = [document syntaxParserVariant];
    	[TS setSyntaxParserStyle:style variant:variant];
        id old = [TS.syntaxParser attributesServer];
		[self setAttributesServer:[[[[old class] alloc]
            initWithVariant: [document syntaxParserVariant]] autorelease]];
        [TS.syntaxParser setAttributesServer:self.attributesServer];
		NSString * sampleString = [self valueForKey:@"sampleString_meta"];
		if (!sampleString) {
			sampleString = [[TS.syntaxParser class] sampleString];
		}
        [self.textView setString:sampleString];
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL)
	{
		return YES;
	}
	NSString * fileName = absoluteURL.path;
    NSString * stylePath = [[fileName stringByAppendingPathComponent:iTM2TextAttributesModesComponent] stringByAppendingPathExtension:iTM2TextAttributesPathExtension];
	iTM2TextSyntaxParserAttributesServer * AS = self.attributesServer;
	NSDictionary * modesAttributes = [AS modesAttributes];
	NSString * sampleString = [self.textView string];
	[self setValue:sampleString forKeyPath:@"sampleString_meta"];
	if (![[AS class] writeModesAttributes:modesAttributes toFile:stylePath error:outErrorPtr])
	{
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"Could not write the modes attributes at path:%@", stylePath]),nil);
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * modes = [self.attributesServer modesAttributes];
	if (modes.count)
	{
		NSPasteboard * pboard = [NSPasteboard generalPasteboard];
		if ([pboard changeCount] !=
				[pboard declareTypes:[NSArray arrayWithObject:@"iTM2TextStyleModesPboardType"] owner:nil])
		{
			[pboard setData:[NSArchiver archivedDataWithRootObject:modes] forType:@"iTM2TextStyleModesPboardType"];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCopyAllModes:
- (BOOL)validateCopyAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * modes = [self.attributesServer modesAttributes];
//END4iTM3;
	return modes.count > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pasteAllModes:
- (IBAction)pasteAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSPasteboard * pboard = [NSPasteboard generalPasteboard];
	NSString * dataType = [pboard availableTypeFromArray:[NSArray arrayWithObject:@"iTM2TextStyleModesPboardType"]];
	if (dataType)
	{
		NSData * D = [pboard dataForType:dataType];
		if (D)
		{
			NSDictionary * DICT = [NSUnarchiver unarchiveObjectWithData:D];
			if ([DICT isKindOfClass:[NSDictionary class]])
			{
				[self doPasteAllModes:DICT];
			}
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doPasteAllModes:
- (void)doPasteAllModes:(NSDictionary *)dictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id AS = self.attributesServer;
	[[self.undoManager prepareWithInvocationTarget:self]doPasteAllModes:[AS modesAttributes]];
	NSEnumerator * E = [[AS modesAttributes] keyEnumerator];
	NSString * mode;
	while(mode = E.nextObject)
	{
		id attributes = [dictionary objectForKey:mode];
		if (attributes)
			[AS setAttributes:attributes forMode:mode];
	}
	// force to update the view when we paste
	NSString * style = [[[self.document class] syntaxParserClass] syntaxParserStyle];
	[INC postNotificationName:iTM2TextAttributesDidChangeNotification object:nil userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:style, @"style", [AS variant], @"variant", nil]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePasteAllModes:
- (BOOL)validatePasteAllModes:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[NSPasteboard generalPasteboard] availableTypeFromArray:[NSArray arrayWithObject:@"iTM2TextStyleModesPboardType"]] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStyleToggle:
- (IBAction)textStyleToggle:(id)sender;
/*"Designated initializer. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTextStyleToggle:
- (BOOL)validateTextStyleToggle:(NSButton *)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStyleEdit:
- (IBAction)textStyleEdit:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// this is just a message catcher
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTextStyleEdit:
- (BOOL)validateTextStyleEdit:(id)sender;
/*"Description Forthcoming. Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStyle:
- (void)setStyle:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  variant
- (NSString *)variant;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setVariant:
- (void)setVariant:(id)argument;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewSyntaxParserVariantForStyle:
+ (NSString *)createNewSyntaxParserVariantForStyle:(NSString *)aStyle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TextNewSyntaxParserVariantController * controller = nil;
	if (controller = [[self.alloc initWithWindowNibName:NSStringFromClass(self)] autorelease])
    {
        [controller setStyle:[[aStyle copy] autorelease]];
		[controller setWindowFrameAutosaveName:NSStringFromClass(self)];
        NSWindow * W = controller.window;
        if (W)
        {
			[controller validateWindowContent4iTM3];
            [W makeKeyAndOrderFront:controller];
            if ([NSApp runModalForWindow:W] == 1)
			{
				NSString * variant = [controller variant];
				if (variant.length)
				{
					[iTM2TextSyntaxParser createAttributesServerWithStyle:[controller style] variant:variant];
					[W orderOut:controller];
					return variant;
				}
			}
            [W orderOut:controller];
        }
    }
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  styleEdited:
- (IBAction)styleEdited:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStyleEdited:
- (BOOL)validateStyleEdited:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue:([[iTM2TextSyntaxParser syntaxParserClassForStyle:self.style] prettySyntaxParserStyle]?:@"")];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  variantEdited:
- (IBAction)variantEdited:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = [sender stringValue];
	NSString * variant = self.variant;
    if (![variant pathIsEqual4iTM3:name])
    {
		NSString * style = self.style;
		NSDictionary * variants = [iTM2TextSyntaxParser syntaxParserVariantsForStyle:style];
		NSArray * lowerKeys = [variants valueForKeyPath:@"allKeys.@lowercaseString"];
		NSString * lowerName = [name lowercaseString];
        if (![lowerKeys containsObject:lowerName])
        {
			name = [[name copy] autorelease];
            [self setVariant:name];
            [NSApp stopModalWithCode:1];
        }
    }
    [sender.window validateContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateVariantEdited:
- (BOOL)validateVariantEdited:(NSTextField *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue:(self.variant.length? self.variant:@"")];
    if (self != (id)sender.delegate)
        sender.delegate = self;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  controlTextDidChange:
- (void)controlTextDidChange:(NSNotification *)aNotification
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = [[aNotification userInfo] objectForKey:@"NSFieldEditor"];
    if (!self.variant.length)
    {
        [self setVariant:[[[TV string] copy] autorelease]];
		self.validateWindowContent4iTM3;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[sender.window makeFirstResponder:nil];// force the text filed to end editing and send its message
//    [NSApp stopModalWithCode:1];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOK:
- (BOOL)validateOK:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return (self.variant.length>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [NSApp stopModalWithCode:0];
//END4iTM3;
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
- (BOOL)validateStyleMenuItem:(NSMenuItem *)sender;
{
	sender.action = @selector(submenuAction:);
	if (!sender.image)
	{
		NSImage * I = [NSImage cachedImageNamed4iTM3:@"iTM2FontsAndColors"];
		sender.image = I;//size
		[sender.image setSizeSmallIcon4iTM3];
	}
	return YES;// message catcher
}
@end
