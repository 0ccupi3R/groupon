require 'nokogiri'

require 'mailgun'

require "open-uri"

class Scrape

  def scr

    html = open('http://www.coupons.com')

    coupons = Nokogiri::HTML(html)

    @projects = {}

    coupons.css("div.right").each do |project|
      title = project.css("h5.brand").text
      @projects[title] = {    
      :savings => project.css("h4.summary").text,
      :description => project.css("p.details").text
    }
    #puts @projects.to_a[-1]

    end

  end

  # def scr2

  #   html = File.read('testforscrape.html')         #open('http://www.coupons.com')

  #   coupons = Nokogiri::HTML(html)

  #   @projects2 = {}

  #   coupons.css("div.right").each do |project|
  #     title = project.css("h5.brand").text
  #     @projects2[title] = {    
  #     :savings => project.css("h4.summary").text,
  #     :description => project.css("p.details").text
  #   }
  #   #puts @projects2.to_a[-1]  

  #   end

  # end

  def compare(first_scrape, second_scrape)
    if first_scrape.sort.to_s == second_scrape.sort.to_s
      puts "No new coupons" #just so we know it works
    else
      puts "NEW COUPON"
      #puts @projects2.to_a - @projects.to_a
      Mailgun.configure do |config|
        config.api_key = 'key-3a1ol4a0tctrk2x2yr7c-ys8tsatgr07'
        config.domain  = 'sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org'
      end

      @mailgun = Mailgun()

      parameters = {
      :to => "mabramson97@gmail.com",
      :subject => "You got a new coupon!",
      :text => "you one pootanker", #the array - array did not work, it was triggered by ads updating yet remained empty, causing an error and ending the script
      :from => "postmaster@sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org"
      }
      @mailgun.messages.send_email(parameters)

    end
  end

  def work
    scr
    first_scrape = @projects
    sleep(10)
    scr
    second_scrape = @projects
    compare(first_scrape,second_scrape)
    work
  end
end

scraper = Scrape.new

scraper.work



