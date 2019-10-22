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
    options[:folder] = "../1stSem2018/"
    ProcessFullExamJob.perform_now options
    PdfyLatexJob.perform_now options
end

desc 'process full exam: 7th Sem 2019'
task process_7thsem2019: :environment do
    options = Hash.new
    options[:exam] = Exam.find_by(uuid:"_seventhbsc2019")
    options[:folder] = "../7thSem2019/"
    ProcessFullExamJob.perform_now options
    PdfyLatexJob.perform_now options
end
