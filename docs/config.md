<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->
@def website_title = "TLDR.jl"
@def website_descr = "Julia snippets"
@def website_url   = "https://abelsiqueira.github.io/TLDR.jl/"
@def prepath = "TLDR.jl"
@def div_content = "container"

@def author = "Abel Soares Siqueira"

@def mintoclevel = 2

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
@def ignore = ["node_modules/", "franklin", "franklin.pub", ".history/", ".vscode/", "_sass/"]

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
\newcommand{\notification}[2]{
~~~
<div class="notification #1">
~~~
#2
~~~
</div>
~~~
}