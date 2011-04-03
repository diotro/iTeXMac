# this is iTM2_Engine_MPtoPDF for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a MPtoPDF 1.3 wrapper

class MPtoPDFWrapper < EngineWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_MPtoPDF_'
	end

	def options
		opts = ""
		opts << "--latex " if _is_latex.yes?
		opts << "--rawmp " if _is_raw_metapost.yes?
		opts << "--metafun " if _with_metafun.yes?
	end

	def engine_shortcut
						command = "mptopdf #{options} \"#{project.master_name}\""
						pdfout = project.master_name.to_s.sub(/\.(\d+)$/,"-\1.pdf")
						pdfout = pdfout.sub(/\.[^\.]*$/,".pdf")
						# opening the script file:
						engine_shortcut = <<EOF
$pdfout = "#{pdfout}"
$command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{$command}")
if system($command)
	system("iTeXMac2","touch","-file",$pdfout,"-project",$project)
else
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
end
EOF
						engine_shortcut
	end

end
$launcher.engine_wrapper = MPtoPDFWrapper.new
