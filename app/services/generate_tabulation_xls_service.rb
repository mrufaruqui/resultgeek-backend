require 'axlsx'

class GenerateTabulationXlsService < TabulationBaseService
    def self.perform(options={})
      @exam = options[:exam]
      Axlsx::Package.new do |p|
       wb = p.workbook
         wb.styles do |s| 
             heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => false}
         end
       
        wb.add_worksheet(name: "Tabulations") do |sheet|
         generate_tabulations.each do |tr|
            cr = course_array(tr)
             sheet.add_row [tr[:roll], tr[:name]] + cr.flatten + [tr[:tce], tr[:tps], tr[:gpa], tr[:result], tr[:remarks], tr[:hall]]
         end
        end
        p.serialize("reports/" + @exam.uuid+".xlsx")
     end
      true
    end
    
     def self.generate_tabulations()
        tab_a = []
        Tabulation.where(exam_uuid:@exam.uuid).each do |t| 
            tab_a <<  generate_single_page_tabulation(t)
        end
        tab_a
     end

     def self.course_array(data)
        a = []
        Course.where(exam_uuid:@exam.uuid).each { |c| a << data[c.code].values }
        a
     end

     def self.generate_single_page_tabulation(t)
        student = Student.find_by(roll:t.student_roll) 
        @retHash = Hash.new
        @retHash[:sl_no] = t.sl_no
        @retHash[:gpa] = '%.2f' % t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = '%.2f' % t.tce
        @retHash[:remarks] = t.remarks
        @retHash[:roll] = student.roll
        @retHash[:name] = student.name
        @retHash[:hall] = student.hall_name;
        @retHash[:courses] = []
        tps = 0.0;
        t.tabulation_details.each do |td|
            course = Hash.new
            ps = ( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2)
            if td.summation.course.course_type === "lab"
               @retHash[td.summation.course.code] =  {:mo=>td.summation.total_marks, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>ps }
            else
               @retHash[td.summation.course.code] = {:cact=>td.summation.cact, :fem=>td.summation.marks, :mo=>td.summation.total_marks, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>ps }
            end  
            tps += ps;
          #  @retHash[:courses] << course
        end
        @retHash[:tps] = '%.2f' % tps; 
        @retHash
      end    

end

