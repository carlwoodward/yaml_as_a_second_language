require 'rubygems'
require 'spec'
require 'yaml'
require 'active_support'
require 'active_support/hash_with_indifferent_access'

describe 'Yaml as a Second Language' do
  class Renderer
    attr_accessor :yaml, :buffer
    def initialize(yaml)
      self.yaml = yaml
      self.buffer = ''
    end
    # This method is too long
    def render(list=yaml, space_count=0)
      list.each do |nav_item|
        # nav_item is a single element hash
        key, value = nav_item.keys.first, nav_item.values.first
        if value.is_a?(Array)
          self.buffer += "#{' ' * space_count}#{key}\n"
          render value, space_count + 4
        else
          self.buffer += "#{' ' * space_count}#{key} = #{value}\n"
        end
      end
      buffer
    end
  end
  
  describe 'Tree Based Navigation' do
    before :all do
      @yaml = YAML.load_file 'tree_based_navigation.yaml'
      @renderer = Renderer.new @yaml
    end
    
    it 'should have 2 items' do
      @yaml.length.should == 2
    end
    
    it 'should render a funny representation of the tree using recursion' do
      @renderer.render.split("\n").length.should == 7
    end
  end
  
  describe 'No Sql, but with Sql' do
    before :all do
      @yaml = YAML.load_file 'no_sql_but_with_sql.yaml'
    end
    
    it 'should be a hash with indifferent access' do
      @yaml.is_a?(HashWithIndifferentAccess).should be_true
    end
    
    it 'should allow access with multiple ways' do
      @yaml['label_name'].should == 'Myer'
      @yaml[:label_name].should == 'Myer'
    end
  end
end