---
layout: page
---
{% include JB/setup %}

<div class="row">
  <div class="span8">
  <div id="home">
    <div id="post">
        {% for post in site.posts limit:3 %}
            <h3><a href="{{ post.url }}">{{ post.date | date_to_string }} : {{ post.title }}</a></h3>
            {{ post.content }}
            <br>
            <a href="{{ post.url }}">comments &raquo;</a>
            <br>
            <hr style="border: 1px; border-color: #cccccc; border-style: dashed; ">
            <br>
        {% endfor %}
    </div>

    <div>
        <br>
        <h2>Blog Posts (last 10)</h2>
        <ul class="posts">
            {% for post in site.posts limit:10 %}
              <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a> <br>
                  {{ post.info }}</li>
            {% endfor %}
        </ul>
        <br>
        <b><a href="all.html">... all posts &raquo;</a></b>
    </div>
  </div>
  </div>
  <div class="span4">
  </div>
</div>
