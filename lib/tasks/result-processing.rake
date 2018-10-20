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