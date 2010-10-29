/*
//  iTM2NewDocumentKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2005-2010 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A pARTICULAR pURPOSE.
//  See the GNU General public License for more details. You should have received a copy
//  of the GNU General public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

// all headers are private

#include "iTM2NewDocumentKit.h"

NSString * const iTM2NewDDATEKey = @"__(DATE)__";
NSString * const iTM2NewDTIMEKey = @"__(TIME)__";
NSString * const iTM2NewDYEARKey = @"__(YEAR)__";
NSString * const iTM2NewDPROJECTNAMEKey = @"__(PROJECTNAME)__";
NSString * const iTM2NewDFULLUSERNAMEKey = @"__(FULLUSERNAME)__";
NSString * const iTM2NewDAUTHORNAMEKey = @"__(AUTHORNAME)__";
NSString * const iTM2NewDORGANIZATIONNAMEKey = @"__(ORGANIZATIONNAME)__";

NSString * const iTM2NewDPathComponent = @"New Documents.localized";

@interface iTM2NewDocumentTreeNode:iTM2TreeNode
{
@private
    NSURL * iVarURLValue4iTM3;
    NSString * iVarPathValue4iTM3;
    NSString * iVarNameValue4iTM3;
    NSString * iVarPrettyNameValue4iTM3;
    NSURL * iVarStandaloneFileURLValue4iTM3;
}
+ (id)nodeWithParent:(id)parent;
- (void)sortChildrenAccordingToPrettyNameValue;
- (id)childWithPrettyNameValue:(NSString *) prettyName;
@property (copy,readwrite) NSURL * URLValue;
@property (copy,readwrite) NSString * pathValue;
@property (copy,readwrite) NSString * nameValue;
@property (copy,readwrite) NSString * prettyNameValue;
@property (assign,readwrite) NSURL * standaloneFileURLValue;
@end

/*!
    @class		iTM2NewDocumentAssistant
    @abstract	Assistant to create new documents
    @discussion	The assistant lets the user choose amongst a list of templates
				Then choose a name to save the document
				Finally, it creates the document from the template making the appropriate changes
*/

@interface iTM2NewDocumentAssistant(PRIVATE)
+ (id)_MutableDictionaryFromArray:(id)array;
+ (id)_ArrayFromDictionary:(id)dictionary;
+ (void)loadTemplates;
+ (void)_loadTemplatesAtURL:(NSURL *)path inTree:(iTM2NewDocumentTreeNode *)tree;
+ (id)newDocumentDataSource;
- (id)outlineView;
- (iTM2NewDocumentTreeNode *)selectedTemplate;
- (id)createSheet;
- (id)createField;
- (id)createProgressIndicator;
- (NSString *)convertedString:(NSString *) fileName withDictionary:(NSDictionary *) filter;
- (NSURL *)convertedURL:(NSURL *)fileURL withDictionary:(NSDictionary *)filter;
- (IBAction)next:(id)sender;
- (NSURL *)oldProjectURL;
- (void)setOldProjectURL:(id)argument;
- (IBAction)orderFrontPanelIfRelevant:(id)object;
- (id)savePanelAccessoryView;
- (void)validateCreationMode;
- (NSInteger)creationMode;
- (void)setCreationMode:(NSInteger)tag;
- (iTM2ProjectDocument *)projectTarget;
- (BOOL)selectedTemplateCanBeStandalone;
- (BOOL)item:(id)item canBeStandaloneForDirectory:(NSString *)directory;
- (BOOL)selectedTemplateCanCreateNewProject;
- (BOOL)item:(id)item canCreateNewProjectForDirectoryURL:(NSURL *)directoryURL;
- (BOOL)selectedTemplateCanInsertInOldProject;
- (BOOL)canInsertItem:(iTM2NewDocumentTreeNode *)item inOldProjectForDirectoryURL:(NSURL *)directoryURL;
- (NSURL *)standaloneFileURL;
- (id)availableProjects;
- (void)setAvailableProjects:(id) argument;
- (BOOL)preferWrapper;
- (void)setPreferWrapper:(BOOL) yorn;
- (BOOL)createNewWrapperWithURL:(NSURL *) fileURL error:(NSError **)outErrorPtr;
- (BOOL)createNewWrapperAndProjectWithURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
- (BOOL)createInNewProjectNewDocumentWithURL:(NSURL *) fileURL error:(NSError **)outErrorPtr;
- (BOOL)createInMandatoryProjectNewDocumentWithURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
- (BOOL)createInOldProjectNewDocumentWithURL:(NSURL *)targetURL error:(NSError **)outErrorPtr;
@end

@interface iTM2SharedResponder(NewDocumentKit)
- (void)newDocumentFromRunningAssistantPanelForProject4iTM3:(id)project;
@end

@implementation iTM2SharedResponder(NewDocumentKit)
static iTM2NewDocumentAssistant * _iTM2NewDocumentAssistant = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newDocumentFromRunningAssistantPanel:
- (IBAction)newDocumentFromRunningAssistantPanel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:25:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self newDocumentFromRunningAssistantPanelForProject4iTM3:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newDocumentFromRunningAssistantPanelForProject4iTM3:
- (void)newDocumentFromRunningAssistantPanelForProject4iTM3:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:26:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!_iTM2NewDocumentAssistant) {
		_iTM2NewDocumentAssistant = [[iTM2NewDocumentAssistant alloc]
			initWithWindowNibName: @"iTM2NewDocumentAssistant"];
	}
	_iTM2NewDocumentAssistant.mandatoryProjectURL = project.fileURL;
	[_iTM2NewDocumentAssistant orderFrontPanelIfRelevant:self];
//END4iTM3;
    return;
}
@end

#include <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>

@interface iTM2NewDocumentAssistant()
@property (readwrite,assign) BOOL preferWrapper;
@property (readwrite,assign) NSURL * panelDirectoryURL;
- (NSFileWrapper *)convertedFileWrapper:(NSFileWrapper *)FW withDictionary:(NSDictionary *)filter;
@end

@implementation iTM2NewDocumentAssistant

@synthesize createField = iVarCreateField;
@synthesize createProgressIndicator = iVarCreateProgressIndicator;
@synthesize createSheet = iVarCreateSheet;
@synthesize savePanelAccessoryView = iVarSavePanelAccessoryView;
@synthesize tabViewItemIdentifier = iVarTabViewItemIdentifier;
@synthesize templateImageView = iVarTemplateImageView;
@synthesize templateImage = iVarTemplateImage;
@synthesize templatePDFView = iVarTemplatePDFView;
@synthesize mandatoryProjectURL = iVarMandatoryProjectURL;
@synthesize oldProjectURL = iVarOldProjectURL;

static id _iTM2NewDocumentsTree = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataSourceWindowDidLoad4iTM3
- (void)dataSourceWindowDidLoad4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:31:18 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		@"%x", @"iTM2DateCalendarFormat",
		@"%X", @"iTM2TimeCalendarFormat",
		@"%Y", @"iTM2YearCalendarFormat",
		@"The 7th World Company", @"iTM2OrganizationName", nil]];
	// reload the data
	NSOutlineView * OLV = self.outlineView;
	[OLV setDelegate:self];
	OLV.dataSource = self;
	OLV.reloadData;
	OLV.doubleAction = @selector(_outlineViewDoubleAction:);
	// expand the first level items
	NSInteger row = [OLV numberOfRows];
	while (row--) {
		if ([OLV levelForRow:row] == 0) {
			[OLV expandItem:[OLV itemAtRow:row]];
		}
	}
	[OLV registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSStringPboardType, nil]];
	[self.window setDelegate:self];
	[self setPreferWrapper:[SUD boolForKey:iTM2NewDocumentEnclosedInWrapperKey]];
	[self setCreationMode:[SUD integerForKey:iTM2NewProjectCreationModeKey]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= newDocumentDataSource
+ (id)newDocumentDataSource;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:31:28 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return _iTM2NewDocumentsTree;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadTemplates
+ (void)loadTemplates;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:31:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// creating the data source model:
	// starting from the various Library/Application\ Support/iTeXMac2/Templates folders
	// the data model is a tree, node is a dictionary with
	// a "name" key for its name
	// a "object" key for its value
	// a "children" key for the children, which is an array of nodes.
	// Starting from the file wrappers:
	// the built in templates are gathered in localized directories.
	// They are stored in dictionaries which keys are either names or localized names
	// further templates read will override previously read templates with the same name.
	// We cannot ask the user to implement the localized stuff so we must consider the localized name as a good value
	LOG4iTM3(@"INFORMATION: Loading the templates...START");
	iTM2NewDocumentTreeNode * tree = [iTM2NewDocumentTreeNode nodeWithParent:nil];
	for (NSURL * url in [[[NSBundle mainBundle] allURLsForResource4iTM3:iTM2NewDPathComponent withExtension:@""] reverseObjectEnumerator]) {
		[self _loadTemplatesAtURL:url inTree:tree];
	}
	_iTM2NewDocumentsTree = tree;
	LOG4iTM3(@"INFORMATION: templates loaded.");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _loadTemplatesAtURL:inTree:
+ (void)_loadTemplatesAtURL:(NSURL *)url inTree:(iTM2NewDocumentTreeNode *)tree;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:48:56 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"+=+=+=+=+=+=+=+=+=+=  Loading Templates at path: %@", path);
	if (url.isFileURL) {
		url = [url URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
	} else {
		return;
	}
	// path is now expected to point to a folder
	INIT_POOL4iTM3;
	NSMutableString * hidden = [NSMutableString stringWithContentsOfURL:[url URLByAppendingPathComponent:@".hidden"] encoding:NSUTF8StringEncoding error:nil];
	if (hidden.length) {
		NSString * replacement= @"\n";
		unichar U = 0x000A;
		NSString * target = [NSString stringWithCharacters:&U length:1];
		[hidden replaceOccurrencesOfString:target withString:replacement options:0L range:iTM3MakeRange(0, hidden.length)];
		U = 0x000D;
		target = [NSString stringWithCharacters:&U length:1];
		[hidden replaceOccurrencesOfString:target withString:replacement options:0L range:iTM3MakeRange(0, hidden.length)];
		U = 0x0085;
		target = [NSString stringWithCharacters:&U length:1];
		[hidden replaceOccurrencesOfString:target withString:replacement options:0L range:iTM3MakeRange(0, hidden.length)];
	}
	NSArray * hiddenFiles = [hidden componentsSeparatedByString:@"\n"];
//- (id) _MutableDictionaryFromArray: (id) array;
//- (id) _ArrayFromDictionary: (id) dictionary;
	for (NSString * component in [DFM contentsOfDirectoryAtPath:url.path error:NULL]) {
//LOG4iTM3(@"+=+=+=+=+=+=+=+=+=+=  component: %@", component);
		if([component hasPrefix:@"."])
			continue;
		if([[component pathExtension] pathIsEqual4iTM3:@"templateDescription"])
			continue;
		if([[component pathExtension] pathIsEqual4iTM3:@"templateImage"])
			continue;
		if([component hasPrefix:@"."])
			continue;
		if([hiddenFiles containsObject:component])
			continue;
   		FSRef possibleInvisibleFile;
   		FSCatalogInfo catalogInfo;
		NSURL * fullURL = [url URLByAppendingPathComponent:component];
   		OSStatus errStat = FSPathMakeRef((UInt8 *)[fullURL.path fileSystemRepresentation], &possibleInvisibleFile, nil);
		if (!errStat) {
   			OSErr errStat = FSGetCatalogInfo(&possibleInvisibleFile, kFSCatInfoFinderInfo, &catalogInfo, nil, nil, nil);
			if(!errStat && ((FileInfo*)catalogInfo.finderInfo)->finderFlags & kIsInvisible)
   			   	continue;
		}
		// all the invisible file have been managed so far
		// Some note about the alias and sym links policy:
		// The name is attached to the file name and the contents is attached to the target.
		// this allows to have two different pointers to the same template
		// The name is determined before the alias or links are resolved
		// the object and children are determined once the alias or link has been resolved.
		NSString * name = component;
		NSURL * resolvedURL = [fullURL URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		BOOL isDirectory = NO;
		if (![DFM fileExistsAtPath:resolvedURL.path isDirectory:&isDirectory]) {
			continue;
        }
		NSURL * contentsURL = [fullURL URLByAppendingPathComponent:iTM2BundleContentsComponent];
		NSString * prettyName = [DFM prettyNameAtPath4iTM3:fullURL.path];
		iTM2NewDocumentTreeNode * child = nil;
		if(isDirectory
			&& (![SWS isFilePackageAtPath:resolvedURL.path]
				&& !([DFM fileExistsAtPath:contentsURL.path isDirectory:&isDirectory] && isDirectory)))
		{
			// this is considered as a directory
//LOG4iTM3(@"+=+=+=+=+=+=+=+=+=+=  DIRECTORY. %@, %@, %@", contentsPath, ([DFM fileExistsAtPath:contentsPath isDirectory:&isDirectory]?@"Y":@"N"), (isDirectory?@"Y":@"N"));
			child = [tree childWithPrettyNameValue:prettyName];
			if (!child) {
				child = [iTM2NewDocumentTreeNode nodeWithParent:tree];
				child.prettyNameValue = prettyName;
			}
			[self _loadTemplatesAtURL:resolvedURL inTree:child];
			if (![child countOfChildren]) {
				[tree removeObjectFromChildren:child];
			}
		} else {
			// at resolvedPath points either to a standard file or a file package or a directory containing a "Contents" folder
			// all of them are mapped to one separate entry
//LOG4iTM3(@"+=+=+=+=+=+=+=+=+=+=  FILE.");
			child = [iTM2NewDocumentTreeNode nodeWithParent:tree];
			child.nameValue = name;
			child.prettyNameValue = prettyName;
			child.URLValue = resolvedURL;
		}
	}
	if (tree.countOfChildren) {
		tree.nameValue = url.lastPathComponent;
		tree.prettyNameValue = [DFM displayNameAtPath:url.path];
		tree.URLValue = url;
	}
	RELEASE_POOL4iTM3;
//LOG4iTM3(@"Plug-ins loaded at path: %@", path);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3:
- (BOOL)windowPositionShouldBeObserved4iTM3:(NSWindow *)window;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:44:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setPanelDirectoryURL:
- (void)setPanelDirectoryURL:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:44:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iVarPanelDirectoryURL4iTM3 = object;
	self.availableProjects = nil;
	self.validateCreationMode;
	return;
}
@synthesize panelDirectoryURL = iVarPanelDirectoryURL4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= orderFrontPanelIfRelevant:
- (IBAction)orderFrontPanelIfRelevant:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:56:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self outlineView:self.outlineView numberOfChildrenOfItem:nil] != 0) {
		[self.window makeKeyAndOrderFront:self];
	} else {
		[SDC newDocument:object];
	}
