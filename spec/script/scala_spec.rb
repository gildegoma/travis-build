require 'spec_helper'

describe Travis::Build::Script::Scala do
  let(:options) { { logs: { build: false, state: false } } }
  let(:data)    { PAYLOADS[:push].deep_clone }

  subject { described_class.new(data, options).compile }

  after :all do
    store_example
  end

  it_behaves_like 'a build script'
  # it_behaves_like 'a jdk build'

  it 'sets TRAVIS_SCALA_VERSION' do
    should set 'TRAVIS_SCALA_VERSION', '2.10.0'
  end

  it 'announces Scala 2.10.0' do
    should run 'echo Using Scala 2.10.0'
  end

  it 'runs sbt ++2.10.0 test if ./project directory exists' do
    directory('project')
    should run_script 'sbt ++2.10.0 test'
  end

  it 'runs sbt ++2.10.0 test if ./build.sbt exists' do
    file('build.sbt')
    should run_script 'sbt ++2.10.0 test'
  end

  it 'runs gradle check if ./build.gradle exists' do
    file('build.gradle')
    should run_script 'gradle check'
  end

  it 'runs mvn test if no project directory or build file exists' do
    should run_script 'mvn test'
  end
end
