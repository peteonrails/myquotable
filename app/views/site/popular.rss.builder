xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "MyQuotable: Most Popular Quotes"
    xml.description "Most popular user generated quotes for MyQuotable.com" 
    xml.link formatted_root_url(:rss)
    
    for quote in @quotes do
      xml.item do
        xml.title "#{quote.quote}"
        xml.description "#{quote.quote} \n -- #{quote.author}, #{quote.quote_context}"
        xml.pubDate quote.created_at.to_s(:rfc822)
        xml.link formatted_user_quote_url(quote.user, quote, :html)
      end
    end
  end
end
