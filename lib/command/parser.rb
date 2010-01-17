#--
# Copyright 2010 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module Command
  class Parser
    Token = Struct.new(:type, :value)

    attr_reader :command
    attr_reader :options
    attr_reader :argv

    def initialize(definition, argv)
      @definition = definition
      @argv       = argv
      @affix      = [] # arguments after '--'
      if i = argv.index('--')
        @affix     = argv[(i+1)..-1]
        @arguments = argv.first(i)
      else
        @arguments = @argv.dup
      end
    end

    def argument(name)
      position = @definition.argument_position[name]
      raise ArgumentError, "No argument #{name.inspect} available" unless position
      arguments[position]
    end

    def option(name)
      @options[name]
    end

    def arguments
      @arguments+@affix
    end

    def parse(*flags)
      ignore_invalid_options = flags.delete(:ignore_invalid_options)
      @affix      = []
      @parse_argv = @arguments
      @arguments  = []
      @options    = {}

      if @definition.commands_by_name.include?(@parse_argv.first)
        @command = @parse_argv.shift
      else
        @command = @definition.default_command
      end
      options  = (@command ? @definition[@command] : @definition).options_by_flag # options available to this command

      while arg = @parse_argv.shift
        if option = options[arg] then
          case option.necessity
            when :required
              value = option.process!(@parse_argv.shift)
            when :optional
              if @parse_argv.first && @parse_argv.first !~ /\A-/ then
                value = option.process!(@parse_argv.shift)
              else
                value = true
              end
            when :none
              value = true
          end
          @options[option.name] = (arg == option.negated) ? !value : value
        elsif arg =~ /\A-/ then
          raise "Invalid option #{arg}" unless ignore_invalid_options
          @arguments << arg
        else
          @arguments << arg
        end
      end

      @result = Result.new(@command, @options, arguments+@affix)
    end
  end
end
