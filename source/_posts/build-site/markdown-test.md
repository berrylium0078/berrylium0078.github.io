---
title: Test Page for Pandoc's Markdown
date: 2025-07-20 11:15:55
tags:
categories: "build site"
description: "This page test functionality of pandoc flavored markdown syntax, including fancy ordered lists, grid tables, footnotes, etc."
---

## Headings

### Attributes { #attr}

[Explicit](#attr) and [Implicit][Attributes] references.

    [Explicit](#attr) and [Implicit][Attributes] references.

## Code blocks

### Indented code blocks

    if (a > 3) {
        moveShip(5 * gravity, DOWN);
    }

### Fenced code blocks

```cpp
#include <bits/stdc++.h>
int main() {
    if (1 <= 2) {
        return 0;
    } else {
        return 1;
    }
}
```

Use Hexo's inline tag plugin [*codeblock*](https://hexo.io/docs/tag-plugins#Code-Block) instead of pandoc extension *fenced_code_attributes*.

{% code aha lang:cpp http://bing.com "Link to Bing" mark:100,103-104,105 first_line:100 %}
int main() {
    int argc;
    if (true) {
        return 0;
    } else {
        return 1;
    }
}
{% endcode %}


```markdown
{% code aha lang:cpp http://bing.com "Link to Bing" mark:100,103-104,105 first_line:100 %}
{% endcode %}
```


## Line blocks

| The Right Honorable Most Venerable and Righteous Samuel L.
  Constable, Jr.
| 200 Main St.
| Berkeley, CA 94718

## Lists

### Bullet list

* here is my first
list item.
* and my second.

<!----->

* here is my second list item.

<!----->

    * here is my first
    list item.

    * and my second.

    <!-- to end a list, add a HTML comment like this -->

    * here is my second list item.

### Ordered lists

1. Arabic numerals
#. Second.
i. Roman numerals
#. Second.
a. Lowercase letters
#. Second.
A.  Uppercase letters need two spaces.
#.  Second.
(A) Parentheses enclosed uppercase letters
(#) Second.
A) Right parentheses uppercase letters
B) Second.

<!---->

    1. Arabic numerals
    #. Second.
    i. Roman numerals
    #. Second.
    a. Lowercase letters
    #. Second.
    A.  Uppercase letters need two spaces.
    #.  Second.
    (A) Parentheses enclosed uppercase letters
    (#) Second.
    A) Right parentheses uppercase letters
    #) Second.

### Task lists

- [ ] an unchecked task list item
- [x] checked item 

### Definition lists

Term 1

:   Definition 1

Term 2 with *inline markup*

:   Definition 2

        { some code, part of Definition 2 }

### Example lists

(@)  My first example will be numbered (1).


#### some title...
some text...

(@)  My second example will be numbered (2).

<!---->

    (@)  My first example will be numbered (1).


    #### some title...
    some text...

    (@)  My second example will be numbered (2).

## Tables

: Sample grid table.

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+

: Grid table with row & column spans

+---------------------+----------+
| Property            | Earth    |
+=============+=======+==========+
|             | min   | -89.2 °C |
| Temperature +-------+----------+
| 1961-1990   | mean  | 14 °C    |
|             +-------+----------+
|             | max   | 56.7 °C  |
+-------------+-------+----------+

: Tic-Tac-Toe

+---+---+---+
| x | o |   |
+---+---+---+
| o | x | x |
+---+---+---+
| x |   | o |
+---+---+---+

: Sample pipe table.

| Right | Left | Default | Center |
|------: | :----- | --------- | :------: |
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |


| a | b |
|---|---|
| a | b |



```markdown
: Sample grid table.

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+

: Grid table with row & column spans

+---------------------+----------+
| Property            | Earth    |
+=============+=======+==========+
|             | min   | -89.2 °C |
| Temperature +-------+----------+
| 1961-1990   | mean  | 14 °C    |
|             +-------+----------+
|             | max   | 56.7 °C  |
+-------------+-------+----------+

: Tic-Tac-Toe

+---+---+---+
| x | o |   |
+---+---+---+
| o | x | x |
+---+---+---+
| x |   | o |
+---+---+---+

: Sample pipe table.

| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |
```

## Formatting

This text is _emphasized with underscores_, and this
is *emphasized with asterisks*.

This is **strong emphasis** and __with underscores__.

feas*ible*, not feas*able*

This ~~is deleted text.~~

H~2~O is a liquid. 2^10^ is 1024.

==Marked text==

[underline]{.underline}


    This text is _emphasized with underscores_, and this
    is *emphasized with asterisks*.

    This is **strong emphasis** and __with underscores__.

    feas*ible*, not feas*able*

    This ~~is deleted text.~~

    H~2~O is a liquid. 2^10^ is 1024.

    ==Marked text==

    [underline]{.underline}

## Verbatim

`int main()`{.hljs .cpp} (inline code blocks do not support syntax highlighting) `` `int main()`{.hljs .cpp} ``

## Links

### Automatic links

<https://google.com>

    <https://google.com>

### Reference links

[Link1][my label 1] [Link2][my label 2] [Link3][My LaBeL 3]

[my label 1]: https://fsf.org
"The Free Software Foundation"
[my label 2]: <https://fsf.org> "The Free Software Foundation"
[my label 3]: https://fsf.org (The Free Software Foundation)

    [Link1][my label 1] [Link2][my label 2] [Link3][My LaBeL 3]

    [my label 1]: https://fsf.org
    "The Free Software Foundation"
    [my label 2]: <https://fsf.org> "The Free Software Foundation"
    [my label 3]: https://fsf.org (The Free Software Foundation)


## Images

Image: ![image](/img/butterfly-icon.png){height=150px}

Inline image: {% inlineImg /img/butterfly-icon.png 150px %}

    Image: ![image](/img/butterfly-icon.png){height=150px}

    Inline image: {% inlineImg /img/butterfly-icon.png 150px %}

## Divs and spans

::: Warning ::::::
This is a warning.

::: Danger
This is a warning within a warning.
:::
::::::::::::::::::

[This is *some text*]{.class key="val"}

## Foot notes

Here is a footnote reference,[^1] and another.[^longnote]

[^1]: Here is the footnote.

[^longnote]: Here's one with multiple blocks.

    Subsequent paragraphs are indented to show that they
belong to the previous footnote.

        { some.code }

    The whole paragraph can be indented, or just the first
    line. In this way, multi-paragraph footnotes work like
    multi-paragraph list items.

Here is an inline note.^[Inline notes are easier to write, since
you don't have to pick an identifier and move down to type the
note.]


```markdown
Here is a footnote reference,[^1] and another.[^longnote]

[^1]: Here is the footnote.

[^longnote]: Here's one with multiple blocks.

    Subsequent paragraphs are indented to show that they
belong to the previous footnote.

    ...

Here is an inline note.^[Inline notes are ...]
```
