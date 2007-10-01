/*
//  iTMCIsMEKit.h
//  New projects 1.4
//
//  Created by jlaurens@users.sourceforge.net on Fri May 23 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSPropertyList.h>
#import <AppKit/NSDocument.h>

@protocol iTMIdentity

/*!
@method key
@abstract The key of the object.
@discussion In a certain context, there is a one to one correspondance between keys and objects. The intrinsic nature of an object can change while its key remains the same.
@result An NSString instance.
*/
- (NSString *) key;

/*! 
@method setKey: 
@abstract The lowest level setter of key.
@discussion This method does not care about overall consistency.
@param an NSDictionary, an NSInvalidArgumentException is raised if the argument has a wrong type.
*/
- (void) setKey: (id) argument;

/*!
@method identifier
@abstract The identifier of the object.
@discussion The identifier is used to achieve a dynamical polymorphism of the code. For example, one object can be viewed with one inspector but when its identifier has changed, another inspector can be used to view it.
@result An object.
*/
- (id) identifier;

/*! 
@method setIdentifier: 
@abstract The lowest level setter of the receiver's identifier.
@discussion This method does not care about overall consistency.
@param an NSDictionary, an NSInvalidArgumentException is raised if the argument has a wrong type.
*/
- (void) setIdentifier: (id) argument;

@end

@class iTMController;

@protocol iTMControlled

/*! 
@method controller
@abstract The owning controller, if any.
@discussion See the iTMController description for details.
@result An iTMController instance.
*/
- (id) controller;

/*! 
@method setController:
@abstract The lowest level setter of controller. The receiver does not own its controller, it is owned by its controller.
@discussion This method does not care about overall consistency.
@param An id instance.
*/
- (void) setController: (iTMController *) argument;

/*! 
@method replaceController:
@abstract The highest level setter of controller.
@discussion This method does care about overall consistency.
@param An iTMModel instance.
*/
- (void) replaceController: (iTMController *) argument;

@end

/*! 
@protocol iTMModel 
@abstract A general purpose model protocol, from the MVC implementation in iTM : CIsME. 
@discussion This concrete class is the model articulation in an MVC code design. See the MVC Readme.rtf about the MVC in iTM. Those object are mutable.
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMInspector

@protocol iTMInspector <NSObject, iTMControlled>

/*!
@method addItemInTabView:withController:
@abstract Adds a new item in the tabView.
@discussion The item added is the user interface associated to the inspector. Once the tabview is added, the inspector is simply the identifier of the tabView item (remember that the identifier can be any kind of object).
@param tabView is the NSTabview instance where the item should be added.
@result The NSTabviewItem instance really added.
*/
+ (NSTabViewItem *) addItemInTabView: (NSTabView *) tabView withController: (id) controller;

/*! 
@method canBeginInspecting:
@abstract Whether the receiver can start the inspection of the argument.
@discussion The default implementation just returns NO and must be overriden.
@param An iTMController.
@result YORN.
*/
- (BOOL) canBeginInspecting: (id) argument;

/*! 
@method canEndInspectingWithWarning:
@abstract Whether the receiver can inspect the argument.
@discussion The default implementation just returns YES and must be overriden.
@param An flag indicating whether the end user should be informed if there is latent unregistered changes.
@result YORN.
*/
- (BOOL) canEndInspectingWithWarning: (BOOL) argument;

/*! 
@method tabViewItem
@abstract The owning tabViewItem.
@discussion In general, yhe tabViewItem is owned by the tabView, and owns the receiver itself. If the receiver is really the owner of its tabViewItem, there is an internal flag set to YES.
@result An iTMController instance.
*/
- (NSTabViewItem *) tabViewItem;

/*! 
@method setTabViewItem:
@abstract The lowest level setter of the tabViewItem.
@discussion Description Forthcoming.
@param An NSTabViewItem instance.
*/
- (void) setTabViewItem: (NSTabViewItem *) argument;

/*! 
@method validateUserInterface
@abstract Validates the user interface sending a validateContent to the window of the receiver.
@discussion Description Forthcoming.
*/
- (void) validateUserInterface;

/*! 
@method updateChangeCount:
@abstract Updates the change count.
@discussion Forwards the message to the document of the receiver's window. This leads to a proper display of the edited status of the window.
@param the change type.
*/
- (void) updateChangeCount: (NSDocumentChangeType) change;

