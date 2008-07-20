xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "MyQuotable: #{@user.login}'s Quotes"
    xml.description "User generated quotes for #{@user.login}" 
    xml.link formatted_user_quotes_url(@user, :rss)
    
    for quote in @quotes do
      xml.item do
        xml.title "#{quote.quote}"
        xml.description "#{quote.quote} \n -- #{quote.author}, #{quote.quote_context}"
        xml.pubDate quote.created_at.to_s(:rfc822)
        xml.link formatted_user_quote_url(@user, quote, :html)
      end
    end
  end
end
