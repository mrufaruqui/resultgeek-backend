class ResultMailerJob < ApplicationJob
  queue_as :default

  def perform(options)
    email = Hash.new
    email[:recipents ] = options[:result][:email] #"kazi.ashrafuzzaman@gmail.com;rokan@cu.ac.bd;rudra@cu.ac.bd;sohelcu.cse@gmail.com"
    email[:subject] = "#{options[:exam].fullname} : Unofficial Result"
    email[:body] = email_body options
    ResultMailer.email_indiviual_result(email).deliver unless email[:recipents ].blank?
  end

  def email_body (options) 
   result = options[:result]
   first = ''
   first << <<-EOF 
     <html> 
     <style>
     tr:nth-child(even) {
  background-color: #D6EEEE;
}
table, th, td {
  border: 1px solid black;
  border-radius: 10px;
} 
</style>
</head>
     <body>
      Dear #{result[:name]},<br></br>

      <i> The following is a preliminary, informal result calculated on the basis of the marks you were given by the examiners in the . Be warned, however, that there is no guarantee at this point that the calculations are entirely correct and you are entitled to this result. All relevant results, including yours, are still under scrutiny and audit by the
      exam committee, and corrections are in order whenever errors in the associated data are found. The Controller of Examinations is set to receive the results from the exam committee before sending their signed copies to
      the office of your residential Hall. You are meant to receive your official results from there in a day or two. </i>
      <br></br>
       <center>
        <h4>Department of Computer Science and Engineering</h4>
         <h3> University of Chittagong </h3>
        <h4>#{options[:exam].fullname}</h4>
      </center>

      <table style="width:40%">
       <tr> <td>Name:</td> <td> <strong> #{result[:name]} </strong> </td></tr>
       <tr> <td>ID:</td> <td> <strong> #{result[:roll]} </strong></td></tr>
       <tr> <td> Hall: </td> <td> <strong>#{result[:hall]}</strong></td></tr>
      </table>
          <br></br>
       <table style="width:75%; border: 1px solid black;text-align:center">
        <tr style="border: 1px solid black;">
        <th style="border: 1px solid black;">Course Code</th>
        <th style="border: 1px solid black;">Course Title</th>
        <th style="border: 1px solid black;">Credits</th>
        <th style="border: 1px solid black;">Letter Grade</th>
        <th style="border: 1px solid black;">Grade Point</th>
        <th style="border: 1px solid black;">Point Secured</th>
        </tr>
        EOF
       
       second = ''
        result[:courses].each do |course|
          second << 
          <<-EOF
          <tr style="border: 1px solid black;">
          <td style="border: 1px solid black;"> #{course[:code]} </td>
          <td style="border: 1px solid black;text-align:left"> #{course[:title]} </td>
          <td style="border: 1px solid black;"> #{course[:credit]} </td>
          <td style="border: 1px solid black;"> #{course[:lg]}  </td>
          <td style="border: 1px solid black;"> #{'%.2f' % course[:gp]}</td>
          <td style="border: 1px solid black;">#{'%.2f' % course[:ps]}</td>
          </tr> 
          EOF

        end
      third = ''
      third << 
      <<-EOF
       </table> 
       <br></br>
       <table style="width:30%">
          <tr> <td>Total Credits Earned (TCE)</td><td style="border: 1px solid black;text-align:center"><strong>#{result[:tce]}</strong></td></tr>
          <tr> <td>Total Points Secured (TPS)</td><td style="border: 1px solid black;text-align:center"><strong>#{result[:tps]}</strong></td></tr>
          <tr> <td>Grade Point Average (GPA)</td><td style="border: 1px solid black;text-align:center"><strong>#{'%.2f' % result[:gpa]}</strong></td></tr> 
          <tr> <td>Result</td><td style="border: 1px solid black;text-align:center"><strong>#{result[:result]}</strong></td></tr>
          <tr> <td>Remarks</td><td><strong>#{result[:remarks]}</strong></td></tr>
       </table>
       <br></br>
       Best Regards,
       <h4>Chairman of the Exam Committee</h4>
      </body>
     </html>
   EOF
   first + second + third
end
end
