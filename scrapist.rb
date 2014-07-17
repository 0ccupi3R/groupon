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

    def work 
     scr
    @first_scrape = @projects.to_a[1..18]
    sleep(3)
    scr
    second_scrape = @projects.to_a[1..18]
    compare(@first_scrape,second_scrape)
  
  end 

  def email 
  
    Mailgun.configure do |config|
        config.api_key = 'key-3a1ol4a0tctrk2x2yr7c-ys8tsatgr07'
        config.domain  = 'sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org'
      end

      @mailgun = Mailgun()

      parameters = {
      :to => "mailing@sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org",
      :subject => "Free Printable Coupons!",
      :text => @first_scrape.to_a.to_s.gsub(",","\n\n").gsub("[","").gsub("]","").gsub("{","").gsub("}","").chomp.strip.gsub(/"/,'') + " " + "www.coupons.com",  
      :from => "postmaster@sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org"
      }
      @mailgun.messages.send_email(parameters)
    end
  


  def compare(first_scrape, second_scrape)
    if first_scrape.sort.to_s == second_scrape.sort.to_s
      puts "No new coupons" #just so we know it works
    else
      puts "NEW COUPON"
      #puts @projects2.to_a - @projects.to_a


      content = second_scrape.to_a - @first_scrape.to_a

      Mailgun.configure do |config|
        config.api_key = 'key-3a1ol4a0tctrk2x2yr7c-ys8tsatgr07'
        config.domain  = 'sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org'
      end

      @mailgun = Mailgun()

      parameters = {
      :to => "mabramson97@gmail.com",
      :subject => "You got a new coupon!",
      :text => content.to_s.gsub(",","\n\n").gsub("[","").gsub("]","").gsub("{","").gsub("}","").chomp.strip.gsub(/"/,''), 
      :from => "postmaster@sandbox16208d02c8bb4a4f88c2c87212757b2a.mailgun.org"
      }
      @mailgun.messages.send_email(parameters)

    end
  end

  def view
      puts @first_scrape
  end


  def system
    work
    # email
    9.times do work
    end
    view
    system
  end


  
end


scraper = Scrape.new

scraper.system