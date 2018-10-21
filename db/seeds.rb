# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#User.create(email: 'user@example.com', nickname: 'UOne', name: 'User One', password: "monkey67")
#Course.delete_all
# Course.create(code:'CSE111',	title:'Introduction to Computer Systems and Computing Agents', credit:3)
# Course.create(code:'CSE113',	title:	'Structured Programming Language', credit: 3)
# Course.create(code:'CSE114',	title:	'Structured Programming Language Lab', credit:2)
# Course.create(code:'EEE121',	title:	'Electrical Engineering', credit: 3)
# Course.create(code:'EEE122',	title:	'Electrical Engineering Lab', credit:1)
# Course.create(code:'MAT131',	title:	'Matrices, Vector Analysis and Geometry', credit:3)
# Course.create(code:'STA151',	title:	'Basic Statistics', credit:	3)
Course.find_by(code:'CSE111').update(sl_no:1)
Course.find_by(code:'CSE113').update(sl_no:2)
Course.find_by(code:'CSE114').update(sl_no:3)
Course.find_by(code:'EEE121').update(sl_no:4)
Course.find_by(code:'EEE122').update(sl_no:5)
Course.find_by(code:'MAT131').update(sl_no:6)
Course.find_by(code:'STA151').update(sl_no:7)
Dept.create(code:'CSE', name:'Computer Science and Engineering')