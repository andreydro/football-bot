### Description

This Rails application provides Telegram Bot functionality and has the following features:

- Register and ban users
- Create a football match
- Join a football match (personally and with a friend)
- Leave football match
- Send reminders before the match

Additionally, the application has a web admin dashboard that helps to manage records.

### Requirements

To run the application locally you need:

-   Ruby 2.7.2

-   bundler -  `gem install bundler`

-   Redis - For Sidekiq

-   PostgreSQL -  `brew install postgresql`

-   Yarn -  `brew install yarn`  or  [Install Yarn](https://yarnpkg.com/en/docs/install)

- Add Telegram Token to `credentials.yml.enc`
