# 12/03/2017 Mono/multi repositories approach in organizing your code base

In this post I'll describe my experience in the field of organizing the source code. Mainly, it will be a comparison
of the two architectures or approaches, as you like to say, for solving a very common problem in software development.
We can start by introducing both of them.

Multirepo architecture is the way of organizing your source code by splitting it into independent repos. So each
project/library/package should be kept in its own place - it usually means that tests and other code checkers, CI
pipeline, documentation are also separated and belong to a special project. One might think that it's similar to
the microservices concept or unix utilities that are built for doing one thing well and nothing more or tiny npm packages
that you can use as bricks to construct something. But actually multirepo is a different thing - it's about code inclusively,
the way to manage your code but not distribute it and share instances or results of your development.

As opposed to multirepo, monorepo is a monolith. All your code and tools live in one repository.
It’s up to you how to organize stuff. There are no restrictions and you're free to choose  how to split the code
inside. There is a stereotype that monolithic apps are bad and building them is considered bad practice especially nowadays.
So there is kind of skepticism about everything with prefix `mono`. But as i said before, mono/multi-repo doesn't restrict
spreading and running your programs. It means that you can keep multiple projects in one monolithic repo.

Lets try to come up with advantages and drawbacks of each.

## Multirepo

Pros:

 - push developers away from monolithic monsters to micro-programs. I cannot name it `microservices` because it's not only
 about them. So it's kind of motivation or natural restriction for writing smaller programs and tools.
 - development workflow is faster. Tests and other checks are faster because they're smaller because of less code base
 - clearer commits history. It means that you know that every commit was specially made for that program
 - potentially less messy docs - again, because the existing documentation is devoted to one thing
 - good to promote in open source

Cons:

 - duplication of settings, docs, tools. For example you have to create a special pipeline for each project.
 - necessity to create and support a lot of repos. It can take time because, usually, a limited group of people are able to do it

## Monorepo

Pros:

 - share common stuff for development environment - test runner, linter, common dependencies, union CI, bundlers, etc.
 So uniform development medium.
 - source code of programs is in one place and it's easier to navigate and work with
 - easier to start working on a new program. In practice, it means to create a special folder in filesystem
 - it pushes you to integrate pieces more often because of all the tests running together.
 - you can easily make the changes in different pieces in one commit

Cons:
 - it takes more time to perform the tests and other checks
 - more complicated CI pipeline because it should know how to build multiple pieces in one place
 - slower builds. Again, because you need to execute more checkouts and, probably, build more than one piece

## Real world examples and links

Multirepo

 - https://github.com/webpack
 - https://github.com/npm

Monorepo

 - https://github.com/react-cosmos/react-cosmos
 - https://github.com/googleapis/googleapis
 - http://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext

