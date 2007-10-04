# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

require 'iTM2_Engine_dvipdfm'

class DVIPDFmxWrapper<DVIPDFmWrapper
	
	def key_prefix
		#subclassers will override this
		'iTM2_Dvipdfmx_'
	end
	
	def engine
		#subclassers will override this
		'dvipdfmx'
	end
	
	def command_arguments
		args = super.command_arguments
		args << "-d #{decimal_digits} " if decimal_digits.length?
		args << "-C #{option_flags} " if permission_flags.length?
		args << "-P #{permission_flags} " if permission_flags.length?
		args << "-O #{open_bookmark_depth} " if open_bookmark_depth.length?
		args << "-S " if enable_encryption.yes?
		args << "-T " if include_thumbnails.yes?
		args << "-V #{minor_version} " if minor_version.yes?
		args << "-M " if mps_to_pdf.yes?
	end
	
end
$launcher.engine_wrapper = DVIPDFmxWrapper.new
