class CreateGazette
      def self.perform options
           @exam = options[:exam]
           tab = Tabulation.where.not(:student_type=>:improvement).where(exam_uuid: @exam.uuid).pluck(:sl_no, :student_roll, :remarks, :result)
           CSV.open("gazette.csv", "wb") { |csv|  csv << ["id", "result", "remarks"]; tab.each { |t| csv<<tab } }
        #    CSV.open("reports/"+ @exam.uuid + "_gazette.csv", "wb") do |csv|  
        #           csv << ["id", "result", "remarks"]; 
        #           tab.each do |t| 
        #             csv<<t 
        #           end
        #     end
      end
end