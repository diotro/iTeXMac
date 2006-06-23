/*
//  TBR Tutorial
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Jun 27 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSView_iTeXMac2

@interface NSView(iTeXMac2)
/*"Class methods"*/
+(int)grabKeyMask;
+(int)zoomInKeyMask;
+(int)zoomOutKeyMask;
/*"Setters and Getters"*/
-(NSPoint)frameCenter;
-(void)setFrameCenter:(NSPoint)aCenter;
-(NSPoint)boundsCenter;
-(void)setBoundsCenter:(NSPoint)aCenter;
-(float)visibleArea;
-(NSComparisonResult)compareArea:(NSView *)otherView;
/*"Main methods"*/
-(NSPoint)absolutePointWithPoint:(NSPoint)aPoint;
-(NSPoint)pointWithAbsolutePoint:(NSPoint)aRelativePoint;
-(NSSize)absoluteSizeWithSize:(NSSize)aSize;
-(NSSize)sizeWithAbsoluteSize:(NSSize)aSize;
-(NSRect)absoluteRectWithRect:(NSRect)aRect;
-(NSRect)rectWithAbsoluteRect:(NSRect)aRect;
-(void)centerBoundsOrigin;
-(void)centerInSuperview;
-(void)removeSubviewsWithoutNeedingDisplay;
-(NSPoint)absoluteFocus;
-(NSControl *)controlWithAction:(SEL)action;
/*"Overriden methods"*/
@end

@interface NSView(iTeXMac2Scrolling)
-(void)scrollPageLeft:(id)sender;
-(void)scrollPageRight:(id)sender;
-(void)scrollCharacterLeft:(id)sender;
-(void)scrollCharacterRight:(id)sender;
-(void)scrollLineUp:(id)sender;
-(void)scrollLineDown:(id)sender;
-(void)scrollPageUp:(id)sender;
-(void)scrollPageDown:(id)sender;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2View

@interface iTM2View: NSView
{
@private
    id _Implementation;
}
/*!
    @method		implementation
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		an iTM2Implementation object.
*/
-(id)implementation;

/*!
    @method		setImplementation:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		None.
*/
-(void)setImplementation:(id)argument;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CenteringView

@interface iTM2CenteringView: NSView
{
@private
    id _Subview;
    id _Implementation;
}
/*"Class methods"*/
/*"Setters and Getters"*/
-(id)centeredSubview;
-(void)setCenteredSubview:(NSView *)argument;
-(void)willChangeCenteredSubview;
-(void)didChangeCenteredSubview;
-(void)centerSubview;
-(NSSize)minFrameSize;
-(float)horizontalMargin;
-(float)verticalMargin;
/*"Main methods"*/
/*"Overriden methods"*/
@end

@interface iTM2FlagsChangedView: NSView
{
@private
    id _SubFrames;
    int _IndexFromTag[16];
    int _VisibleSubviewIndex;
    
}
-(void)computeIndexFromTag;
-(BOOL)acceptsFirstResponder;
-(void)updateWithFlags:(unsigned int)flags;
-(int)tagFromMask:(int)aMask;
-(void)moveAwaySubviewAtIndex:(int)index;
-(void)moveCloserSubviewAtIndex:(int)index;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CenteringView

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Geometry

NSPoint iTM2PointConvertedToIntrinsic(NSPoint point, NSRect rect);
NSPoint iTM2PointConvertedToGlobal(NSPoint point, NSRect rect);
NSRect iTM2CenterRect(NSRect rect, NSPoint point);

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Geometry

@interface NSView(iTM2SplitKit)

/*!
    @method		enclosingSplitView
    @abstract	The enclosing split view, exluding the receiver.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		an NSSplitView.
*/
-(NSSplitView *)enclosingSplitView;

@end

@interface NSWindowController(iTM2AutoSplitKit)

