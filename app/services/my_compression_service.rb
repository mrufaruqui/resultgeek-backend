require "zlib"

class MyCompressionService

    def self.compress data
        encode Zlib::Deflate.deflate  data
    end

    def self.decompress data
          Zlib::Inflate.inflate decode data
    end

    def self.encode data
        Base64.encode64 data
    end

    def self.decode data
        Base64.decode64 data
    end
end