//END4iTM3;
	return;
}
#pragma mark =-=-=-=-=-  OLV
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= outlineView
- (id)outlineView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:56:10 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSOutlineView * OLV = metaGETTER;
	if(OLV)
		return OLV;
	OLV = self.window.contentView;
	onceAgain:
	if (![OLV isKindOfClass:[NSOutlineView class]]) {
		NSArray * subviews = [OLV subviews];
		if (subviews.count) {
			OLV = [subviews objectAtIndex:0];
			goto onceAgain;
		} else {
			onceUp:;
			NSView * superview = [OLV superview];
			if (superview) {
				NSArray * subviews = [superview subviews];
				NSInteger index = [subviews indexOfObject:OLV];
				if (++index<subviews.count) {
					OLV = [subviews objectAtIndex:index];
					goto onceAgain;
				}
				OLV = (id)superview;
				goto onceUp;
			}
		}
	}
	metaSETTER(OLV);
//END4iTM3;
    return OLV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _outlineViewDoubleAction:
- (IBAction)_outlineViewDoubleAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:58:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger row = [sender selectedRow];
	id selectedItem = [sender itemAtRow:row];
	if(selectedItem && ![self outlineView:sender numberOfChildrenOfItem:selectedItem]) {
		[self next:sender];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplate
- (iTM2NewDocumentTreeNode *)selectedTemplate;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:57:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// just a message catcher
	NSOutlineView * OLV = self.outlineView;
//END4iTM3;
    return [OLV itemAtRow:OLV.selectedRow];
}
#pragma mark =-=-=-=-=-  DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:shouldSelectItem:
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:58:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = self.mandatoryProjectURL;
	if (url) {
		return [self canInsertItem:item inOldProjectForDirectoryURL:[url parentDirectoryURL4iTM3]];
	}
//END4iTM3;
    return ![[outlineView dataSource] outlineView:outlineView isItemExpandable:item];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineViewSelectionDidChange:
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:59:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.templateImage=nil;
	self.tabViewItemIdentifier=@"Image";
	[self.templatePDFView setDocument:nil];
    self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:willDisplayCell:forTableColumn:item:
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:59:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[outlineView dataSource] outlineView:outlineView isItemExpandable:item]) {
		NSMutableAttributedString * AS = [[[cell attributedStringValue] mutableCopy] autorelease];
		if (!AS.length) {
			return;
        }
		NSFont * F = [[AS attributesAtIndex:0 effectiveRange:nil] objectForKey:NSFontAttributeName];
		if (F) {
			F = [SFM convertFont:F toHaveTrait:NSBoldFontMask];
		} else {
			F = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
		}
		[AS addAttribute:NSFontAttributeName value:F range:iTM3MakeRange(0, AS.length)];
		[cell setAttributedStringValue:AS];
	} else if([self outlineView:outlineView shouldSelectItem:item]) {
		return;
	} else {
		NSMutableAttributedString * AS = [[[cell attributedStringValue] mutableCopy] autorelease];
		if(!AS.length) {
			return;
        }
		NSFont * F = [[AS attributesAtIndex:0 effectiveRange:nil] objectForKey:NSFontAttributeName];
		if(F) {
			F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		} else {
			F = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
		}
		[AS addAttribute:NSFontAttributeName value:F range:iTM3MakeRange(0, AS.length)];
		[AS addAttribute:NSForegroundColorAttributeName value:[NSColor disabledControlTextColor] range:iTM3MakeRange(0, AS.length)];
		[cell setAttributedStringValue:AS];
	}
	
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:willDisplayCell:shouldEditTableColumn:item:
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:00:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
#pragma mark =-=-=-=-=-  DATA SOURCE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:child:ofItem:
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:01:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [(item?:_iTM2NewDocumentsTree) objectInChildrenAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:isItemExpandable:
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:01:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [(item?:_iTM2NewDocumentsTree) countOfChildren]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:numberOfChildrenOfItem:
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:01:13 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [(item?:_iTM2NewDocumentsTree) countOfChildren];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:objectValueForTableColumn:byItem:
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:01:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [(item?:_iTM2NewDocumentsTree) prettyNameValue];
}
/*
// optional
- (void)outlineView:(NSOutlineView *)outlineView setPathValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView itemForPersistentObject:(id)object;
- (id)outlineView:(NSOutlineView *)outlineView persistentObjectForItem:(id)item;
*/
#pragma mark =-=-=-=-=- D & D
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:writeItems:toPasteboard:
- (BOOL)outlineView:(NSOutlineView *)olv writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the outline view once this call returns with YES.  The items array is the list of items that will be participating in the drag.
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:01:23 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:validateDrop:proposedItem:proposedChildIndex:
- (NSDragOperation)outlineView:(NSOutlineView*)olv validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index;
    // This method is used by NSOutlineView to determine a valid drop target.  Based on the mouse position, the outline view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropItem:dropChildIndex: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:01:27 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDragOperation result = NSDragOperationNone;
	NSPasteboard * pboard = [info draggingPasteboard];
	NSArray * Ts = [pboard types];
	if ([Ts containsObject:NSFilenamesPboardType]) {
		for (NSString * filename in [pboard propertyListForType:NSFilenamesPboardType]) {
            if ([DFM fileOrLinkExistsAtPath4iTM3:filename.stringByResolvingSymlinksAndFinderAliasesInPath4iTM3]) {
				result = NSDragOperationCopy;
				break;
			}
        }
	} else if([Ts containsObject:NSStringPboardType]) {
		result = NSDragOperationCopy;
	} else {
//END4iTM3;
		return NSDragOperationNone;
	}
	// don't drop on indexes
	if (index == NSOutlineViewDropOnItemIndex) {
		if(item) {
			if([olv isExpandable:item]) {
				if(![olv isItemExpanded:item]) {
					[olv expandItem:item];
                }
				[olv setDropItem:item dropChildIndex:0];
			} else {
				// finding the ancestor...
				NSInteger row = [olv rowForItem:item];
				if (row) {
					NSInteger level = [olv levelForRow:row];
					if (level) {
						NSInteger R = row;
						index = 0;
						while (R--) {
							NSInteger L = [olv levelForRow:R];
							if (L == level - 1) {
								item = [olv itemAtRow:R];
								[olv setDropItem:item dropChildIndex:index];
								break;
							} else if(L == level) {
								++index;
                            }
						}
						// if things are consistent, the above loop really breaks. 
					} else {
						NSInteger R = row;
						index = 0;
						while(R--) {
							if([olv levelForRow:R] == 0) {
								++index;
                            }
                        }
						item = nil;
						[olv setDropItem:item dropChildIndex:index];
					}
				} else {
					index = 0;
					item = nil;
					[olv setDropItem:nil dropChildIndex:index];
				}
			}
		} else {
			index = 0;
			[olv setDropItem:item dropChildIndex:index];
		}
	}
	// item and index are now consistent
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _delayed_outlineView:acceptDrop:item:childIndex:
- (BOOL)_delayed_outlineView:(NSOutlineView*)olv acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 09:14:43 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * dirname = item? [item pathValue]:
		[[NSBundle URLForSupportDirectory4iTM3:iTM2NewDPathComponent inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName4iTM3] create:YES] path];
	for (NSString * filename in [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType]) {
        filename = filename.stringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
		if ([DFM fileOrLinkExistsAtPath4iTM3:filename]) {
			NSString * target = [dirname stringByAppendingPathComponent:filename.lastPathComponent];
			if([target pathIsEqual4iTM3:filename]) {
				continue;
			} else if([DFM fileOrLinkExistsAtPath4iTM3:target]) {
				NSSavePanel * SP = [NSSavePanel savePanel];
				[SP pushNavLastRootDirectory4iTM3];
				[SP setTreatsFilePackagesAsDirectories:NO];
				[SP setDelegate:self];
				[SP beginSheetForDirectory:dirname file:nil modalForWindow:self.window
						modalDelegate: self didEndSelector:@selector(savePanelDidEnd:returnCode:filename:)
							contextInfo: filename];
				
			} else if(![DFM copyItemAtPath:filename toPath:target error:NULL]) {
				LOG4iTM3(@"*** ERROR: I could not copy %@ to %@, please do it yourself...", filename, target);
			}
		}
    }
//END4iTM3;
	[self.class loadTemplates];
	[self.outlineView reloadData];
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:acceptDrop:item:childIndex:
- (BOOL)outlineView:(NSOutlineView*)olv acceptDrop:(id <NSDraggingInfo>)info item:(iTM2NewDocumentTreeNode *)item childIndex:(NSInteger)index;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 09:15:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSPasteboard * pboard = [info draggingPasteboard];
	NSArray * Ts = [pboard types];
//LOG4iTM3(@"Ts are: %@", Ts);
	if ([Ts containsObject:NSFilenamesPboardType]) {
		NSMutableSet * filenames = [NSMutableSet set];
		for (NSString * filename in [pboard propertyListForType:NSFilenamesPboardType]) {
           filename = filename.stringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
			if([DFM fileOrLinkExistsAtPath4iTM3:filename]) {
				[filenames addObject:filename];
            }
        }
		if (filenames.count) {
            NSInvocation * I = nil;
            [[NSInvocation getInvocation4iTM3:&I withTarget:self]
                _delayed_outlineView:olv acceptDrop:info item:item childIndex:index];
			[I performSelectorOnMainThread:@selector(invokeWithTarget:) withObject:self waitUntilDone:NO];
            return YES;
		}
	} else if ([Ts containsObject:NSStringPboardType]) {
		NSString * contents = [pboard stringForType:NSStringPboardType];
		if (contents.length) {
			NSSavePanel * SP = [NSSavePanel savePanel];
			[SP pushNavLastRootDirectory4iTM3];
			[SP setTreatsFilePackagesAsDirectories:NO];
			[SP setDelegate:self];
            NSURL * dirURL = item? item.URLValue:
                [NSBundle URLForSupportDirectory4iTM3:iTM2NewDPathComponent
                    inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName4iTM3] create:YES];
			[SP beginSheetForDirectory:dirURL.path file:nil modalForWindow:self.window
					modalDelegate: self didEndSelector:@selector(savePanelDidEnd:returnCode:contents:)
						contextInfo: contents];
		}
		return YES;
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  savePanelDidEnd:returnCode:contents:
- (void)savePanelDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode contents:(NSString *)contents;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 09:16:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  concluding the drop sequence
	if (returnCode == NSOKButton) {
		NSString * target = [panel filename];
		if ([[contents dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] writeToFile:target atomically:YES]) {
			[self.class loadTemplates];
			[self.outlineView reloadData];
		} else {
			LOG4iTM3(@"*** ERROR: I could not save to %@, please do it yourself...", target);
		}
	}
	[panel popNavLastRootDirectory4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  savePanelDidEnd:returnCode:filename:
- (void)savePanelDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode filename:(NSString *)filename;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 09:19:01 UTC 2010
fTo Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (returnCode == NSOKButton) {
		NSString * target = panel.URL.path;
		if (![DFM copyItemAtPath:filename toPath:target error:NULL]) {
			LOG4iTM3(@"*** ERROR: I could not copy %@ to %@, please do it yourself...", filename, target);
		}
	}
	[panel popNavLastRootDirectory4iTM3];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=- UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:04:23 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.window orderOut:self];
	_iTM2NewDocumentAssistant = nil;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  next:
