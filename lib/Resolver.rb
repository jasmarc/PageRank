require "Logger"
require "open-uri"

class Resolver
  def Resolver.resolve(url, base=nil)
    begin
      if(!base.nil?)
        url = URI.parse(base).merge(URI.parse(url)).to_s
      end
      open(url) do |f|
        f.base_uri.to_s
      end
    rescue OpenURI::HTTPError, Errno::ENOENT, \
        Errno::ECONNREFUSED, Errno::ETIMEDOUT => ex
      Logger.new(File.dirname(__FILE__) + "/../logs/resolver.log").error \
        "Couldn't find url = #{url} base = #{base}"
      return nil
    rescue Exception => ex
      Logger.new(File.dirname(__FILE__) + "/../logs/resolver.log").error \
        "url = #{url} base = #{base}\n#{ex.message}"
      raise ex, "url = #{url} base = #{base}\n#{ex.message}"
    end
  end
end