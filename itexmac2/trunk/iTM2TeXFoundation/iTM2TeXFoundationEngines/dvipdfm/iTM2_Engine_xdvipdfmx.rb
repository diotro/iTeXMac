# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

require 'iTM2Engine_dvipdfmx'

class XDVIPDFmxWrapper<DVIPDFmxWrapper
	
	def command_arguments
		arguments = super.command_arguments
		arguments << "-E " if ignore_font_license != "0"
	end
	
	def engine
		'xdvipdfm'
	end
	
	def extension
		'xdv'
	end
	
end
$launcher.engine_wrapper = XDVIPDFmxWrapper.new