- (IBAction)next:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:04:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// seeding the creation mode: single document, already existing project, new project
	// If the document can create a new project, we have the choice
	// what mode?
	// If there is a mandatory project, things are more constrained
	// one of the problems is the memory
	// 
	self.validateCreationMode;
    NSSavePanel * SP = [NSSavePanel savePanel];
	[SP setDelegate:self];
	[SP setAccessoryView:self.savePanelAccessoryView];
	[SP pushNavLastRootDirectory4iTM3];
	[SP setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden]];
	[SP setCanSelectHiddenExtension:YES];
	NSString * newDirectory = nil;
	BOOL isDirectory = NO;
	NSURL * url = self.mandatoryProjectURL;
	if (url) {
		// the mandatory project is the one that asked for a new document
		newDirectory = url.parentDirectoryURL4iTM3.path;// the directory containing the mandatory project
		if ([DFM fileExistsAtPath:newDirectory isDirectory:&isDirectory] && isDirectory) {
			[SP setTreatsFilePackagesAsDirectories:YES];
			iTM2ProjectDocument * project = [SPC projectForURL:url];
			NSWindow * W = project.subdocumentsInspector.window;
			[W orderFront:nil];
			[self.window orderOut:self];
			[SP beginSheetForDirectory:newDirectory file:nil modalForWindow:(W?:self.window)
					modalDelegate: self didEndSelector:@selector(nextSavePanelDidEnd:returnCode:unused:)
							contextInfo: nil];
//END4iTM3;
			return;
		}
	}
	newDirectory = [self contextStringForKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	newDirectory = newDirectory.stringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
	if (![DFM fileExistsAtPath:newDirectory isDirectory:&isDirectory] || !isDirectory) {
		newDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectEnumerator] nextObject];	
	}
	[SP setTreatsFilePackagesAsDirectories:YES];
	[SP beginSheetForDirectory:newDirectory file:nil modalForWindow:self.window
			modalDelegate: self didEndSelector:@selector(nextSavePanelDidEnd:returnCode:unused:)
					contextInfo: nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNext:
- (BOOL)validateNext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:04:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self.outlineView numberOfSelectedRows] == 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startProgressIndicationForName:
- (void)startProgressIndicationForName:(NSString *) targetName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:04:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * sheet = self.createSheet;
	if (sheet) {
		NSProgressIndicator * PI = self.createProgressIndicator;
		[PI startAnimation:self];
		[PI setUsesThreadedAnimation:YES];
		self.createField.stringValue = targetName;
		[NSApp beginSheet:sheet modalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:nil];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  filterForProjectName:
- (NSDictionary *)filterForProjectName:(NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:05:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSCalendarDate * CD = [NSCalendarDate calendarDate];
	NSMutableDictionary * filter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		[CD descriptionWithCalendarFormat:[self contextStringForKey:@"iTM2DateCalendarFormat" domain:iTM2ContextAllDomainsMask]], iTM2NewDDATEKey,
		[CD descriptionWithCalendarFormat:[self contextStringForKey:@"iTM2TimeCalendarFormat" domain:iTM2ContextAllDomainsMask]], iTM2NewDTIMEKey,
		[CD descriptionWithCalendarFormat:[self contextStringForKey:@"iTM2YearCalendarFormat" domain:iTM2ContextAllDomainsMask]], iTM2NewDYEARKey,
		(projectName.length?projectName:@""), iTM2NewDPROJECTNAMEKey,
		NSFullUserName(), iTM2NewDFULLUSERNAMEKey,
		[self contextStringForKey:@"iTM2AuthorName" domain:iTM2ContextAllDomainsMask], iTM2NewDAUTHORNAMEKey,
		[self contextStringForKey:@"iTM2OrganizationName" domain:iTM2ContextAllDomainsMask], iTM2NewDORGANIZATIONNAMEKey,
			nil];
//END4iTM3;
    return filter;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stopProgressIndication
- (void)stopProgressIndication;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:05:18 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * sheet = self.createSheet;
	[NSApp endSheet:sheet];
	[self.createProgressIndicator stopAnimation:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nextSavePanelDidEnd:returnCode:unused:
- (void)nextSavePanelDidEnd:(NSSavePanel *)panel returnCode:(NSInteger)returnCode unused:(void*)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 17:05:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isExtensionHidden = [panel isExtensionHidden];
	[SUD setBool:isExtensionHidden forKey:NSFileExtensionHidden];
	[panel popNavLastRootDirectory4iTM3];
	[panel close];
    [self.window orderOut:self];
	if (returnCode == NSOKButton) {
		NSURL * URL = [panel URL];
		if(![DFM fileOrLinkExistsAtPath4iTM3:URL.path]
			|| [SWS performFileOperation:NSWorkspaceRecycleOperation
				source:URL.path.stringByDeletingLastPathComponent
					destination:nil
						files:[NSArray arrayWithObject:URL.path.lastPathComponent]
							tag:nil])
		{
            NSError * ROR = nil;
			[self createInMandatoryProjectNewDocumentWithURL:URL error:&ROR]
			|| [self createNewWrapperAndProjectWithURL:URL error:&ROR]// create a new wrapper and the new included project, if relevant
			|| [self createNewWrapperWithURL:URL error:&ROR]// create a new wrapper assuming that the included project will come for free
			|| [self createInNewProjectNewDocumentWithURL:URL error:&ROR]// create a new project if relevant, but no wrapper
			|| [self createInOldProjectNewDocumentWithURL:URL error:&ROR];// just insert the main file in the project if relevant
			if (ROR) {
                REPORTERROR4iTM3(2,@"There was a problem creating the new document",ROR);
            }
            
		} else {
			REPORTERROR4iTM3(1,@"There is already a file I can't remove",nil);
			[SWS activateFileViewerSelectingURLs:[NSArray arrayWithObject:URL]];
		}
	}
	[self.window orderOut:self];// the run modal is dangerous:don't autorelease when not garbage collected
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createInMandatoryProjectNewDocumentWithURL:error:
- (BOOL)createInMandatoryProjectNewDocumentWithURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:40:10 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * mandatoryURL = self.mandatoryProjectURL;
	if (!mandatoryURL) {
		return NO;
	}
	iTM2ProjectDocument * mandatoryProject = [SPC projectForURL:mandatoryURL];
	if (!mandatoryProject) {
		return NO;
	}
	// just insert a new document in an already existing project
	NSURL * sourceURL = self.standaloneFileURL;// must be a file URL?

	NSString * originalExtension = sourceURL.pathExtension;
	NSURL * targetDirectoryURL = mandatoryURL.URLByDeletingLastPathComponent;
	[self takeContextValue:targetDirectoryURL.path forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	NSString * fileName = fileURL.path;
	NSString * newCore = fileName;
	NSArray * newCoreComponents = newCore.pathComponents;
	NSArray * mandatoryNameComponents = mandatoryURL.path.pathComponents;
	NSRange R = iTM3MakeRange(mandatoryNameComponents.count, newCoreComponents.count);
	// if the document is added in a subdirectory...
	if (R.length>R.location) {
		R.length -= R.location;
		newCoreComponents = [newCoreComponents subarrayWithRange:R];
		newCore = [NSString pathWithComponents4iTM3:newCoreComponents];
	} else {
		newCore = newCore.lastPathComponent;
	}
	if (originalExtension.length) {
		newCore = [newCore.stringByDeletingPathExtension stringByAppendingPathExtension:originalExtension];
	}
    //  Manage spaces in filenames for tex documents
	if ([[SDC documentClassForType:[SDC typeForContentsOfURL:sourceURL error:outErrorPtr]] isSubclassOfClass:[iTM2TeXDocument class]]) {
		NSDictionary * filter = [NSDictionary dictionaryWithObject:	@"-" forKey:@" "];
		newCore = [self convertedString:newCore withDictionary:filter];
	}
	NSMutableDictionary * filter = [NSMutableDictionary dictionaryWithDictionary:[self filterForProjectName:mandatoryURL.path]];
	newCore = [self convertedString:newCore withDictionary:filter];

	NSURL * targetURL = [targetDirectoryURL URLByAppendingPathComponent:newCore];
	NSAssert(![DFM fileExistsAtPath:targetURL.path], @"***  My dear, you as a programmer are a big naze...");
	[self startProgressIndicationForName:targetURL.path];

	if ([DFM copyItemAtURL:sourceURL toURL:targetURL error:outErrorPtr]) {
		[DFM setExtensionHidden4iTM3:[SUD boolForKey:NSFileExtensionHidden] atURL:targetURL];
		BOOL isDirectory = NO;
		if ([DFM fileExistsAtPath:targetURL.path isDirectory:&isDirectory]) {
			NSMutableArray * urls = [NSMutableArray array];
			if (isDirectory) {
                [urls setArray:[[DFM enumeratorAtURL:targetURL includingPropertiesForKeys:[NSArray array] options:0 errorHandler:NULL] allObjects]];
			} else {
				[urls addObject:targetURL];
			}
            //  set the name of the project in the filter
            [filter setObject:mandatoryURL.lastPathComponent.stringByDeletingPathExtension forKey:iTM2NewDPROJECTNAMEKey];
			for (NSURL * url in urls) {
				[SPC setProject:mandatoryProject forURL:url];//
				iTM2TextDocument * document = [SDC openDocumentWithContentsOfURL:url display:YES error:outErrorPtr];
				if ([document isKindOfClass:[iTM2TextDocument class]]) {
					NSTextStorage * TS = [document textStorage];
					[TS beginEditing];
					[TS replaceCharactersInRange:iTM3MakeRange(0, TS.length)
                            withString:[self convertedString:TS.string withDictionary:filter]];
                    [TS endEditing];
				}//if([document isKindOfClass:[iTM2TextDocument class]])
				[document saveToURL:document.fileURL ofType:document.fileType forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
				document.undoManager.removeAllActions;
			}
			[mandatoryProject saveDocument:self];
		} else {
			LOG4iTM3(@"*** ERROR: Missing file at %@", targetURL);
		}
	} else {
		LOG4iTM3(@"*** ERROR: Could not copy %@ to %@", sourceURL, targetURL);
	}
	self.stopProgressIndication;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewWrapperAndProjectWithURL:error:
- (BOOL)createNewWrapperAndProjectWithURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:44:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.creationMode != iTM2ToggleNewProjectMode) {
		return NO;
	}
	if (!self.preferWrapper) {
		return NO;
	}
	NSURL * sourceURL = self.selectedTemplate.URLValue;
	NSArray * enclosedProjects = sourceURL.enclosedProjectURLs4iTM3;
	if(enclosedProjects.count!=0) {
		return NO;
	}
	[self takeContextValue:fileURL.path.stringByDeletingLastPathComponent forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	// No extension for fileName, the extension will be borrowed from the project
	NSString * projectName = fileURL.lastPathComponent.stringByDeletingPathExtension;
	NSURL * targetURL = [fileURL.URLByDeletingPathExtension URLByAppendingPathExtension:[SDC wrapperPathExtension4iTM3]];
	
	NSDictionary * filter = [self filterForProjectName:projectName];

	// we copy the whole directory at sourceName, possibly add a project, clean extra folders, change the names
	if ([DFM fileExistsAtPath:targetURL.path]) {
		LOG4iTM3(@"There is already a wrapper at %@...", targetURL);
	} else if(![DFM copyItemAtPath:sourceURL.path toPath:targetURL.path error:outErrorPtr]) {
		LOG4iTM3(@"*** ERROR: Could not copy %@ to %@", sourceURL, targetURL);
	}
	BOOL isDirectory;
	if ([DFM fileExistsAtPath:targetURL.path isDirectory:&isDirectory]) {
        //  Hide the extension if required by the user
		[DFM setExtensionHidden4iTM3:[self contextBoolForKey:NSFileExtensionHidden domain:iTM2ContextAllDomainsMask] atURL:targetURL];
		if (isDirectory) {
			// remove any "Contents" directory;
			NSString * deeper = [targetURL.path stringByAppendingPathComponent:iTM2BundleContentsComponent];
			if ([DFM fileOrLinkExistsAtPath4iTM3:deeper]) {
				NSInteger tag;
				if([SWS performFileOperation:NSWorkspaceRecycleOperation source:targetURL.path destination:nil
					files:[NSArray arrayWithObject:iTM2BundleContentsComponent] tag:&tag]) {
					LOG4iTM3(@"Recycling the \"Contents\" of directory %@...", targetURL);
				} else {
					LOG4iTM3(@"........... ERROR: Could not recycle the \"Contents\" directory...");
				}
			}
			// changing the name of all the files included in the newly created directory according to the filter above
			NSURL * convertedURL = nil;
            NSString * convertedPath = nil;
			for (NSString * path in [DFM enumeratorAtPath:targetURL.path]) {
				convertedPath = [self convertedString:path withDictionary:filter];
				if (![convertedPath pathIsEqual4iTM3:path]) {
					fileURL = [targetURL URLByAppendingPathComponent:path];
					convertedURL = [targetURL URLByAppendingPathComponent:convertedPath];
					convertedURL = convertedURL.URLByStandardizingPath;
					if (![DFM moveItemAtPath:fileURL.path toPath:convertedURL.path error:outErrorPtr]) {
						LOG4iTM3(@"..........  ERROR: Could not change\n%@\nto\n%@.", path, convertedPath);
					}
				}
			}
			// creating one at the top level or just below
			convertedPath = [self.standaloneFileURL.path stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:sourceURL.path];
			convertedPath = [self convertedString:convertedPath withDictionary:filter];
            convertedURL = [targetURL URLByAppendingPathComponent:convertedPath];
            convertedURL = convertedURL.URLByStandardizingPath;
			iTM2TeXProjectDocument * PD = [SPC getProjectFromPanelForURLRef:&convertedURL display:NO error:outErrorPtr];
			NSString * key = [PD createNewFileKeyForURL:convertedURL];
			[PD setMasterFileKey:key];
			
			NSDictionary * context = [NSDocument contextDictionaryFromURL:convertedURL];
			NSNumber * N = [context objectForKey:iTM2StringEncodingOpenKey];
			NSUInteger encoding = [N integerValue];
			NSString * S = nil;
			if (encoding) {
				if(!(S = [NSString stringWithContentsOfURL:convertedURL encoding:encoding error:outErrorPtr])) {
					S = [NSString stringWithContentsOfURL:convertedURL usedEncoding:&encoding error:outErrorPtr];
				}
			} else {
				S = [NSString stringWithContentsOfURL:convertedURL usedEncoding:&encoding error:outErrorPtr];
			}
			S = [self convertedString:S withDictionary:filter];
			NSData * D = [S dataUsingEncoding:encoding allowLossyConversion:YES];
			[D writeToURL:convertedURL options:NSAtomicWrite error:outErrorPtr];
			[PD makeWindowControllers];
			[PD showWindows];
			[PD openSubdocumentWithContentsOfURL:convertedURL context:context display:YES error:outErrorPtr];
			[PD saveDocument:self];
//END4iTM3;
			return YES;
		} else {
			LOG4iTM3(@"*** ERROR: Missing directory at %@", targetURL);
		}
	} else {
		LOG4iTM3(@"*** ERROR: Missing file at %@", targetURL);
	}
	self.stopProgressIndication;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewWrapperWithURL:error:
- (BOOL)createNewWrapperWithURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 10:24:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.creationMode != iTM2ToggleNewProjectMode) {
		return NO;
	}
	if (!self.preferWrapper) {
		return NO;
	}
	NSURL * sourceURL = self.selectedTemplate.URLValue;
	NSArray * enclosedProjects = sourceURL.enclosedProjectURLs4iTM3;
	if (enclosedProjects.count==0) {
		return NO;
	}
	[self takeContextValue:sourceURL.URLByDeletingLastPathComponent.path forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	// No extension for fileName, the extension will be borrowed from the project
	fileURL = fileURL.URLByDeletingPathExtension;
	NSURL * targetURL = [fileURL URLByAppendingPathExtension:[SDC wrapperPathExtension4iTM3]];
	NSString * projectName = fileURL.lastPathComponent;
	
	NSDictionary * filter = [self filterForProjectName:projectName];

	// we copy the whole directory at sourceName, possibly add a project, clean extra folders, change the names
	if (targetURL.isFileURL) {
        if ( [DFM fileExistsAtPath:targetURL.path]) {
            LOG4iTM3(@"There is already a wrapper at %@...", targetURL);
        } else if(![DFM copyItemAtPath:sourceURL.path toPath:targetURL.path error:outErrorPtr]) {
            LOG4iTM3(@"*** ERROR: Could not copy %@ to %@", sourceURL, targetURL);
        }
        BOOL isDirectory = NO;
        if ([DFM fileExistsAtPath:targetURL.path isDirectory:&isDirectory]) {
            [DFM setExtensionHidden4iTM3:[SUD boolForKey:NSFileExtensionHidden] atURL:targetURL];
            if (isDirectory) {
                // remove any "Contents" directory;
                NSURL * deeperURL = [targetURL URLByAppendingPathComponent:iTM2BundleContentsComponent];
                if ([DFM fileOrLinkExistsAtPath4iTM3:deeperURL.path]) {
                    NSInteger tag;
                    if ([SWS performFileOperation:NSWorkspaceRecycleOperation source:targetURL.path destination:nil
                            files:[NSArray arrayWithObject:iTM2BundleContentsComponent] tag:&tag]) {
                        LOG4iTM3(@"Recycling the \"Contents\" of directory %@...", targetURL);
                    } else {
                        LOG4iTM3(@"........... ERROR: Could not recycle the \"Contents\" directory...");
                    }
                }
                // changing the name of all the files included in the newly created directory according to the filter above
                NSURL * originalURL = nil;
                NSURL * convertedURL = nil;
                for (originalURL in [DFM enumeratorAtURL:targetURL includingPropertiesForKeys:[NSArray array] options:0 errorHandler:NULL]) {
                    convertedURL = [self convertedURL:originalURL withDictionary:filter];
                    if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
                        if(![DFM moveItemAtPath:originalURL.path toPath:convertedURL.URLByStandardizingPath.path error:outErrorPtr]) {
                            LOG4iTM3(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalURL, convertedURL);
                        }
                    }
                }
                // Modify the project file, to sync with the possibly modified file names
                iTM2TeXProjectDocument * PD = nil;
                for (originalURL in targetURL.enclosedProjectURLs4iTM3) {
                    originalURL = originalURL.URLByStandardizingPath;
    //LOG4iTM3(@"originalURL is: %@", originalURL);
                    // originalURL is no longer used
                    // open the project document
                    PD = [SDC openDocumentWithContentsOfURL:originalURL display:NO error:outErrorPtr];// first registerProject
    //LOG4iTM3(@"[SDC documents]:%@",[SDC documents]);
                    // filter out the declared files
                    for (NSString * key in [PD.mainInfos fileKeys]) {
    //LOG4iTM3(@"key is: %@", key);
    //LOG4iTM3(@"document is: %@", document);
                        iTM2TextDocument * document = nil;
                        if(document = [PD subdocumentForFileKey:key]) {
                            // then change the file name:
                            originalURL = document.fileURL;
                            convertedURL = [self convertedURL:originalURL withDictionary:filter];
    //LOG4iTM3(@"convertedPath is: %@", convertedPath);
                            if(![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
                                [PD setURL:convertedURL forFileKey:key];
                                document.fileURL = convertedURL;
                            }
                            if ([document isKindOfClass:[iTM2TextDocument class]]) {
                                NSTextStorage * TS = [document textStorage];
                                NSString * new = [self convertedString:TS.string withDictionary:filter];
                                [TS beginEditing];
                                [TS replaceCharactersInRange:iTM3MakeRange(0, TS.length) withString:new];
                                [TS endEditing];
                                [document saveToURL:document.fileURL ofType:document.fileType forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
                                document.undoManager.removeAllActions;
    //LOG4iTM3(@"Open document saved");
                            }
                        } else if(originalURL = [PD URLForFileKey:key]) {
                            convertedURL = [self convertedURL:originalURL withDictionary:filter];
                            if(![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
                                [PD setURL:convertedURL forFileKey:key];// do this before...
                            }
                            document = [SDC openDocumentWithContentsOfURL:convertedURL display:NO error:outErrorPtr];
    //LOG4iTM3(@"document is: %@", document);
                            if ([document isKindOfClass:[iTM2TextDocument class]]) {
                                NSTextStorage * TS = [document textStorage];
                                NSString * old = [TS string];
                                NSString * new = [self convertedString:old withDictionary:filter];
                                [TS beginEditing];
                                [TS replaceCharactersInRange:iTM3MakeRange(0, TS.length) withString:new];
                                [TS endEditing];
                            }
    //LOG4iTM3(@"originalPath is: %@", originalPath);
    //LOG4iTM3(@"convertedPath is: %@", convertedPath);
                            if(PD != (id)document) {
                                [document saveToURL:document.fileURL ofType:document.fileType forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
                                [document close];
    //LOG4iTM3(@"Document saved and closed");
                            }
                        }
                    }
                    [PD saveDocument:self];
                    [[PD undoManager] removeAllActions];
                    [PD makeWindowControllers];
                    [PD showWindows];
                }
                // changing the name of all the files included in the newly created directory according to the filter above
                for (originalURL in [DFM enumeratorAtURL:targetURL includingPropertiesForKeys:[NSArray array] options:0 errorHandler:NULL]) {
                    convertedURL = [self convertedURL:originalURL withDictionary:filter];
                    if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
                        if (![DFM moveItemAtPath:originalURL.path toPath:convertedURL.URLByStandardizingPath.path error:outErrorPtr]) {
                            LOG4iTM3(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalURL, convertedURL);
                        }
                    }
                }
                // changing the file permissions: it is relevant if the document was built in...
                [DFM makeFileWritableAtPath4iTM3:targetURL.path recursive:YES];
                if (![SWS isFilePackageAtPath:targetURL.path]) {
                    NSImage * I = [SWS iconForFile:sourceURL.path];
                    if(I) {
                        [SWS setIcon:I forFile:targetURL.path options:NSExclude10_4ElementsIconCreationOption];
                    }
                }
                // what are the available documents
                // I must create a project here before calling the next stuff, is it really true?
    //			NSURL * url = [NSURL fileURLWithPath:targetName];
    //			[SDC openDocumentWithContentsOfURL:url display:YES error:outErrorPtr];//second registerProject
            } else {
                LOG4iTM3(@"*** ERROR: Missing directory at %@", targetURL);
            }
        } else {
            LOG4iTM3(@"*** ERROR: Missing file at %@", targetURL);
        }
    }
	self.stopProgressIndication;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createInNewProjectNewDocumentWithURL:error:
- (BOOL)createInNewProjectNewDocumentWithURL:(NSURL *) fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 10:23:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.creationMode != iTM2ToggleNewProjectMode) {
		return NO;
	}
	if (self.preferWrapper) {
		return NO;
	}
	NSURL * sourceURL = self.selectedTemplate.URLValue;
    //  create a file wrapper for that URL
    //  remove all the unnecessary stuff
    //  change the names and the contents
    //  finally save the result
    //  We start by opening all the available projects
    //  Then we convert all the projects
    //  Then all the documents owned by the project
    //  Then all the other documents
    NSMutableArray * alreadyURLs = [NSMutableArray array];
    for (NSURL * projectURL in sourceURL.enclosedProjectURLs4iTM3) {
        NSString * type = [SDC typeForContentsOfURL:projectURL error:outErrorPtr];
        Class C = [SDC documentClassForType:type];
        iTM2ProjectDocument * PD = [[C alloc] initWithContentsOfURL:projectURL error:outErrorPtr];
        
    }
    NSFileWrapper * FW = [[NSFileWrapper alloc] initWithURL:sourceURL options:NSFileWrapperReadingImmediate error:outErrorPtr];
    if (!FW) {
        return YES;//   returns YES BUT there was an error
    }
    //  resolve the symbolic links
    NSUInteger firewall = 256;
    while (FW.isSymbolicLink) {
        sourceURL = FW.symbolicLinkDestinationURL;
        FW = [[NSFileWrapper alloc] initWithURL:FW.symbolicLinkDestinationURL options:NSFileWrapperReadingImmediate error:outErrorPtr];
        if (--firewall) {
            continue;
        } else {
            OUTERROR4iTM3((-1),(@"Too many links"),nil);
            return YES;
        }
    }
	fileURL = fileURL.URLByDeletingPathExtension;
	NSURL * targetURL = fileURL;
	NSString * projectName = fileURL.lastPathComponent;
	[self takeContextValue:targetURL.URLByDeletingLastPathComponent.path
		forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	if ([DFM fileExistsAtPath:targetURL.path]) {
		LOG4iTM3(@"There is already a project at\n%@",targetURL);
	}
	NSDictionary * filter = [self filterForProjectName:projectName];
    [self convertedFileWrapper:FW withDictionary:filter];
    
    if (FW.isDirectory) {
        
    }
    // UTTypeCreatePreferredIdentifierForTag
	// No extension for fileName, the extension will be borrowed from the project
	// we copy the whole directory at sourceURL
	// add a project
	// clean extra folders
	// change the names
	// what is the target name?
    
	if ([DFM copyItemAtPath:sourceURL.path toPath:fileURL.path error:outErrorPtr]) {
		BOOL isDirectory = NO;
		if ([DFM fileExistsAtPath:targetURL.path isDirectory:&isDirectory]) {
			if (isDirectory) {
				// the original "file" might be either a project or a wrapper
				// remove any "Contents" directory;
				NSURL * deeperURL = [targetURL URLByAppendingPathComponent:iTM2BundleContentsComponent];
				if ([DFM fileOrLinkExistsAtPath4iTM3:deeperURL.path]) {
					NSInteger tag;
					if ([SWS performFileOperation:NSWorkspaceRecycleOperation source:targetURL.path destination:nil
                            files:[NSArray arrayWithObject:iTM2BundleContentsComponent] tag:&tag]) {
						LOG4iTM3(@"Recycling the \"Contents\" of directory %@...", targetURL);
					} else {
						LOG4iTM3(@"........... ERROR: Could not recycle the \"Contents\" directory...");
					}
				}
				// Modify the project files,
				// finding the contained projects
				NSURL * originalURL = nil;
				NSURL * convertedURL = nil;
				for (originalURL in targetURL.enclosedProjectURLs4iTM3) {
					originalURL = originalURL.URLByStandardizingPath;
					convertedURL = [self convertedURL:originalURL withDictionary:filter];
					if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
						if (![DFM moveItemAtURL:originalURL toURL:convertedURL error:outErrorPtr]) {
							LOG4iTM3(@"..........  ERROR: Could not change the project file name.");
							convertedURL = originalURL;
						}
					}
					// originalURL is no longer used
					// open the project document
					iTM2ProjectDocument * PD = [SDC openDocumentWithContentsOfURL:convertedURL display:NO error:outErrorPtr];
					// filter out all the declared files
					for (NSString * key in PD.fileKeys) {
						iTM2TextDocument * document = [PD subdocumentForFileKey:key];
						if ([document isKindOfClass:[iTM2TextDocument class]]) {
							NSTextStorage * TS = document.textStorage;
							NSString * old = TS.string;
							NSString * new = [self convertedString:old withDictionary:filter];
							TS.beginEditing;
							[TS replaceCharactersInRange:iTM3MakeRange(0, TS.length) withString:new];
							TS.endEditing;
							// then change the file name:
							originalURL = document.fileURL;
							convertedURL = [self convertedURL:originalURL withDictionary:filter];
                            //  manage spaces in file names
							if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
								if ([DFM moveItemAtPath:originalURL.path toPath:convertedURL.path error:outErrorPtr]) {
									[PD setURL:convertedURL forFileKey:key];
									document.fileURL = convertedURL;
								} else {
									LOG4iTM3(@"..........  ERROR: Could not change the project document file name -1.");
								}
							}
							[document saveToURL:document.fileURL ofType:document.fileType forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
							document.undoManager.removeAllActions;
//LOG4iTM3(@"Open document saved");
						} else if (!document) {
							originalURL = [PD URLForFileKey:key];
//LOG4iTM3(@"originalPath is: %@", originalPath);
							convertedURL = [self convertedURL:originalURL withDictionary:filter];
//LOG4iTM3(@"convertedPath is: %@", convertedPath);
							NSString * typeName = [SDC typeForContentsOfURL:originalURL error:outErrorPtr];
							if (typeName.length) {
								Class C = [SDC documentClassForType:typeName];
								if ([C isSubclassOfClass:[iTM2TextDocument class]]) {
									document = [SDC openDocumentWithContentsOfURL:originalURL display:NO error:outErrorPtr];
									NSString * old = document.stringRepresentation;
									iTM2StringFormatController * stringFormatter4iTM3 = document.stringFormatter4iTM3;
									NSStringEncoding encoding = stringFormatter4iTM3.stringEncoding;
									NSMutableDictionary * filteredFilter = filter.mutableCopy;
									// convert the filter to the new encoding
									// just in case this was not suitable, do not loose much.
									for (NSString * key in filter.keyEnumerator) {
										NSString * translation = [filter objectForKey:key];
										NSData * data = [translation dataUsingEncoding:encoding allowLossyConversion:YES];
										translation = [[NSString alloc] initWithData:data encoding:encoding];
										[filteredFilter setObject:translation forKey:key];
									}
									document.stringRepresentation = [self convertedString:old withDictionary:filteredFilter];
								}
							}
							if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
								if (document) {
									// originalPath must exist
									// convertedPath must not exist
									#warning Links mngt?
									if ([DFM fileExistsAtPath:originalURL.path])/* links? */ {
										if ([DFM fileExistsAtPath:convertedURL.path]) {
											LOG4iTM3(@"..........  ERROR: Already existing file at\n%@");
										} else {
											if ([DFM moveItemAtPath:originalURL.path toPath:convertedURL.path error:outErrorPtr]) {
												[PD setURL:convertedURL forFileKey:key];
												document.fileURL = convertedURL;
											} else {
												LOG4iTM3(@"..........  ERROR: Could not move\n%@ to\n%@", originalURL, convertedURL);
											}
										}
									} else {
										LOG4iTM3(@"..........  WARNING: Missing file at\n%@", originalURL);// should not go there because the doc is already existing!
									}
								} else {
									[PD setURL:convertedURL forFileKey:key];
								}
							}
							[document stringRepresentationCompleteWriteToURL4iTM3:document.fileURL ofType:document.fileType error:outErrorPtr];
							document.close;
LOG4iTM3(@"[PD subdocumentForFileKey:%@]:%@",key,[PD subdocumentForFileKey:key]);
LOG4iTM3(@"Document saved and closed");
						}
					}
					[PD saveDocument:self];
					PD.undoManager.removeAllActions;
					PD.makeWindowControllers;
					PD.showWindows;
				}
				// changing the name of all the files included in the newly created directory according to the filter above
                
                for (originalURL in [DFM enumeratorAtURL:targetURL includingPropertiesForKeys:[NSArray array] options:0 errorHandler:NULL]) {
                    convertedURL = [self convertedURL:originalURL withDictionary:filter];
                    if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
                        if (![DFM moveItemAtPath:originalURL.path toPath:convertedURL.URLByStandardizingPath.path error:outErrorPtr]) {
                            LOG4iTM3(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalURL, convertedURL);
                        }
                    }
                }
				// changing the file permissions: it is relevant if the document was built in...
				[DFM makeFileWritableAtPath4iTM3:targetURL.path recursive:YES];
				if (![SWS isFilePackageAtPath:targetURL.path]) {
					NSImage * I = [SWS iconForFile:sourceURL.path];
					if (I) {
						[SWS setIcon:I forFile:targetURL.path options:NSExclude10_4ElementsIconCreationOption];
					}
				}
				// I must create a project here before calling the next stuff
				[SDC openDocumentWithContentsOfURL:targetURL display:YES error:outErrorPtr];
			} else {
				LOG4iTM3(@"*** ERROR: Missing directory at %@", targetURL);
			}
		} else {
			LOG4iTM3(@"*** ERROR: Missing file at %@", targetURL);
		}
	} else {
		LOG4iTM3(@"*** ERROR: Could not copy %@ to %@", sourceURL, targetURL);
	}
	self.stopProgressIndication;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createInOldProjectNewDocumentWithURL:error:
- (BOOL)createInOldProjectNewDocumentWithURL:(NSURL *)targetURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 10:41:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.creationMode != iTM2ToggleOldProjectMode) {
		return NO;
	}
	NSURL * oldProjectURL = self.oldProjectURL;
	if (!oldProjectURL) {
		LOG4iTM3(@"*** ERROR: I have been asked to create a document in an old project, but Ii was not given an old project...");
		return NO;//<< this is a bug
	}
	if ([SWS isWrapperPackageAtURL4iTM3:oldProjectURL])/* Crash Log Report */ {
		if (!oldProjectURL.enclosedProjectURLs4iTM3.count && ![SWS isTeXProjectPackageAtURL4iTM3:oldProjectURL]) {
			return NO;
		}
	}
	iTM2ProjectDocument * oldProject = [SDC openDocumentWithContentsOfURL:oldProjectURL display:NO error:outErrorPtr];
	if (!oldProject) {
		return YES;
	}
#warning **** ERROR: this MUST be revisited, together with the other similar methods above
	//  remember the location where the new document should be stored
	[self takeContextValue:oldProject.parentURL.path
		forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	
	NSAssert(![DFM fileExistsAtPath:targetURL.path], @"***  My dear, you as a programmer are a big naze...");

	[self startProgressIndicationForName:targetURL.path];
	NSURL * sourceURL = self.standaloneFileURL;
	if ([DFM copyItemAtPath:sourceURL.path toPath:targetURL.path error:outErrorPtr]) {
		[DFM setExtensionHidden4iTM3:[SUD boolForKey:NSFileExtensionHidden] atURL:targetURL];
		BOOL isDirectory = NO;
		if ([DFM fileExistsAtPath:targetURL.path isDirectory:&isDirectory]) {
			NSDictionary * filter = [self filterForProjectName:oldProject.fileURL.lastPathComponent];
			NSURL * originalURL = nil;
			NSURL * convertedURL = nil;
			if (isDirectory) {
				// changing the file permissions: it is relevant if the document was built in...
				[DFM makeFileWritableAtPath4iTM3:targetURL.path recursive:YES];
				// If necessary, the project will be created as expected side effect
				iTM2TextDocument * document = [SDC openDocumentWithContentsOfURL:targetURL display:YES error:outErrorPtr];
				for (originalURL in [DFM enumeratorAtURL:targetURL includingPropertiesForKeys:[NSArray array] options:0 errorHandler:NULL]) {
                    originalURL = originalURL.URLByStandardizingPath;
                    convertedURL = [self convertedURL:originalURL withDictionary:filter];
                    if (![convertedURL.path pathIsEqual4iTM3:originalURL.path]) {
                        if(![DFM moveItemAtPath:originalURL.path toPath:convertedURL.URLByStandardizingPath.path error:outErrorPtr]) {
                            LOG4iTM3(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalURL, convertedURL);
                        }
                    }
					if ([[SDC documentClassForType:[SDC typeForContentsOfURL:originalURL error:outErrorPtr]] isSubclassOfClass:[iTM2TeXDocument class]]) {
						iTM2TeXDocument * document = [SDC openDocumentWithContentsOfURL:originalURL display:NO error:outErrorPtr];
						NSTextStorage * TS = document.textStorage;
						TS.beginEditing;
						[TS replaceCharactersInRange:iTM3MakeRange(0, TS.length) withString:[self convertedString:TS.string withDictionary:filter]];
                        TS.endEditing;
					}
				}
				[oldProject saveDocument:self];
				[[oldProject undoManager] removeAllActions];
				[document saveToURL:document.fileURL ofType:document.fileType forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
				document.undoManager.removeAllActions;
			} else {
				[oldProject createNewFileKeyForURL:targetURL];
				// changing the file permissions: it is relevant if the document was built in...
				[DFM makeFileWritableAtPath4iTM3:targetURL.path recursive:YES];
				// If necessary, the project will be created as expected side effect
				iTM2TextDocument * document = [SDC openDocumentWithContentsOfURL:targetURL display:YES error:outErrorPtr];
				if ([document isKindOfClass:[iTM2TextDocument class]]) {
					NSTextStorage * TS = [document textStorage];
					[TS beginEditing];
					[TS replaceCharactersInRange:iTM3MakeRange(0, TS.length) withString:[self convertedString:TS.string withDictionary:filter]];
					[TS endEditing];
				}
				[oldProject saveDocument:self];
				[[oldProject undoManager] removeAllActions];
				[document saveToURL:document.fileURL ofType:document.fileType forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
				document.undoManager.removeAllActions;
			}
		} else {
			LOG4iTM3(@"*** ERROR: Missing file at %@", targetURL);
		}
	} else {
		LOG4iTM3(@"*** ERROR: Could not copy %@ to %@", sourceURL, targetURL);
	}
	self.stopProgressIndication;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  convertedFileWrapper:withDictionary:
- (NSFileWrapper *)convertedFileWrapper:(NSFileWrapper *)FW withDictionary:(NSDictionary *)filter;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 12:47:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (FW.isDirectory) {
        for (NSFileWrapper * fw in FW.fileWrappers.copy) {
            NSFileWrapper * newFW = [self convertedFileWrapper:fw withDictionary:filter];
            if (![fw isEqual:newFW]) {
                [FW removeFileWrapper:fw];
                [FW addFileWrapper:newFW];
            }
        }
    } else if (FW.isRegularFile) {
        //  How can I retrieve the file encoding ?
        //  The old method was based on the text document class
        if ([[SDC documentClassForType:[SDC typeForContentsOfURL:originalURL error:NULL]] isSubclassOfClass:[iTM2TextDocument class]]) {
            iTM2TextDocument * document = [SDC openDocumentWithContentsOfURL:originalURL display:NO error:outErrorPtr];
            NSTextStorage * TS = document.textStorage;
            TS.beginEditing;
            [TS replaceCharactersInRange:iTM3MakeRange(0, TS.length) withString:[self convertedString:TS.string withDictionary:filter]];
            TS.endEditing;
        }
    }
    FW.preferredFilename = [self convertedString:FW.filename withDictionary:filter];
    
//END4iTM3;
    return FW;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  convertedURL:withDictionary:
- (NSURL *)convertedURL:(NSURL *)fileURL withDictionary:(NSDictionary *)filter;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 12:47:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return fileURL.isFileURL?
        [NSURL fileURLWithPath:[self convertedString:fileURL.path withDictionary:filter]]
        :fileURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  convertedString:withDictionary:
- (NSString *)convertedString:(NSString *)fileName withDictionary:(NSDictionary *)filter;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 12:47:26 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableString * MS = [[fileName mutableCopy] autorelease];
	for (NSString * target in filter.keyEnumerator) {
		if(target.length) {
			NSString * replacement = [filter objectForKey:target];
			[MS replaceOccurrencesOfString:target withString:replacement options:0L range:iTM3MakeRange(0, MS.length)];
		}
	}
//END4iTM3;
    return [MS copy];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTemplateDescription:
- (IBAction)editTemplateDescription:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 12:47:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// just a message catcher
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTemplateDescription:
- (BOOL)validateEditTemplateDescription:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 12:47:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSString * noDescriptionAvailable = nil;
	if (!noDescriptionAvailable) {
		noDescriptionAvailable = sender.stringValue.copy;
	}
#warning EXC_BAD_ACCESS here
//LOG4iTM3(@"Item is: %@ (%@)", item, [item pathValue]);
	NSURL * baseURL = self.selectedTemplate.URLValue;
	if (!baseURL) {
		return NO;
	}
	NSBundle * B = [NSBundle bundleWithURL:baseURL];
	NSURL * url = nil;
//LOG4iTM3(@"base1 is: %@", base);
	if (!B) {
		url = [baseURL URLByAppendingPathExtension:@"templateDescription"];
//LOG4iTM3(@"base2 is: %@", base);
		B = [NSBundle bundleWithURL:baseURL];
		if (!B) {
			sender.stringValue = noDescriptionAvailable;
			self.templateImage=nil;
			[self.templatePDFView setDocument:nil];
			return NO;
		}
	}
//LOG4iTM3(@"fixing");
	// fixing the template image
	url = [B URLForImageResource:@"templateImage"];
	if (url.isFileURL) {
		if ([[SDC typeForContentsOfURL:url error:NULL] isEqualToUTType4iTM3:(NSString *)kUTTypePDF]) {
			PDFDocument * D = nil;
longemer:
			D = [[PDFDocument alloc] initWithURL:url];
			[self.templatePDFView setDocument:D];
			self.tabViewItemIdentifier = @"PDF";
		} else {
			NSImage * I = [[NSImage alloc] initWithContentsOfURL:url];
			if (nil == I) {
				// is there a unique pdf file at the top level?
				for (NSString * component in [DFM contentsOfDirectoryAtPath:B.bundlePath error:NULL]) {
                    url = [B.bundleURL URLByAppendingPathComponent:component];
					if ([[SDC typeForContentsOfURL:url error:NULL] isEqualToUTType4iTM3:(NSString *)kUTTypePDF]) {
                        goto longemer;
					}
				}
				I = [SWS iconForFile:self.standaloneFileURL.path];
			}
			self.templateImage = I;
			self.tabViewItemIdentifier = @"Image";
		}
	} else {
		self.templateImage = nil;
	}
	// select the tab view containing V, which is the view containing the appropriate information
	// fixing the template image: looking for an rtf file and then a text file
	url = [B URLForResource:@"templateDescription" withExtension:@"rtf"];
	if (url.isFileURL) {
		NSAttributedString * description = [[NSAttributedString alloc]
			initWithRTF: [NSData dataWithContentsOfURL:url] documentAttributes:nil];
		if(description.length) {
			sender.attributedStringValue = description;
			return NO;
		}
	}
	url = [B URLForResource:@"templateDescription" withExtension:@"txt"];
	if (url.isFileURL) {
		NSString * description = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];// encoding?
		if (description.length) {
			sender.stringValue = description;
			return NO;
		}
	}
	sender.stringValue = noDescriptionAvailable;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTemplateFolderPath:
- (IBAction)editTemplateFolderPath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:40:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// just a message catcher
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTemplateFolderPath:
- (BOOL)validateEditTemplateFolderPath:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:41:12 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// just a message catcher
	NSURL * url = [NSBundle URLForSupportDirectory4iTM3:iTM2NewDPathComponent inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName4iTM3] create:YES];
	sender.stringValue = (url.isFileURL? url.path:@"");
//END4iTM3;
    return NO;
}
#pragma mark =-=-=-=-=- SAVE PANEL DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:shouldEnableURL:
- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 13:10:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return url.isFileURL && ![SWS isTeXProjectPackageAtURL4iTM3:url] && ![SWS isTeXProjectPackageAtURL4iTM3:url];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:didChangeToDirectoryURL:
- (void)panel:(id)sender didChangeToDirectoryURL:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 13:10:47 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setPanelDirectoryURL:url];// will make some setups too
	[sender validateContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:userEnteredFilename:confirmed:
- (NSString *)panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 13:11:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// this is where we manage the extension
	// If the user entered an extension, we do nothing because we expect the user to know what he is doing
	// If the user entered an extensionless file name, then we add the extension based on the creation mode and the template
	if (!filename.pathExtension.length) {
		NSString * requiredPathExtension = nil;
		switch(self.creationMode) {
			case iTM2ToggleOldProjectMode:// insert in existing project
			case iTM2ToggleStandaloneMode:// standalone document (in fact with an faraway project)
			// it is not expected to be a project or a wrapper: it is a standalone document
				requiredPathExtension = self.standaloneFileURL.path.pathExtension;
				break;
			case iTM2ToggleNewProjectMode:// create new project
			default:
			{
				id item = self.selectedTemplate;
				requiredPathExtension = [item pathValue];
				requiredPathExtension = [requiredPathExtension pathExtension];
				break;
			}
		}
		if (requiredPathExtension.length) {
			filename = [filename stringByAppendingPathExtension:requiredPathExtension];
		}
	}
	if ([[SDC typeForContentsOfURL:[NSURL fileURLWithPath:filename] error:NULL] isEqualToString:iTM2TeXDocumentType]) {
		NSDictionary *filter = [NSDictionary dictionaryWithObject:@"-" forKey:@" "];
		filename = [self convertedString:filename withDictionary:filter];
	}
//END4iTM3;
    return filename;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:validateURL:error:
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 13:12:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger creationMode = self.creationMode;
	NSURL * mandatoryURL = self.mandatoryProjectURL;
	if (creationMode == iTM2ToggleForbiddenProjectMode) {
		if (mandatoryURL) {
			mandatoryURL = mandatoryURL.parentDirectoryURL4iTM3.absoluteURL;
			[sender setDirectoryURL:mandatoryURL];
		}
		return NO;
	}
	if (!url.isFileURL) {
		return NO;
	}
	BOOL result = NO;
	if (mandatoryURL) {
		mandatoryURL = mandatoryURL.parentDirectoryURL4iTM3.absoluteURL;
		if ([url.path belongsToDirectory4iTM3:mandatoryURL.path]) {
			return YES;
		} else {
			[sender setDirectoryURL:mandatoryURL];
			return NO;
		}
	} else {//
		switch (self.creationMode) {
			case iTM2ToggleStandaloneMode: result = self.selectedTemplateCanBeStandalone; break;
			case iTM2ToggleOldProjectMode: result = self.selectedTemplateCanInsertInOldProject; break;
			default:
                if (self.selectedTemplateCanCreateNewProject) {
                    NSURL * targetURL = [url.URLByDeletingPathExtension URLByAppendingPathExtension:[SDC wrapperPathExtension4iTM3]];
                    result = self.selectedTemplateCanCreateNewProject && ![DFM fileExistsAtPath:targetURL.path];
                    break;
                }
		}
	}
	if (result) {
		return YES;
	}
	NSURL * enclosingURL = url.enclosingWrapperURL4iTM3;
	if(enclosingURL) {
		mandatoryURL = enclosingURL.parentDirectoryURL4iTM3;
	} else if (enclosingURL = url.enclosingProjectURL4iTM3) {
		mandatoryURL = enclosingURL.parentDirectoryURL4iTM3;
	}
	if (mandatoryURL) {
		[sender setDirectoryURL:mandatoryURL];
	}
//END4iTM3;
    return NO;
}
#pragma mark =-=-=-=-=- OTHER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTarget
- (iTM2ProjectDocument *)projectTarget;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 13:21:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.standaloneFileURL.isFileURL? [SPC projectForURL:self.mandatoryProjectURL]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInsertItem:inOldProjectForDirectoryURL:
- (BOOL)canInsertItem:(iTM2NewDocumentTreeNode *)item inOldProjectForDirectoryURL:(NSURL *)directoryURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:41:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * directory = directoryURL.path;
	if (![DFM isWritableFileAtPath:directory]) {
//END4iTM3;
		return NO;
	}
	if (directoryURL.belongsToFactory4iTM3) {
		return NO;// nothing can be added in the faraway projects directory
	}
	NSURL * enclosing = directoryURL.enclosingProjectURL4iTM3;
	if (enclosing) {
		return NO;// nothing can be inserted inside a .texp project directory
	}
	NSURL * standalone = item.standaloneFileURLValue;
	if (!standalone.isFileURL) {
		return NO;
	}
	if ([SWS isWrapperPackageAtURL4iTM3:standalone]) {
		return NO;
	}
	NSURL * mandatoryURL = self.mandatoryProjectURL;
	if (mandatoryURL) {
		if ([SWS isProjectPackageAtURL4iTM3:mandatoryURL]) {
			return NO;
		}
		mandatoryURL = mandatoryURL.parentDirectoryURL4iTM3;
		NSString * relative = [directory stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:mandatoryURL.path];
		if ([relative hasPrefix:@".."]) {
			return NO;
		}
		return YES;
	}
	if ([SWS isTeXProjectPackageAtURL4iTM3:standalone]) {
		enclosing = directoryURL.enclosingWrapperURL4iTM3;
		if (enclosing) {
			return enclosing.enclosedProjectURLs4iTM3.count == 0;
		}
		NSDictionary * available = [SPC availableProjectsForURL:standalone];
		for (enclosing in available.keyEnumerator) {
			if ([SWS isWrapperPackageAtURL4iTM3:enclosing]) {
                if (enclosing.enclosedProjectURLs4iTM3.count == 0) {
					return YES;
				}
			}
		}
		return NO;
	}
//END4iTM3;
	return [[SPC availableProjectsForURL:directoryURL] count]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplateCanInsertInOldProject
- (BOOL)selectedTemplateCanInsertInOldProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:41:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self canInsertItem:self.selectedTemplate inOldProjectForDirectoryURL:self.panelDirectoryURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  item:canCreateNewProjectForDirectoryURL:
- (BOOL)item:(id)item canCreateNewProjectForDirectoryURL:(NSURL *)directoryURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:43:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![DFM isWritableFileAtPath:directoryURL.path]) {
//END4iTM3;
		return NO;
	}
	if (self.mandatoryProjectURL) {
//END4iTM3;
		return NO;
	}
	if (directoryURL.belongsToFactory4iTM3) {
//END4iTM3;
		return NO;// nothing can be added in the faraway projects directory
	}
	NSURL * enclosing = directoryURL.enclosingProjectURL4iTM3;
	if (enclosing) {
//END4iTM3;
		return NO;// nothing can be inserted inside a .texp project directory
	}
	// and if the directory is not in a wrapper
	enclosing = directoryURL.enclosingWrapperURL4iTM3;
	if (enclosing) {
		NSArray * enclosed = enclosing.enclosedProjectURLs4iTM3;
		if (enclosed.count) {
//END4iTM3;
			return NO;// nothing can be inserted inside a .texd wrapper directory
		}
	}
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplateCanCreateNewProject
- (BOOL)selectedTemplateCanCreateNewProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:43:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self item:self.selectedTemplate canCreateNewProjectForDirectoryURL:self.panelDirectoryURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  item:canBeStandaloneForDirectoryURL:
- (BOOL)item:(iTM2NewDocumentTreeNode *)item canBeStandaloneForDirectoryURL:(NSURL *)directoryURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:43:52 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![DFM isWritableFileAtPath:directoryURL.path]) {
//END4iTM3;
		return NO;
	}
	if (self.mandatoryProjectURL) {
//END4iTM3;
		return NO;
	}
	if (directoryURL.belongsToFactory4iTM3) {
		return NO;// nothing can be added in the faraway projects directory
	}
	if (directoryURL.enclosingProjectURL4iTM3) {
		return NO;// nothing can be inserted inside a .texp project directory
	}
	if (directoryURL.enclosingWrapperURL4iTM3) {
		return NO;// no standalone projects inside a wrapper
	}
	// two conditions
	// 1 the template has a standalone file name
	// 2 the current panel directory is not included in a wrapper
	// except when the wrapper no longer has a project
	NSURL * url = item.standaloneFileURLValue;
	if ([SWS isProjectPackageAtURL4iTM3:url]) {
		return NO;
	}
	if ([SWS isWrapperPackageAtURL4iTM3:url]) {
		return NO;
	}
