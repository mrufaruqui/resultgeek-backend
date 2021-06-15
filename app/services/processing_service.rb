class ProcessingService
   def self.perform(options={})
       #######Retrieve exam info ##########
        @student_type = options[:student_type]
        @exam = options[:exam]
        @courses = Course.where(exam_uuid:@exam.uuid)

       ####Remove Old Caculations####
       #TabulationDetail.destroy_all
      # Tabulation.where(exam_uuid:@exam.uuid, :student_type=>options[:student_type], :record_type=>options[:record_type]).destroy_all 
       process_result_regular({:exam=>@exam, :student_type=>@student_type, :record_type=>options[:record_type]})
       true
  end
 
  ###Format CGPA According to CU Syndicate Directions ####

  def self.format_gpa(gpa)
    third_decimal = ((gpa.round(3) - gpa.round(2)) * 1000).to_i
    fourth_decimal = ((gpa.round(4) - gpa.round(3)) * 10000).to_i
    third_decimal > 0  || fourth_decimal > 0 ? (gpa.round(2).+(0.01)).round(2) : gpa.round(2)
  end

  def self.process_result_regular(options) 
     @exam = options[:exam]
     @courses = Course.where(exam_uuid:@exam.uuid)
    #######Retrieve Registered  Regular Studentsstudents #########
     Registration.where(exam_uuid:@exam.uuid,:student_type=>options[:student_type]).each do |r|
            is_failed_in_a_course = false;
            s = r.student
            tabulation = Tabulation.find_by(student_roll:s.roll, exam_uuid:@exam.uuid, :record_type=> options[:record_type] ) || Tabulation.new
            tabulation.student_roll = s.roll
            tabulation.hall_name = s.hall_name
            tabulation.exam_uuid = @exam.uuid
            tabulation.sl_no = r.sl_no
            tabulation.student_type = r.student_type.to_sym
            tabulation.record_type = options[:record_type]
            tps = 0.0
            tce = 0.0
            remarks = []
            sm_a = []
            @courses.each do |c|
                sm = Summation.find_by(student_id:s.id, course_id: c.id, :record_type=>options[:record_type]) || Summation.create(:record_type=>:current, student_id:s.id, course_id: c.id, gpa:'X', grade:0)
               # if sm.gpa != 'X' #!sm.blank? || !sm.nil?
                    td = TabulationDetail.find_by(:tabulation_id=>tabulation.id, :summation_id=>sm.id)  || TabulationDetail.new
                        td.tabulation = tabulation
                        td.summation  = sm
                        td.save 

                        # if r.student_type != :improvement
                          remarks << c.code.split(/[a-zA-Z]/).last if sm.gpa === 'F' 
                          tce += c.credit unless sm.gpa === 'F' || sm.gpa === 'X'
                          is_failed_in_a_course = true if sm.gpa === 'F'
                          tps += (sm.grade * c.credit) unless sm.nil? || sm.blank? || sm.gpa === 'X' || sm.gpa === 'F'
                        # end
                        sm_a << sm
            end
            
           # if r.student_type != :improvement
              gpa = tps > 0 ? format_gpa(tps / Course.where(exam_uuid:@exam.uuid).sum(:credit).to_f) : 0.00
              s.gpa = gpa
              tabulation.gpa = gpa #gpa.round(2);
              tabulation.tce = tce.to_i
              tabulation.result = (gpa >= 2.20) ? 'P' : 'F'
              tabulation.remarks = 'F-' + remarks.join(", ") if is_failed_in_a_course 
           # end 
            
            s.save
            tabulation.save
            end
     true  
  end

  def self.process_result_improvement options
     @exam = options[:exam]
     @courses = Course.where(exam_uuid:@exam.uuid)
    # Tabulation.where(exam_uuid:@exam.uuid, :student_type=>:irregular, :record_type=>:temp).destroy_all 
    #######Retrieve Registered  Regular Studentsstudents #########
      Registration.where(exam_uuid:@exam.uuid,:student_type=>:improvement).each do |r|
            is_failed_in_a_course = false;
            s = r.student
            @courses.each do |c|
                sm_cur = Summation.find_by(student_id:s.id, course_id: c.id, :record_type=>:current)
                if  !sm_cur.blank? or !sm_cur.nil?
                    sm_prev = Summation.find_by(student_id:s.id, course_id: c.id, :record_type=>:previous)
                    sm_temp = Summation.new(sm_prev.as_json)
                    sm_temp.id = nil;
                    sm_temp.record_type = :temp     
                    if c.course_type === "theory"
                        sm_temp.marks = sm_prev.marks
                        sm_cur.marks
                        sm_temp.marks = (sm_cur.marks.to_f > sm_prev.marks.to_f ? sm_cur.marks.to_f : sm_prev.marks.to_f).to_s unless sm_cur.marks.nil?
                        sm_temp.total_marks = (sm_temp.marks.to_f + sm_temp.cact.to_f).ceil
                    else 
                        sm_temp.total_marks = (sm_cur.total_marks > sm_prev.total_marks ? sm_cur.total_marks : sm_prev.total_marks) unless sm_cur.total_marks.nil?
                    end

                    sm_temp.percetage = (sm_temp.total_marks.to_f / (c.credit.to_f * 25.to_f)) * 100.to_f
                    ret = calculate_grade(sm_temp.percetage.to_f) 
                   
                   ##punishment grading
                    if (sm_cur.gpa != 'X' and ret[:ps] > 3.00)
                         ret[:ps] = 3.00
                         ret[:lg] = 'B' 
                    end

                    sm_temp.gpa = ret[:lg]
                    sm_temp.grade = ret[:ps]
                    sm_temp.save
                end
            true
           end
      end
      process_result_regular({:student_type=>:improvement, :record_type=>:temp, :exam=>@exam })
  end

def self.process_result_irregular options
    @exam = options[:exam]
    @courses = Course.where(exam_uuid:@exam.uuid)
  # Summation.where(:student_type=>:irregular,:record_type=>:temp).destroy_all
   #Tabulation.where(exam_uuid:@exam.uuid, :student_type=>:irregular, :record_type=>:temp).destroy_all 
    
    #######Retrieve Registered  Regular Studentsstudents #########
      Registration.where(exam_uuid:@exam.uuid,:student_type=>:irregular).each do |r|
            is_failed_in_a_course = false;
            s = r.student
            @courses.each do |c|
                     sm_cur = Summation.find_by(student_id:s.id, course_id: c.id, :record_type=>:current)
                     sm_prev = Summation.find_by(student_id:s.id, course_id: c.id, :record_type=>:previous)
                     #Summation.where(course_id:c.id,student:s, :record_type=>:temp).destroy_all

                 if  (!sm_cur.blank? or !sm_cur.nil?)  and (!sm_prev.blank? or !sm_prev.nil?)
                       sm_temp =  sm_prev.grade > sm_cur.grade ? Summation.new(sm_prev.as_json) :  Summation.new(sm_cur.as_json) 
                 elsif sm_prev 
                        sm_temp = Summation.new(sm_prev.as_json)
                 end
                    # sm_temp = (!sm_cur.blank? or !sm_cur.nil?)? (sm_prev.grade > sm_cur.grade ? Summation.new(sm_prev.as_json) :  Summation.new(sm_cur.as_json)) :  Summation.new(sm_prev.as_json)
                     sm_temp.id = nil;
                     sm_temp.record_type = :temp
                     sm_temp.save 
          #      end
          #   true
            end
      end
      process_result_regular({:student_type=>:irregular, :record_type=>:temp, :exam=>@exam})
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
end
