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
        <b><a href="/archive.html">... all posts &raquo;</a></b>
    </div>
  </div>
  </div>
  <div class="span4">
    <a href="/about.html"><img id="math" src="/mathieu-avatar.jpg"></img></a>
    <h3><a href="/about.html">About Mathieu ANCELIN</a></h3>
    <h4><a href="https://github.com/mathieuancelin/mathieuancelin.github.com/issues/new"  target="_blank">Ask me anything</a></h4>
    <h4><a href="https://twitter.com/#!/TrevorReznik">@TrevorReznik</a></h4>
    <h4><a href="https://github.com/mathieuancelin">mathieuancelin on github</a></h4>
    <h4><a href="/atom.xml">RSS feed</a></h4>
    <h4><a href="/archive.html">All posts</a></h4>
    <h4><a href="/tags.html">Tags</a></h4>
    <hr>
    <div>
        <h3>Last Tweets</h3>
        <!--<ul class="posts" id="from_TrevorReznik"></ul>-->
        <table class="table table-striped" id="from_TrevorReznik">
        </table>
        </div>
        <hr>
  </div>
  <script type="text/javascript">
      /**clippy.load('Merlin', function(agent) {
        agent.show();
    });**/
  </script>
</div>