//END4iTM3;
    return url.isFileURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplateCanBeStandalone
- (BOOL)selectedTemplateCanBeStandalone;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:43:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self item:self.selectedTemplate canBeStandaloneForDirectoryURL:self.panelDirectoryURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  standaloneFileURL
- (NSURL *)standaloneFileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar  5 20:37:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self.selectedTemplate.standaloneFileURLValue;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCreationMode
- (void)validateCreationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:21:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!self.panelDirectoryURL) {
		return;
	}
	NSInteger creationMode = self.creationMode;
	if((creationMode == iTM2ToggleOldProjectMode) && self.selectedTemplateCanInsertInOldProject) {
		return;
	} else if((creationMode == iTM2ToggleNewProjectMode) && self.selectedTemplateCanCreateNewProject) {
		return;
	} else if((creationMode == iTM2ToggleStandaloneMode) && self.selectedTemplateCanBeStandalone) {
		return;
	}
	creationMode = iTM2ToggleForbiddenProjectMode;
	if(self.selectedTemplateCanBeStandalone) {
		creationMode = iTM2ToggleStandaloneMode;
	} else if(self.selectedTemplateCanCreateNewProject) {
		creationMode = iTM2ToggleNewProjectMode;
	} else if(self.selectedTemplateCanInsertInOldProject) {
		creationMode = iTM2ToggleOldProjectMode;
	}
	self.creationMode = creationMode;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  creationMode
