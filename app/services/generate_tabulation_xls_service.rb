require 'axlsx'

class GenerateTabulationXlsService < TabulationBaseService
    def self.perform(options={})
      @exam = Exam.first
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
        p.serialize("reports/" + @exam.uuid+".xls")
     end
      true
    end
    
     def self.generate_tabulations()
        tab_a = []
        Tabulation.all.each do |t| 
            tab_a <<  generate_single_page_tabulation(t)
        end
        tab_a
     end

     def self.course_array(data)
        a = []
        Course.all.each { |c| a << data[c.code].values }
        a
     end

end