/*!
    @method		splittableEnclosingViewForView:vertical:
    @abstract	The splittable view for the given direction.
    @discussion	The default implementation returns nothing. Subclassers will override this.
				Subclassers will return a view that can be split.
				There is no automatic management because splitrting means duplication and there is no automatic duplication process.
    @param		view can be nil.
    @param		yorn.
    @result		a view.
*/
-(NSView *)splittableEnclosingViewForView:(NSView *)view vertical:(BOOL)yorn;

/*!
    @method		unsplittableEnclosingViewForView:
    @abstract	The unsplittable view.
    @discussion	The default implementation returns nothing. Subclassers will override this.
				Subclassers will return a view that can be split.
				There is no automatic management because splitrting means duplication and there is no automatic duplication process.
    @param		view can be nil.
    @result		a unsplittableViewEnclosingViewForView:.
*/
-(NSView *)unsplittableEnclosingViewForView:(NSView *)view;

/*!
    @method		duplicateViewForSplitting:vertical:
    @abstract	Duplicates the given view.
    @discussion	This view is expected to be inserted in the split view. The default implementation returns nothing.
				Subclassers will do the job.
    @param		view to be splitted.
    @param		vertical indicates the direction (of the resizing control).
				When this view is added to the split view, a -didAddSplittingView: message should be sent.
    @result		a duplicated view.
*/
-(NSView *)duplicateViewForSplitting:(NSView *)view vertical:(BOOL)vertical;

/*!
    @method		split:vertical:createSplitView:
    @abstract	Split the given view.
    @discussion	Discussion forthcoming.
    @param		view to be splitted.
    @param		vertical indicates the direction of the knob.
    @param		create indicates whether an already existing enclosing split view should be used or a new one should be used iinstead.
    @result		None.
*/
-(void)split:(NSView *)view vertical:(BOOL)vertical createSplitView:(BOOL)create;

/*!
    @method		didAddSplittingView:
    @abstract	The given view has just been added to the split view.
    @discussion	The receiver will take any action to make things consistent.
				The default implementation ensures that the view is properly set up
				and subclassers will append or prepend their own actions.
    @param		view was added to the split view...
    @result		None.
*/
-(void)didAddSplittingView:(NSView *)view;

/*!
    @method		didRemoveSplittingView:
    @abstract	The given view has just been removed from the split view.
    @discussion	The receiver will take any action to make things consistent.
				The default implementation does nothing yet but subclassers will append or prepend their own actions.
    @param		view was removed from the split view...
    @result		None.
*/
-(void)didRemoveSplittingView:(NSView *)view;

/*!
    @method		unsplit:
    @abstract	Unsplit the given view.
    @discussion	If there are only 2 view in the split view, it will be removed from the view hierarchy and replaced by the remaining view.
    @param		view is the view to be removed.
    @result		None.
*/
-(void)unsplit:(NSView *)view;

@end

typedef enum
{
	iTM2ScrollerToolbarPositionTop = 0,
	iTM2ScrollerToolbarPositionBottom = 1,
	iTM2ScrollerToolbarPositionLeft = 2,
	iTM2ScrollerToolbarPositionRight = 3
} iTM2ScrollerToolbarPosition;

/*!
	@class			iTM2ScrollerToolbar
	@abstract		Small scroller toolbars.
	@discussion		If a scroll view has such subviews, it will adjust the scrollers to display those views.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/

@interface iTM2ScrollerToolbar: NSView//iTM2View
{
unsigned int _Position;
}
/*!
    @method		scrollerToolbarForPosition
    @abstract	A small toolbar view.
    @discussion	A small toolbar view to be inserted on the left of an horizontal scroller view.
    @param		position is the expected.
    @result		A view.
*/
+(id)scrollerToolbarForPosition:(iTM2ScrollerToolbarPosition)position;

/*!
    @method		position
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A position.
*/
-(iTM2ScrollerToolbarPosition)position;

@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2SplitKit
