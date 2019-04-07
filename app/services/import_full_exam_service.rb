require 'csv'
class ImportFullExamService

    
    def self.register_students(options={})
            @exam = options[:exam]
        if options.has_key? :exam  
            MyLogger.info  "Reading files: " + "../6thSem2018/students.csv"
            file = CSV.read("../6thSem2018/students.csv")
            header = file[0]
            body = file - [header]
            body.each do |i| 
                row = Hash[[header, i].transpose].symbolize_keys
                student = Student.find_by(roll: row[:roll]) || Student.new
                student.roll = row[:roll]
                student.name = row[:name]
                student.hall_name = row[:hall_name]
                student.hall = row[:hall] 
                student.save
                registration = Registration.find_by(student_id: student.id, exam_uuid:options[:exam] ) || Registration.new
                registration.exam_id = @exam.id
                registration.sl_no = row[:sl].to_i
                registration.exam_uuid = @exam.uuid
                registration.student = student
                registration.student_type = row[:type].downcase.to_sym
                registration.course_list=row[:courses]
                registration.save 
            end
          MyLogger.info "No of regular students: "    + Registration.where(exam:@exam, :student_type=>:regular).count.to_s
          MyLogger.info "No of irregular students: "  +  Registration.where(exam:@exam, :student_type=>:irregular).count.to_s
          MyLogger.info "No of improvement students: " + Registration.where(exam:@exam, :student_type=>:improvement).count.to_s
          MyLogger.info "Total students: " + Registration.where(exam:@exam).count.to_s
          
          true
        else
             MyLogger.info "Specify exam"
             return true
        end

    end

    def self.import_single_course options
        data = options[:data]
        @exam = options[:exam]
        @course = options[:course] #Course.find_by(id: params[:course_id])
        options = Hash.new
        options[:exam] = @exam
        if !@course.blank?
            MyLogger.info  @course.code + ":" + @course.title + "  " + @course.credit.to_s 
            Summation.where(exam_uuid:@exam.uuid, course_id:@course.id).destroy_all
            header = data[0]
            body = data - [header]
            body.each do |i| 
                row = Hash[[header, i].transpose].symbolize_keys
                options[:row] = row
                create_summation options
            end
          MyLogger.info  body.size.to_s + " students' marks imported" 
        else  
          MyLogger.info "no such course"
        end   
    end

    def self.import_all_courses(options={})
       @exam = options[:exam]
       courses = Course.where(exam_uuid:@exam.uuid)
       courses.each do |c|
         options[:course] = c
         MyLogger.info  "Reading files: " + "../6thSem2018/"+ c.code.split(/[a-zA-z]/).last+".csv"
         options[:data] = CSV.read("../6thSem2018/"+ c.code.split(/[a-zA-z]/).last+".csv") 
         import_single_course options
       end
    end

    def self.create_summation options
        row = options[:row]
        @exam = options[:exam]

        student =   Student.find_by(roll: row[:roll]) || Student.create(:roll=>row[:roll])
        registration = Registration.find_by(student_id: student.id, exam_uuid:@exam.uuid ) || Registration.create(student:student, exam:@exam)
        summation = Summation.find_by(student_id: student.id, course_id: @course.id) || Summation.new
        summation.exam_uuid = @exam.uuid 
        summation.student =   registration.student
        summation.course   =  @course 
        if @course.course_type === "theory" 
          summation.assesment = row[:ct]
          summation.attendance = row[:ca]
          if row[:cact].blank?
              summation.cact = summation.marks.to_f + summation.assesment.to_f
          else
              summation.cact = row[:cact]
          end
          summation.section_a_marks = row[:marks_a]
          summation.section_b_marks = row[:marks_b]
          summation.section_a_code = row[:code_a]
          summation.section_b_code = row[:code_b]
          summation.marks = summation.section_a_marks.to_f + summation.section_b_marks.to_f
          m = 
          summation.total_marks = (summation.marks.to_f + summation.cact.to_f).ceil
        else
          summation.total_marks = (row[:marks]).to_f.ceil
        end

        summation.percetage = (summation.total_marks.to_f / (@course.credit.to_f * 25.to_f)) * 100.to_f
        ret = calculate_grade(summation.percetage.to_f) 
        summation.gpa = ret[:lg]
        summation.grade = ret[:ps]
        summation.save
    end
    
    def self.calculate_grade(p)
      retHash = {}
      if p >= 80 
        retHash[:ps] = 4.00
        retHash[:lg] = 'A+'
      elsif p >= 75 && p <80
        retHash[:ps] = 3.75
        retHash[:lg] = 'A'
      elsif p >= 70 && p < 75
        retHash[:ps] = 3.50
        retHash[:lg] = 'A-'
      elsif p >= 65 && p <70
        retHash[:ps] = 3.25
        retHash[:lg] = 'B+'
      elsif p >= 60 && p <65
        retHash[:ps] = 3.00
        retHash[:lg] = 'B'
      elsif p >= 55 && p <60
        retHash[:ps] = 2.75
        retHash[:lg] = 'B-'
      elsif p >= 50 && p <55
        retHash[:ps] = 2.50
        retHash[:lg] = 'C+'
      elsif p >= 45 && p <50
        retHash[:ps] = 2.25
        retHash[:lg] = 'C'
      elsif p >= 40 && p <45
        retHash[:ps] = 2.00
        retHash[:lg] = 'D'
      elsif p < 40
        retHash[:ps] = 0.00
        retHash[:lg] = 'F'
      else
        retHash[:ps] = 0.00
        retHash[:lg] = 'X'
      end
      retHash
    end

     def self.reset_exam_result options
      @exam = options[:exam]
      TabulationDetail.destroy_all
      Tabulation.where(exam_uuid:@exam.uuid).destroy_all
      Summation.where(exam_uuid:@exam.uuid).destroy_all
      Registration.where(exam_uuid:@exam.uuid).destroy_all
   end

   def self.process_result_regular options
      @exam = options[:exam]
      ProcessingService.perform({:exam=>@exam, :student_type=>:regular, :record_type=>:current})
      ProcessingService.perform({:exam=>@exam, :student_type=>:irregular, :record_type=>:current})
      ProcessingService.perform({:exam=>@exam, :student_type=>:improvement, :record_type=>:current})
   end


   def self.import_irregular options
      @exam = options[:exam]
      @courses = Course.where(exam_uuid:@exam.uuid)
      @student_type = :irregular
      Tabulation.where(exam_uuid:@exam.uuid, :record_type=>:previous, :student_type=>:irregular).destroy_all
      MyLogger.info  "Reading files: "  + "../6thSem2018/irregular.csv"
      data = CSV.read("../6thSem2018/irregular.csv") 
      header = data[0]
      body = data - [header]
      body.each do |i| 
        row = Hash[[header.map(&:downcase), i].transpose].symbolize_keys
        options[:row] = row
        create_tabulation_row options
      end  
   end

   def self.import_improvement options
      @exam = options[:exam]
      @courses = Course.where(exam_uuid:@exam.uuid) 
      @student_type = :improvement
      Tabulation.where(exam_uuid:@exam.uuid, :record_type=>:previous, :student_type=>:improvement).destroy_all
      MyLogger.info  "Reading files: "  +  "../6thSem2018/improve.csv"
      data = CSV.read("../6thSem2018/improve.csv") 
      header = data[0]
      body = data - [header]
      body.each do |i| 
        row = Hash[[header.map(&:downcase), i].transpose].symbolize_keys
        options[:row] = row
        create_tabulation_row options  
      end  
  end

   def self.full_process_result_irregular options
        @exam = options[:exam]
        Tabulation.where(exam_uuid:@exam.uuid, :student_type=>:irregular, :record_type=> :temp).destroy_all
        ProcessingService.process_result_irregular({:exam=>@exam, :student_type=>:irregular, :record_type=>:temp})
   end
   
   def self.full_process_result_improve options
        @exam = options[:exam]
        Tabulation.where(exam_uuid:@exam.uuid, :student_type=>:improve, :record_type=> :temp).destroy_all
        ProcessingService.process_result_improvement({:exam=>@exam, :student_type=>:improvement, :record_type=>:temp})
   end

   def self.generate_tabulations options
      @exam = options[:exam]
      GenerateTabulationLatexV3Service.new.perform({:exam=>@exam,:student_type=>:regular,:record_type=>:current})
      GenerateTabulationLatexV3Service.new.perform({:exam=>@exam,:student_type=>:improvement,:record_type=>:temp})
      GenerateTabulationLatexV3Service.new.perform({:exam=>@exam,:student_type=>:irregular,:record_type=>:temp}) 
   end

   def self.generate_gradesheets  options
        @exam = options[:exam]
        GenerateGradeSheetService.create_gs_latex({:exam=>@exam,:student_type=>:regular, :record_type=>:current})
        GenerateGradeSheetService.create_gs_latex({:exam=>@exam,:student_type=>:improvement, :record_type=>:temp})
       GenerateGradeSheetService.create_gs_latex({:exam=>@exam,:student_type=>:irregular, :record_type=>:temp})
   end
 

   def self.generate_summations_sheets  options
        @exam = options[:exam]
        GenerateSummationLatexService.new.perform({:exam=>@exam})
   end
   
  def self.create_tabulation_row options
        row = options[:row]
        @exam = options[:exam]
       
      student =   Student.find_by(roll: row[:roll])
      r = Registration.find_by(student_id: student.id, exam_uuid:@exam.uuid )  
      if r
              # r.student_type = :improvement
              # r.student = student
              # r.save
              is_failed_in_a_course = false;
              s = r.student
              tabulation = Tabulation.find_by(student_roll:s.roll, exam_uuid:@exam.uuid, :record_type=>:previous) || Tabulation.new
              tabulation.student_roll = s.roll;
              tabulation.exam_uuid = @exam.uuid
              tabulation.sl_no = r.sl_no
              tabulation.student_type = @student_type
              tabulation.record_type = :previous
              tabulation.hall_name = s.hall_name
              tps = row[:tps]
              tce = row[:tce]
              #sm_a = []
             @courses.each do |c|
                  summation = Summation.find_by(exam_uuid:@exam.uuid, course:c, student: s, :record_type=>:previous) || Summation.new
                  summation.student = student
                  summation.exam_uuid = @exam.uuid
                  summation.course = c
                  summation.record_type = :previous
               if c.course_type === "theory" 
                  summation.cact = row[(c.code.downcase+'cact').to_sym] 
                  summation.marks = row[(c.code.downcase+'fem').to_sym] 
                  summation.total_marks = row[(c.code.downcase+'mo').to_sym]
                else 
                  summation.total_marks = row[(c.code.downcase+'mo').to_sym]
                end

                summation.percetage =  row[(c.code.downcase+'pr').to_sym]
                summation.gpa = row[(c.code.downcase+'lg').to_sym]
                summation.grade = row[(c.code.downcase+'gp').to_sym]
                summation.save
                td = TabulationDetail.find_by(:tabulation_id=>tabulation.id, :summation_id=>summation.id)  || TabulationDetail.new
                td.tabulation = tabulation
                td.summation  = summation
                td.save
             end
              tabulation.gpa = row[:gpa].to_f
              tabulation.tce = row[:tce].to_f
              tabulation.result = row[:result]
              tabulation.remarks = row[:remarks]
              #tabulation.remarks = 'F-' + remarks.join(", ") if is_failed_in_a_course  
              tabulation.save
        end
  end
  
  def self.perform options
    @exam = options[:exam]

    MyLogger.info  "Destroy prevoius calculations"
       reset_exam_result options
    MyLogger.info  "Register students"
       register_students options
       
     MyLogger.info  "## Step 3: import all course marks"
       import_all_courses options       
    MyLogger.info  "Processing   result: regular"
        Tabulation.where(exam_uuid:@exam.uuid).destroy_all
        process_result_regular options
    MyLogger.info  "Importing irregular previous result"
        import_irregular options
    MyLogger.info  "Processing   result: irregular"
        full_process_result_irregular options
    MyLogger.info  "Importing irregular previous result"
        import_improvement options
    MyLogger.info  "Processing  result: improvement"
        full_process_result_improve options
    MyLogger.info  "Generating latex files"
        generate_summations_sheets options
        generate_tabulations options
        generate_gradesheets options

  end

   def self.generate_latex_files options
       @exam = options[:exam]
        generate_summations_sheets options
        generate_tabulations options
        generate_gradesheets options
   end 
end