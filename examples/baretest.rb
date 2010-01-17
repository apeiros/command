lib_dir = File.expand_path("#{__FILE__}/../../lib")
$LOAD_PATH.unshift lib_dir if File.directory?(lib_dir)

require 'command'



# Specify commands and options
Command "run" do
  # global arguments
  argument :command, '[command]', :Virtual, "The command to run. See `baretest commands`"
  argument :options, '[options]', :Virtual, "The flags and options, see in the \"Options\" section."

  # global options
  o :commands,    nil,  '--commands', :Boolean, "overview over the commands"
  o :help,        '-h', '--help',     :Boolean, "help for usage and flags"
  o :version,     '-v', '--version',  :Boolean, "print the version and exit"

  # specify the 'run' command, its default options, its options and helptext
  command "run", :format => 'cli', :interactive => false, :verbose => false do
    usage

    argument :command
    argument :options
    argument '*glob', File, "The testfiles to run.\n" \
                            "Defaults to 'test/{suite,unit,integration,system}/**/*.rb'\n" \
                            "Providing a directory is equivalent to dir/**/*.rb"

    text "\nDefault command is 'run', which runs the testsuite or the provided testfiles.\n\nOptions:\n"

    o :commands
    o :debug,       '-d', '--debug',         :Boolean, "set debugging flags (set $DEBUG to true)"
    o :interactive, '-i', '--interactive',   :Boolean, "drop into IRB on error or failure"
    o :format,      '-f', '--format FORMAT', :String,  "use FORMAT for output, see `baretest formats`"
    o :setup_file,  '-s', '--setup FILE',    :File,    "specify setup file"
    o :verbose,     '-w', '--warn',          :Boolean, "turn warnings on for your script"
    o :help
    o :version

    text ""

    placeholder :format_options

    text "\nEnvironment variables:\n"

    env_option :format,      'FORMAT'
    env_option :verbose,     'VERBOSE'
    env_option :interactive, 'INTERACTIVE'
  end

  command "init" do
    text '  Create the necessary directories and files'
    o :help
  end

  command "formats"
  command "env"
  command "version"
  command "commands"
  command "help"
end