/*! 
@method window
@abstract The window of the receiver.
@discussion Description Forthcoming.
@result the window of the tab view item oif the receiver.
*/
- (NSWindow *) window;

/*! 
@method isEditing
@abstract Whether the receiver is editing.
@discussion Description Forthcoming.
@result YORN.
*/
- (BOOL) isEditing;

/*! 
@method setEditing:
@abstract Sets the editing status of the receiver.
@discussion Description Forthcoming.
@param YORN.
*/
- (void) setEditing: (BOOL) flag;

/*! 
@method synchronizeUIWithEditor
@abstract Synchronizes the user interface with the editor.
@discussion This message is sent by the controller which will ask to validate the user interface.
*/
- (void) synchronizeUIWithEditor;

/*! 
@method synchronizeEditorWithUI
@abstract Synchronizes the editor with the user interface.
@discussion This message is sent by the controller.
*/
- (void) synchronizeEditorWithUI;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMController

/*! 
@class iTMController 
@abstract A general purpose controller, from the MVC. 
@discussion This concrete class is the central articulation in an MVC code design. See the MVC Readme.rtf about the MVC in iTM. 
*/

@interface iTMController: NSObject <iTMIdentity>
{
@private
    id _Model;
    id _Editor;
    id _Inspectors;
    BOOL _IsEditing;
}

/*! 
@method model
@abstract The underlying model.
@discussion The underlying model is expected to manage the data and information. It wraps the data polymorphism of the receiver such that there is no need to subclass iTMController a priori.
@result An iTMModel instance.
*/
- (id) model;

/*! 
@method setModel:
@abstract The lowest level setter of model. The receiver owns the model.
@discussion This method does not care about overall consistency.
@param An iTMModel instance.
*/
- (void) setModel: (id) argument;

/*! 
@method editor
@abstract The underlying editor.
@discussion The underlying model is expected to be a copy of the underlying model. Editing is made on the copy and then validated in the model. This simplifies the editing process. The editor can be the model itself but the default implementation returns a copy of the underlying model. It is set to nil each time the underlying model object changes, not its contents of course.
This default implementation creates a new instance of the model and uses the synchronizedWithObject:
@result An iTMModel instance.
*/
- (id) editor;

/*! 
@method modelDidChange
@abstract Each time the model object changes as a whole.
@discussion Message sent by the setModel:, the default implementation removes the editor and the inspectors. Subclassers will append their own stuff.
*/
- (void) modelDidChange;

/*! 
@method inspectorsEnumerator 
@abstract The inspectors enumerator.
@discussion Returns an enumerator of the inspectors actually used to edit the underlying model.
Many different inspector's can be used to edit the underlying model.
@param An enumerator of iTMInspector's instances.
*/
- (NSEnumerator *) inspectorsEnumerator;

/*!
@method beginEditingWithInspector:
@abstract Start the editing process.
@discussion Each time a new inspector will display the underlying model, this message should be sent to the receiver with  the inspector as argument. See the balancing endEditingWithInspector:.
The receiver will add the inspector to the list of known inspectors.
The receiver is the only object responsioble of overall consistency of the MVC chain, such that it must ensure that the inspector forget their previously used controllers.
The receiver does not owns the inspector, the inspector is meant to be owned by a third party object.
@param A new iTMInspector's instances.
@result The answer is NO if the inspector can not edit the receiver's underlying model or if it is already editing it.
*/
- (BOOL) beginEditingWithInspector: (id <iTMInspector>) argument;

/*!
@method endEditingWithInspector:
@abstract Ends the editing process.
@discussion Each time an inspector has finished editing the underlying model, this message must be sent to the receiver. See the balancing beginEditingWithInspector:. The receiver will remove the inspector from its list.
@param A new iTMInspector's instances.
*/
- (void) endEditingWithInspector: (id <iTMInspector>) argument;

/*! 
@method synchronizeEditorWithModel
@abstract Synchronize the editor with the model.
@discussion This is used the first time the model is being edited, or when the editor is asked to revert to its initial state.
*/
- (void) synchronizeEditorWithModel;

/*! 
@method synchronizeModelWithEditor
@abstract Synchronize the model with the editor.
@discussion This is used when the user validates or records the changes made on the editor.
*/
- (void) synchronizeModelWithEditor;

