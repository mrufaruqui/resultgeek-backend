class GenerateAttendanceService
   attr_accessor :exam, :folder, :tab

  def initialize options
    @exam   = options[:exam]
    @folder = options[:folder]
    @tab = {}
  end

   def genereate_validation_reports
         a = []
        @tab =  Tabulation.where(exam_uuid: @exam.uuid, :student_type=>:regular, :record_type=>:current).order(:sl_no)
        @tab.each do |t| 
            retHash = view_tabulation_row t
        a << retHash
        end
       
         @tab =  Tabulation.where(exam_uuid: @exam.uuid, :student_type=>:irregular, :record_type=>:temp).order(:sl_no)
        @tab.each do |t| 
            retHash = view_tabulation_row t
        a << retHash
        end

         @tab =  Tabulation.where(exam_uuid: @exam.uuid, :student_type=>:improvement, :record_type=>:temp).order(:sl_no)
        @tab.each do |t| 
            retHash = view_tabulation_row t
        a << retHash
        end

        write_reports a
    end

    def view_tabulation_row t
       s = Student.find_by(roll:t.student_roll)
        retHash = Hash.new
        retHash[:roll] = s.roll
        retHash[:name] = s.name  
        retHash[:student_type] = t.student_type
        retHash[:remarks] = t.remarks
        t.tabulation_details.each do |td|
            course = Hash.new 
            if td.summation.course.course_type === "lab" 
               retHash[td.summation.course.code + '_tm'] = (td.summation.total_marks.nil? or td.summation.total_marks == 0.0) ?  'missing' : ''
            else
               retHash[td.summation.course.code + '_cact'] =  (td.summation.cact.nil? or td.summation.cact == 0.0) ?  'missing' : ''
               retHash[td.summation.course.code + '_ct'] =    (td.summation.assesment.nil? or td.summation.assesment == 0.0)  ?  'missing' : ''
               retHash[td.summation.course.code + '_ca'] =    (td.summation.attendance.nil? or td.summation.attendance == 0.0)  ?  'missing' : ''
               retHash[td.summation.course.code + 'section_a_marks'] =   (td.summation.section_a_marks.nil? or td.summation.section_a_marks == 0.0)  ?  'missing' : ''
               retHash[td.summation.course.code + 'section_b_marks'] =   (td.summation.section_b_marks.nil? or td.summation.section_b_marks == 0.0) ?  'missing' : ''
            end   
          #  retHash[:courses] << course
        end
        retHash 
    end

    def write_reports data
      Axlsx::Package.new do |p|
       wb = p.workbook
         wb.styles do |s| 
             heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => false}
         end
       
        wb.add_worksheet(name: "Tabulations") do |sheet|
            sheet.add_row data.first.keys
         data.each do |tr|
           # cr = course_array(tr)
             sheet.add_row tr.values
         end
        end
        p.serialize(@folder + "/validations_" + @exam.uuid+".xlsx")
     end
      true
    end

    def course_array(data)
        a = []
        Course.where(exam_uuid:@exam.uuid).each { |c| a << data[c.code].values }
        a
    end

end    