- (NSInteger)creationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:22:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * result = metaGETTER;
//END4iTM3;
    return result?[result integerValue]:[SUD integerForKey:iTM2NewProjectCreationModeKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCreationMode:
- (void)setCreationMode:(NSInteger)tag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:22:08 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([NSNumber numberWithInteger:tag]);
	if(tag>=0)
	{
		[SUD setInteger:tag forKey:iTM2NewProjectCreationModeKey];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeCreationModeFromTag:
- (IBAction)takeCreationModeFromTag:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:18:27 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// Hum, the sender is the matrix despite each cell is connected separately in interface builder
	self.creationMode = [sender.selectedCell tag];
	self.validateCreationMode;
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeCreationModeFromTag:
- (BOOL)validateTakeCreationModeFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:18:12 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger creationMode = self.creationMode;
	if (creationMode == iTM2ToggleForbiddenProjectMode) {
		sender.state = NSOffState;
		return NO;
	}
	BOOL selected = sender.tag == creationMode;
	sender.state = (selected? NSOnState:NSOffState);
#if 1
	BOOL result = YES;
	switch(sender.tag)
	{
#warning DEBUGGGGGGGGGGG CLEAN the standalone
//		case iTM2ToggleStandaloneMode: result = self.selectedTemplateCanBeStandalone;break;
		case iTM2ToggleOldProjectMode: result = self.selectedTemplateCanInsertInOldProject;break;
		default: result = self.selectedTemplateCanCreateNewProject;break;
	}
	NSAssert(!selected || result, @"Missed(1)");
	return result;
#else
// next code does not give the expected result (at least with gdb 09/13/2006 Mac OS X 10.4.6)
	switch(sender.tag)
	{
		case iTM2ToggleOldProjectMode: return self.selectedTemplateCanInsertInOldProject;break;
		case iTM2ToggleStandaloneMode: return self.selectedTemplateCanBeStandalone;break;
		default: return self.selectedTemplateCanCreateNewProject;break;
	}
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeProjectFromSelectedItem:
- (IBAction)takeProjectFromSelectedItem:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:16:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * new = [sender.selectedItem representedObject];
	NSURL * old = self.oldProjectURL;
	if ([old isEquivalentToURL4iTM3:new]) {
		return;
	}
	[self setOldProjectURL:new];
	if (![new belongsToFactory4iTM3] && [SWS isWrapperPackageAtURL4iTM3:new]) {
		NSSavePanel * SP = [NSSavePanel savePanel];
		[SP setDirectoryURL:new];
		[SP update];
	}
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeProjectFromSelectedItem:
- (BOOL)validateTakeProjectFromSelectedItem:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:15:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * oldProjectURL = self.oldProjectURL;
	if ([sender isKindOfClass:[NSPopUpButton class]]) {
		[sender removeAllItems];
		NSDictionary * availableProjects = self.availableProjects;
		for (NSURL * url in  availableProjects.keyEnumerator) {
			NSString * displayName = [availableProjects objectForKey:url];
			displayName = displayName.stringByDeletingPathExtension;
			[sender addItemWithTitle:displayName];
			NSMenuItem * item = [sender lastItem];
			item.representedObject = url;
            NSImage * icon = [SWS iconForFile:url.path];
			NSSize iconSize = [icon size];
			if (iconSize.height > 0) {
				CGFloat height = sender.frame.size.height;
				height -= 8;
				iconSize.width *= height/iconSize.height;
				iconSize.height = height;
				[icon setScalesWhenResized:YES];
				[icon setSize:iconSize];
			}
			item.image = icon;
		}
		if ([sender numberOfItems]>0) {
			NSInteger index = 0;
			if(!oldProjectURL) {
				oldProjectURL = [[sender itemAtIndex:index] representedObject];
				[self setOldProjectURL:oldProjectURL];
			} else {
				index = [sender indexOfItemWithRepresentedObject:oldProjectURL];
				if (index<0) {
					// the old project oldProjectURL, if any, is not listed in the available projects
					index = 0;// a better choice?
					oldProjectURL = [[sender itemAtIndex:index] representedObject];
					[self setOldProjectURL:oldProjectURL];
				}
			}
			[sender selectItemAtIndex:index];
			return self.selectedTemplateCanInsertInOldProject
					&& ([sender numberOfItems]>1)
						&& (self.creationMode == iTM2ToggleOldProjectMode);
		}
		return NO;
	} else if ([sender isKindOfClass:[NSMenuItem class]]) {
		NSURL * standalone = self.standaloneFileURL;
		if (!standalone.isFileURL) {
			return NO;
		}
		if ([SWS isWrapperPackageAtURL4iTM3:standalone]) {
			return NO;
		}
		if ([SWS isTeXProjectPackageAtURL4iTM3:standalone]) {
			standalone = [(NSMenuItem *)sender representedObject];
			if ([SWS isWrapperPackageAtURL4iTM3:standalone]) {
				if (!standalone.enclosedProjectURLs4iTM3.count) {
					return YES;
				}
			}
			return NO;
		}
		return YES;
	}
    return NO;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPreferWrapper:
- (void)setPreferWrapper:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:42:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD setBool:yorn forKey:iTM2NewDocumentEnclosedInWrapperKey];
	iVarPreferWrapper4iTM3 = yorn;
//END4iTM3;
    return;
}
@synthesize preferWrapper = iVarPreferWrapper4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleWrapper:
- (IBAction)toggleWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:43:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iVarPreferWrapper4iTM3 = !iVarPreferWrapper4iTM3;
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWrapper:
- (BOOL)validateToggleWrapper:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:38:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = (self.preferWrapper? NSOnState:NSOffState);
//END4iTM3;
    return self.creationMode == iTM2ToggleNewProjectMode;
}
#pragma mark =-=-=-=-=-  DATA SOURCE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjects
- (NSDictionary *)availableProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 13:07:49 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iVarAvailableProjects4iTM3) {
		return iVarAvailableProjects4iTM3;
	}
	NSURL * url = self.panelDirectoryURL;
	NSURL * enclosing = url.enclosingWrapperURL4iTM3;
	if (enclosing) {
		NSString * displayName = enclosing.path.lastPathComponent.stringByDeletingPathExtension;
		iVarAvailableProjects4iTM3 = [NSDictionary dictionaryWithObject:displayName forKey:enclosing];
	} else {
		iVarAvailableProjects4iTM3 = [SPC availableProjectsForURL:url];
	}
