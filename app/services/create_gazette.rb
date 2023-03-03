class CreateGazette
      def self.perform options
           @exam = options[:exam]
            @folder = options[:folder]
            i = 1
            filename = @folder +  "gazette.csv" 
            CSV.open(filename, "wb") do |csv|  
                  csv << [preamble]
            @halls =  Tabulation.all.pluck(:hall_name).uniq
                 @halls.each do |hall|
                  csv << [hall + "\n"]
                  tab = Tabulation.where.not(:student_type=>:improvement).where(exam_uuid: @exam.uuid, hall_name: hall).order(:sl_no).pluck(:sl_no, :student_roll, :remarks, :result)
                  csv << ["id", "roll", "remarks", "result","\n"]; tab.each { |t| csv<<t } 
                 end
            end
        #    CSV.open("reports/"+ @exam.uuid + "_gazette.csv", "wb") do |csv|  
        #           csv << ["id", "result", "remarks"]; 
        #           tab.each do |t| 
        #             csv<<t 
        #           end
        #     end
      end

      def self.preamble
            <<-EOF
            Office of the
Controller of Examinations
University of Chittagong Chittagong-4331.

Memo No. CE/RS    Date:#{Date.today}

NOTICE

The under mentioned candidates are declared to have passed the 7th Semester B.Sc. Engineering Examination 2021 in Computer Science and Engineering, held in September - December 2022. The results are published provisionally subject to the approval of the competent authority and the Syndicate of the University.

The University reserves the right to correct or amend the results if necessary. 
    #{@exam.fullname}
    Subject: Computer Science and Engineering.

      EOF
      end
end