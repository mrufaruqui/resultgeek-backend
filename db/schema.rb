# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181021060458) do

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "code"
    t.integer "credit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_type", limit: 1, default: 0
    t.integer "sl_no"
  end

  create_table "depts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
  end

  create_table "exams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "sem", limit: 1, default: 0
    t.string "year"
    t.integer "program", limit: 1, default: 0
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.integer "program_type", limit: 1
    t.index ["uuid"], name: "index_exams_on_uuid", unique: true
  end

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "roll"
    t.integer "hall"
    t.string "hall_name"
    t.float "gpa", limit: 24
    t.integer "status", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float "assesment", limit: 24
    t.float "attendance", limit: 24
    t.float "section_a_marks", limit: 24
    t.float "section_b_marks", limit: 24
    t.float "total_marks", limit: 24
    t.string "gpa"
    t.float "grade", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "section_a_code"
    t.string "section_b_code"
    t.bigint "student_id"
    t.bigint "course_id"
    t.string "marks"
    t.string "remarks"
    t.float "percetage", limit: 24
    t.float "cact", limit: 24
    t.string "exam_uuid"
    t.index ["course_id"], name: "index_summations_on_course_id"
    t.index ["student_id"], name: "index_summations_on_student_id"
  end

  create_table "tabulation_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "summation_id"
    t.bigint "tabulation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["summation_id"], name: "index_tabulation_details_on_summation_id"
    t.index ["tabulation_id"], name: "index_tabulation_details_on_tabulation_id"
  end

  create_table "tabulations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "student_id"
    t.float "gpa", limit: 24
    t.float "tce", limit: 24
    t.string "result"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_tabulations_on_student_id", unique: true
  end

  create_table "teachers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "fullname"
    t.integer "designation", limit: 1, default: 0
    t.bigint "dept_id"
    t.string "address"
    t.string "email"
    t.integer "phone"
    t.integer "status", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sl_no"
    t.index ["dept_id"], name: "index_teachers_on_dept_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "workforces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "role", default: "member"
    t.integer "status"
    t.string "exam_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exam_id"
    t.bigint "teacher_id"
    t.index ["exam_id"], name: "index_workforces_on_exam_id"
    t.index ["teacher_id"], name: "index_workforces_on_teacher_id"
  end

  add_foreign_key "tabulation_details", "summations"
  add_foreign_key "tabulation_details", "tabulations"
  add_foreign_key "tabulations", "students"
  add_foreign_key "teachers", "depts"
end
