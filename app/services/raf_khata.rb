class RafKhata
    def self.perform
        sql = """
        SELECT name, roll, hall_name, student_type 
        FROM students as s 
        INNER JOIN registrations as r 
        ON s.id = r.student_id 
        WHERE r.exam_uuid = '_sixthbsc2018'
        """ 

        ##Database result -- MySQL::Result Pg::Result
        r = ActiveRecord::Base.connection.execute(sql)
        ## Active record
         r = ActiveRecord::Base.connection.exec_query(sql)


        sql = """
                SELECT *
                FROM students as s 
                INNER JOIN tabulations as t
                INNER JOIN tabulation_details as td
                ON s.roll = t.student_roll and
                t.id = td.tabulation_id
                WHERE t.exam_uuid = '_sixthbsc2018'
        """ 
    end

    def self.sit_for_exam? course_id
        sql = """
        SELECT name, roll,attendance, assesment, cact, section_a_marks, section_b_marks, marks
        FROM students as s 
        INNER JOIN registrations as r 
        INNER JOIN summations as sm
        ON s.id = r.student_id and
           r.student_id = sm.student_id and
           sm.course_id = #{course_id}
        WHERE r.exam_uuid = '_sixthbsc2018'
        """ 
        r = ActiveRecord::Base.connection.exec_query(sql)
        r
    end
end
