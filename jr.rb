require 'faraday-cookie_jar'
require 'faraday_middleware'
module WebApis
  module Jr 
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def booking_application_form(params)
        if params['taobao_id'].nil? || params['taobao_id'].empty?
          return response = { 
              :status => "error",
              :message => 'Please complete the "Taobao ID" field.',
            }
        end

        email = params['singleAnswer(ANSWER568-1)']
        email_split = email.split("@")

        params['singleAnswer(ANSWER568-1)'] = email_split[0] 
        params['singleAnswer(ANSWER568-2)'] = email_split[1]
        params['singleAnswer(ANSWER568-1-R)'] = email_split[0]
        params['singleAnswer(ANSWER568-2-R)'] = email_split[1]

        url = "https://entry.jr-odekake.net/webapp/form/18254_cabb_25/index.do"
        response = Faraday.get url
        body = Nokogiri::HTML.parse(response.body, nil, nil)
        params['org.apache.struts.taglib.html.TOKEN'] =  body.css("input[name='org.apache.struts.taglib.html.TOKEN']").first.attribute("value").value
        params['singleAnswer(ANSWER576)'] = 'http://www.westjr.co.jp/global/en/travel-information/pass/pdf/station_kansai-airport.pdf'
        params['singleAnswer(ANSWER575)'] = params['fromdate']
        params['singleAnswer(ANSWER570)'] = params['singleAnswer(ANSWER569-3)']+'-'+ params['singleAnswer(ANSWER569-2)']+'-'+params['singleAnswer(ANSWER569-1)']   
        con = Faraday.new(url: "https://entry.jr-odekake.net") do |builder|
          builder.use :cookie_jar
          builder.request :url_encoded
          builder.adapter :net_http
        end
        res = con.post do |req|
          req.url '/webapp/form/18254_cabb_25/setParameters.do'
          req.body = params.permit(params.keys).to_h  
        end

        errorList = Nokogiri::HTML.parse(res.body, nil, nil).css("div[class='center']").first.text
        
        if errorList.empty? 
          tokennew = Nokogiri::HTML.parse(res.body, nil, nil).css("input[name='org.apache.struts.taglib.html.TOKEN']").first.attribute("value").value
          res1 = con.post do |req1|
            req1.url '/webapp/form/18254_cabb_25/executeRegister.do'
            req1.body = { "org.apache.struts.taglib.html.TOKEN": tokennew} 
          end
          return response = { 
              :status => "success",
              :message => "Tickets booked",
              :params => params,
            }
        else
         return response = { 
              :status => "error",
              :message => errorList.gsub('.', '.</br>'),
            }
        end
      end
    end
  end
end