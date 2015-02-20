### Familyable

This gem makes creating self-referential parent child relationships on a model easy. So for a `Person` model you have `person.parent` and `person.children` where the parent and children are also people.

You also get the following instance methods:

* descendents
* elders
* siblings
* family    
* master  *- the 'oldest' in the family*

and the class method:

* masters *- everyone without a parent*

Standard stuff I know but...
##### Everyone of the methods above works with a single call to the data base!!!

This is a **[huge](https://github.com/brookisme/familyable-testapp)** performance gain.  In fact, being able build the above methods with a single database call was the entire motivation for gemifiying something that otherwise was entirely straight forward.  It should be noted that this was built the day after reading [this](http://hashrocket.com/blog/posts/recursive-sql-in-activerecord).

-----------------------------------------------------------

##### WARNING: This project is still in development
    [x] create relationship concern
    [X] create generators for relationship models
    [X] check that it works with engines
    [ ] generate data for testapp
    [ ] tests tests tests
    [ ] refactor concern
    [ ] add babies methods (class and instance)?


### Requirments

You must be using a postgres data base... thats where the single-db-query magic happens.

### Installation

Note: use with caution. This gem is still in developement

*Gemfile*
```
gem 'ng_on_rails'
```
```
$  bundle install
```

### Usage

-----------------------------------------------------------

Example: Adding Relationships to an existing `Person` model:

##### Step 1: Generate Relationship Model

```
$  bundle exec rails g familyable:relationships Person
$  bundle exec rake db:migrate
```

**Rails Engine Note**: For use with rails engines use the full model name from the the root of your Engine directory and require it in your engine.rb

```
$  bundle exec rails g familyable:relationships MyEngine::Person
```

*lib/engine_name/engine.rb*
```ruby
...
require 'familyable'
module EngineName
  class Engine < ::Rails::Engine
  ...
```

##### Step 2: Add Relationships Concern to Model

_app/models/person.rb_
```ruby
class Person < ActiveRecord::Base
    include Familyable::Relationships
    ...
end
```

##### Step 3: You're done! start coding

quick note: all the instance methods above (accept for master) take an optional parameter *include\_self=false*.  it does what you exactly what you think.

```ruby
Person.masters
person.master
person.descendents
person.descendents(true)
...
```