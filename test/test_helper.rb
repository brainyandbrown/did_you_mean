NAME_ERROR = (___ rescue $!).class

require 'minitest/autorun'
require 'minitest/unit'
require 'did_you_mean'

begin
  MiniTest::Test
rescue NameError
  MiniTest::Test = MiniTest::Unit::TestCase
end

require 'did_you_mean/test_helper'
MiniTest::Test.send :include, DidYouMean::TestHelper

begin
  require 'active_record'

  # database
  ActiveRecord::Base.configurations = {'test' => {adapter: 'sqlite3', database: ':memory:'}}
  ActiveRecord::Base.establish_connection(:test)

  # models
  class User < ActiveRecord::Base; end

  class CreateAllTables < ActiveRecord::Migration
    def self.up
      create_table(:users) {|t| t.string :first_name }
    end
  end
  ActiveRecord::Migration.verbose = false
  CreateAllTables.up
rescue LoadError
end

begin
  require 'better_errors'
  require 'did_you_mean/better_errors'
rescue LoadError
end

require 'pry'
require_relative 'helpers/repl_tester'
