module Travis
  module Build
    class Script
      class Python < Script
        DEFAULTS = {
          python: '2.7',
          virtualenv: { system_site_packages: false }
        }

        NO_REQUIREMENTS = 'Could not locate requirements.txt. Override the install: key in your .travis.yml to install dependencies.'
        NO_SCRIPT       = 'Please override the script: key in your .travis.yml to run tests.'

        def export
          super
          set 'TRAVIS_PYTHON_VERSION', config[:python], echo: false
        end

        def setup
          super
          cmd "source #{virtualenv_activate}"
        end

        def announce
          cmd 'python --version'
          cmd 'pip --version'
        end

        def install
          sh_if   '-f Requirements.txt', "pip install -r Requirements.txt --use-mirrors"
          sh_elif '-f requirements.txt', "pip install -r requirements.txt --use-mirrors"
          sh_else { echo NO_REQUIREMENTS }
        end

        def script
          # This always fails the build, asking the user to provide a custom :script.
          # The Python ecosystem has no good default build command most of the
          # community aggrees on. Per discussion with jezjez, josh-k and others. MK
          failure NO_SCRIPT
        end

        private

          def virtualenv_activate
            "~/virtualenv/#{python_version}#{system_site_packages}/bin/activate"
          end
          
          def python_version
            config[:python] =~ /pypy/i ? "pypy" : "python#{config[:python]}"
          end
          
          def system_site_packages
            if config[:virtualenv][:system_site_packages]
              "_with_system_site_packages"
            end
          end
      end
    end
  end
end

