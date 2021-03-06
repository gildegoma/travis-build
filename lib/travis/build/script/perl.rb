module Travis
  module Build
    class Script
      class Perl < Script
        DEFAULTS = {
          perl: '5.14'
        }

        def export
          super
          set 'TRAVIS_PERL_VERSION', perl_version, echo: false
        end

        def setup
          super
          cmd "perlbrew use #{perl_version}"
        end

        def announce
          super
          cmd 'perl --version'
          cmd 'cpanm --version'
        end

        def install
          cmd 'cpanm --quiet --installdeps --notest .'
        end

        def script
          sh_if   '-f Build.PL',    'perl Build.PL && ./Build test'
          sh_elif '-f Makefile.PL', 'perl Makefile.PL && make test'
          sh_else                   'make test'
        end

        def perl_version
          # this check is needed because safe_yaml parses the string 5.10 to 5.1
          config[:perl] == 5.1 ? "5.10" : config[:perl]
        end
      end
    end
  end
end
