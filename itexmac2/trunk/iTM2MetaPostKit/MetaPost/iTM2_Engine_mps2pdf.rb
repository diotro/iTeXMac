# this is iTM2_Engine_MPS2PDF.rb for iTeXMac2
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a MPS2PDF based on mps2eps, instable
class MPS2PDFWrapper < EngineWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_MPS2PDF_'
	end

	def engine_shortcut
						pdftex_opts = (_USE_tex_options.yes? and _tex_options.length?)?(_tex_options):(' ')
						tex_file = project.job_name.basename.to_s+'_mps2pdf.tex'
						tex_file_contents = <<EOF
\nopagenumbers
\input epsf
\centerline{\epsfbox{"#{project.job_name.basename.to_s}"}}
\end
EOF
						file = File.new("#{tex_file}","w")
						file.puts(tex_file_contents)
						file.close
						dvi_file = project.job_name.basename.to_s+'_mps2pdf.dvi'
						pdftex_command = "pdftex #{pdftex_opts} -out_format dvi -interaction batchmode \"#{tex_file}\""
						eps_file  = project.job_name.basename.to_s+'_mps2pdf.eps'
						dvips_opts = (_USE_dvips_options.yes? and _dvips_options.length?)?(_dvips_options):(' ')
						dvips_command = "dvips \"#{eps_file}\" -E -j -o \"#{dvi_file}\""
						epstopdf_command = "epstopdf \"#{eps_file}\""
						engine_shortcut = <<EOF
Dir.chdir("#{project.job_name.dirname.to_s}")
$command = "#{pdftex_command.gsub(/"/,'\"')}"
notify("comment","Performing \#{$command}")
if !system($command) or ! Kernel.test(?s,"#{dvi_file}")
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
else
	$command = "#{dvips_command.gsub(/"/,'\"')}"
	notify("comment","Performing \#{$command}")
	if !system($command) or ! Kernel.test(?s,"#{eps_file}")
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	else
		$command = "#{epstopdf_command.gsub(/"/,'\"')}"
		notify("comment","Performing \#{$command}")
		if !system($command) or ! Kernel.test(?s,"#{eps_file}")
			notify("error","#{$me} FAILED(#{$?}).")
			exit $?
		end
	end
end
Dir.chdir($pwd)
EOF
						engine_shortcut
	end

end
$launcher.engine_wrapper = MPS2PDFWrapper.new
