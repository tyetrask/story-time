## Story Time

Story Time is a developer-focused interface to popular project management tracking tools (such as Pivotal Tracker). It has a minimalistic interface allowing the developer to focus on the task at hand. It also adds additional time tracking to use for billing or to provide feedback on story estimation.

This project is currently using Ruby 2.3, Rails 5.0, and React 15.3.

To create the development environment:
```
$ vagrant up
$ vagrant ssh
$ bundle install
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

And finally, start the development server:
```
$ rails s
```

<!--
TODO Complete the following information:

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

-->
