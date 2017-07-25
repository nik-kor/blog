# Why Elmlang is outstanding

![Elm logo](https://raw.githubusercontent.com/nik-kor/blog/master/images/elm-logo.svg)

There is a lot of buzz about Elm language right now. You can find tons of posts about the advantages of this language
by just googling it or going to http://elm-lang.org/ . I don't want to repeat this other information but will mention
the main features here just to build the context - so if you know something about Elm - it's fine to skip the next part.


## Elm main features

Elm is a statically typed purely functional programming language. Elm is compiled to javascript and officially works only
in the browser. It's possible to use it on the server but with some hacks and afaik there is no plans to support elm
for it - so very frontend specific tool.

Elm has no runtime exceptions after your program is compiled. It's like a mantra that elm's aficionados like to repeat
and it's true.

Elm has [a blazing fast rendering](http://elm-lang.org/blog/blazing-fast-html-round-two), the terse, clean, expressive
syntax that was inspired by Haskell. Probably, it's not advantageous (suitable) for everyone because the syntax can look weird the first time.

Elm has super friendly compiler errors and the compiler itself is your best friend.

Elm package system guarantees SemVer support - the feature I don't think exists in other package managers.

And finally it's pretty easy to embed elm programs into your code base and use browser API - some examples
[here](https://blog.reifyworks.com/javascript-interop-with-elm-using-ports-to-read-and-parse-csv-files-fef60c318b7a).


## Being functional

The functional approach is trendy in frontend world now and developers adapt and use truly functional features in
modern javascript.

It's important to support immutability. You can try to control it manually which does not protect you from some
weird bugs sometimes. Or you can use libraries like Immutable.js, it solves the problem but in my opinion exposes not so
convenient APIs to manipulate data. Of course, there are no variables in Elm(because it's a functional language)
and all is immutable by default.

I like Redux and think that it's a brilliant approach to organizing your data flow that scales. I've been using it in
my apps for more than 2 years and have been happy with it. The thing is elm has a built-in support of redux-like
architecture. So all of your programs, libraries, components should use the same way to handle data. Redux was inspired by Elm btw.

Elm is stricter in general. As an example, I'm totally fine with React but there is always a temptation to endue components with
the local state. Having such components leads you to a classical OOP approach with all its downsides. Of course, Elm
won't protect you from bad design decisions but it'd be much harder to implement them.

I missed ADS, curring, function composition syntax, pattern matching, etc in Javascript.
You can use libraries like [fantasyland](https://github.com/fantasyland) or wait for next ES initiative but again -
it's not elegant as in Elm.


## Types annotation and javascript

Types annotation can make your code easier to maintain - that means safe refactorings, code that is easier to read and
analyze. Also, it helps to catch errors earlier and supports you with better IDE hints/tips.

What are the alternatives to Elm if you want to type check your javascript? There are the well-known Typescript and Flow.
I don’t have experience using Flow, but I have used Typescript(TS) and we built applications that I believe still
work in production. And my overall experience and impression of it is very positive. As I know, Flow can have some
advantages but it alone with TS are more or less the same - you can find a nice comparison
[here](http://thejameskyle.com/adopting-flow-and-typescript.html).

So what's the advantage of Elm compared to these guys. The motto of TS says "Javascript that scales". I don't like
that TS is the good old JS with types. Don't get me wrong, I've been using JS for almost a decade and know the good
parts. But I also know the bad parts and personally I think that the JS as a language is far from perfect and has
some flawed features just by design. That means whatever new features you introduce to the language you won't fix the
basis and you need to support the heritage.

You can annotate your Elm program with types as well and keeping in mind that Elmlang is much better designed as a language
(my personal opinion) means that it can be a better alternative to Javascript.

I remember the words of Evan Czaplicki that it's not possible to compete with huge companies like Microsoft or Facebook
doing similar things. He said that even if you 10x programmer they have 50 good developers and so to beat them you need to
offer very unique features. So the unique feature of Elm in this context is that it is a totally different, modern,
well-designed language.

You can think about type annotation in Elm like a language inside a language. It's a product of decades of research in
computer science and it's inspired by Haskell.


## Personal motivation

I'm passionate about functional programming in general and think that it makes sense to use purely functional languages
to be better in FP. The classical candidate for it is Haskell. The problem is that Haskell is harder to use and it's only for
the server side. The Elmlang itself is kind of an adapted and simplified version of Haskell that can be used in the browser.
So Elmlang can be considered as a good opportunity to study FP in general and this knowledge can be implemented in more
hard-core stuff like haskell or the ideas can be ported into the javascript world.


## Can it be mainstream

If you don't, please watch this 2-year old video
["Let's be mainstream! User focused design in Elm - Curry On"](https://www.youtube.com/watch?v=oYk8CKH7OhE).

I asked the same question at the [Elm europe conference](https://elmeurope.org/) over and over again and one guy just
answered me with the question: "Isn't it already?". His answer was perfectly right because if we see how many people are
interested in it, contribute to the language, use it in production, compare the language to other rivals and just having
fun playing with it then (not than) it'd be ok to say "Elm is mainstream now".

Everything in the frontend universe is compiled to javascript - be it modern JS or fancy alternatives like PureScript.
So it doesn't make sense to be afraid of it and Elmlang in that context has its own niche  and could be something like
Ruby or Python to PHP very soon.
