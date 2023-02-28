# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_20_140916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_workforces", force: :cascade do |t|
    t.string "exam_uuid"
    t.bigint "course_id"
    t.bigint "teacher_id"
    t.integer "status", limit: 2, default: 0
    t.integer "role", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_workforces_on_course_id"
    t.index ["teacher_id"], name: "index_course_workforces_on_teacher_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.integer "credit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_type", limit: 2, default: 0
    t.integer "sl_no"
    t.string "exam_uuid"
    t.bigint "exam_id"
    t.index ["exam_id"], name: "index_courses_on_exam_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "depts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "institute"
    t.string "institute_code"
  end

  create_table "docs", force: :cascade do |t|
    t.string "exam_uuid"
    t.string "uuid"
    t.string "latex_name"
    t.string "latex_loc"
    t.string "pdf_name"
    t.string "pdf_loc"
    t.string "xls_name"
    t.string "xls_loc"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "latex_str"
    t.binary "pdf_str"
  end

  create_table "exams", force: :cascade do |t|
    t.string "year"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "held_in"
    t.string "uuid"
    t.integer "sem", limit: 2, default: 0
    t.integer "program", limit: 2, default: 0
    t.integer "program_type", limit: 2, default: 0
    t.bigint "dept_id"
    t.index ["dept_id"], name: "index_exams_on_dept_id"
    t.index ["uuid"], name: "index_exams_on_uuid", unique: true
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "student_id"
    t.integer "student_type", limit: 2, default: 0
    t.string "course_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "exam_uuid"
    t.integer "sl_no"
    t.index ["exam_id"], name: "index_registrations_on_exam_id"
    t.index ["student_id"], name: "index_registrations_on_student_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "exam_uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_uuid"], name: "index_sessions_on_exam_uuid"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
    t.index ["uuid"], name: "index_sessions_on_uuid", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.integer "roll"
    t.integer "hall"
    t.string "hall_name"
    t.float "gpa"
    t.integer "status", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "summations", force: :cascade do |t|
    t.float "assesment"
    t.float "attendance"
    t.float "section_a_marks"
    t.float "section_b_marks"
    t.float "total_marks"
    t.string "gpa"
    t.float "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "section_a_code"
    t.string "section_b_code"
    t.bigint "student_id"
    t.bigint "course_id"
    t.string "marks"
    t.string "remarks"
    t.float "percetage"
    t.float "cact"
    t.string "exam_uuid"
    t.integer "record_type", limit: 2, default: 0
    t.index ["course_id"], name: "index_summations_on_course_id"
    t.index ["student_id"], name: "index_summations_on_student_id"
  end

  create_table "tabulation_details", force: :cascade do |t|
    t.bigint "summation_id"
    t.bigint "tabulation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["summation_id"], name: "index_tabulation_details_on_summation_id"
    t.index ["tabulation_id"], name: "index_tabulation_details_on_tabulation_id"
  end

  create_table "tabulations", force: :cascade do |t|
    t.integer "student_roll"
    t.float "gpa"
    t.float "tce"
    t.string "result"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "record_type", limit: 2, default: 0
    t.integer "sl_no"
    t.string "exam_uuid"
    t.integer "student_type", limit: 2, default: 0
    t.string "hall_name"
    t.float "tps", default: 0.0
    t.index ["student_roll", "exam_uuid", "record_type"], name: "registered_student_record"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "title"
    t.string "fullname"
    t.integer "designation", limit: 2, default: 0
    t.bigint "dept_id"
    t.string "address"
    t.string "email"
    t.integer "phone"
    t.integer "status", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sl_no"
    t.index ["dept_id"], name: "index_teachers_on_dept_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.bigint "exam_id"
    t.string "exam_uuid"
    t.datetime "login_time"
    t.datetime "logout_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_tenants_on_exam_id"
    t.index ["exam_uuid"], name: "index_tenants_on_exam_uuid"
  end

  create_table "users", force: :cascade do |t|
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
    t.string "exam_uuid"
    t.string "session_uuid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["session_uuid"], name: "index_users_on_session_uuid"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "workforces", force: :cascade do |t|
    t.integer "status"
    t.string "exam_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exam_id"
    t.bigint "teacher_id"
    t.integer "role", limit: 2, default: 0
    t.index ["exam_id"], name: "index_workforces_on_exam_id"
    t.index ["teacher_id"], name: "index_workforces_on_teacher_id"
  end

  add_foreign_key "course_workforces", "courses"
  add_foreign_key "course_workforces", "teachers"
  add_foreign_key "registrations", "exams"
  add_foreign_key "registrations", "students"
  add_foreign_key "tabulation_details", "summations"
  add_foreign_key "tabulation_details", "tabulations"
  add_foreign_key "teachers", "depts"
  add_foreign_key "tenants", "exams"
end
