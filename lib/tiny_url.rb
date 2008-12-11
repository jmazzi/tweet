require 'net/http'
module TinyUrl
  class << self
    def create(url)
      uri = 'http://tinyurl.com/api-create.php?url=' + url
      uri = URI.parse(uri)
      tiny_url = Net::HTTP.get_response(uri).body
    end
    
    # taken from rails
    def auto_link_urls(text)
      auto_link_re = %r{
                              (                          # leading text
                                <\w+.*?>|                # leading HTML tag, or
                                [^=!:'"/]|               # leading punctuation, or
                                ^                        # beginning of line
                              )
                              (
                                (?:https?://)|           # protocol spec, or
                                (?:www\.)                # www.*
                              )
                              (
                                [-\w]+                   # subdomain or domain
                                (?:\.[-\w]+)*            # remaining subdomains or domain
                                (?::\d+)?                # port
                                (?:/(?:[~\w\+@%=\(\)-]|(?:[,.;:'][^\s$]))*)* # path
                                (?:\?[\w\+@%&=.;-]+)?     # query string
                                (?:\#[\w\-]*)?           # trailing anchor
                              )
                              ([[:punct:]]|<|$|)       # trailing text
                             }x 

      text.gsub(auto_link_re) do
        all, a, b, c, d = $&, $1, $2, $3, $4
        if a =~ /<a\s/i # don't replace URL's that are already linked
          all
        else
          text = b + c
          url = create("http://#{c}")
          %(#{a}#{url})
        end
      end
    end
    
  end
end