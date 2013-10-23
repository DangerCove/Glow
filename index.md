---
layout: page
title: Tapetrap for Mac Updates
---

<ol class="updates">
{% for post in site.posts %}
<li>
  <h2>Version {{ post.version }}{% if post.title %} ({{ post.title }}){% endif %}</h2>
  <p class="date">{{ post.date | date: "%-d %B %Y" }}</p>
  {{ post.content }}
</li>
{% endfor %}
</ol>