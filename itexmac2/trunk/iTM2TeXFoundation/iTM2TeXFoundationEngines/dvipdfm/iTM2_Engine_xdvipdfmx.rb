# this is iTM2_Engine_xdvipdfmx.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a " xdvipdfmx-0.4 by Jonathan Kew and Jin-Hwan Cho" wrapper

require 'iTM2Engine_dvipdfmx'

class XDVIPDFmxWrapper<DVIPDFmxWrapper
	
	def key_prefix
		#subclassers will override this
		'iTM2_Xdvipdfmx_'
	end
	
	def engine
		#subclassers will override this
		'xdvipdfmx'
	end
	
	def command_arguments
		arguments = super.command_arguments
		arguments << "-E " if ignore_font_license.yes?
	end
	
	def extension
		'xdv'
	end
	
end
$launcher.engine_wrapper = XDVIPDFmxWrapper.new
