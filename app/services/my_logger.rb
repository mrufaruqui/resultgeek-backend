class MyLogger
    def self.info str
       #Rails.logger.info str 
       puts str.green
    end 
    
    def self.warn str
       #Rails.logger.info str 
       puts str.yellow
    end  

    def self.error str
       #Rails.logger.info str 
       puts str.red
    end  
end