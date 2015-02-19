# Familyable

*making families easy since some very recent date*  
-----------------------------------------------------------

This gem makes creating self-referential parent child relationships on a model easy. So for a `Person` model you have `person.parent` and `person.children` where the parent and child are also people.

You also get the following instance methods:
    * decendents(include_self=false)
    * elders(include_self=false)
    * siblings(include_self=false)
    * family(include_self=false)    
    * master  *- the 'oldest' in the family*
and the class method:
    * masters *- everyone without a parent*

Standard stuff I know but...
##### Everyone of the methods above works with a single call to the data base!!!

This is a **huge** performance gain.  In fact, being able build the above methods with a single database call was the entire motivation for gemifiying something that otherwise was entirely straight forward.  It should be noted that this was built the day after reading [this](http://hashrocket.com/blog/posts/recursive-sql-in-activerecord)

-----------------------------------------------------------

##### WARNING: This project is still in development
    [x] create relationship concern
    [ ] create generators for migration files
    [ ] tests tests tests

### Requirments

You must be using a postgres data base... thats where the single-db-query magic happens.

### Installation

...

### Usage

...

