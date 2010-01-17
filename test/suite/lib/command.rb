#--
# Copyright 2010 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



BareTest.suite "Command", :requires => 'command' do
  suite "Units" do
    suite "Command" do
      suite "Definition" do
        suite "Class methods" do
          suite "::create_option" do
            suite "name, short" do
              setup do
                @name   = :short_name
                @short  = "-s"
                @option = Command::Definition.create_option(@name, @short)
              end
              assert "name is set" do
                equal(@name, @option.name)
              end
              assert "short is set" do
                equal(@short, @option.short)
              end
            end

            suite "name, long" do
              setup do
                @name   = :long_name
                @long  = "--long-opt"
                @option = Command::Definition.create_option(@name, @long)
              end
              assert "name is set" do
                equal(@name, @option.name)
              end
              assert "long is set" do
                equal(@long, @option.long)
              end
            end
          end
        end
      end
    end
  end

  suite "Integration" do
    suite "parse one argument" do
      setup :argument, {
        "<none>"           => [[],nil],
        "run"              => [%w[run],"run"],
        "init"             => [%w[init],"init"],
        "run (with flags)" => [%w[run --help],"run"],
      } do |data|
        argv, @expected = *data 
        @desc = Command::Definition.new do
          argument :first, "FIRST"
        end
        @parser = Command::Parser.new(@desc, argv)
        @parser.parse :ignore_invalid_options
      end

      assert "parses arguments (argv: :argument)" do
        equal(@expected, @parser.argument(:first))
      end
    end

    suite "parse many arguments" do
      setup do |data|
        @first  = "firstarg"
        @second = "secondarg"
        @third  = "thirdarg"
        @desc   = Command::Definition.new do
          argument :first, "FIRST"
          argument :second, "SECOND"
          argument :third, "THIRD"
        end
        @parser = Command::Parser.new(@desc, [@first, @second, @third])
        @parser.parse :ignore_invalid_options
      end

      assert "first argument is the first supplied" do
        equal(@first, @parser.argument(:first))
      end
      assert "second argument is the second supplied" do
        equal(@second, @parser.argument(:second))
      end
      assert "third argument is the third supplied" do
        equal(@third, @parser.argument(:third))
      end
    end

    suite "parse commands" do
      setup :command, {
        "valid1"      => [%w[valid1],      "valid1"],
        "valid2"      => [%w[valid2],      "valid2"],
        "valid3"      => [%w[valid3],      "valid3"],
        "notacommand" => [%w[notacommand], nil],
      } do |data|
        argv, @expected = *data 
        @desc = Command::Definition.new do
          command "valid1"
          command "valid2"
          command "valid3"
        end
        @parser = Command::Parser.new(@desc, argv)
        @parser.parse :ignore_invalid_options
      end

      assert "parses argv: :command)" do
        equal(@expected, @parser.command)
      end
    end

    suite "parse short options" do
      setup :options, {
        "-a"       => [%w[-a],       :a, true],
        "-b"       => [%w[-b],       :b, true],
        "-b hello" => [%w[-b hello], :b, "hello"],
        "-c hello" => [%w[-c hello], :c, "hello"],
      } do |data|
        argv, @option, @expected = *data 
        @desc = Command::Definition.new do
          o :a, '-a'
          o :b, '-b [OPTIONAL_ARG]'
          o :c, '-c REQUIRED_ARG'
        end
        @parser = Command::Parser.new(@desc, argv)
        @parser.parse
      end

      assert "parses options in argv: :options" do
        equal(@expected, @parser.option(@option))
      end
    end

    suite "parse long options" do
    end

    suite "parse env" do
    end

    suite "parse mixed" do
    end

    suite "complex command" do
      
    end
  end
end
