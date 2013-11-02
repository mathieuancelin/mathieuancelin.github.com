---
layout: post
title: "Intoducing play2-couchbase"
description: ""
category: [Dev]
tags: [Play, Play framework, Play 2, Couchbase, Scala, Java, Async, Reactive]
---
{% include JB/setup %}

Some months ago, a friend of mine asked me if 

Introducing play2-couchbase
=================================

For several months now, I'm working on a project that is completely different from what I've done until now and today I'll try to show what it is.

At the beginning of the year, I had the opportunity to attend several presentation about Couchbase and I must say that the technology attracted me. But I didn't had the chance at the time to really dig into the project. A couple of month later, one of my colleague asked me about it and how to use it from a Play2 Scala application. I answered that the Java API should be enought, but I started thinking about it and how to integrate it into the reactive programming model of Play 2.

And that's how it begins, I started writing few classes to help integrate Couchbase into a Play 2 application and it became an actual Play2 plugin. 

This project aims to help you using Couchbase from a Play 2 app, use a reactive programming style to deal with this datastore and also improve your productivity as a Java or Scala developer. play2-couchbase is a pure reactive access layer to a Couchbase server and is designed to avoid any kind of blocking request. Every operation returns immediately, freeing the running thread and resuming execution when it is over. It allows you to stream data both into and from your Couchbase servers.

Using play2-couchbase
---------------------