/*! 
@method synchronizeEditorWithInspectors
@abstract Synchronize the editor with the inspectors' contents.
@discussion When the outlets of the view are not direct, some active introspection might be needed (for NSTextView's as opposit to NSTextField's)
*/
- (void) synchronizeEditorWithInspectors;

/*! 
@method synchronizeModelWithEditor
@abstract Synchronize the inspectors with the editor.
@discussion This is used to update the user interface to the contents of the editor. This should be used each time one inspector has changed the underlying editor.
*/
- (void) synchronizeInspectorsWithEditor;

/*!
@method writeToFile:originalFile:saveOperation:
@abstract Description Forthcoming.
@discussion Delegates the job to the model of the receiver.
@param fileName is the path where data should be saved
@param fullOriginalDocumentPath is the path where data is actually saved (CVS support)
@param saveOperationType is the kind of save operation to perform
@result YES if the save was successful, NO otherwise
*/
- (BOOL) writeToFile: (NSString *) fileName originalFile: (NSString *) fullOriginalDocumentPath saveOperation: (NSSaveOperationType) saveOperationType;

/*!
@method loadModelFromFile:
@abstract Description Forthcoming.
@discussion If the model of the receiver knows about a setFileName: method, it is used, then the receiver tries to loadModel.
@param fileName is the path where data should be loaded
@result YES if the laod was successful, NO otherwise
*/
- (BOOL) readFromFile: (NSString *) fileName;

/*! 
@method isEditing
@abstract Whether the receiver is editing.
@discussion Description Forthcoming.
@result YORN.
*/
- (BOOL) isEditing;

/*! 
@method setEditing:
@abstract Sets the editing status of the receiver.
@discussion Description Forthcoming.
@param YORN.
*/
- (void) setEditing: (BOOL) flag;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMController

/*! 
@define iTMItemPropertyListXMLFormatKey
@abstract Key.
@discussion This is the key used to store default value for the property list XML format used in deserialization.
*/
extern NSString * const iTMItemPropertyListXMLFormatKey;

@interface iTMModel: NSObject <iTMIdentity, iTMControlled>
{
@private
    id _DataModel;
    id _Controller;
    id _Identifier;
    id _Key;
    NSPropertyListFormat _PLXMLFormat;
}

/*! 
@method inspectorClass
@abstract Default inspector class.
@discussion Used in a lazy initialization to create a default inspector class to edit the receiver.
@result An inspector class, a subclass of iTMInspector.
*/
+ (Class) inspectorClass;

/*! 
@method initWithDataModel:
@abstract Designated initializer.
@discussion Also sets the default Property List serialization Format and the model.
@param the model argument can be nil to set to default values.
@result As usual.
*/
- (id) initWithDataModel: (id) dataModel;

/*! 
@method synchronizedWith:
@abstract Synchronize with another object.
@discussion This method is used by the controller to synchronize its model and its editor, in both directions.
The default implementation just returns the receiver unchanged. Be careful if one of the subclassers returns the argument. This must be overriden by subclassers to perform interesting stuff.
@param An iTMModel instance.
@param A synchronized iTMModel instance.
*/
- (id) synchronizedWith: (id) argument;

/*! 
@method compare:
@abstract Designated comparator.
@discussion The default implementation returns NSOrderedSame.
@param Description Forthcoming.
@result Description Forthcoming.
*/
- (NSComparisonResult) compare: (iTMModel *) rhs;

/*! 
@method PLXMLFormat
@abstract Returns the property list XML format to be used when deserializing the data into a model object.
@discussion Description Forthcoming.
@result NSPropertyListFormat: the format.
*/
- (NSPropertyListFormat) PLXMLFormat;

/*! 
@method setPLXMLFormat:
@abstract Sets the property list XML format.
@discussion Description Forthcoming.
@param NSPropertyListFormat argument: new format.
*/
- (void) setPLXMLFormat: (NSPropertyListFormat) argument;

/*! 
@method lazyIdentifier 
@abstract The lazy value of the object identifying the object.
@discussion Description forthcoming.
@result an object.
*/
- (id) lazyIdentifier;

/*! 
@method dataModel 
@abstract Access to the data model instance variable. 
@discussion Description Forthcoming. Partial lazy initializer through -synchronizeModelWithIdentifier.
@result An object, basically a property list Foundation object.
*/
- (id) dataModel;

