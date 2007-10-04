# this is pstopdf wrapper
# © 2006 jlaurens AT users DOT sourceforge DOT net

require 'iTM2_Engine_Dvipdfm'

class PSTOPDFWrapper < DVIPDFmWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_pstopdf_'
	end

	def engine
		'pstopdf'
	end

	def extension
		'e?ps'
	end

	def command_arguments
		args = " "
		args << "-l " if write_to_log.yes?
		args << "-p " if progress_message.yes?
		if use_output.yes? and output.length?
		then
			@pdfout = output
			args << "-o \"@pdfout\" "
		fi
	end

end
$launcher.engine_wrapper = PSTOPDFWrapper.new