//END4iTM3;
    return iVarAvailableProjects4iTM3;
}
@synthesize availableProjects = iVarAvailableProjects4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfItemsInComboBox:
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:38:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.availableProjects.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:objectValueForItemAtIndex:
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:38:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self.availableProjects.allKeys objectAtIndex:index] path];// are the keys ordered?
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:indexOfItemWithStringValue:
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:38:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:completedString:
- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:37:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return string;
}
#endif
- (void)showHelp:(id) sender;
{
	return;
}
@end

@implementation NSUserDefaultsController(NewDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeNewDocumentAuthorNameFromCombo:
- (IBAction)takeNewDocumentAuthorNameFromCombo:(NSComboBox *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:37:49 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * author = [sender stringValue];
	if ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) {
		[self.values setValue:[NSArray array] forKey:@"iTM2KnownAuthorsList"];
	} else if(author.length) {
		NSArray * original = [self.values valueForKey:@"iTM2KnownAuthorsList"];
		NSMutableArray * authors = [NSMutableArray arrayWithArray:([original isKindOfClass:[NSArray class]]? original:nil)];
		[authors removeObject:author];
		[authors insertObject:author atIndex:0];
		[self.values setValue:authors forKey:@"iTM2KnownAuthorsList"];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeNewDocumentOrganizationNameFromCombo:
- (IBAction)takeNewDocumentOrganizationNameFromCombo:(NSComboBox *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:37:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * organization = [sender stringValue];
	if ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) {
		[self.values setValue:[NSArray array] forKey:@"iTM2KnownOrganizationsList"];
	} else if(organization.length) {
		NSArray * original = [self.values valueForKey:@"iTM2KnownOrganizationsList"];
		NSMutableArray * organizations = [NSMutableArray arrayWithArray:([original isKindOfClass:[NSArray class]]? original:nil)];
		[organizations removeObject:organization];
		[organizations insertObject:organization atIndex:0];
		[self.values setValue:organizations forKey:@"iTM2KnownOrganizationsList"];
	}
//END4iTM3;
    return;
}
@end

@implementation iTM2MainInstaller(NewDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newDocumentKitCompleteInstallation4iTM3
+ (void)newDocumentKitCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:37:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2NewDocumentAssistant loadTemplates];
    if ([[iTM2NewDocumentAssistant newDocumentDataSource] countOfChildren]>0) {
		MILESTONE4iTM3((@"iTM2NewDocumentKit"),(@"No New Documents templates available"));
	}
//END4iTM3;
	return;
}
@end