/*! 
@method setDataModel: 
@abstract Lowest setter. 
@discussion This is only used in -dealloc and -replaceModel:. It should be considered private.
It is the responsibility of the client to give a consistent data model (regarding the mutability for example)
@param argument is the new data model.
*/
- (void) setDataModel: (id) argument;

/*! 
@method replaceModel: 
@abstract The real method to change the data model preserving the overall consistency of the data hierarchy and wrapper. 
@discussion High level setter. This method is allowed to change the key state and will certainly do it.
A -dataModelDidChange: message is posted.
@param argument is the new data model.
@result id the data model really replaced, just in case it id a copy of the argument...
*/
- (id) replaceDataModel: (id) argument;

/*! 
@method dataModelWithDataModel: 
@abstract Ensures data model consistencey. 
@discussion Before replacing the data model, the receiver is given a chance to check if the new data model is consistent. Subclassers will override this method to modify the argument to fit their needs. It is possible that data models come from files that have been changed somewhere else and do not contain what they really should, this  method allows corrections and initialization too. Subclassers will append their treatment.
The default implementation just returns the argument.
@param argument is the new data model.
@result id the consistent data model...
*/
- (id) dataModelWithDataModel: (id) argument;

/*!
@method dataModelDidChange 
@abstract Message sent when the data model did change. 
@discussion This message is intended for subclassers, it is sent by the -replaceModel: and synchronizeModelWithKeyState when there is really a change.
Default implementation does nothing. Subclassers will prepend or append their own treatment.
*/
- (void) dataModelDidChange;

/*! 
@method addItemInTabView:
@abstract Adds a new item in tab view.
@discussion Convenience method...
@param argument is the tab view where we should add an item.
*/
- (NSTabViewItem *) addItemInTabView: (NSTabView *) tabView;

/*!
@method prepareToSave
@abstract Prepares the receiver to save.
@discussion Description Forthcoming.
@result YES if the save was successful, NO otherwise
*/
- (void) prepareToSave;

/*!
@method dataRepresentation
@abstract The data representation.
@discussion Description Forthcoming.
@result YES if the save was successful, NO otherwise
*/
- (NSData *) dataRepresentation;

/*!
@method loadDataRepresentation:
@abstract Description Forthcoming.
@discussion If the model loader of the receiver knows about a setFileName: method, it is used, then the receiver tries to loadModel.
@param data is the data to be loaded.
@result YES if the laod was successful, NO otherwise.
*/
- (BOOL) loadDataRepresentation: (NSData *) data;

/*!
@method writeToFile:originalFile:saveOperation:
@abstract Writes the model to the file.
@discussion Description Forthcoming.
@param fileName is the path where data should be saved
@param fullOriginalDocumentPath is the path where data is actually saved (CVS support)
@param saveOperationType is the kind of save operation to perform
@result YES if the save was successful, NO otherwise
*/
- (BOOL) writeToFile: (NSString *) fileName originalFile: (NSString *) fullOriginalDocumentPath saveOperation: (NSSaveOperationType) saveOperationType;

/*!
@method readFromFile:
@abstract Reads the model from the file.
@discussion Description Forthcoming. Concrete implementation won't need do do anything here.
@param fileName is the path where data should be loaded
@result YES if the laod was successful, NO otherwise
*/
- (BOOL) readFromFile: (NSString *) fileName;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMController


@interface iTMInspector: NSObject <iTMInspector>
{
@private
    IBOutlet NSTabViewItem * _TabViewItem;
    id _Controller;
    BOOL _OwnsTabViewItem;
}

/*! 
@method tabViewItem
@abstract The owning tabViewItem.
@discussion In general, yhe tabViewItem is owned by the tabView, and owns the receiver itself. If the receiver is really the owner of its tabViewItem, there is an internal flag set to YES.
@result An iTMController instance.
*/
- (NSTabViewItem *) tabViewItem;

/*! 
@method setTabViewItem:
@abstract The lowest level setter of the tabViewItem.
@discussion Description Forthcoming.
@param An NSTabViewItem instance.
*/
- (void) setTabViewItem: (NSTabViewItem *) argument;

/*! 
@method loadOutlets
@abstract Loads the window and outlets.
@discussion Description Forthcoming.
*/
- (void) loadOutlets;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMInspector

@interface NSTabViewItem(iTMInspector)
- (void) setTabState: (NSTabState) newState;
- (void) inspectorReplaceController: (iTMController *) newEditor;
@end

