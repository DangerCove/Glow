---
layout: page
---

<ol class="updates">
{% for post in site.posts %}
<li>
  <h2>Version {{ post.version }}{% if post.title %} ({{ post.title }}){% endif %}</h2>
  {% if post.beta %}<p class="build">Build {{ post.bundle }}</p>{% endif %}
  <p class="date">{{ post.date | date: "%-d %B %Y" }}</p>
  {{ post.content }}
</li>
{% endfor %}
</ol>
