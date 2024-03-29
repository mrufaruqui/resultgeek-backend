require 'smarter_csv'

class MyCSVReader

    def self.read filename
        if File.exist? filename
            MyLogger.info "Reading files: " + filename
            return  CSV.read(filename)
        else
            MyLogger.warn "File missing: " + filename
            return nil
        end
    end

    def self.smart_read filename
        if File.exist? filename
            MyLogger.info "Reading files: " + filename
            SmarterCSV.process(filename)
        else
            MyLogger.warn "File missing: " + filename
            return nil
        end
    end
end