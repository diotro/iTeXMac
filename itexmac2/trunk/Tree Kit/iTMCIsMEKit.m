/*
//  iTMCIsMEKit.m
//  New projects 1.4
//
//  Created by jlaurens@users.sourceforge.net on Fri May 23 2003.
//  Copyright � 2003 Laurens'Tribune. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "NSControl_iTeXMac.h"
#import "iTMCIsMEKit.h"

@interface iTMController(PRIVATE)
- (id) _inspectors;
- (void) _setInspectors: (id) argument;
- (void) _setEditor: (id) argument;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMController
/*"iTMController is a view controller class. It is designed to wirk in conjunction with an iTMDataWrapper instance to control its stored data and an inspector to view the data. The tree item only knows the class of the inspector that will be able to display and edit its data. Those objects are the nodes and leaves of a tree: each object has access to a parent and to children, except the root object and the ending leaves."*/
@implementation iTMController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self _setInspectors: nil];
    [self setModel: nil];
    [self _setEditor: nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  identifier
- (id) identifier;
/*"Lazy initialized.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[self model] identifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIdentifier:
- (void) setIdentifier: (id) argument;
/*"It changes the identifier of the model.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [[self model] setIdentifier: argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  key
- (NSString *) key;
/*"Lazy initialized.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[self model] key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setKey:
- (void) setKey: (id) argument;
/*"It changes the key of the model.
NO is returned when there is a latent problem.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [[self model] setKey: argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  model
- (id) model;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Model;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setModel:
- (void) setModel: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(argument && ![argument isKindOfClass: [iTMModel class]])
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] iTMModel object expected: got %@.",
            [self class], NSStringFromSelector(_cmd), argument];
    else if(![argument isEqual: _Model])
    {
        [_Model autorelease];
        _Model = [argument retain];
        [self modelDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelDidChange
- (void) modelDidChange;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self _setEditor: nil];
    [self _setInspectors: nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editor
- (id) editor;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(!_Editor)
    {
        _Editor = [[[_Model class] allocWithZone: [self zone]] init];
        _Editor = [_Editor synchronizedWith: _Model];
        [_Editor replaceController: self];
    }
    return _Editor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _setEditor:
- (void) _setEditor: (id) argument;
/*"The receiver no longer is the controller of the previous editor.

Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![_Editor isEqual: argument])
    {
        [_Editor replaceController: nil];
        [_Editor autorelease];
        _Editor = [argument retain];
        [_Editor replaceController: self];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEditing
- (BOOL) isEditing;
/*"The low level getter. Returns NO if there is no editor.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"%@", (_IsEditing? @"Y": @"N"));
    return _IsEditing;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEditing:
- (void) setEditing: (BOOL) flag;
/*"Also validates the user interface.  Don't call this from within the validation process (unless you want to loop...)
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"flag: %@", (flag? @"Y": @"N"));
    _IsEditing = flag;
    return;
}
#pragma mark ==========  INSPECTING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectors
- (id) _inspectors;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Inspectors? _Inspectors: (_Inspectors = [[NSMutableSet allocWithZone: [self zone]] initWithCapacity: 1]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectors
- (void) _setInspectors: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(argument && ![argument isKindOfClass: [NSSet class]])
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] NSSet object expected: got %@.",
            [self class], NSStringFromSelector(_cmd), argument];
    else if(![argument isEqual: _Inspectors])
    {
        NSEnumerator * E = [self inspectorsEnumerator];
        id <iTMInspector> I;
        while(I = [E nextObject])
        {
            [I replaceController: nil];
            [I synchronizeUIWithEditor];
        }
        [_Inspectors autorelease];
        _Inspectors = argument;
        argument = [[argument mutableCopyWithZone: [self zone]] autorelease];
        E = [_Inspectors objectEnumerator];
        while(I = [E nextObject])
        {
            if([I canBeginInspecting: self])
            {
                [I replaceController: self];
            }
            else
            {
                [I replaceController: nil];
                [argument removeObject: I];
            }
            [I synchronizeUIWithEditor];
        }
        _Inspectors = [argument mutableCopyWithZone: [self zone]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorsEnumerator
- (NSEnumerator *) inspectorsEnumerator;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [_Inspectors objectEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  beginEditingWithInspector:
- (BOOL) beginEditingWithInspector: (id <iTMInspector>) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![argument canBeginInspecting: self] || [_Inspectors containsObject: argument])
        return NO;
    if(![_Inspectors count])
        [self synchronizeEditorWithModel];
    [argument setController: self];
    [_Inspectors addObject: argument];
    [argument setEditing: NO];
    [argument synchronizeUIWithEditor];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  endEditingWithInspector:
- (void) endEditingWithInspector: (id <iTMInspector>) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [argument replaceController: nil];
    [argument setEditing: NO];
    if([argument window])
        [argument synchronizeUIWithEditor];
    [_Inspectors removeObject: argument];
    return;
}
#pragma mark ==========  SYNCHRONIZING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeEditorWithModel
- (void) synchronizeEditorWithModel;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![_Editor isEqual: _Model])
        _Editor = [_Editor synchronizedWith: _Model];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeModelWithEditor
- (void) synchronizeModelWithEditor;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![_Model isEqual: _Editor])
        _Model = [_Model synchronizedWith: _Editor];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeEditorWithInspectors
- (void) synchronizeEditorWithInspectors;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSEnumerator * E = [self inspectorsEnumerator];
    id <iTMInspector> I;
    while(I = [E nextObject])
        [I synchronizeEditorWithUI];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeInspectorsWithEditor
- (void) synchronizeInspectorsWithEditor;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSEnumerator * E = [self inspectorsEnumerator];
    id <iTMInspector> I;
    NSMutableSet * S = [NSMutableSet set];
    while(I = [E nextObject])
    {
        [I synchronizeUIWithEditor];
        NSWindow * W = [I window];
        if(W)
            [S addObject: W];
        else
            [self endEditingWithInspector: I];
    }
    [[S allObjects] makeObjectsPerformSelector: @selector(iTM2_validateContent)];
    return;
}
#pragma mark ==========  DATA I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToFile:originalFile:saveOperation:
- (BOOL) writeToFile: (NSString *) fileName originalFile: (NSString *) fullOriginalDocumentPath saveOperation: (NSSaveOperationType) saveOperationType;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[self model]
        writeToFile: fileName
            originalFile: fullOriginalDocumentPath
                saveOperation: saveOperationType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromFile:
- (BOOL) readFromFile: (NSString *) fileName;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"fileName: %@", fileName);
    return [[self model] readFromFile: fileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToDirectoryWrapper:
@end

NSString * const iTMItemPropertyListXMLFormatKey = @"iTMItemPropertyListXMLFormat";

@implementation iTMModel
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void) initialize;
/*"Designated Initializer.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    static BOOL firstTime = YES;
    if(firstTime)
    {
        firstTime = NO;
        [[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt: NSPropertyListXMLFormat_v1_0], iTMItemPropertyListXMLFormatKey,
                nil]];
        Class C = NSClassFromString(@"NSKeyBinding");
        SEL S = @selector(suppressCapitalizedKeyWarning);
        if([C respondsToSelector: S]) [C performSelector: S];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorClass
+ (Class) inspectorClass;
/*"Designated Initializer.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [iTMInspector class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addItemInTabView:
- (NSTabViewItem *) addItemInTabView: (NSTabView *) tabView;
/*"Convenience method.
Version history: jlaurens@users.sourceforge.net
- 1.3: Fri Nov 15 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[[self class] inspectorClass] addItemInTabView: tabView withController: [self controller]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithDataModel:
- (id) initWithDataModel: (id) dataModel;
/*"The Designated initializers.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(self = [[super init] autorelease])
    {
        _PLXMLFormat = [[NSUserDefaults standardUserDefaults] integerForKey: iTMItemPropertyListXMLFormatKey];
        [self replaceDataModel: dataModel];
    }
    return [self retain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithModel:
- (id) init;
/*"The Designated initializers.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [self initWithDataModel: nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self setIdentifier: nil];
    [self setKey: nil];
    [self setDataModel: nil];
    [self setController: nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizedWith:
- (id) synchronizedWith: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= compare:
- (NSComparisonResult) compare: (iTMModel *) rhs;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.3: Thu Oct 31 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return  NSOrderedSame;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  description
- (NSString *) description;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.3: Thu Oct 31 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [NSString stringWithFormat: @"<%@ 0x%x, identifier: %@>", [self class], self, [self identifier]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PLXMLFormat
- (NSPropertyListFormat) PLXMLFormat;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _PLXMLFormat;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPLXMLFormat:
- (void) setPLXMLFormat: (NSPropertyListFormat) argument;
/*"Description forthcoming. argument is retained. Lazy dataWrapper initializer as side effect.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    _PLXMLFormat = argument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  controller
- (id) controller;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Controller;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setController:
- (void) setController: (iTMController *) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(argument && ![argument isKindOfClass: [iTMController class]])
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] iTMController argument expected: got %@.",
            [self class], NSStringFromSelector(_cmd), argument];
    else if(argument != _Controller)
    {
        _Controller = argument;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceController:
- (void) replaceController: (iTMController *) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self setController: argument];
    return;
}
#pragma mark ========== identifier management
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyKey
- (id) lazyKey;
/*"Description forthcoming. For subclassers. The default implementation just returns a void string.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  key
- (NSString *) key;
/*"Lazy initialized.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Key? _Key: (_Key = [[self lazyKey] retain]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setKey:
- (void) setKey: (id) argument;
/*"Description forthcoming. argument is copied if possible or just retained.
May raise an exception.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List: implement the key identifier check
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![argument isEqual: _Identifier])
    {
        [_Identifier autorelease];
        _Identifier = [argument respondsToSelector: @selector(copy:)]? [argument copy]: [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyIdentifier
- (id) lazyIdentifier;
/*"Description forthcoming. For subclassers. The default implementation just returns a null object.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  identifier
- (id) identifier;
/*"Lazy initialized.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Identifier? _Identifier: (_Identifier = [[self lazyIdentifier] retain]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIdentifier:
- (void) setIdentifier: (id) argument;
/*"Description forthcoming. argument is copied if possible or just retained.
May raise an exception.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List: implement the key identifier check
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![argument isEqual: _Identifier])
    {
        [_Identifier autorelease];
        _Identifier = [argument respondsToSelector: @selector(copy:)]? [argument copy]: [argument retain];
    }
    return;
}
#pragma mark ==========  DATA MODEL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeIdentifierWithDataModel
- (void) synchronizeIdentifierWithDataModel;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeDataModelWithIdentifier
- (void) synchronizeDataModelWithIdentifier;
/*"Lazy initializer. It is actually a dictionary, but is subject to change.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataModel
- (id) dataModel;
/*"Basic getter.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(!_DataModel) [self replaceDataModel: nil];
    return _DataModel;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDataModel:
- (void) setDataModel: (id) argument;
/*"Description forthcoming. Very low level setter. The argument is not checked for mutability.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"argument: %@", argument);
#warning DEBUGGGG
//    if(!argument) NSLog(@"COUCOUROUCOUCOU");
    if(argument != _DataModel)
    {
        [_DataModel autorelease];
        _DataModel = [argument retain];
//NSLog(@"%@ data model was set to: 0x%x", self, _Model);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceDataModel:
- (id) replaceDataModel: (id) argument;
/*"Description forthcoming. argument can't be nil.
The data hierarchy is meant to remain consistent.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x (item)", [self class], NSStringFromSelector(_cmd), self);
    argument = [self dataModelWithDataModel: argument];
    if([_DataModel isEqual: argument])
        return _DataModel;
    if(argument)
    {
        [self setDataModel: argument];
        [self dataModelDidChange];
    }
//NSLog(@"OK!!!");
    return argument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataModelWithDataModel:
- (id) dataModelWithDataModel: (id) argument;
/*"The default implementation just returns the argument.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x (iTMBranch)", [self class], NSStringFromSelector(_cmd), self);
    return argument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataModelDidChange
- (void) dataModelDidChange;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self synchronizeIdentifierWithDataModel];
    return;
}
#pragma mark ==========  DATA I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToSave
- (void) prepareToSave;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentation:
- (NSData *) dataRepresentation;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x -file", [self class], NSStringFromSelector(_cmd), self);
    [self prepareToSave];
    NSString * errorString = nil;
    id result = [NSPropertyListSerialization dataFromPropertyList: [self dataModel]
        format: [self PLXMLFormat] errorDescription: &errorString];

    if(errorString)
    {
        NSBeep();
        NSLog(@"Big problem\nReport BUG ref: iTM861");
        NSLog(@"error string: '%@'", errorString);
        [errorString autorelease];
        errorString = nil;
    }
//NSLog(@"data: %@", result);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadDataRepresentation:
- (BOOL) loadDataRepresentation: (NSData *) D;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"D: %@", D);
    if([D length])
    {
        NSString * errorString = nil;
        NSPropertyListFormat format;
        id DM = [NSPropertyListSerialization propertyListFromData: D
            mutabilityOption: NSPropertyListMutableContainersAndLeaves
                format: &format errorDescription: &errorString];
        if(errorString)
        {
            NSBeep();
            NSLog(@"Big problem\nReport BUG ref: iTM168");
            NSLog(@"error string: '%@'", errorString);
            [errorString autorelease];
            errorString = nil;
        }
//NSLog(@"DM: %@", DM);
        if(DM)
        {
//NSLog(@"THE MODEL LOADER IS ABOUT TO REPLACE THE item DATA.......");
            [self setPLXMLFormat: format];
            return [self replaceDataModel: DM] != nil;
        }
    }
    [self replaceDataModel: nil];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToFile:originalFile:saveOperation:
- (BOOL) writeToFile: (NSString *) fileName originalFile: (NSString *) fullOriginalDocumentPath saveOperation: (NSSaveOperationType) saveOperationType;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[self dataRepresentation] writeToFile: fileName atomically: YES];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromFile:
- (BOOL) readFromFile: (NSString *) fileName;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [self loadDataRepresentation: [NSData dataWithContentsOfFile: fileName]];
}
@end

@interface iTMInspector(PRIVATE)
- (NSTabViewItem *) tabViewItem;
- (void) setTabViewItem: (NSTabViewItem *) argument;
- (id) _init;
- (NSTabViewItem *) _addItemInTabView: (NSTabView *) tabView;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMInspector
/*"iTMInspector is a semi abstract class. It is a view controller that owns a #{tabViewItem} which is meant to be inserted in some NSTabView. The identifier of this #{tabViewItem} is nothing but the inspector itself, not an NSString instance. "*/
@implementation iTMInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id) init;
/*"_init is a designated initializer.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(self = [super init])
    {
        _OwnsTabViewItem = NO;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self setController: nil];
    if(_OwnsTabViewItem)
        [self setTabViewItem: nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  controller
- (id) controller;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Controller;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceController:
- (void) setController: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(argument && ![argument isKindOfClass: [iTMController class]])
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] iTMController argument expected: got %@.",
            [self class], NSStringFromSelector(_cmd), argument];
    else if(argument != _Controller)
    {
        _Controller = argument;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceController:
- (void) replaceController: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(([self controller] != argument) && [self canEndInspectingWithWarning: YES] && [self canBeginInspecting: argument])
    {
        [[self controller] endEditingWithInspector: self];
        [argument beginEditingWithInspector: self];
        // side effect: [self setController: argument]
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canBeginInspecting:
- (BOOL) canBeginInspecting: (id) argument;
/*"Default implementation returns YES. Subclassers must make their own decision.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canEndInspectingWithWarning:
- (BOOL) canEndInspectingWithWarning: (BOOL) argument;
/*"Default implementation returns YES. Subclassers must make their own decision.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return YES;
}
#pragma mark ==========  MANAGING THE TABVIEWITEM
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addItemInTabView:withController:
+ (NSTabViewItem *) addItemInTabView: (NSTabView *) tabView withController: (id) controller;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"+[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    id inspector = [[[self alloc] init] autorelease];
    [inspector replaceController: controller];
    return [inspector _addItemInTabView: tabView];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _addItemInTabView:
- (NSTabViewItem *) _addItemInTabView: (NSTabView *) tabView;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if([tabView isKindOfClass: [NSTabView class]])
    {
        [self loadOutlets];
        if(!_TabViewItem)
            [NSException raise: NSInternalInconsistencyException format:
                @"-[%@ %@] Problem with %@.nib",
                    [self class], NSStringFromSelector(_cmd), NSStringFromClass([self class])];
        [_TabViewItem setIdentifier: self];
        [tabView addTabViewItem: _TabViewItem];
        if([_TabViewItem tabView] == tabView)
        {
            [_TabViewItem autorelease];
            _OwnsTabViewItem = NO;
        }
        [self validateUserInterface];
        return _TabViewItem;
    }
    else if(tabView)
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] NSTabView argument expected: got %@.",
            [self class], NSStringFromSelector(_cmd), tabView];
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabViewItem
- (NSTabViewItem *) tabViewItem;
/*"Lazy initializer. The identifier of the #{tabViewItem} is the receiver.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _TabViewItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTabViewItem:
- (void) setTabViewItem: (NSTabViewItem *) argument;
/*"Description forthcoming. Private.
Nib loading and cleaning only!!!
Retains the argument and removes it from its tab view.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(argument && ![argument isKindOfClass: [NSTabViewItem class]])
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] NSTabViewItem argument expected: got %@.",
            [self class], NSStringFromSelector(_cmd), argument];
    else if(argument != _TabViewItem)
    {
        [_TabViewItem autorelease];
        _TabViewItem = [argument retain];// must retain because there is another pool in place
        [[_TabViewItem tabView] removeTabViewItem: _TabViewItem];// detach from its tabView...
        [_TabViewItem setTabState: NSBackgroundTab];
        _OwnsTabViewItem = YES;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadOutlets
- (void) loadOutlets;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [[[[NSWindowController alloc] initWithWindowNibName: NSStringFromClass([self class]) owner: self] autorelease] window];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUserInterface
- (void) validateUserInterface;
/*"Subclassers will add their own stuff.
The default implementation just sends a #{validateWindowContent} to the view of the tabViewItem.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSView * V = [[self tabViewItem] view];
//NSLog(@"V: %@", V);
//NSLog(@"[V window]: %@", [V window]);
    if([V respondsToSelector: @selector(validateWindowContent)])
        [V performSelector: @selector(validateWindowContent)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateChangeCount
- (void) updateChangeCount: (NSDocumentChangeType) change;
/*"Subclassers will add their own stuff.
The default implementation just sends a #{validateWindowContent} to the view of the tabViewItem.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self setEditing: YES];
    [[[[self window] windowController] document] updateChangeCount: change];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  window
- (NSWindow *) window;
/*"The default implementation returns the window of the view of the receiver's tabViewItem.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[[self tabViewItem] view] window];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEditing
- (BOOL) isEditing;
/*"The low level getter. Returns NO if there is no editor.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [[self controller] isEditing];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEditing:
- (void) setEditing: (BOOL) flag;
/*"Also validates the user interface.  Don't call this from within the validation process (unless you want to loop...)
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"flag: %@", (flag? @"Y": @"N"));
    [[self controller] setEditing: flag];
    [self validateUserInterface];
    return;
}
#pragma mark ==========  SYNCHRONIZATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeUIWithEditor
- (void) synchronizeUIWithEditor;
/*"This default implementation just marks the receiver as unedited.
Subclassers should override the do and did methods, not this one. 
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeEditorWithUI
- (void) synchronizeEditorWithUI;
/*"This default implementation just marks the receiver as unedited.
Subclassers should override the do and did methods, not this one. 
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerDidLoadNib:
- (void) windowControllerDidLoadNib: (NSWindowController *) WC;
/*"Default implementation does nothing. Subclasses will append their stuff if needed. 
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerWillLoadNib:
- (void) windowControllerWillLoadNib: (NSWindowController *) WC;
/*"Default implementation does nothing. Subclasses will append their stuff if needed. 
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return;
}
#endif
@end

@implementation NSTabViewItem(iTMInspector)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didDeselect
- (void) setTabState: (NSTabState) newState;
/*"Deescription Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
#warning THIS CODE IS DANGEROUS ON SYSTEM UPGRADE
    self->_tabState = newState;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorReplaceController:
- (void) inspectorReplaceController: (iTMController *) argument;
/*"Deescription Forthcoming.
Version history: jlaurens@users.sourceforge.net
- for 1.4: Fri May 23 2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    id SI = [self identifier];
//NSLog(@"SI: %@", SI);
    if([SI respondsToSelector: @selector(replaceController:)])
        [SI replaceController: argument];
    else if(SI)
        NSLog(@"unexpected SI: %@", SI);
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMInspector

