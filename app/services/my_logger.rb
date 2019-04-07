class MyLogger
    def self.info str
       Rails.logger.info str 
       ap str
    end  
end