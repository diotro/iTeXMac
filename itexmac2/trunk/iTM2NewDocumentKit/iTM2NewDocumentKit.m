/*
//  iTM2NewDocumentKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright ¬© 2005 Laurens'Tribune. All rights reserved.
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
+ (id)nodeWithParent:(id)parent;
- (void)sortChildrenAccordingToPrettyNameValue;
- (id)childWithPrettyNameValue:(NSString *) prettyName;
- (id)prettyNameValue;
- (void)setPrettyNameValue:(NSString *) prettyName;
- (id)nameValue;
- (void)setNameValue:(NSString *) name;
- (id)pathValue;
- (void)setPathValue:(NSString *) path;
- (id)standaloneFileNameValue;
- (void)setStandaloneFileNameValue:(NSString *) path;
- (id)containsAProjectValue;
- (void)setContainsAProjectValue:(NSNumber *) value;
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
+ (void)_loadTemplatesAtPath:(NSString *)path inTree:(iTM2NewDocumentTreeNode *)tree;
+ (id)newDocumentDataSource;
- (id)outlineView;
- (id)selectedTemplate;
- (id)createSheet;
- (id)createField;
- (id)createProgressIndicator;
- (NSString *)convertedString:(NSString *) fileName withDictionary:(NSDictionary *) filter;
- (IBAction)next:(id)sender;
- (NSString *)panelDirectory;
- (void)setPanelDirectory:(id)object;
- (id)mandatoryProject;
- (void)setMandatoryProject:(id)object;
- (NSString *)oldProjectName;
- (void)setOldProjectName:(id)argument;
- (IBAction)orderFrontPanelIfRelevant:(id)object;
- (id)savePanelAccessoryView;
- (void)validateCreationMode;
- (int)creationMode;
- (void)setCreationMode:(int)tag;
- (iTM2ProjectDocument *)projectTarget;
- (BOOL)selectedTemplateCanBeStandalone;
- (BOOL)item:(id)item canBeStandaloneForDirectory:(NSString *)directory;
- (BOOL)selectedTemplateCanCreateNewProject;
- (BOOL)item:(id)item canCreateNewProjectForDirectory:(NSString *)directory;
- (BOOL)selectedTemplateCanInsertInOldProject;
- (BOOL)canInsertItem:(id)item inOldProjectForDirectory:(NSString *)directory;
- (NSString *)standaloneFileName;
- (id)availableProjects;
- (void)setAvailableProjects:(id) argument;
- (BOOL)preferWrapper;
- (void)setPreferWrapper:(BOOL) yorn;
- (BOOL)createNewWrapperWithName:(NSString *) fileName;
- (BOOL)createNewWrapperAndProjectWithName:(NSString *)fileName;
- (BOOL)createInNewProjectNewDocumentWithName:(NSString *) fileName;
- (BOOL)createInMandatoryProjectNewDocumentWithName:(NSString *)fileName;
- (BOOL)createInOldProjectNewDocumentWithName:(NSString *)targetName;
@end

@interface iTM2SharedResponder(NewDocumentKit)
- (void)newDocumentFromRunningAssistantPanelForProject:(id)project;
@end

@implementation iTM2SharedResponder(NewDocumentKit)
static iTM2NewDocumentAssistant * _iTM2NewDocumentAssistant = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newDocumentFromRunningAssistantPanel:
- (IBAction)newDocumentFromRunningAssistantPanel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self newDocumentFromRunningAssistantPanelForProject:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newDocumentFromRunningAssistantPanelForProject:
- (void)newDocumentFromRunningAssistantPanelForProject:(id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!_iTM2NewDocumentAssistant)
	{
		_iTM2NewDocumentAssistant = [[iTM2NewDocumentAssistant allocWithZone:[self zone]]
			initWithWindowNibName: @"iTM2NewDocumentAssistant"];
	}
	[_iTM2NewDocumentAssistant setMandatoryProject:project];
	[_iTM2NewDocumentAssistant orderFrontPanelIfRelevant:self];
//iTM2_END;
    return;
}
@end

@implementation iTM2NewDocumentAssistant
static id _iTM2NewDocumentsTree = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataSourceWindowDidLoad
- (void)dataSourceWindowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		@"%x", @"iTM2DateCalendarFormat",
		@"%X", @"iTM2TimeCalendarFormat",
		@"%Y", @"iTM2YearCalendarFormat",
		@"The 7th World Company", @"iTM2OrganizationName", nil]];
	// reload the data
	NSOutlineView * OLV = [self outlineView];
	[OLV setDelegate:self];
	[OLV setDataSource:self];
	[OLV reloadData];
	[OLV setDoubleAction:@selector(_outlineViewDoubleAction:)];
	// expand the first level items
	int row = [OLV numberOfRows];
	while(row--)
	{
		if([OLV levelForRow:row] == 0)
		{
			[OLV expandItem:[OLV itemAtRow:row]];
		}
	}
	[OLV registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSStringPboardType, nil]];
	[[self window] setDelegate:self];
	[self setPreferWrapper:[SUD boolForKey:iTM2NewDocumentEnclosedInWrapperKey]];
	[self setCreationMode:[SUD integerForKey:iTM2NewProjectCreationModeKey]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= newDocumentDataSource
+ (id)newDocumentDataSource;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _iTM2NewDocumentsTree;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadTemplates
+ (void)loadTemplates;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
	iTM2_LOG(@"INFORMATION: Loading the templates...START");
	iTM2NewDocumentTreeNode * tree = [iTM2NewDocumentTreeNode nodeWithParent:nil];
	NSBundle * B = [NSBundle mainBundle];
	NSArray * paths = [B allPathsForResource:iTM2NewDPathComponent ofType:@"" inDirectory:@""];
	NSEnumerator * E = [paths reverseObjectEnumerator];
	NSString * path = nil;
	while(path = [E nextObject])
	{
		[self _loadTemplatesAtPath:path inTree:tree];
	}
	[_iTM2NewDocumentsTree autorelease];
	_iTM2NewDocumentsTree = [tree retain];
	iTM2_LOG(@"INFORMATION: templates loaded.");
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _loadTemplatesAtPath:inTree:
+ (void)_loadTemplatesAtPath:(NSString *)path inTree:(iTM2NewDocumentTreeNode *)tree;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"+=+=+=+=+=+=+=+=+=+=  Loading Templates at path: %@", path);
	if([path length])
	{
		path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	}
	else
	{
		return;
	}
	// path is now expected to point to a folder
	iTM2_INIT_POOL;
	NSMutableString * hidden = [NSMutableString stringWithContentsOfFile:[path stringByAppendingPathComponent:@".hidden"]];
	if([hidden length])
	{
		NSString * replacement= @"\n";
		unichar U = 0x000A;
		NSString * target = [NSString stringWithCharacters:&U length:1];
		[hidden replaceOccurrencesOfString:target withString:replacement options:0L range:NSMakeRange(0, [hidden length])];
		U = 0x000D;
		target = [NSString stringWithCharacters:&U length:1];
		[hidden replaceOccurrencesOfString:target withString:replacement options:0L range:NSMakeRange(0, [hidden length])];
		U = 0x0085;
		target = [NSString stringWithCharacters:&U length:1];
		[hidden replaceOccurrencesOfString:target withString:replacement options:0L range:NSMakeRange(0, [hidden length])];
	}
	NSArray * hiddenFiles = [hidden componentsSeparatedByString:@"\n"];
//- (id) _MutableDictionaryFromArray: (id) array;
//- (id) _ArrayFromDictionary: (id) dictionary;
	NSEnumerator * DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
	NSString * component;
	while(component = [DE nextObject])
	{
//iTM2_LOG(@"+=+=+=+=+=+=+=+=+=+=  component: %@", component);
		if([component hasPrefix:@"."])
			continue;
		if([[component pathExtension] pathIsEqual:@"templateDescription"])
			continue;
		if([[component pathExtension] pathIsEqual:@"templateImage"])
			continue;
		if([component hasPrefix:@"."])
			continue;
		if([hiddenFiles containsObject:component])
			continue;
   		FSRef possibleInvisibleFile;
   		FSCatalogInfo catalogInfo;
		NSString * fullPath = [path stringByAppendingPathComponent:component];
   		OSStatus errStat = FSPathMakeRef((UInt8 *)[fullPath fileSystemRepresentation], &possibleInvisibleFile, nil);
		if(!errStat)
		{
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
		NSString * resolvedPath = [fullPath stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDirectory;
		if(![DFM fileExistsAtPath:resolvedPath isDirectory:&isDirectory])
			continue;
		NSString * contentsPath = [fullPath stringByAppendingPathComponent:iTM2BundleContentsComponent];
		NSString * prettyName = [DFM prettyNameAtPath:fullPath];
		iTM2NewDocumentTreeNode * child = nil;
		if(isDirectory
			&& (![SWS isFilePackageAtPath:resolvedPath]
				&& !([DFM fileExistsAtPath:contentsPath isDirectory:&isDirectory] && isDirectory)))
		{
			// this is considered as a directory
//iTM2_LOG(@"+=+=+=+=+=+=+=+=+=+=  DIRECTORY. %@, %@, %@", contentsPath, ([DFM fileExistsAtPath:contentsPath isDirectory:&isDirectory]?@"Y":@"N"), (isDirectory?@"Y":@"N"));
			child = [tree childWithPrettyNameValue:prettyName];
			if(!child)
			{
				child = [iTM2NewDocumentTreeNode nodeWithParent:tree];
				[child setPrettyNameValue:prettyName];
			}
			[self _loadTemplatesAtPath:resolvedPath inTree:child];
			if(![child countOfChildren])
			{
				[tree removeObjectFromChildren:child];
			}
		}
		else
		{
			// at resolvedPath points either to a standard file or a file package or a directory containing a "Contents" folder
			// all of them are mapped to one separate entry
//iTM2_LOG(@"+=+=+=+=+=+=+=+=+=+=  FILE.");
			child = [iTM2NewDocumentTreeNode nodeWithParent:tree];
			[child setNameValue:name];
			[child setPrettyNameValue:prettyName];
			[child setPathValue:resolvedPath];
		}
	}
	if([tree countOfChildren])
	{
		[tree setNameValue:[path lastPathComponent]];
		[tree setPrettyNameValue:[DFM displayNameAtPath:path]];
		[tree setPathValue:path];
	}
	iTM2_RELEASE_POOL;
//iTM2_LOG(@"Plug-ins loaded at path: %@", path);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_windowPositionShouldBeObserved:
- (BOOL)iTM2_windowPositionShouldBeObserved:(NSWindow *)window;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mandatoryProject
- (id)mandatoryProject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [metaGETTER nonretainedObjectValue];
	if([SPC isProject:result])
		return [[result retain] autorelease];
	metaSETTER(nil);
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMandatoryProject:
- (void)setMandatoryProject:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(([SPC isProject:object]? [NSValue valueWithNonretainedObject:object]:nil));
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= panelDirectory
- (NSString *)panelDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setPanelDirectory:
- (void)setPanelDirectory:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	[self setAvailableProjects:nil];
	[self validateCreationMode];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= oldProjectName
- (NSString *)oldProjectName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = metaGETTER;
	if([result length]>0)
	{
		return result;
	}
//iTM2_END;
	return [[self mandatoryProject] fileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setOldProjectName:
- (void)setOldProjectName:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tabViewItemIdentifier
- (id)tabViewItemIdentifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setTabViewItemIdentifier:
- (void)setTabViewItemIdentifier:(NSString *)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= templateImage
- (id)templateImage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setTemplateImage:
- (void)setTemplateImage:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= templatePDFView
- (id)templatePDFView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setTemplatePDFView:
- (void)setTemplatePDFView:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= createSheet
- (id)createSheet;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCreateSheet:
- (void)setCreateSheet:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= createField
- (id)createField;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCreateField:
- (void)setCreateField:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= createProgressIndicator
- (id)createProgressIndicator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCreateProgressIndicator:
- (void)setCreateProgressIndicator:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= orderFrontPanelIfRelevant:
- (IBAction)orderFrontPanelIfRelevant:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self outlineView:[self outlineView] numberOfChildrenOfItem:nil] != 0)
	{
		[[self window] makeKeyAndOrderFront:self];
	}
	else
	{
		[SDC newDocument:object];
	}
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  OLV
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= outlineView
- (id)outlineView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSOutlineView * OLV = metaGETTER;
	if(OLV)
		return OLV;
	OLV = [[self window] contentView];
	onceAgain:
	if(![OLV isKindOfClass:[NSOutlineView class]])
	{
		NSArray * subviews = [OLV subviews];
		if([subviews count])
		{
			OLV = [subviews objectAtIndex:0];
			goto onceAgain;
		}
		else
		{
			onceUp:;
			NSView * superview = [OLV superview];
			if(superview)
			{
				NSArray * subviews = [superview subviews];
				int index = [subviews indexOfObject:OLV];
				if(++index<[subviews count])
				{
					OLV = [subviews objectAtIndex:index];
					goto onceAgain;
				}
				OLV = (id)superview;
				goto onceUp;
			}
		}
	}
	metaSETTER(OLV);
//iTM2_END;
    return OLV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _outlineViewDoubleAction:
- (IBAction)_outlineViewDoubleAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int row = [sender selectedRow];
	id selectedItem = [sender itemAtRow:row];
	if(selectedItem && ![self outlineView:sender numberOfChildrenOfItem:selectedItem])
		[self next:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplate
- (id)selectedTemplate;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// just a message catcher
	NSOutlineView * OLV = [self outlineView];
//iTM2_END;
    return [OLV itemAtRow:[OLV selectedRow]];
}
#pragma mark =-=-=-=-=-  DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:shouldSelectItem:
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * mandatoryProject = [self mandatoryProject];
	if(mandatoryProject)
	{
		NSString * mandatory = [mandatoryProject fileName];
		mandatory = [mandatory stringByDeletingLastPathComponent];
		return [self canInsertItem:item inOldProjectForDirectory:mandatory];
	}
//iTM2_END;
    return ![[outlineView dataSource] outlineView:outlineView isItemExpandable:item];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineViewSelectionDidChange:
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:willDisplayCell:forTableColumn:item:
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[outlineView dataSource] outlineView:outlineView isItemExpandable:item])
	{
		NSMutableAttributedString * AS = [[[cell attributedStringValue] mutableCopy] autorelease];
		if(![AS length])
			return;
		NSFont * F = [[AS attributesAtIndex:0 effectiveRange:nil] objectForKey:NSFontAttributeName];
		if(F)
		{
			F = [SFM convertFont:F toHaveTrait:NSBoldFontMask];
		}
		else
		{
			F = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
		}
		[AS addAttribute:NSFontAttributeName value:F range:NSMakeRange(0, [AS length])];
		[cell setAttributedStringValue:AS];
	}
	else if([self outlineView:outlineView shouldSelectItem:item])
	{
		return;
	}
	else
	{
		NSMutableAttributedString * AS = [[[cell attributedStringValue] mutableCopy] autorelease];
		if(![AS length])
			return;
		NSFont * F = [[AS attributesAtIndex:0 effectiveRange:nil] objectForKey:NSFontAttributeName];
		if(F)
		{
			F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		}
		else
		{
			F = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
		}
		[AS addAttribute:NSFontAttributeName value:F range:NSMakeRange(0, [AS length])];
		[AS addAttribute:NSForegroundColorAttributeName value:[NSColor disabledControlTextColor] range:NSMakeRange(0, [AS length])];
		[cell setAttributedStringValue:AS];
	}
	
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:willDisplayCell:shouldEditTableColumn:item:
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  DATA SOURCE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:child:ofItem:
- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [(item?:_iTM2NewDocumentsTree) objectInChildrenAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:isItemExpandable:
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [(item?:_iTM2NewDocumentsTree) countOfChildren]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:numberOfChildrenOfItem:
- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [(item?:_iTM2NewDocumentsTree) countOfChildren];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:objectValueForTableColumn:byItem:
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
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
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:validateDrop:proposedItem:proposedChildIndex:
- (NSDragOperation)outlineView:(NSOutlineView*)olv validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(int)index;
    // This method is used by NSOutlineView to determine a valid drop target.  Based on the mouse position, the outline view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropItem:dropChildIndex: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDragOperation result = NSDragOperationNone;
	NSPasteboard * pboard = [info draggingPasteboard];
	NSArray * Ts = [pboard types];
	if([Ts containsObject:NSFilenamesPboardType])
	{
		NSEnumerator * E = [[pboard propertyListForType:NSFilenamesPboardType] objectEnumerator];
		NSString * filename;
		while(filename = [[E nextObject] stringByResolvingSymlinksAndFinderAliasesInPath])
			if([DFM fileOrLinkExistsAtPath:filename])
			{
				result = NSDragOperationCopy;
				break;
			}
	}
	else if([Ts containsObject:NSStringPboardType])
	{
		result = NSDragOperationCopy;
	}
	else
	{
//iTM2_END;
		return NSDragOperationNone;
	}
	// don't drop on indexes
	if(index == NSOutlineViewDropOnItemIndex)
	{
		if(item)
		{
			if([olv isExpandable:item])
			{
				if(![olv isItemExpanded:item])
					[olv expandItem:item];
				[olv setDropItem:item dropChildIndex:0];
			}
			else
			{
				// finding the ancestor...
				int row = [olv rowForItem:item];
				if(row)
				{
					int level = [olv levelForRow:row];
					if(level)
					{
						int R = row;
						index = 0;
						while(R--)
						{
							int L = [olv levelForRow:R];
							if(L == level - 1)
							{
								item = [olv itemAtRow:R];
								[olv setDropItem:item dropChildIndex:index];
								break;
							}
							else if(L == level)
								++index;
						}
						// if things are consistent, the above loop really breaks. 
					}
					else
					{
						int R = row;
						index = 0;
						while(R--)
							if([olv levelForRow:R] == 0)
								++index;
						item = nil;
						[olv setDropItem:item dropChildIndex:index];
					}
				}
				else
				{
					index = 0;
					item = nil;
					[olv setDropItem:nil dropChildIndex:index];
				}
			}
		}
		else
		{
			index = 0;
			[olv setDropItem:item dropChildIndex:index];
		}
	}
	// item and index are now consistent
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:acceptDrop:item:childIndex:
- (BOOL)outlineView:(NSOutlineView*)olv acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * dirname = item? [item pathValue]:
		[NSBundle pathForSupportDirectory:iTM2NewDPathComponent inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName] create:YES];
	NSPasteboard * pboard = [info draggingPasteboard];
	NSArray * Ts = [pboard types];
//iTM2_LOG(@"Ts are: %@", Ts);
	if([Ts containsObject:NSFilenamesPboardType])
	{
		NSEnumerator * E = [[pboard propertyListForType:NSFilenamesPboardType] objectEnumerator];
		NSString * filename;
		NSMutableArray * filenames = [NSMutableArray array];
		while(filename = [[E nextObject] stringByResolvingSymlinksAndFinderAliasesInPath])
			if([DFM fileOrLinkExistsAtPath:filename])
				[filenames addObject:filename];
		if([filenames count])
		{
			SEL selector = @selector(_delayed_outlineView:acceptDrop:item:childIndex:);
			NSMethodSignature * MS = [self methodSignatureForSelector:selector];
			if(MS)
			{
				NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
				[I setSelector:selector];
				[I setArgument:&olv atIndex:2];
				[I setArgument:&info atIndex:3];
				[I setArgument:&item atIndex:4];
				[I setArgument:&index atIndex:5];
				[I performSelectorOnMainThread:@selector(invokeWithTarget:) withObject:self waitUntilDone:NO];
	//iTM2_END;
				return YES;
			}
		}
	}
	else if([Ts containsObject:NSStringPboardType])
	{
		NSString * contents = [pboard stringForType:NSStringPboardType];
		if([contents length])
		{
			NSSavePanel * SP = [NSSavePanel savePanel];
			[SP pushNavLastRootDirectory];
			[SP setTreatsFilePackagesAsDirectories:NO];
			[SP setDelegate:self];
			[SP beginSheetForDirectory:dirname file:nil modalForWindow:[self window]
					modalDelegate: self didEndSelector:@selector(savePanelDidEnd:returnCode:contents:)
						contextInfo: [contents copy]];
		}
		return YES;
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  savePanelDidEnd:returnCode:contents:
- (void)savePanelDidEnd:(NSSavePanel *)panel returnCode:(int)returnCode contents:(NSString *)contents;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(returnCode == NSOKButton)
	{
		NSString * target = [panel filename];
		if([[contents dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] writeToFile:target atomically:YES])
		{
			[isa loadTemplates];
			[[self outlineView] reloadData];
		}
		else
		{
			iTM2_LOG(@"*** ERROR: I could not save to %@, please do it yourself...", target);
		}
	}
	[contents autorelease];
	[panel popNavLastRootDirectory];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _delayed_outlineView:acceptDrop:item:childIndex:
- (BOOL)_delayed_outlineView:(NSOutlineView*)olv acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * dirname = item? [item pathValue]:
		[NSBundle pathForSupportDirectory:iTM2NewDPathComponent inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName] create:YES];
	NSPasteboard * pboard = [info draggingPasteboard];
	NSEnumerator * E = [[pboard propertyListForType:NSFilenamesPboardType] objectEnumerator];
	NSString * filename;
	while(filename = [[E nextObject] stringByResolvingSymlinksAndFinderAliasesInPath])
		if([DFM fileOrLinkExistsAtPath:filename])
		{
			NSString * target = [dirname stringByAppendingPathComponent:[filename lastPathComponent]];
			if([target pathIsEqual:filename])
				continue;
			else if([DFM fileOrLinkExistsAtPath:target])
			{
				NSSavePanel * SP = [NSSavePanel savePanel];
				[SP pushNavLastRootDirectory];
				[SP setTreatsFilePackagesAsDirectories:NO];
				[SP setDelegate:self];
				[SP beginSheetForDirectory:dirname file:nil modalForWindow:[self window]
						modalDelegate: self didEndSelector:@selector(savePanelDidEnd:returnCode:filename:)
							contextInfo: [filename copy]];
				
			}
			else if(![DFM copyPath:filename toPath:target handler:nil])
			{
				iTM2_LOG(@"*** ERROR: I could not copy %@ to %@, please do it yourself...", filename, target);
			}
		}
//iTM2_END;
	[isa loadTemplates];
	[[self outlineView] reloadData];
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  savePanelDidEnd:returnCode:filename:
- (void)savePanelDidEnd:(NSSavePanel *)panel returnCode:(int)returnCode filename:(NSString *)filename;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(returnCode == NSOKButton)
	{
		NSString * target = [panel filename];
		if(![DFM copyPath:filename toPath:target handler:nil])
		{
			iTM2_LOG(@"*** ERROR: I could not copy %@ to %@, please do it yourself...", filename, target);
		}
	}
	[panel popNavLastRootDirectory];
	[filename autorelease];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=- UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self window] orderOut:self];
	[_iTM2NewDocumentAssistant performSelector:@selector(description) withObject:nil afterDelay:10];// delayed retain release...
	[_iTM2NewDocumentAssistant autorelease];
	_iTM2NewDocumentAssistant = nil;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  next:
- (IBAction)next:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// seeding the creation mode: single document, already existing project, new project
	// If the document can create a new project, we have the choice
	// what mode?
	// If there is a mandatory project, things are more constrained
	// one of the problems is the memory
	// 
	[self validateCreationMode];
    NSSavePanel * SP = [NSSavePanel savePanel];
	[SP setDelegate:self];
	[SP setAccessoryView:[self savePanelAccessoryView]];
	[SP pushNavLastRootDirectory];
	[SP setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden]];
	[SP setCanSelectHiddenExtension:YES];
	NSString * newDirectory = nil;
	BOOL isDirectory = NO;
	iTM2ProjectDocument * mandatoryProject = [self mandatoryProject];
	if(mandatoryProject)
	{
		// the mandatory project is the one that asked for a new document
		newDirectory = [mandatoryProject fileName];
		newDirectory = [newDirectory stringByDeletingLastPathComponent];// the directory containing the mandatory project
		if([DFM fileExistsAtPath:newDirectory isDirectory:&isDirectory] && isDirectory)
		{
			[SP setTreatsFilePackagesAsDirectories:YES];
			NSWindow * W = [[mandatoryProject subdocumentsInspector] window];
			[W orderFront:nil];
			[[self window] orderOut:self];
			[SP beginSheetForDirectory:newDirectory file:nil modalForWindow:(W? W:[self window])
					modalDelegate: self didEndSelector:@selector(nextSavePanelDidEnd:returnCode:contextInfo:)
							contextInfo: nil];
//iTM2_END;
			return;
		}
	}
	newDirectory = [self contextStringForKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	newDirectory = [newDirectory stringByResolvingSymlinksAndFinderAliasesInPath];
	if(![DFM fileExistsAtPath:newDirectory isDirectory:&isDirectory] || !isDirectory)
	{
		newDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectEnumerator] nextObject];	
	}
	[SP setTreatsFilePackagesAsDirectories:YES];
	[SP beginSheetForDirectory:newDirectory file:nil modalForWindow:[self window]
			modalDelegate: self didEndSelector:@selector(nextSavePanelDidEnd:returnCode:contextInfo:)
					contextInfo: nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNext:
- (BOOL)validateNext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self outlineView] numberOfSelectedRows] == 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startProgressIndicationForName:
- (void)startProgressIndicationForName:(NSString *) targetName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * sheet = [self createSheet];
	if(sheet)
	{
		NSProgressIndicator * PI = [self createProgressIndicator];
		[PI startAnimation:self];
		[PI setUsesThreadedAnimation:YES];
		[[self createField] setStringValue:targetName];
		[NSApp beginSheet:sheet modalForWindow:[self window] modalDelegate:nil didEndSelector:NULL contextInfo:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  filterForProjectName:
- (NSDictionary *)filterForProjectName:(NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSCalendarDate * CD = [NSCalendarDate calendarDate];
	NSMutableDictionary * filter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		[CD descriptionWithCalendarFormat:[self contextStringForKey:@"iTM2DateCalendarFormat" domain:iTM2ContextAllDomainsMask]], iTM2NewDDATEKey,
		[CD descriptionWithCalendarFormat:[self contextStringForKey:@"iTM2TimeCalendarFormat" domain:iTM2ContextAllDomainsMask]], iTM2NewDTIMEKey,
		[CD descriptionWithCalendarFormat:[self contextStringForKey:@"iTM2YearCalendarFormat" domain:iTM2ContextAllDomainsMask]], iTM2NewDYEARKey,
		([projectName length]?projectName:@""), iTM2NewDPROJECTNAMEKey,
		NSFullUserName(), iTM2NewDFULLUSERNAMEKey,
		[self contextStringForKey:@"iTM2AuthorName" domain:iTM2ContextAllDomainsMask], iTM2NewDAUTHORNAMEKey,
		[self contextStringForKey:@"iTM2OrganizationName" domain:iTM2ContextAllDomainsMask], iTM2NewDORGANIZATIONNAMEKey,
			nil];
//iTM2_END;
    return filter;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stopProgressIndication
- (void)stopProgressIndication;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * sheet = [self createSheet];
	[NSApp endSheet:sheet];
	[[self createProgressIndicator] stopAnimation:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nextSavePanelDidEnd:returnCode:contextInfo:
- (void)nextSavePanelDidEnd:(NSSavePanel *)panel returnCode:(int)returnCode contextInfo:(void*)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isExtensionHidden = [panel isExtensionHidden];
	[SUD setBool:isExtensionHidden forKey:NSFileExtensionHidden];
	[panel popNavLastRootDirectory];
	[panel close];
	if(returnCode == NSOKButton)
	{
		NSString * fileName = [panel filename];
		if(![DFM fileOrLinkExistsAtPath:fileName]
			|| [SWS performFileOperation:NSWorkspaceRecycleOperation source:[fileName stringByDeletingLastPathComponent] destination:nil files:[NSArray arrayWithObject:[fileName lastPathComponent]] tag:nil])
		{
			[self createInMandatoryProjectNewDocumentWithName:fileName]
			|| [self createNewWrapperAndProjectWithName:fileName]// create a new wrapper and the new included project, if relevant
			|| [self createNewWrapperWithName:fileName]// create a new wrapper assuming that the included project will come for free
			|| [self createInNewProjectNewDocumentWithName:fileName]// create a new project if relevant, but no wrapper
			|| [self createInOldProjectNewDocumentWithName:fileName];// just insert the main file in the project if relevant
		}
		else
		{
			iTM2_REPORTERROR(1,@"There is already a file I can't remove",nil);
			[SWS selectFile:fileName inFileViewerRootedAtPath:[fileName stringByDeletingLastPathComponent]];
		}
	}
	[[self window] orderOut:self];// the run modal is dangerous:don't autorelease
	[_iTM2NewDocumentAssistant performSelector:@selector(description) withObject:nil afterDelay:10];// delayed retain release...
	[_iTM2NewDocumentAssistant autorelease];
	_iTM2NewDocumentAssistant = nil;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createInMandatoryProjectNewDocumentWithName:
- (BOOL)createInMandatoryProjectNewDocumentWithName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * mandatoryProject = [self mandatoryProject];
	if(!mandatoryProject)
	{
		return NO;
	}
	// just insert a new document in an already existing project
	NSString * sourceName = [self standaloneFileName];// must be a file name?
	NSString * originalExtension = [sourceName pathExtension];
	NSString * mandatoryName = [mandatoryProject fileName];
	NSString * targetDirectory = [mandatoryName stringByDeletingLastPathComponent];
	[self takeContextValue:targetDirectory forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	NSString * newCore = fileName;
	NSArray * newCoreComponents = [newCore pathComponents];
	NSArray * mandatoryNameComponents = [mandatoryName pathComponents];
	NSRange R = NSMakeRange([mandatoryNameComponents count], [newCoreComponents count]);
	// if the document is added in a subdirectory...
	if(R.length>R.location)
	{
		R.length -= R.location;
		newCoreComponents = [newCoreComponents subarrayWithRange:R];
		newCore = [NSString pathWithComponents:newCoreComponents];
	}
	else
	{
		newCore = [newCore lastPathComponent];
	}
	NSString * targetName = nil;
	if([originalExtension length])
	{
		newCore = [newCore stringByDeletingPathExtension];
		newCore = [newCore stringByAppendingPathExtension:originalExtension];
	}
	if([[SDC typeFromFileExtension:[targetName pathExtension]] isEqualToString:iTM2TeXDocumentType])
	{
		NSDictionary * filter = [NSDictionary dictionaryWithObject:	@"-" forKey:@" "];
		newCore = [self convertedString:newCore withDictionary:filter];
	}
	NSMutableDictionary * filter = [NSMutableDictionary dictionaryWithDictionary:[self filterForProjectName:mandatoryName]];
	newCore = [self convertedString:newCore withDictionary:filter];
	targetName = [targetDirectory stringByAppendingPathComponent:newCore];
	NSAssert(![DFM fileExistsAtPath:targetName], @"***  My dear, you as a programmer are a big naze...");
	[self startProgressIndicationForName:targetName];
	if([DFM copyPath:sourceName toPath:targetName handler:nil])
	{
		[DFM setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden] atPath:fileName];
		BOOL isDirectory;
		if([DFM fileExistsAtPath:targetName isDirectory:&isDirectory])
		{
			NSMutableArray * names = [NSMutableArray array];
			NSString * component = nil;
			if(isDirectory)
			{
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:targetName];
				while(component = [DE nextObject])
				{
					[names addObject:[targetName stringByAppendingPathComponent:component]];
				}
			}
			else
			{
				[names addObject:targetName];
			}
			NSEnumerator * E = [names objectEnumerator];
			while(component = [E nextObject])
			{
				mandatoryName = [mandatoryName lastPathComponent];
				mandatoryName = [mandatoryName stringByDeletingPathExtension];
				[filter setObject:mandatoryName forKey:iTM2NewDPROJECTNAMEKey];
				NSURL * url = [NSURL fileURLWithPath:targetName];
				[SPC setProject:mandatoryProject forURL:url];//
				id document = [SDC openDocumentWithContentsOfURL:url display:YES error:nil];
				if([document isKindOfClass:[iTM2TextDocument class]])
				{
					NSTextStorage * TS = [document textStorage];
					NSString * old = [TS string];
					NSString * new = [self convertedString:old withDictionary:filter];
					[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:new];
				}//if([document isKindOfClass:[iTM2TextDocument class]])
				[document saveToURL:[document fileURL] ofType:[document fileType] forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
				[[document undoManager] removeAllActions];
			}
			[mandatoryProject saveDocument:self];
		}
		else
		{
			iTM2_LOG(@"*** ERROR: Missing file at %@", targetName);
		}
	}
	else
	{
		iTM2_LOG(@"*** ERROR: Could not copy %@ to %@", sourceName, targetName);
	}
	[self stopProgressIndication];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewWrapperAndProjectWithName:
- (BOOL)createNewWrapperAndProjectWithName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self creationMode] != iTM2ToggleNewProjectMode)
	{
		return NO;
	}
	if(![self preferWrapper])
	{
		return NO;
	}
	id item = [self selectedTemplate];
	NSString * sourceName = [item pathValue];
	NSArray * enclosedProjects = [sourceName enclosedProjectFileNames];
	if([enclosedProjects count]!=0)
	{
		return NO;
	}
	[self takeContextValue:[fileName stringByDeletingLastPathComponent] forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	// No extension for fileName, the extension will be borrowed from the project
	fileName = [fileName stringByDeletingPathExtension];
	NSString * targetName = [fileName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
	NSString * projectName = [fileName lastPathComponent];
	
	NSDictionary * filter = [self filterForProjectName:projectName];

	// we copy the whole directory at sourceName, possibly add a project, clean extra folders, change the names
	if([DFM fileExistsAtPath:targetName])
	{
		iTM2_LOG(@"There is already a wrapper at %@...", targetName);
	}
	else if(![DFM copyPath:sourceName toPath:targetName handler:nil])
	{
		iTM2_LOG(@"*** ERROR: Could not copy %@ to %@", sourceName, targetName);
	}
	BOOL isDirectory;
	if([DFM fileExistsAtPath:targetName isDirectory:&isDirectory])
	{
		[DFM setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden] atPath:targetName];
		if(isDirectory)
		{
			// remove any "Contents" directory;
			NSString * deeper = [targetName stringByAppendingPathComponent:iTM2BundleContentsComponent];
			if([DFM fileOrLinkExistsAtPath:deeper])
			{
				int tag;
				if([SWS performFileOperation:NSWorkspaceRecycleOperation source:targetName destination:nil
					files:[NSArray arrayWithObject:iTM2BundleContentsComponent] tag:&tag])
				{
					iTM2_LOG(@"Recycling the \"Contents\" of directory %@...", targetName);
				}
				else
				{
					iTM2_LOG(@"........... ERROR: Could not recycle the \"Contents\" directory...");
				}
			}
			// changing the name of all the files included in the newly created directory according to the filter above
			NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:targetName];
			NSString * path = nil;
			NSString * convertedPath = nil;
			while(path = [DE nextObject])
			{
				convertedPath = [self convertedString:path withDictionary:filter];
				if(![convertedPath pathIsEqual:path])
				{
					path = [targetName stringByAppendingPathComponent:path];
					convertedPath = [targetName stringByAppendingPathComponent:convertedPath];
					convertedPath = [convertedPath stringByStandardizingPath];
					if(![DFM movePath:path toPath:convertedPath handler:NULL])
					{
						iTM2_LOG(@"..........  ERROR: Could not change\n%@\nto\n%@.", path, convertedPath);
					}
				}
			}
			// creating one at the top level or just below
			NSString * standaloneFileName = [self standaloneFileName];
			standaloneFileName = [standaloneFileName stringByAbbreviatingWithDotsRelativeToDirectory:sourceName];
			standaloneFileName = [self convertedString:standaloneFileName withDictionary:filter];
			standaloneFileName = [targetName stringByAppendingPathComponent:standaloneFileName];
			standaloneFileName = [standaloneFileName stringByStandardizingPath];
			NSURL * url = [NSURL fileURLWithPath:standaloneFileName];
			iTM2TeXProjectDocument * PD = [SPC getProjectFromPanelForURLRef:&url display:NO error:nil];
			NSString * key = [PD newFileKeyForURL:url];
			[PD setMasterFileKey:key];
			
			NSDictionary * context = [NSDocument contextDictionaryFromURL:url];
			NSNumber * N = [context objectForKey:iTM2StringEncodingOpenKey];
			unsigned int encoding = [N intValue];
			NSString * S = nil;
			if(encoding)
			{
				if(!(S = [NSString stringWithContentsOfURL:url encoding:encoding error:nil]))
				{
					S = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:nil];
				}
			}
			else
			{
				S = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:nil];
			}
			S = [self convertedString:S withDictionary:filter];
			NSData * D = [S dataUsingEncoding:encoding allowLossyConversion:YES];
			[D writeToURL:url options:NSAtomicWrite error:nil];
			[PD makeWindowControllers];
			[PD showWindows];
			[PD openSubdocumentWithContentsOfURL:url context:context display:YES error:nil];
			[PD saveDocument:self];
//iTM2_END;
			return YES;
		}
		else
		{
			iTM2_LOG(@"*** ERROR: Missing directory at %@", targetName);
		}
	}
	else
	{
		iTM2_LOG(@"*** ERROR: Missing file at %@", targetName);
	}
	[self stopProgressIndication];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewWrapperWithName:
- (BOOL)createNewWrapperWithName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self creationMode] != iTM2ToggleNewProjectMode)
	{
		return NO;
	}
	if(![self preferWrapper])
	{
		return NO;
	}
	id item = [self selectedTemplate];
	NSString * sourceName = [item pathValue];
	NSArray * enclosedProjects = [sourceName enclosedProjectFileNames];
	if([enclosedProjects count]==0)
	{
		return NO;
	}
	[self takeContextValue:[fileName stringByDeletingLastPathComponent] forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	// No extension for fileName, the extension will be borrowed from the project
	fileName = [fileName stringByDeletingPathExtension];
	NSString * targetName = [fileName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
	NSString * projectName = [fileName lastPathComponent];
	
	NSDictionary * filter = [self filterForProjectName:projectName];

	// we copy the whole directory at sourceName, possibly add a project, clean extra folders, change the names
	if([DFM fileExistsAtPath:targetName])
	{
		iTM2_LOG(@"There is already a wrapper at %@...", targetName);
	}
	else if(![DFM copyPath:sourceName toPath:targetName handler:nil])
	{
		iTM2_LOG(@"*** ERROR: Could not copy %@ to %@", sourceName, targetName);
	}
	BOOL isDirectory;
	if([DFM fileExistsAtPath:targetName isDirectory:&isDirectory])
	{
		[DFM setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden] atPath:targetName];
		if(isDirectory)
		{
			// remove any "Contents" directory;
			NSString * deeper = [targetName stringByAppendingPathComponent:iTM2BundleContentsComponent];
			if([DFM fileOrLinkExistsAtPath:deeper])
			{
				int tag;
				if([SWS performFileOperation:NSWorkspaceRecycleOperation source:targetName destination:nil
					files:[NSArray arrayWithObject:iTM2BundleContentsComponent] tag:&tag])
				{
					iTM2_LOG(@"Recycling the \"Contents\" of directory %@...", targetName);
				}
				else
				{
					iTM2_LOG(@"........... ERROR: Could not recycle the \"Contents\" directory...");
				}
			}
			// changing the name of all the files included in the newly created directory according to the filter above
			NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:targetName];
			NSString * originalPath = nil;
			NSString * convertedPath = nil;
			while(originalPath = [DE nextObject])
			{
				convertedPath = [self convertedString:originalPath withDictionary:filter];
				if(![convertedPath pathIsEqual:originalPath])
				{
					originalPath = [targetName stringByAppendingPathComponent:originalPath];
					convertedPath = [targetName stringByAppendingPathComponent:convertedPath];
					convertedPath = [convertedPath stringByStandardizingPath];
					if(![DFM movePath:originalPath toPath:convertedPath handler:NULL])
					{
						iTM2_LOG(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalPath, convertedPath);
					}
				}
			}
			// Modify the project file, to sync with the possibly modified file names
			NSArray * enclosedProjects = [targetName enclosedProjectFileNames];
			iTM2TeXProjectDocument * PD = nil;
			NSEnumerator * E = [enclosedProjects objectEnumerator];
			while(originalPath = [E nextObject])
			{
				originalPath = [originalPath stringByStandardizingPath];
//iTM2_LOG(@"originalPath is: %@", originalPath);
				// originalPath is no longer used
				// open the project document
				NSURL * url = [NSURL fileURLWithPath:originalPath];
				PD = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];// first registerProject
//iTM2_LOG(@"[SDC documents]:%@",[SDC documents]);
				// filter out the declared files
				NSEnumerator * e = [[[PD mainInfos] keyedNames] keyEnumerator];
				NSString * key = nil;
				id document;
				while(key = [e nextObject])
				{
//iTM2_LOG(@"key is: %@", key);
//iTM2_LOG(@"document is: %@", document);
					if(document = [PD subdocumentForFileKey:key])
					{
						// then change the file name:
						originalPath = [document fileName];
						convertedPath = [self convertedString:originalPath withDictionary:filter];
//iTM2_LOG(@"convertedPath is: %@", convertedPath);
						if(![convertedPath pathIsEqual:originalPath])
						{
							url = [NSURL fileURLWithPath:convertedPath];
							[PD setURL:url forFileKey:key];
							[document setFileURL:url];
						}
						if([document isKindOfClass:[iTM2TextDocument class]])
						{
							NSTextStorage * TS = [document textStorage];
							[TS beginEditing];
							NSString * old = [TS string];
							NSString * new = [self convertedString:old withDictionary:filter];
							[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:new];
							[TS endEditing];
							[document saveToURL:[document fileURL] ofType:[document fileType] forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
							[[document undoManager] removeAllActions];
//iTM2_LOG(@"Open document saved");
						}
					}
					else if(originalPath = [[PD URLForFileKey:key] path])
					{
						convertedPath = [self convertedString:originalPath withDictionary:filter];
						NSURL * url = [NSURL fileURLWithPath:convertedPath];
						if(![convertedPath pathIsEqual:originalPath])
						{
							[PD setURL:url forFileKey:key];// do this before...
						}
						document = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
//iTM2_LOG(@"document is: %@", document);
						if([document isKindOfClass:[iTM2TextDocument class]])
						{
							NSTextStorage * TS = [document textStorage];
							NSString * old = [TS string];
							NSString * new = [self convertedString:old withDictionary:filter];
							[TS beginEditing];
							[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:new];
							[TS endEditing];
						}
//iTM2_LOG(@"originalPath is: %@", originalPath);
//iTM2_LOG(@"convertedPath is: %@", convertedPath);
						if(PD != document)
						{
							[document saveToURL:[document fileURL] ofType:[document fileType] forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
							[document close];
//iTM2_LOG(@"Document saved and closed");
						}
					}
				}
				[PD saveDocument:self];
				[[PD undoManager] removeAllActions];
				[PD makeWindowControllers];
				[PD showWindows];
			}
			// changing the name of all the files included in the newly created directory according to the filter above
			DE = [DFM enumeratorAtPath:targetName];
			while(originalPath = [DE nextObject])
			{
				convertedPath = [self convertedString:originalPath withDictionary:filter];
				if(![convertedPath pathIsEqual:originalPath])
				{
					originalPath = [targetName stringByAppendingPathComponent:originalPath];
					convertedPath = [targetName stringByAppendingPathComponent:convertedPath];
					convertedPath = [convertedPath stringByStandardizingPath];
					if(![DFM movePath:originalPath toPath:convertedPath handler:NULL])
					{
						iTM2_LOG(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalPath, convertedPath);
					}
				}
			}
			// changing the file permissions: it is relevant if the document was built in...
			[DFM makeFileWritableAtPath:targetName recursive:YES];
			if(![SWS isFilePackageAtPath:targetName])
			{
				NSImage * I = [SWS iconForFile:sourceName];
				if(I)
				{
					[SWS setIcon:I forFile:targetName options:NSExclude10_4ElementsIconCreationOption];
				}
			}
			// what are the available documents
			// I must create a project here before calling the next stuff, is it really true?
//			NSURL * url = [NSURL fileURLWithPath:targetName];
//			[SDC openDocumentWithContentsOfURL:url display:YES error:nil];//second registerProject
		}
		else
		{
			iTM2_LOG(@"*** ERROR: Missing directory at %@", targetName);
		}
	}
	else
	{
		iTM2_LOG(@"*** ERROR: Missing file at %@", targetName);
	}
	[self stopProgressIndication];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createInNewProjectNewDocumentWithName:
- (BOOL)createInNewProjectNewDocumentWithName:(NSString *) fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self creationMode] != iTM2ToggleNewProjectMode)
	{
		return NO;
	}
	if([self preferWrapper])
	{
		return NO;
	}
	id item = [self selectedTemplate];
	NSString * sourceName = [item pathValue];
	// No extension for fileName, the extension will be borrowed from the project
	fileName = [fileName stringByDeletingPathExtension];
	// we copy the whole directory at sourceName
	// add a project
	// clean extra folders
	// change the names
	// what is the target name?
	NSString * targetName = fileName;
	targetName = [targetName stringByDeletingPathExtension];
	// setting the path extension
	if([self preferWrapper])
	{
		targetName = [targetName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
	}
	NSString * projectName = fileName;
	projectName = [projectName lastPathComponent];
	[self takeContextValue:[targetName stringByDeletingLastPathComponent]
		forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	if([DFM fileExistsAtPath:targetName])
	{
		iTM2_LOG(@"There is already a project at\n%@",targetName);
	}
	NSDictionary * filter = [self filterForProjectName:projectName];
	if([DFM copyPath:sourceName toPath:fileName handler:nil])
	{
		[DFM setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden] atPath:fileName];
		BOOL isDirectory;
		if([DFM fileExistsAtPath:targetName isDirectory:&isDirectory])
		{
			if(isDirectory)
			{
				// the original "file" might be either a project or a wrapper
				// remove any "Contents" directory;
				NSString * deeper = [targetName stringByAppendingPathComponent:iTM2BundleContentsComponent];
				if([DFM fileOrLinkExistsAtPath:deeper])
				{
					int tag;
					if([SWS performFileOperation:NSWorkspaceRecycleOperation source:targetName destination:nil
						files:[NSArray arrayWithObject:iTM2BundleContentsComponent] tag:&tag])
					{
						iTM2_LOG(@"Recycling the \"Contents\" of directory %@...", targetName);
					}
					else
					{
						iTM2_LOG(@"........... ERROR: Could not recycle the \"Contents\" directory...");
					}
				}
				// Modify the project files,
				// finding the contained projects
				NSArray * enclosedProjects = [targetName enclosedProjectFileNames];
				NSString * originalPath = nil;
				NSString * convertedPath = nil;
				NSEnumerator * E = [enclosedProjects objectEnumerator];
				while(originalPath = [E nextObject])
				{
					originalPath = [originalPath stringByStandardizingPath];
					convertedPath = [self convertedString:originalPath withDictionary:filter];
					if(![convertedPath pathIsEqual:originalPath])
					{
						if(![DFM movePath:originalPath toPath:convertedPath handler:NULL])
						{
							iTM2_LOG(@"..........  ERROR: Could not change the project file name.");
							convertedPath = originalPath;
						}
					}
//iTM2_LOG(@"convertedPath is: %@", convertedPath);
					// originalPath is no longer used
					// open the project document
					NSURL * url = [NSURL fileURLWithPath:convertedPath];
					iTM2ProjectDocument * PD = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
					// filter out the declared files
					NSEnumerator * e = [[PD allFileKeys] objectEnumerator];
					NSString * key = nil;
					while(key = [e nextObject])
					{
//iTM2_LOG(@"key is: %@", key);
						id document = [PD subdocumentForFileKey:key];
//iTM2_LOG(@"document is: %@", document);
						if([document isKindOfClass:[iTM2TextDocument class]])
						{
							NSTextStorage * TS = [document textStorage];
							[TS beginEditing];
							NSString * old = [TS string];
							NSString * new = [self convertedString:old withDictionary:filter];
							[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:new];
							[TS beginEditing];
							// then change the file name:
							originalPath = [document fileName];
							convertedPath = [self convertedString:originalPath withDictionary:filter];
//iTM2_LOG(@"convertedPath is: %@", convertedPath);
							if([document isKindOfClass:[iTM2TeXDocument class]])
							{
								convertedPath = [self convertedString:convertedPath
									withDictionary: [NSDictionary dictionaryWithObject:	@"-" forKey:@" "]];
//iTM2_LOG(@"convertedPath is: %@", convertedPath);
							}
							if(![convertedPath pathIsEqual:originalPath])
							{
								if([DFM movePath:originalPath toPath:convertedPath handler:NULL])
								{
									NSURL * url = [NSURL fileURLWithPath:convertedPath];
									[PD setURL:url forFileKey:key];
									[document setFileURL:url];
								}
								else
								{
									iTM2_LOG(@"..........  ERROR: Could not change the project document file name -1.");
								}
							}
							[document saveToURL:[document fileURL] ofType:[document fileType] forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
							[[document undoManager] removeAllActions];
//iTM2_LOG(@"Open document saved");
						}
						else if(!document)
						{
							NSURL * url = [PD URLForFileKey:key];
							originalPath = [url path];
//iTM2_LOG(@"originalPath is: %@", originalPath);
							convertedPath = [self convertedString:originalPath withDictionary:filter];
//iTM2_LOG(@"convertedPath is: %@", convertedPath);
							NSError * error = nil;
							NSString * typeName = [SDC typeForContentsOfURL:url error:&error];
							if([typeName length])
							{
								Class C = [SDC documentClassForType:typeName];
								if([C isSubclassOfClass:[iTM2TextDocument class]])
								{
									document = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
									NSString * old = [document stringRepresentation];
									iTM2StringFormatController * stringFormatter = [document stringFormatter];
									NSStringEncoding encoding = [stringFormatter stringEncoding];
									NSMutableDictionary * filteredFilter = [[filter mutableCopy] autorelease];
									// convert the filter to then new encoding
									// just in case this was not suitable, do not loose much.
									NSEnumerator * E = [filter keyEnumerator];
									NSString * key;
									while(key = [E nextObject])
									{
										NSString * translation = [filter objectForKey:key];
										NSData * data = [translation dataUsingEncoding:encoding allowLossyConversion:YES];
										translation = [[[NSString alloc] initWithData:data encoding:encoding] autorelease];
										[filteredFilter setObject:translation forKey:key];
									}
									NSString * new = [self convertedString:old withDictionary:filteredFilter];
									NSData * D = [stringFormatter dataWithString:new allowLossyConversion:YES];
									#warning **** ERROR: is it compatible with the leopard string encoding extended attributes
									if(D)
									{
										[document loadDataRepresentation:D ofType:[document modelType]]
											|| [document loadDataRepresentation:D ofType:[document fileType]];
									}
									if([document isKindOfClass:[iTM2TeXDocument class]])
									{
										convertedPath = [[convertedPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:
												[self convertedString:[convertedPath lastPathComponent]
														withDictionary: [NSDictionary dictionaryWithObject:	@"-" forKey:@" "]]];
									}
								}
							}
							if(![convertedPath pathIsEqual:originalPath])
							{
								if(document)
								{
									// originalPath must exist
									// convertedPath must not exist
									#warning Links mngt?
									if([DFM fileExistsAtPath:originalPath])// links?
									{
										if([DFM fileExistsAtPath:convertedPath])
										{
											iTM2_LOG(@"..........  ERROR: Already existing file at\n%@");
										}
										else
										{
											if([DFM movePath:originalPath toPath:convertedPath handler:NULL])
											{
												NSURL * url = [NSURL fileURLWithPath:convertedPath];
												[PD setURL:url forFileKey:key];
												[document setFileURL:url];
											}
											else
											{
												iTM2_LOG(@"..........  ERROR: Could not move\n%@ to\n%@", originalPath, convertedPath);
											}
										}
									}
									else
									{
										iTM2_LOG(@"..........  WARNING: Missing file at\n%@", originalPath);// should not go there because the doc is already existing!
									}
								}
								else
								{
									[PD setURL:[NSURL fileURLWithPath:convertedPath] forFileKey:key];
								}
							}
							[document stringRepresentationCompleteWriteToURL:[document fileURL] ofType:[document fileType] error:nil];
							[document close];
iTM2_LOG(@"[PD subdocumentForFileKey:%@]:%@",key,[PD subdocumentForFileKey:key]);
iTM2_LOG(@"Document saved and closed");
						}
					}
					[PD saveDocument:self];
					[[PD undoManager] removeAllActions];
					[PD makeWindowControllers];
					[PD showWindows];
				}
				// changing the name of all the files included in the newly created directory according to the filter above
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:targetName];
				while(originalPath = [DE nextObject])
				{
					convertedPath = [self convertedString:originalPath withDictionary:filter];
					if(![convertedPath pathIsEqual:originalPath])
					{
						originalPath = [targetName stringByAppendingPathComponent:originalPath];
						convertedPath = [targetName stringByAppendingPathComponent:convertedPath];
						convertedPath = [convertedPath stringByStandardizingPath];
						if(![DFM movePath:originalPath toPath:convertedPath handler:NULL])
						{
							iTM2_LOG(@"..........  ERROR: Could not change\n%@\nto\n%@.", originalPath, convertedPath);
						}
					}
				}
				// changing the file permissions: it is relevant if the document was built in...
				[DFM makeFileWritableAtPath:targetName recursive:YES];
				if(![SWS isFilePackageAtPath:targetName])
				{
					NSImage * I = [SWS iconForFile:sourceName];
					if(I)
					{
						[SWS setIcon:I forFile:targetName options:NSExclude10_4ElementsIconCreationOption];
					}
				}
				// I must create a project here before calling the next stuff
				NSURL * url = [NSURL fileURLWithPath:targetName];
				[SDC openDocumentWithContentsOfURL:url display:YES error:nil];
			}
			else
			{
				iTM2_LOG(@"*** ERROR: Missing directory at %@", targetName);
			}
		}
		else
		{
			iTM2_LOG(@"*** ERROR: Missing file at %@", targetName);
		}
	}
	else
	{
		iTM2_LOG(@"*** ERROR: Could not copy %@ to %@", sourceName, targetName);
	}
	[self stopProgressIndication];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createInOldProjectNewDocumentWithName:
- (BOOL)createInOldProjectNewDocumentWithName:(NSString *)targetName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self creationMode] != iTM2ToggleOldProjectMode)
	{
		return NO;
	}
	NSString * oldProjectName = [self oldProjectName];
	if(![oldProjectName length])
	{
		iTM2_LOG(@"*** ERROR: I have been asked to create a document in an old project, but Ii was not given an old project...");
		return NO;//<< this is a bug
	}
	NSString * sourceName = [self standaloneFileName];
	if([SWS isWrapperPackageAtPath:oldProjectName])// Crash Log Report
	{
		NSArray * enclosed = [oldProjectName enclosedProjectFileNames];
		if(![enclosed count] && ![SWS isProjectPackageAtPath:oldProjectName])
		{
			return NO;
		}
	}
	NSURL * url = [NSURL fileURLWithPath:oldProjectName];
	NSError * localError = nil;
	iTM2ProjectDocument * oldProject = [SDC openDocumentWithContentsOfURL:url display:NO error:&localError];
	if(localError)
	{
		[SDC presentError:localError];
		return YES;
	}
#warning **** ERROR: this MUST be revisited, together with the other similar methods above
	NSString * targetDirName = [[SPC directoryURLOfProjectWithURL:url] path];
	// this is the location where the new document should be stored
	[self takeContextValue:targetDirName
		forKey:@"iTM2NewDocumentDirectory" domain:iTM2ContextAllDomainsMask];
	NSString * newCore = [targetName lastPathComponent];
	newCore = [newCore stringByDeletingPathExtension];

	NSAssert(![DFM fileExistsAtPath:targetName], @"***  My dear, you as a programmer are a big naze...");

	[self startProgressIndicationForName:targetName];
	if([DFM copyPath:sourceName toPath:targetName handler:nil])
	{
		[DFM setExtensionHidden:[SUD boolForKey:NSFileExtensionHidden] atPath:targetName];
		BOOL isDirectory;
		if([DFM fileExistsAtPath:targetName isDirectory:&isDirectory])
		{
			NSString * oldProjectName = [oldProject fileName];
			NSDictionary * filter = [self filterForProjectName:oldProjectName];
			NSString * old = nil;
			NSString * new = nil;
			if(isDirectory)
			{
				// changing the file permissions: it is relevant if the document was built in...
				[DFM makeFileWritableAtPath:targetName recursive:YES];
				// If necessary, the project will be created as expected side effect
				NSURL * url = [NSURL fileURLWithPath:targetName];
				id document = [SDC openDocumentWithContentsOfURL:url display:YES error:nil];
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:targetName];
				while(old = [DE nextObject])
				{
					old = [targetName stringByAppendingPathComponent:old];
					old = [old stringByStandardizingPath];
					new = [self convertedString:old withDictionary:filter];
					if(![old pathIsEqual:new])
					{
						if(![DFM movePath:old toPath:new handler:NULL])
						{
							iTM2_LOG(@"Could not move\n%@\nto\n%@",old,new);
						}
					}
					NSURL * url = [NSURL fileURLWithPath:old];
					NSError * localError = nil;
					if([[SDC typeForContentsOfURL:url error:&localError] isEqualToString:iTM2TeXDocumentType])
					{
						id document = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
						NSTextStorage * TS = [document textStorage];
						old = [TS string];
						new = [self convertedString:old withDictionary:filter];
						[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:new];
					}
				}
				[oldProject saveDocument:self];
				[[oldProject undoManager] removeAllActions];
				[document saveToURL:[document fileURL] ofType:[document fileType] forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
				[[document undoManager] removeAllActions];
			}
			else
			{
				NSURL * url = [NSURL fileURLWithPath:targetName];
				[oldProject newFileKeyForURL:url];
				// changing the file permissions: it is relevant if the document was built in...
				[DFM makeFileWritableAtPath:targetName recursive:YES];
				// If necessary, the project will be created as expected side effect
				id document = [SDC openDocumentWithContentsOfURL:url display:YES error:nil];
				if([document isKindOfClass:[iTM2TextDocument class]])
				{
					NSTextStorage * TS = [document textStorage];
					old = [TS string];
					new = [self convertedString:old withDictionary:filter];
					[TS beginEditing];
					[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:new];
					[TS endEditing];
				}
				[oldProject saveDocument:self];
				[[oldProject undoManager] removeAllActions];
				[document saveToURL:[document fileURL] ofType:[document fileType] forSaveOperation:NSSaveAsOperation delegate:nil didSaveSelector:NULL contextInfo:nil];
				[[document undoManager] removeAllActions];
			}
		}
		else
		{
			iTM2_LOG(@"*** ERROR: Missing file at %@", targetName);
		}
	}
	else
	{
		iTM2_LOG(@"*** ERROR: Could not copy %@ to %@", sourceName, targetName);
	}
	[self stopProgressIndication];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  convertedString:withDictionary:
- (NSString *)convertedString:(NSString *)fileName withDictionary:(NSDictionary *)filter;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * MS = [[fileName mutableCopy] autorelease];
	NSEnumerator * E = [filter keyEnumerator];
	NSString * target;
	while(target = [E nextObject])
	{
		if([target length])
		{
			NSString * replacement = [filter objectForKey:target];
			[MS replaceOccurrencesOfString:target withString:replacement options:0L range:NSMakeRange(0, [MS length])];
		}
	}
//iTM2_END;
    return [[MS copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTemplateDescription:
- (IBAction)editTemplateDescription:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// just a message catcher
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTemplateDescription:
- (BOOL)validateEditTemplateDescription:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * noDescriptionAvailable = nil;
	if(!noDescriptionAvailable)
	{
		noDescriptionAvailable = [[sender stringValue] copy];
	}
	id item = [self selectedTemplate];
	if(!item)
	{
		return NO;
	}
#warning EXC_BAD_ACCESS here
//iTM2_LOG(@"Item is: %@ (%@)", item, [item pathValue]);
	NSString * base = [item pathValue];
	NSBundle * B = [NSBundle bundleWithPath:base];
	NSString * path;
//iTM2_LOG(@"base1 is: %@", base);
	if(!B)
	{
		path = [base stringByAppendingPathExtension:@"templateDescription"];
//iTM2_LOG(@"base2 is: %@", base);
		B = [NSBundle bundleWithPath:path];
		if(!B)
		{
			[sender setStringValue:noDescriptionAvailable];
			[self setTemplateImage:nil];
			[[self templatePDFView] setDocument:nil];
			return NO;
		}
	}
//iTM2_LOG(@"fixing");
	// fixing the template image
	path = [B pathForImageResource:@"templateImage"];
	if([[SDC typeFromFileExtension:[path pathExtension]] isEqualToString:NSPDFPboardType])
	{
		PDFDocument * D = nil;
longemer:
		D = [[[PDFDocument allocWithZone:[self zone]]
			initWithURL:[NSURL fileURLWithPath:path]] autorelease];
		[(PDFView *)[self templatePDFView] setDocument:D];
		[self setTabViewItemIdentifier:@"PDF"];
	}
	else
	{
		NSImage * I = [[[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path] autorelease];
		if(nil == I)
		{
			// is there a unique pdf file at the top level?
			path = [B bundlePath];
			NSEnumerator * E = [[DFM directoryContentsAtPath:path] objectEnumerator];
			NSString * component;
			while(component = [E nextObject])
				if([[SDC typeFromFileExtension:[component pathExtension]] isEqualToString:NSPDFPboardType])
				{
					path = [path stringByAppendingPathComponent:component];
					goto longemer;
				}
			I = [SWS iconForFile:[self standaloneFileName]];
		}
		[self setTemplateImage:I];
		[self setTabViewItemIdentifier:@"Image"];
	}
	// select the tab view containing V, which is the view containing the appropriate information
	// fixing the template image: looking for an rtf file and then a text file
	path = [B pathForResource:@"templateDescription" ofType:@"rtf"];
	if([path length])
	{
		id description = [[[NSAttributedString allocWithZone:[self zone]]
			initWithRTF: [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]] documentAttributes:nil] autorelease];
		if([description length])
		{
			[sender setAttributedStringValue:description];
			return NO;
		}
	}
	path = [B pathForResource:@"templateDescription" ofType:@"txt"];
	if([path length])
	{
		id description = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path]];// encoding?
		if([description length])
		{
			[sender setStringValue:description];
			return NO;
		}
	}
	[sender setStringValue:noDescriptionAvailable];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTemplateFolderPath:
- (IBAction)editTemplateFolderPath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// just a message catcher
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTemplateFolderPath:
- (BOOL)validateEditTemplateFolderPath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// just a message catcher
	NSString * path = [NSBundle pathForSupportDirectory:iTM2NewDPathComponent inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName] create:YES];
	[sender setStringValue:([path length]? path:@"")];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=- SAVE PANEL DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:shouldShowFilename:
- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [filename length] && ![SWS isTeXProjectPackageAtPath:filename] && ![SWS isProjectPackageAtPath:filename];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:directoryDidChange:
- (void)panel:(id)sender directoryDidChange:(NSString *)path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setPanelDirectory:path];// will make some setups too
	[sender iTM2_validateContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:userEnteredFilename:confirmed:
- (NSString *)panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// this is where we manage the extension
	// If the user entered an extension, we do nothing because we expect the user to know what he is doing
	// If the user entered an extensionless file name, then we add the extension based on the creation mode and the template
	if(![[filename pathExtension] length])
	{
		NSString * requiredPathExtension = nil;
		switch([self creationMode])
		{
			case iTM2ToggleOldProjectMode:// insert in existing project
			case iTM2ToggleStandaloneMode:// standalone document (in fact with an faraway project)
			// it is not expected to be a project or a wrapper: it is a standalone document
				requiredPathExtension = [[self standaloneFileName] pathExtension];
				break;
			case iTM2ToggleNewProjectMode:// create new project
			default:
			{
				id item = [self selectedTemplate];
				requiredPathExtension = [item pathValue];
				requiredPathExtension = [requiredPathExtension pathExtension];
				break;
			}
		}
		if([requiredPathExtension length])
		{
			filename = [filename stringByAppendingPathExtension:requiredPathExtension];
		}
	}
	if([[SDC typeFromFileExtension:[filename pathExtension]] isEqualToString:iTM2TeXDocumentType])
	{
		NSDictionary *filter = [NSDictionary dictionaryWithObject:@"-" forKey:@" "];
		filename = [self convertedString:filename withDictionary:filter];
	}
//iTM2_END;
    return filename;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:isValidFilename:
- (BOOL)panel:(id)sender isValidFilename:(NSString *)filename;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int creationMode = [self creationMode];
	iTM2ProjectDocument * mandatoryProject = [self mandatoryProject];
	NSString * mandatoryDirectory = nil;
	if(creationMode == iTM2ToggleForbiddenProjectMode)
	{
		if(mandatoryProject)
		{
			mandatoryDirectory = [mandatoryProject fileName];
			mandatoryDirectory = [mandatoryDirectory stringByDeletingLastPathComponent];
			mandatoryDirectory = [mandatoryDirectory stringByStandardizingPath];
			[sender setDirectory:mandatoryDirectory];
		}
		return NO;
	}
	if(![filename length])
	{
		return NO;
	}
	BOOL result = NO;
	if(mandatoryProject)
	{
		mandatoryDirectory = [mandatoryProject fileName];
		mandatoryDirectory = [mandatoryDirectory stringByDeletingLastPathComponent];
		mandatoryDirectory = [mandatoryDirectory stringByStandardizingPath];
		if([filename belongsToDirectory:mandatoryDirectory])
		{
			return YES;
		}
		else
		{
			[sender setDirectory:mandatoryDirectory];
			return NO;
		}
	}
	else
	{//
		switch([self creationMode])
		{
			case iTM2ToggleStandaloneMode: result = [self selectedTemplateCanBeStandalone]; break;
			case iTM2ToggleOldProjectMode: result = [self selectedTemplateCanInsertInOldProject]; break;
			default:
			{
				NSString * targetName = [filename stringByDeletingPathExtension];
				targetName = [targetName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
				result = [self selectedTemplateCanCreateNewProject] && ![DFM fileExistsAtPath:targetName];
				break;
			}
		}
	}
	if(result)
	{
		return YES;
	}
	NSString * enclosing = [filename enclosingWrapperFileName];
	if([enclosing length]>1)
	{
		mandatoryDirectory = [enclosing stringByDeletingLastPathComponent];
	}
	else
	{
		enclosing = [filename enclosingProjectFileName];
		if([enclosing length]>1)
		{
			mandatoryDirectory = [enclosing stringByDeletingLastPathComponent];
		}
	}
	if(mandatoryDirectory)
	{
		[sender setDirectory:mandatoryDirectory];
	}
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=- ACCESSORY VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  savePanelAccessoryView
- (id)savePanelAccessoryView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSavePanelAccessoryView:
- (void)setSavePanelAccessoryView:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTarget
- (iTM2ProjectDocument *)projectTarget;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self standaloneFileName] length]? [self mandatoryProject]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInsertItem:(id)item inOldProjectForDirectory
- (BOOL)canInsertItem:(id)item inOldProjectForDirectory:(NSString *)directory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM isWritableFileAtPath:directory])
	{
//iTM2_END;
		return NO;
	}
	if([[NSURL fileURLWithPath:directory] belongsToCachedProjectsDirectory])
	{
		return NO;// nothing can be added in the faraway projects directory
	}
	NSString * enclosing = [directory enclosingProjectFileName];
	if([enclosing length])
	{
		return NO;// nothing can be inserted inside a .texp project directory
	}
	NSString * standalone = [item standaloneFileNameValue];
	if(![standalone length])
	{
		return NO;
	}
	if([SWS isWrapperPackageAtPath:standalone])
	{
		return NO;
	}
	NSString * mandatory = [[self mandatoryProject] fileName];
	if([mandatory length])
	{
		if([SWS isProjectPackageAtPath:standalone])
		{
			return NO;
		}
		mandatory = [mandatory stringByDeletingLastPathComponent];
		NSString * relative = [directory stringByAbbreviatingWithDotsRelativeToDirectory:mandatory];
		if([relative hasPrefix:@".."])
		{
			return NO;
		}
		return YES;
	}
	if([SWS isProjectPackageAtPath:standalone])
	{
		NSString * enclosing = [directory enclosingWrapperFileName];
		NSArray * enclosed = nil;
		if([enclosing length])
		{
			enclosed = [enclosing enclosedProjectFileNames];
			return [enclosed count] == 0;
		}
		NSDictionary * available = [SPC availableProjectsForPath:directory];
		NSEnumerator * E = [available keyEnumerator];
		while(enclosing = [E nextObject])
		{
			if([SWS isWrapperPackageAtPath:enclosing])
			{
				enclosed = [enclosing enclosedProjectFileNames];
				if([enclosed count] == 0)
				{
					return YES;
				}
			}
		}
		return NO;
	}
//iTM2_END;
	return [[SPC availableProjectsForPath:directory] count]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplateCanInsertInOldProject
- (BOOL)selectedTemplateCanInsertInOldProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self canInsertItem:[self selectedTemplate] inOldProjectForDirectory:[self panelDirectory]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  item:canCreateNewProjectForDirectory:
- (BOOL)item:(id)item canCreateNewProjectForDirectory:(NSString *)directory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM isWritableFileAtPath:directory])
	{
//iTM2_END;
		return NO;
	}
	if([self mandatoryProject])
	{
//iTM2_END;
		return NO;
	}
	if([[NSURL fileURLWithPath:directory] belongsToCachedProjectsDirectory])
	{
//iTM2_END;
		return NO;// nothing can be added in the faraway projects directory
	}
	NSString * enclosing = [directory enclosingProjectFileName];
	if([enclosing length])
	{
//iTM2_END;
		return NO;// nothing can be inserted inside a .texp project directory
	}
	// and if the directory is not in a wrapper
	enclosing = [directory enclosingWrapperFileName];
	if([enclosing length])
	{
		NSArray * enclosed = [enclosing enclosedProjectFileNames];
		if([enclosed count])
		{
//iTM2_END;
			return NO;// nothing can be inserted inside a .texd wrapper directory
		}
	}
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplateCanCreateNewProject
- (BOOL)selectedTemplateCanCreateNewProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self item:[self selectedTemplate] canCreateNewProjectForDirectory:[self panelDirectory]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  item:canBeStandaloneForDirectory:
- (BOOL)item:(id)item canBeStandaloneForDirectory:(NSString *)directory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM isWritableFileAtPath:directory])
	{
//iTM2_END;
		return NO;
	}
	if([self mandatoryProject])
	{
//iTM2_END;
		return NO;
	}
	if([[NSURL fileURLWithPath:directory] belongsToCachedProjectsDirectory])
	{
		return NO;// nothing can be added in the faraway projects directory
	}
	NSString * enclosing = [directory enclosingProjectFileName];
	if([enclosing length])
	{
		return NO;// nothing can be inserted inside a .texp project directory
	}
	enclosing = [directory enclosingWrapperFileName];
	if([enclosing length])
	{
		return NO;// no standalone projects inside a wrapper
	}
	// two conditions
	// 1 the template has a standalone file name
	// 2 the current panel directory is not included in a wrapper
	// except when the wrapper no longer has a project
	NSString * standalone = [item standaloneFileNameValue];
	if([SWS isProjectPackageAtPath:standalone])
	{
		return NO;
	}
	if([SWS isWrapperPackageAtPath:standalone])
	{
		return NO;
	}
//iTM2_END;
    return [standalone length]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedTemplateCanBeStandalone
- (BOOL)selectedTemplateCanBeStandalone;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self item:[self selectedTemplate] canBeStandaloneForDirectory:[self panelDirectory]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  standaloneFileName
- (NSString *)standaloneFileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	id item = [self selectedTemplate];
	return [item standaloneFileNameValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCreationMode
- (void)validateCreationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self panelDirectory] length])
	{
		return;
	}
	int creationMode = [self creationMode];
	if((creationMode == iTM2ToggleOldProjectMode) && [self selectedTemplateCanInsertInOldProject])
	{
		return;
	}
	else if((creationMode == iTM2ToggleNewProjectMode) && [self selectedTemplateCanCreateNewProject])
	{
		return;
	}
	else if((creationMode == iTM2ToggleStandaloneMode) && [self selectedTemplateCanBeStandalone])
	{
		return;
	}
	creationMode = iTM2ToggleForbiddenProjectMode;
	if([self selectedTemplateCanBeStandalone])
	{
		creationMode = iTM2ToggleStandaloneMode;
	}
	else if([self selectedTemplateCanCreateNewProject])
	{
		creationMode = iTM2ToggleNewProjectMode;
	}
	else if([self selectedTemplateCanInsertInOldProject])
	{
		creationMode = iTM2ToggleOldProjectMode;
	}
	[self setCreationMode:creationMode];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  creationMode
- (int)creationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * result = metaGETTER;
//iTM2_END;
    return result?[result intValue]:[SUD integerForKey:iTM2NewProjectCreationModeKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCreationMode:
- (void)setCreationMode:(int)tag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithInt:tag]);
	if(tag>=0)
	{
		[SUD setInteger:tag forKey:iTM2NewProjectCreationModeKey];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeCreationModeFromTag:
- (IBAction)takeCreationModeFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// Hum, the sender is the matrix despite each cell is connected separately in interface builder
	[self setCreationMode:[[sender selectedCell] tag]];
	[self validateCreationMode];
	[self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeCreationModeFromTag:
- (BOOL)validateTakeCreationModeFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int creationMode = [self creationMode];
	if(creationMode == iTM2ToggleForbiddenProjectMode)
	{
		[sender setState:NSOffState];
		return NO;
	}
	BOOL selected = [sender tag] == creationMode;
	[sender setState:(selected? NSOnState:NSOffState)];
#if 1
	BOOL result = YES;
	switch([sender tag])
	{
#warning DEBUGGGGGGGGGGG CLEAN the standalone
//		case iTM2ToggleStandaloneMode: result = [self selectedTemplateCanBeStandalone];break;
		case iTM2ToggleOldProjectMode: result = [self selectedTemplateCanInsertInOldProject];break;
		default: result = [self selectedTemplateCanCreateNewProject];break;
	}
	NSAssert(!selected || result, @"Missed(1)");
	return result;
#else
// next code does not give the expected result (at least with gdb 09/13/2006 Mac OS X 10.4.6)
	switch([sender tag])
	{
		case iTM2ToggleOldProjectMode: return [self selectedTemplateCanInsertInOldProject];break;
		case iTM2ToggleStandaloneMode: return [self selectedTemplateCanBeStandalone];break;
		default: return [self selectedTemplateCanCreateNewProject];break;
	}
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeProjectFromSelectedItem:
- (IBAction)takeProjectFromSelectedItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * new = [[sender selectedItem] representedObject];
	NSString * old = [self oldProjectName];
	if([old isEqualToString:new])
	{
		return;
	}
	[self setOldProjectName:new];
	if(![[NSURL fileURLWithPath:new] belongsToCachedProjectsDirectory]
		&& [SWS isWrapperPackageAtPath:new])
	{
		NSSavePanel * SP = [NSSavePanel savePanel];
		[SP setDirectory:new];
		[SP update];
	}
	[self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeProjectFromSelectedItem:
- (BOOL)validateTakeProjectFromSelectedItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * oldProjectName = [self oldProjectName];
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSDictionary * availableProjects = [self availableProjects];
		[sender removeAllItems];
		NSString * path;
		NSEnumerator * E = [availableProjects keyEnumerator];
		while(path = [E nextObject])
		{
			NSString * displayName = [availableProjects objectForKey:path];
			displayName = [displayName stringByDeletingPathExtension];
			[sender addItemWithTitle:displayName];
			id item = [sender lastItem];
			[item setRepresentedObject:path];
			NSImage * icon = [SWS iconForFile:path];
			NSSize iconSize = [icon size];
			if(iconSize.height > 0)
			{
				float height = [sender frame].size.height;
				height -= 8;
				iconSize.width *= height/iconSize.height;
				iconSize.height = height;
				[icon setScalesWhenResized:YES];
				[icon setSize:iconSize];
			}
			[item setImage:icon];
		}
		if([sender numberOfItems]>0)
		{
			int index = 0;
			if(![oldProjectName length])
			{
				oldProjectName = [[sender itemAtIndex:index] representedObject];
				[self setOldProjectName:oldProjectName];
			}
			else
			{
				index = [sender indexOfItemWithRepresentedObject:oldProjectName];
				if(index<0)
				{
					// the old project oldProjectName, if any, is not listed in the available projects
					index = 0;// a better choice?
					oldProjectName = [[sender itemAtIndex:index] representedObject];
					[self setOldProjectName:oldProjectName];
				}
			}
			[sender selectItemAtIndex:index];
			return [self selectedTemplateCanInsertInOldProject]
					&& ([sender numberOfItems]>1)
						&& ([self creationMode] == iTM2ToggleOldProjectMode);
		}
		return NO;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		NSString * standalone = [self standaloneFileName];
		if(![standalone length])
		{
			return NO;
		}
		if([SWS isWrapperPackageAtPath:standalone])
		{
			return NO;
		}
		if([SWS isProjectPackageAtPath:standalone])
		{
			NSString * project = [sender representedObject];
			if([SWS isWrapperPackageAtPath:project])
			{
				NSArray * enclosed = [project enclosedProjectFileNames];
				if(![enclosed count])
				{
					return YES;
				}
			}
			return NO;
		}
		return YES;
	}
    return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preferWrapper
- (BOOL)preferWrapper;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPreferWrapper:
- (void)setPreferWrapper:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD setBool:yorn forKey:iTM2NewDocumentEnclosedInWrapperKey];
	metaSETTER([NSNumber numberWithBool:yorn]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleWrapper:
- (IBAction)toggleWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self preferWrapper];
	[self setPreferWrapper:!old];
	[self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWrapper:
- (BOOL)validateToggleWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self preferWrapper]? NSOnState:NSOffState)];
//iTM2_END;
    return [self creationMode] == iTM2ToggleNewProjectMode;
}
#pragma mark =-=-=-=-=-  DATA SOURCE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjects
- (id)availableProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * availableProjects = metaGETTER;
	if(availableProjects)
	{
		return availableProjects;
	}
	NSString * path = [self panelDirectory];
	NSString * enclosing = [path enclosingWrapperFileName];
	if([enclosing length])
	{
		NSString * displayName = [enclosing lastPathComponent];
		displayName = [displayName stringByDeletingPathExtension];
		availableProjects = [NSDictionary dictionaryWithObject:displayName forKey:enclosing];
	}
	else
	{
		availableProjects = [SPC availableProjectsForPath:path];
	}
	[self setAvailableProjects:availableProjects];
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAvailableProjects:
- (void)setAvailableProjects:(id) argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfItemsInComboBox:
- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self availableProjects] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:objectValueForItemAtIndex:
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self availableProjects] objectAtIndex:index];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:indexOfItemWithStringValue:
- (unsigned int)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:completedString:
- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return string;
}
#endif
@end

@implementation NSUserDefaultsController(NewDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeNewDocumentAuthorNameFromCombo:
- (IBAction)takeNewDocumentAuthorNameFromCombo:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * author = [sender stringValue];
	if([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
	{
		[[self values] setValue:[NSArray array] forKey:@"iTM2KnownAuthorsList"];
	}
	else if([author length])
	{
		id original = [[self values] valueForKey:@"iTM2KnownAuthorsList"];
		NSMutableArray * authors = [NSMutableArray arrayWithArray:([original isKindOfClass:[NSArray class]]? original:nil)];
		[authors removeObject:author];
		[authors insertObject:author atIndex:0];
		[[self values] setValue:authors forKey:@"iTM2KnownAuthorsList"];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeNewDocumentOrganizationNameFromCombo:
- (IBAction)takeNewDocumentOrganizationNameFromCombo:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * organization = [sender stringValue];
	if([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
	{
		[[self values] setValue:[NSArray array] forKey:@"iTM2KnownOrganizationsList"];
	}
	else if([organization length])
	{
		id original = [[self values] valueForKey:@"iTM2KnownOrganizationsList"];
		NSMutableArray * organizations = [NSMutableArray arrayWithArray:([original isKindOfClass:[NSArray class]]? original:nil)];
		[organizations removeObject:organization];
		[organizations insertObject:organization atIndex:0];
		[[self values] setValue:organizations forKey:@"iTM2KnownOrganizationsList"];
	}
//iTM2_END;
    return;
}
@end

@implementation iTM2MainInstaller(NewDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No New Documents" forKey:@"iTM2NewDocumentKit"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2NewDocumentKitCompleteInstallation
+ (void)iTM2NewDocumentKitCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2NewDocumentAssistant loadTemplates];
    if([[iTM2NewDocumentAssistant newDocumentDataSource] countOfChildren]>0)
	{
		[iTM2MileStone putMileStoneForKey:@"iTM2NewDocumentKit"];
	}
//iTM2_END;
	return;
}
@end

@interface iTM2NewDocumentPrefPane: iTM2PreferencePane
@end

@implementation iTM2NewDocumentPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"2.New";
}
@end

@implementation iTM2NewDocumentTreeNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nodeWithParent:
+ (id)nodeWithParent:(id)tree;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[[self alloc] initWithParent:tree value:[NSMutableDictionary dictionary]] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sortChildrenAccordingToPrettyNameValue
- (void)sortChildrenAccordingToPrettyNameValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	unsigned index = [self countOfChildren];
	while(index--)
	{
		iTM2NewDocumentTreeNode * child = [self objectInChildrenAtIndex:index];
		[MD setObject:child forKey:[child prettyNameValue]];
	}
	NSEnumerator * E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	NSString * K = nil;
	while(K = [E nextObject])
	{
		id O = [MD objectForKey:K];
		[self removeObjectFromChildren:O];
		[self addObjectInChildren:O];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childWithPrettyNameValue:
- (id)childWithPrettyNameValue:(NSString *) prettyName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned index = [self countOfChildren];
	while(index--)
	{
		iTM2NewDocumentTreeNode * child = [self objectInChildrenAtIndex:index];
		if([prettyName isEqualToString:[child prettyNameValue]])
		{
			return child;
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyNameValue
- (id)prettyNameValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self value] valueForKey:@"prettyName"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPrettyNameValue:
- (void)setPrettyNameValue:(NSString *) prettyName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self value] takeValue:prettyName forKey:@"prettyName"];
	[[self parent] sortChildrenAccordingToPrettyNameValue];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameValue
- (id)nameValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self value] valueForKey:@"name"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNameValue:
- (void)setNameValue:(NSString *) name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self value] takeValue:name forKey:@"name"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathValue
- (id)pathValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self value] valueForKey:@"path"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPathValue:
- (void)setPathValue:(NSString *) path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self value] takeValue:path forKey:@"path"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  standaloneFileNameValue
- (id)standaloneFileNameValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [[self value] valueForKey:@"standaloneFileName"];
	if(result)
	{
		return result;
	}
	NSString * sourceName = [self pathValue];
	if(!sourceName)
	{
		return @"";
	}
	BOOL isDirectory;
	if([DFM fileExistsAtPath:sourceName isDirectory:&isDirectory])
	{
		if(isDirectory)
		{
			NSBundle * B = [NSBundle bundleWithPath:sourceName];
			NSString * component = [[B infoDictionary] objectForKey:@"iTM2StandaloneFileName"];
			if([component length])
			{
				NSString * path = [sourceName stringByAppendingPathComponent:component];
				if([DFM fileExistsAtPath:path])
				{
					[self setStandaloneFileNameValue:path];
					return path;
				}
				else
				{
					NSLog(@"There is no file at: %@", path);
				}
			}
			if([SWS isProjectPackageAtPath:sourceName])
			{
				[self setStandaloneFileNameValue:@""];
				return sourceName;
			}
		}
		else
		{
			[self setStandaloneFileNameValue:sourceName];
			return sourceName;
		}
	}
	[self setStandaloneFileNameValue:@""];
	return @"";
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStandaloneFileNameValue:
- (void)setStandaloneFileNameValue:(NSString *) path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self value] takeValue:path forKey:@"standaloneFileName"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  containsAProjectValue
- (id)containsAProjectValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self value] valueForKey:@"containsAProject"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContainsAProjectValue:
- (void)setContainsAProjectValue:(NSNumber *) value;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self value] takeValue:value forKey:@"containsAProject"];
//iTM2_END;
	return;
}
@end

@implementation NSFileManager(NewDocumentKit)
- (BOOL)newDocumentIsPrivateFileAtPath:(NSString *)path;
{
	return [[path pathComponents] containsObject:iTM2NewDPathComponent];
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2NewDocumentKit
