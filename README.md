# Get A Job

Проект представляет собой сайт по поиску работы или работников. Реализованы основные функции:
- Регистрация в качестве работодателя/соискателя
- Создание вакансии
- Отклик на вакансию
- Поиск вакансий по ключевым словам и фильтрам.

## Используемые технологии
- Ruby 3.1.2
- Ruby On Rails 6
- Postgresql
- BDD/TDD(Rspec/Capybara)
- Devise
- Pundit
- AASM
- pg_search
- Globalize
- Pagy

## Как запустить проект
Склонировать репозиторий:

    git clone https://github.com/NazarovSV/qna.git
  
Установить все зависимости с помощью команды:

    bundle install
  
Создать базу данных и выполнить миграции:

    bundle exec rails db:create
    bundle exec rails db:migrate
  
Запустить локальный сервер:

    bundle exec rails s
  
Открыть приложение в браузере по адресу http://localhost:3000.

## Как запустить тесты
Чтобы запустить тесты, необходимо выполнить команду:

    bundle exec rspec
