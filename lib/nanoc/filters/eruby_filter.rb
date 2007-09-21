def try_require(s) ; begin ; require s ; rescue LoadError ; end ; end

try_require 'rubygems'

require 'erb'
try_require 'erubis'

class ERBContext

  def initialize(hash)
    hash.each_pair do |key, value|
      instance_variable_set('@' + key.to_s, value)
    end
  end

  def get_binding
    binding
  end

end

class String

  # Converts the string using eRuby
  def eruby(params={})
    params[:eruby_engine] == :erubis ? erubis(params) : erb(params)
  end

  # Converts the string using Erubis
  def erubis(params={})
    Erubis::Eruby.new(self).evaluate(params[:assigns] || {})
  end

  # Converts the string using ERB
  def erb(params={})
    ERB.new(self).result(ERBContext.new(params[:assigns] || {}).get_binding)
  end

end

register_filter 'eruby' do |page, pages, config|
  assigns = { :page => page, :pages => pages }
  page.content.eruby(:assigns => assigns, :eruby_engine => config[:eruby_engine])
end