If you want to start using the play2-couchbase plugin you need to install Play 2.2 (http://www.playframework.com/download) and of course a Couchbase server (http://www.couchbase.com/download).

Now, start your Couchbase server and create a new Play 2.2 application using the command `play new project-name`. Once it's done, the real works begin !!!

Project configuration
---------------------

To use the Couchbase plugin, you need to add it to your project dependencies. In your `build.sbt` file add dependencies and resolvers like :

```scala
name := "project-name"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
  cache,
  "org.ancelin.play2.couchbase" %% "play2-couchbase" % "0.6-SNAPSHOT"
)

resolvers += "play2-couchbase Repository" at "https://raw.github.com/mathieuancelin/play2-couchbase/master/repository/snapshots"

resolvers += "Spy Repository" at "http://files.couchbase.com/maven2"

play.Project.playScalaSettings
```

You also need to enable the plugin (or maybe you don't want to use it). To do that, you need to create (or edit) the `conf/play.plugins` file of your application and add the following line :

```
400:org.ancelin.play2.couchbase.CouchbasePlugin
```

And the last thing is to configure the connection to a Couchbase server (or more)

```

couchbase {
  buckets = [{
    host="127.0.0.1"
    port="8091"
    base="pools"
    bucket="bucketname"
    user="username"
    pass="password"
    timeout="0"
  }]
}

```

Now you can use the configured buckets (yes, you can configure more than one bucket, see, `couchbase.buckets` is an array of objects).

If you're lazy like me, you can also use a starter kit where almost everything is already done

* https://github.com/mathieuancelin/play2-couchbase/raw/master/repository/bin/couchbase-scala-starter.zip
* https://github.com/mathieuancelin/play2-couchbase/raw/master/repository/bin/couchbase-java-starter.zip
* https://github.com/mathieuancelin/play2-couchbase/raw/master/repository/bin/couchbase-crud-starter.zip

Just download the zip file, unzip it, change the app name/version in the `build.sbt` file and you're ready to go.

How to use it (from Scala)
---------------------------

Create a Scala controller and write something like :

```scala

import play.api.mvc.{Action, Controller}
import play.api.libs.json._
import org.ancelin.play2.couchbase.Couchbase
import org.ancelin.play2.couchbase.CouchbaseBucket
import org.ancelin.play2.couchbase.CouchbaseController
import play.api.Play.current
import play.api.libs.concurrent.Execution.Implicits._

case class User(name: String, surname: String, email: String)

object UserController extends Controller with CouchbaseController {

  implicit val userFmt = Json.format[User]

  def getUser(key: String) = CouchbaseAction("default") { bucket =>
    bucket.get[User](key).map { maybeUser =>
      maybeUser.map(user => Ok(views.html.user(user)).getOrElse(BadRequest(s"Unable to find user with key: $key"))
    }
  }
}

```

Here I use a special Controller `CouchbaseController` that allow the use of `CouchbaseAction("default")` that targets a bucket for the following block. Then I try to get a specific document that may or may not be here. As it returns a `Future`, I need to map It to transform it into an HTTP result. You can note that play2-couchbase automatically map a JSON document to a `User` instance. To do that I use an implicit Json formatter (`implicit val userReader = Json.reads[User]`) that can serialize and deserialize JSON documents to User instances. As it's async you also need to import or declare an implicit `ExecutionContext` to handle tasks (`import play.api.libs.concurrent.Execution.Implicits._`).

You can also use the API from elsewhere

```scala

import play.api.libs.json._
import org.ancelin.play2.couchbase.Couchbase
import org.ancelin.play2.couchbase.CouchbaseBucket
import play.api.Play.current
import play.api.libs.concurrent.Execution.Implicits._

case class User(id: String, name: String, age: Int) {
  def save(): Future[OperationStatus] = User.save(this)
  def remove(): Future[OperationStatus] = User.remove(this)
}

object User {

  implicit val userFmt = Json.format[User]

  def bucket = Couchbase.bucket("default")

  def findById(id: String): Future[Option[User]] = {
    bucket.get[User](id)
  }

  def findAll(): Future[List[User]] = {
    bucket.find[User]("users", "by_user")(new Query().setIncludeDocs(true).setStale(Stale.FALSE))
  }

  def findByName(name: String): Future[Option[User]] = {
    val query = new Query().setIncludeDocs(true).setLimit(1)
          .setRangeStart(ComplexKey.of(name))
          .setRangeEnd(ComplexKey.of(s"$name\uefff").setStale(Stale.FALSE))
    bucket.find[User]("users", "by_name")(query).map(_.headOption)
  }

  def save(user: User): Future[OperationStatus] = {
    bucket.set[User](beer)
  }

  def remove(user: User): Future[OperationStatus] = {
    bucket.delete(user)
  }
}

```

How to use it (from Java)
---------------------------

Create a Java controller and write something like :

```java

package controllers;

import models.ShortURL;
import org.ancelin.play2.java.couchbase.Couchbase;
import org.ancelin.play2.java.couchbase.CouchbaseBucket;
import play.libs.F;
import static play.libs.F.*;
import play.mvc.Controller;
import play.mvc.Result;

public class Application extends Controller {

    public static CouchbaseBucket bucket = Couchbase.bucket("default");

    public static class User {
        public String name;
        public String age
    }

    public static Promise<Result> getUser(final String key) {
        return bucket.getOpt(key, User.class).map(new Function<Option<User>, Result>() {
            @Override
            public Result apply(Option<User> maybeUser) throws Throwable {
                for (User user : maybeUser) {
                    return ok(views.html.user.render(user));
                }
                return badRequest("Unable to find user with key: " + key);
            }
        });
    }
}

```

Here I just get a Couchbase bucket with `Couchbase.bucket("default")` and in an action, I try to get a specific JSON object from Couchbase that may or may not be there `bucket.getOpt(key, User.class)`. This operation returns a Promise that I need to handle to return an HTTP result with the `map`function.

You can also use it elsewhere 

```java

package models;

import com.couchbase.client.protocol.views.ComplexKey;
import com.couchbase.client.protocol.views.Query;
import com.couchbase.client.protocol.views.Stale;
import net.spy.memcached.ops.OperationStatus;
import org.ancelin.play2.java.couchbase.Couchbase;
import org.ancelin.play2.java.couchbase.CouchbaseBucket;
import play.libs.F;
import static play.libs.F.*;

import java.util.Collection;

public class User {

    public String name;
    public Integer age;
    public String id;

    public User() {}

    public User(String name, Integer age) {
        this.id = UUID.randomUUID().toString();
        this.name = name;
        this.age = age;
    }

    public static CouchbaseBucket bucket = Couchbase.bucket("default");

    public static Promise<Option<User>> findById(String id) {
        return bucket.getOpt(id, User.class);
    }

    public static Promise<Collection<User>> findAll() {
        return bucket.find("shorturls", "by_user",
            new Query().setIncludeDocs(true).setStale(Stale.FALSE), User.class);
    }

    public static Promise<Option<User>> findByAge(Integer age) {
        Query query = new Query()
                .setLimit(1)
                .setIncludeDocs(true)
                .setStale(Stale.FALSE)
                .setRangeStart(ComplexKey.of(age))
                .setRangeEnd(ComplexKey.of(age));
        return bucket.find("users", "by_age", query, User.class)
                .map(new Function<Collection<User>, Option<User>>() {
            @Override
            public Option<ShortURL> apply(Collection<User> users) throws Throwable {
                if (users.isEmpty()) {
                    return Option.None();
                }
                return Option.Some(users.iterator().next());
            }
        });
    }

    public static Promise<OperationStatus> save(User user) {
        return bucket.set(user.id, user);
    }

    public static Promise<OperationStatus> remove(User user) {
        return bucket.delete(user.id);
    }
}

```

In the `User` class you can see how to use Couchbase queries from play2-couchbase.

And what about streaming ???
-------------------------------

Unfortunatelly, built-in streaming feature are only available from Scala. 

Streaming features makes heavy use of play Iteratee library. If you're not familiar with this programming model, you can read more about it at http://www.playframework.com/documentation/2.2.x/Iteratees

Streaming in
-------------

You can stream data in you Couchbase server (here I create an enumerator of tuple(ID, VALUE))

```scala 

def bucket = Couchbase.bucket("default")

val enumerator = Enumerator(
    ("user1", Json.obj("name" -> "mathieu", "age" -> 27, "id" -> "user1")), 
    ("user2", Json.obj("name" -> "mathieu", "age" -> 27, "id" -> "user2")), 
    ("user3", Json.obj("name" -> "mathieu", "age" -> 27, "id" -> "user3")), 
)

bucket.addStream[JsObject](enumerator).map(_ => println("it's done"))
```

Streaming out
-------------

You can stream out documents from multiple keys with 

```scala 

import org.ancelin.play2.couchbase.CouchbaseRWImplicits._
import play.api.libs.concurrent.Execution.Implicits._

object UserController extends Controller {

    def bucket = Couchbase.bucket("default")
    
    def users1 = Action.async {
        val enumerator = bucket.fetchValues[JsValue](Seq("user1", "user2", "user3")).enumerate
        enumerator.map( Ok.chunked( _ ) )
    }

    def users2 = Action.async {
        val keysEnumerator = Enumerator("user1", "user2", "user3")
        val enumerator = bucket.fetchValues[JsValue](keysEnumerator).enumerate
        enumerator.map( Ok.chunked( _ ) )
    }
}

```

or from a query 

```scala 

import org.ancelin.play2.couchbase.CouchbaseRWImplicits._
import play.api.libs.concurrent.Execution.Implicits._

object UserController extends Controller {

    def bucket = Couchbase.bucket("default")
    
    def users1 = Action.async {
        val enumerator = bucket.searchValues[JsValue]("users", "by_user")(new Query().setIncludeDocs(true).setStale(Stale.FALSE)).enumerate        
        enumerator.map( Ok.chunked( _ ) )
    }
}

```

Capped buckets and tailable queries
-----------------------------------

play2-couchbase provides a way to simulate capped buckets (http://docs.mongodb.org/manual/core/capped-collections/). 
You can see a capped bucket as a circular buffer. Once the buffer is full, the oldest entry is removed from the bucket.

Here, the bucket isn't really capped at couchbase level. It is capped at play2-couchbase level.
You can use a bucket as a capped bucket using :

```scala

def bucket = Couchbase.cappedBucket("default", 100) // here I use the default bucket as a capped bucket of size 100
```

of course, only data inserted with this `CappedBucket` object are considered for capped bucket features.

```scala

val john = Json.obj("name" -> "John", "fname" -> "Doe")

for (i <- 0 to 200) {
    bucket.insert(UUID.randomUUID().toString, john)
}
// still 100 people in the bucket (and possibly other data inserted with standard API)
```

You can also insert data coming from an Enumerator.

When a json object is inserted, a timestamp is add to the object and this timestamp will be used to manage all the capped bucket features.

The nice part with capped buckets is the `tail` function. It's like using a `tail -f`command on the datas of the capped bucket

```scala

object MyController extends Controller {

    def tailf = Action.async {
        val enumerator1 = bucket.tail[JsValue]()
        val enumerator2 = bucket.tail[JsValue](1265457L) // start to read data from 1265457L timestamp
        val enumerator3 = bucket.tail[JsValue](1265457L, 200, TimeUnit.MILLISECONDS) // update every 200 milliseconds
        enumerator1.map( Ok.chunked( _ ) )
    }
}
```

--------------------

That's all for today.

In a future post, I will introduce all the goodies provided by play2-couchbase to improve the developer experience.