@interface iTM2NewDocumentPrefPane:iTM2PreferencePane
@end

@implementation iTM2NewDocumentPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 15:37:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return @"2.New";
}
@end

@implementation iTM2NewDocumentTreeNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nodeWithParent:
+ (id)nodeWithParent:(id)tree;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:31:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.alloc initWithParent:tree value:[NSMutableDictionary dictionary]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sortChildrenAccordingToPrettyNameValue
- (void)sortChildrenAccordingToPrettyNameValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:23:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSUInteger index = self.countOfChildren;
	while (index--) {
		iTM2NewDocumentTreeNode * child = [self objectInChildrenAtIndex:index];
		[MD setObject:child forKey:[child prettyNameValue]];
	}
	for (NSString * K in [[MD allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
		id O = [MD objectForKey:K];
		[self removeObjectFromChildren:O];
		[self addObjectInChildren:O];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childWithPrettyNameValue:
- (id)childWithPrettyNameValue:(NSString *) prettyName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:24:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger index = self.countOfChildren;
	while(index--) {
		iTM2NewDocumentTreeNode * child = [self objectInChildrenAtIndex:index];
		if([prettyName isEqualToString:child.prettyNameValue]) {
			return child;
		}
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPrettyNameValue:
- (void)setPrettyNameValue:(NSString *) prettyName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:25:15 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iVarPrettyNameValue4iTM3 = prettyName.copy;
	[self.parent sortChildrenAccordingToPrettyNameValue];
//END4iTM3;
	return;
}
@synthesize prettyNameValue = iVarPrettyNameValue4iTM3;
@synthesize nameValue = iVarNameValue4iTM3;
@synthesize pathValue = iVarPathValue4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  standaloneFileURLValue
- (NSURL *)standaloneFileURLValue;
/*"The standalone file name is used to for the main file.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 16:25:27 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iVarStandaloneFileURLValue4iTM3) {
		return iVarStandaloneFileURLValue4iTM3;
	}
	NSURL * sourceURL = self.URLValue;
	if (!sourceURL.isFileURL) {
		return nil;
	}
	BOOL isDirectory = NO;
	if ([DFM fileExistsAtPath:sourceURL.path isDirectory:&isDirectory]) {
		if (isDirectory) {
			NSBundle * B = [NSBundle bundleWithURL:sourceURL];
			NSString * component = [B.infoDictionary objectForKey:@"iTM2StandaloneFileName"];
			if (component.length) {
				NSURL * url = [sourceURL URLByAppendingPathComponent:component];
				if ([DFM fileExistsAtPath:url.path]) {
					return self.standaloneFileURLValue = url;
				} else {
					NSLog(@"There is no file at: %@", url);
				}
			}
			if ([SWS isTeXProjectPackageAtURL4iTM3:sourceURL]) {
				self.standaloneFileURLValue = nil;
				return sourceURL;
			}
		} else {
            return self.standaloneFileURLValue = sourceURL;
		}
	}
	return self.standaloneFileURLValue = nil;
//END4iTM3;
}
@synthesize standaloneFileURLValue = iVarStandaloneFileURLValue4iTM3;
@synthesize URLValue = iVarURLValue4iTM3;
@end

@implementation NSFileManager(NewDocumentKit)
- (BOOL)newDocumentIsPrivateFileAtPath4iTM3:(NSString *)path;
{
	return [[path pathComponents] containsObject:iTM2NewDPathComponent];
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2NewDocumentKit

#include "../build/Milestones/iTM2NewDocumentKit.m"
