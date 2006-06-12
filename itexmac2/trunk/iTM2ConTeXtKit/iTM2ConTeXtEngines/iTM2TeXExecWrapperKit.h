/*
//  iTM2TeXPEngineWrapperKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

/*!
    @class      iTM2EngineTeXExec
    @abstract   Engine inspectors
    @discussion If you write your own engine inspector by subclassing iTM2TeXPEngineInspector, you must make it +initialized unless it won't be registered and used.
				Built in engine inspectors are +initialized in the iTM2TeXPEngineInspector +load method.
				For inspectors not in the same framework, you just have to [ class]  them in their +load method.
*/

@interface iTM2EngineTeXExec: iTM2TeXPEngineInspector
@end

/*!
    @class      iTM2PDFArrangeInspector
    @abstract   texexec --pdfarrange inspector
    @discussion Discussion forthcoming.
*/

@interface iTM2PDFArrangeInspector: iTM2TeXPEngineInspector
@end

/*!
    @class      iTM2PDFCombineInspector
    @abstract   texexec --pdfcombine inspector
    @discussion Discussion forthcoming.
*/

@interface iTM2PDFCombineInspector: iTM2TeXPEngineInspector
@end

/*!
    @class      iTM2PDFCopyInspector
    @abstract   texexec --pdfcopy inspector
    @discussion Discussion forthcoming.
*/

@interface iTM2PDFCopyInspector: iTM2TeXPEngineInspector
@end

/*!
    @class      iTM2PDFSelectInspector
    @abstract   texexec --pdfselect inspector
    @discussion Discussion forthcoming.
*/

@interface iTM2PDFSelectInspector: iTM2TeXPEngineInspector
@end

@interface iTM2ConTeXtResultFormatter: iTM2StringFormatter
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXExecWrapperKit
