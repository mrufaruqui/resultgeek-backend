class CreateExcelTemplate
    def self.add_header(sheet, heading, report_name)
      sheet.add_row [" SUMMIT ALLIANCE PORT LIMITED (OCL) "], style: heading, height: 20
      sheet.add_row [" KATGHAR, NORTH PATENGA, CHITTAGONG-4204. "] , style: heading, height: 18
      sheet.add_row [" MAERSK LINE  / MAERSK LINE(MAERSK BANGLADESH LTD.)"] , style: heading, height: 16
      sheet.add_row [report_name], style: heading, height: 14 
      sheet.merge_cells("A1:AD1");
      sheet.merge_cells("A2:AD2");
      sheet.merge_cells("A3:AD3");
      sheet.merge_cells("A4:AD4"); 
    end
   
    def self.prepare_workbook(sheet, data, header_info, style_info, hidden=true) 
            sheet.add_row
            # sheet.merge_cells("A5:AD5");
            
            # sheet.add_row header_info, style: style_info   
            # data.each do |info|
            #    sheet.add_row    info.values
            # end    
            # sheet.column_info[0].hidden = hidden
    end
end