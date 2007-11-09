# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb
# unstable
require 'iTM2_Engine_dvipdfm'

class DVIPDFmxWrapper<DVIPDFmWrapper
	
	def key_prefix
		#subclassers will override this
		'iTM2_Dvipdfmx_'
	end
	
	def verb
		'dvipdfmx'
	end

	def options
		opts = super.options
		opts << "-d #{_decimal_digits} " if _decimal_digits.to_i > 0
		opts << "-C #{_option_flags} " if _permission_flags.to_i > 0
		opts << "-P #{_permission_flags} " if _permission_flags.to_i > 0
		opts << "-O #{_open_bookmark_depth} " if _open_bookmark_depth.length?
		opts << "-S " if _enable_encryption.yes?
		opts << "-T " if _include_thumbnails.yes?
		opts << "-V #{_minor_version} " if _minor_version.yes?
		opts << "-M " if _mps_to_pdf.yes?
	end
	
end
$launcher.engine_wrapper = DVIPDFmxWrapper.new
