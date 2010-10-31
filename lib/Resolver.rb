require "Logger"
require "open-uri"

class Resolver
  @@log = Logger.new(File.dirname(__FILE__) + "/../logs/resolver.log")
  def Resolver.resolve(passed_url, base)
    begin
      if(!base.nil?)
        url = URI.parse(base).merge(URI.parse(passed_url)).to_s
      end
      @@log.debug "passed_url = [#{passed_url}] converted = [#{url}] base = [#{base}]"
      return url
      # open(url) do |f|
      #   f.base_uri.to_s
      # end
    rescue OpenURI::HTTPError, Errno::ENOENT, URI::InvalidURIError, \
        Errno::ECONNREFUSED, Errno::ETIMEDOUT, URI::BadURIError => ex
      @@log.error "Couldn't find url = #{url} base = #{base}"
      return nil
    rescue Exception => ex
      @@log.error "url = #{url} base = #{base}\n#{ex.message}"
      raise ex, "url = #{url} base = #{base}\n#{ex.message}"
    end
  end
end