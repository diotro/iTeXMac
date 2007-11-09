# this is iTM2_Engine_MPOST for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a MetaPost 0.641 (Web2C 7.5.3) wrapper

class MPOSTWrapper < EngineWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_MP_'
	end
	
	options
		opts = ""
		opts << "-ini " if _ini.yes?
		opts << "-progname #{_progname} " if _USE_progname.yes? and _progname.length?
		opts << "-jobname #{_jobname} " if _USE_jobname.yes? and _jobname.length?
		opts << "-output-directory \"#{_output_directory}\"" if _USE_output_directory.yes? and _output_directory.length?
		if _parse_first_line.yes?
			opts << "-parse-first-line "
			if _USE_translate_file.yes? and _translate_file.length?
				if _PARSE_translate_file.yes?
					opts << "-default-translate-file "
				else
					opts << "-translate-file "
				end
				opts << "\ "#{_translate_file}\""
			end
		else
			if _fmt.length?
					iTM2_MP_Format_Argument="&#{_fmt}"
			end
			if _USE_translate_file.yes? and _translate_file.length?
					opts << "-translate-file \ "#{_translate_file}\""
			end
		end
		opts << "-recorder " if _recorder.yes?
		opts << "-file-line-error " if _file_line_error.yes?
		opts << "-halt-on-error " if _halt_on_error.yes?
		opts << "-interaction #{_interaction} " if _interaction.length?
		opts << _MoreArgument if _USE_MoreArgument.yes? and _MoreArgument.length?
		if !_TeX_parse_first_line.yes?
			if _TeX_format.length?
				opts << "-tex=#{_TeX_format} "
			else if project.base # no information available, guessing?
				echo "$iTM2_project_mode"|grep -i -q ".*latex.*"
				if project.base.name.to_s =~ /latex/i
					opts << "-tex=latex "
				else
					opts << "-tex=tex "
				end
			end
		end
		opts << _Format_Argument if _Format_Argument.length?
	end

	def engine_shortcut
						command = "mpost #{options}\"#{project.master_name}\""
						engine_shortcut = <<EOF
$command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{$command}")
if ! system($command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
else
EOF
						if _convert_to_pdf('1').yes?
							if _pdf_converter == "1"
						engine_shortcut << <<EOF
	Dir.foreach("."){|f|
		if f =~ /^#{Regexp.escape(project.job_name.to_s)}\.\d*$/
			$command = "mptopdf \"\#{f}\"".gsub(/"/,'\"')
			notify("comment","Performing \#{$command}")
			if ! system($command)
				notify("error","#{$me} FAILED(#{$?}).")
			end
		end
	}
EOF
							elsif _pdf_converter == "2"
						engine_shortcut << <<EOF
	Dir.foreach("."){|f|
		
		if f =~ /^#{Regexp.escape(project.job_name.to_s)}\.(\d*)$/
			$command = "epstopdf -outfile=\"#{project.job_name.to_s}-$1.pdf\" \"\#{f}\""
			notify("comment","Performing \#{$command}")
			if ! system($command)
				notify("error","#{$me} FAILED(#{$?}).")
			end
		end
	}
EOF
							else
						engine_shortcut << <<EOF
	Dir.foreach("."){|f|
		if f =~ /#{Regexp.escape(project.job_name.to_s)}\.\d*$/
			$command = "epstopdf -outfile=\"#{project.job_name.to_s}-$1.pdf\" \"\#{f}\""
			notify("comment","Performing \#{$command}")
			if !system("#{$0}",'-p',$project,'-e','iTM2_Engine_MPS2PDF','-m',"#{f}")
				notify("error","#{$me} FAILED(#{$?}).")
			else
				g = "#{project.job_name.to_s}-$1.pdf"
				FileUtils.rm_f(g) if FileTest.symlink?(g) or FileTest.exist?(g)
				File.rename(f,g)
			end
		end
	}
EOF
							end
						end
						# There should be a better policy "update" vs "touch"
						# the caller should have a mean to specify whether the current tool is building an untermediate file or just a final file.
						engine_shortcut << <<EOF
	system("iTeXMac2","update","-file",$master,"-project",$project)
end
EOF
						engine_shortcut
	end
end
$launcher.engine_wrapper = MPOSTWrapper.new
