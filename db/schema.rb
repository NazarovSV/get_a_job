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

ActiveRecord::Schema.define(version: 20_230_317_151_611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'category_translations', force: :cascade do |t|
    t.bigint 'category_id', null: false
    t.string 'locale', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'name', null: false
    t.index ['category_id'], name: 'index_category_translations_on_category_id'
    t.index ['locale'], name: 'index_category_translations_on_locale'
  end

  create_table 'cities', force: :cascade do |t|
    t.string 'name', null: false
    t.bigint 'country_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['country_id'], name: 'index_cities_on_country_id'
  end

  create_table 'countries', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'currencies', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'code', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'employees', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_employees_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_employees_on_reset_password_token', unique: true
  end

  create_table 'employers', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_employers_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_employers_on_reset_password_token', unique: true
  end

  create_table 'exchange_rates', force: :cascade do |t|
    t.bigint 'from_currency_id', null: false
    t.bigint 'to_currency_id', null: false
    t.float 'rate'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['from_currency_id'], name: 'index_exchange_rates_on_from_currency_id'
    t.index ['to_currency_id'], name: 'index_exchange_rates_on_to_currency_id'
  end

  create_table 'experience_translations', force: :cascade do |t|
    t.bigint 'experience_id', null: false
    t.string 'locale', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'description', null: false
    t.index ['experience_id'], name: 'index_experience_translations_on_experience_id'
    t.index ['locale'], name: 'index_experience_translations_on_locale'
  end

  create_table 'experiences', force: :cascade do |t|
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'locations', force: :cascade do |t|
    t.bigint 'country_id', null: false
    t.bigint 'city_id', null: false
    t.bigint 'vacancy_id', null: false
    t.string 'address'
    t.float 'latitude'
    t.float 'longitude'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['city_id'], name: 'index_locations_on_city_id'
    t.index ['country_id'], name: 'index_locations_on_country_id'
    t.index ['vacancy_id'], name: 'index_locations_on_vacancy_id'
  end

  create_table 'responses', force: :cascade do |t|
    t.bigint 'employee_id'
    t.bigint 'vacancy_id'
    t.string 'email', null: false
    t.string 'phone'
    t.string 'resume_url', null: false
    t.string 'covering_letter'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['employee_id'], name: 'index_responses_on_employee_id'
    t.index ['vacancy_id'], name: 'index_responses_on_vacancy_id'
  end

  create_table 'vacancies', force: :cascade do |t|
    t.string 'title', null: false
    t.string 'description', null: false
    t.string 'email', null: false
    t.string 'phone'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'employer_id', null: false
    t.string 'state'
    t.bigint 'category_id', null: false
    t.integer 'salary_min'
    t.integer 'salary_max'
    t.bigint 'currency_id'
    t.bigint 'experience_id', null: false
    t.integer 'usd_salary_min'
    t.integer 'usd_salary_max'
    t.index ['category_id'], name: 'index_vacancies_on_category_id'
    t.index ['currency_id'], name: 'index_vacancies_on_currency_id'
    t.index ['employer_id'], name: 'index_vacancies_on_employer_id'
    t.index ['experience_id'], name: 'index_vacancies_on_experience_id'
  end

  add_foreign_key 'cities', 'countries'
  add_foreign_key 'exchange_rates', 'currencies', column: 'from_currency_id'
  add_foreign_key 'exchange_rates', 'currencies', column: 'to_currency_id'
  add_foreign_key 'locations', 'cities'
  add_foreign_key 'locations', 'countries'
  add_foreign_key 'locations', 'vacancies'
  add_foreign_key 'vacancies', 'categories'
  add_foreign_key 'vacancies', 'currencies'
  add_foreign_key 'vacancies', 'employers'
  add_foreign_key 'vacancies', 'experiences'
end
