### Familyable

This gem makes creating self-referential parent child relationships on a model easy. So for a `Person` model you have `person.parent` and `person.children` where the parent and children are also people.

You also get the following instance methods:

* decendents
* elders
* siblings
* family    
* master  *- the 'oldest' in the family*

and the class method:

* masters *- everyone without a parent*

Standard stuff I know but...
##### Everyone of the methods above works with a single call to the data base!!!

This is a **huge** performance gain.  In fact, being able build the above methods with a single database call was the entire motivation for gemifiying something that otherwise was entirely straight forward.  It should be noted that this was built the day after reading [this](http://hashrocket.com/blog/posts/recursive-sql-in-activerecord).

-----------------------------------------------------------

##### WARNING: This project is still in development
    [x] create relationship concern
    [ ] create generators for relationship models
    [ ] tests tests tests

### Requirments

You must be using a postgres data base... thats where the single-db-query magic happens.

### Installation

...

### Usage

quick note: all the instance methods above (accept for master) take an optional parameter *include\_self=false*.  it does what you exactly what you think.

