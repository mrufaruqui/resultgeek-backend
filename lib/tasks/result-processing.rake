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
    options[:exam] = Exam.find_by(uuid:"_sixthbsc2018") 
    ProcessFullExamJob.perform_now options
    PdfyLatexJob.perform_now options
end