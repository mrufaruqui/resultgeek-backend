desc 'process raw marks and generate tabulations sheet'
task process_result: :environment do   
    ProcessingService.perform
end

desc 'generate grade sheets  latex file'
task generate_grade_sheets_latex: :environment do   
    GenerateGradeSheetService.create_gs_latex
end

desc 'generate tabulations sheets  latex file'
task generate_tabulations_sheets_latex: :environment do   
    GenerateTabulationLatexService.create_tabulation_latex
end

desc 'generate summations sheets  latex file'
task generate_summations_sheets_latex: :environment do   
    GenerateSummationLatexService.new.perform
end


desc 'process full exam'
task process_6thsem2018: :environment do  
    options = Hash.new
    options[:folder] = "../6thSem2018/"
    options[:exam] = Exam.find_by(uuid:"_sixthbsc2018") 
    ProcessFullExamJob.perform_now options
    PdfyLatexJob.perform_now options
end

desc 'process full exam'
task process_1stsem2018: :environment do  
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_firstbsc2018") 
    options[:folder] = "reports/1stSem2018/"
    ProcessFullExamJob.perform_now options
    PdfyLatexJob.perform_now options
end

desc 'process full exam: 7th Sem 2019'
task process_7thsem2019: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_seventhbsc2019")
    options[:folder] = "../7thSem2019/"
    ProcessFullExamJob.perform_now options
     options[:folder] = "../7thSem2019"
    PdfyLatexJob.perform_now options
end


desc 'process full exam: 2nd Sem 2020 NEC'
task process_2nd2020NEC: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_secondbsc2019cnec")
    options[:folder] = "../2ndSemAC/"
    ProcessFullExamJob.perform_now options
     options[:folder] = "../2ndSemAC"
    PdfyLatexJob.perform_now options
end


desc 'process full exam: 2nd Sem 2020 CIET'
task process_2nd2020CIET: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_secondbsc2019ciet")
    options[:folder] = "../2ndSemCIET/"
    ProcessFullExamJob.perform_now options
     options[:folder] = "../2ndSemCIET"
    PdfyLatexJob.perform_now options
end


desc 'process full exam: 5th Sem 2020'
task process_fifthbsc2020: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_fifthbsc2020")
    options[:folder] = "../5thSem2020/"
    ProcessFullExamJob.perform_now options
    options[:folder] = "../5thSem2020"
    PdfyLatexJob.perform_now options
end

desc 'process full exam: 5th Sem 2021'
task process_fifthbsc2021: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_fifthbsc2021")
    options[:folder] = "../5thSem2021/"
    ProcessFullExamJob.perform_now options
    options[:folder] = "../5thSem2021"
    PdfyLatexJob.perform_now options
end


desc 'process full exam: 7th Sem 2021'
task process_seventhbsc2021: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_seventhbsc2021")
    options[:folder] = "../7thSem2021/"
    ProcessFullExamJob.perform_now options
     options[:folder] = "../7thSem2021"
    PdfyLatexJob.perform_now options
end

desc 'Email individual result: 7th Sem 2021'
task email_seventhbsc2021: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_seventhbsc2021")
    options[:folder] = "../7thSem2021/"
    options[:student_type] = :regular
    results= GenerateGradeSheetService.generate_gs_view({:exam=>options[:exam],:student_type=>options[:student_type], :record_type=>:current, :folder=>   options[:folder]})
    results.each do |result|
        options[:result] = result
        ResultMailerJob.perform_later options
    end
     
end


desc 'Email individual result: 5th Sem 2021'
task email_fifthbsc2021: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_fifthbsc2021")
    options[:folder] = "../fifthbsc2021/"
    options[:student_type] = :regular
    results= GenerateGradeSheetService.generate_gs_view({:exam=>options[:exam],:student_type=>options[:student_type], :record_type=>:current, :folder=>   options[:folder]})
    results.each do |result|
        options[:result] = result
        ResultMailerJob.perform_later options
    end
     
end



 