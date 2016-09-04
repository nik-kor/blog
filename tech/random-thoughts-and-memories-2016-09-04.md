# Random thoughts and memories

I haven't written for a long time on my blog because I was busy and then I was in the mountains and then busy again...
And I need to start to continue. But have no idea what to write about. So this post will be just about some stuff that
happened during my main work in the last month. Something that I still remember although days and weeks have passed.

## Memory is leaking very fast

The first thing I'd like to mention is about memory leaks in V8 and particularly in Node.js. We've almost completed
our project, it is the app for authorization and registration for internet banking for retail customers. The last
sprint finished and the app was opened for internal usage - so everybody in company's network started to use it.
Everything seems fine, I fixed minor bugs from time to time and deployed the new releases to our integration environment.

In one day the app started to drop into OOM and it surprised me a lot because there wasn't a clear reason for it - just
some small fixes and the app has already been load tested. I was familiar with such a problem - about a year ago I
came across the same one and the reason was in the React renderer but it was the beta version of maybe 0.14. The last
time it took a full day to fix it. I also remember clearly that analyzing heapdumps didn't help. Yes, it showed that
there were a great number of newly created objects - millions of them, but who really retained them was unclear.

The same symptoms showed up in the current case. The heap was growing rapidly, e.g. after about 500 hits the size of the
heap was about 500mb, there were also millions of objects and strange retainers - not from the application source.
Finally I found that this behavior was reproducible with react@15.3.0 and was ok with the next minor version.
After a quick googling I found this [PR-7410](https://github.com/facebook/react/pull/7410) and it explained everything.
Because, of course, we have SSR and without NODE_ENV set up to 'production'.

What is the takeaway from this story? If parsing the heapdumps gives no clues then find out which dependencies have been
updated. Also if the leakage is strong then something is wrong with the main library.

## why the front-build-container is failed

I'm talking about this one [build-front-container](https://github.com/alfa-bank-dev/build-front-container). So why did
it fail? In short, because it's over-complicated and/therefore hard to test and debug.

I tried to write good tests but didn't find a suitable solution for it. Also, I remember how painful and time-consuming
it was to fix errors during builds.

Too many technologies involved - a little of bash-scripting, node.js scripts and Docker. Even I had to refresh my mind
about how these parts interact with each other. It's not simple to configure it either.

The problem with not repeating `npm install` which slows down the build process wasn't solved.
The algorithm which defines whenever we should create tarball with dependencies is buggy. It's better to calculate
hashes with package.json.

So maybe the main idea is not so bad. Maybe.

Let's talk about the alternative. We can heavily use layers created by Docker. So for example if no dependencies changed
and it's likely to happen then we can use the layer from the previous build and not waste time on downloading deps.

Dockerfile could be like this:

```Dockerfile
FROM node:4.4.0

ADD tmp-package.json /tmp/package.json
RUN cd /tmp && npm i --quiet --no-progress --unsafe-perm
RUN mkdir -p /src && mv /tmp/node_modules /src
WORKDIR /src
ADD . /src
RUN npm run build
RUN npm prune --production
```

It's important to create package.json file with just dependencies listed  because if something else changed then the
next layer with node_modules would be invalidated.

So why do I like this solution. It's simpler - just one Dockerfile contains all the main steps. Of course, the
implementation of `npm run build` is up to you but the bash file build.sh has disappered. It's fast - Docker is
responsible for it.

## sendBeacon - the weird browser API

[sendBeacon API](https://developer.mozilla.org/ru/docs/Web/API/Navigator/sendBeacon). We have an in-house analytics
system - actually, the clone of google analytics. Please do not ask me why - we are in the bank and very concerned
about users data.

Anyway, this API is very useful when you have to send something before user leaving. Of course we could send synchronous
AJAX request but we don't want to keep the user waiting. Or we could push data periodically but it's harder to handle it
on backend.

Example of usage:
```js

let isWindowUnloading = false;
let isSendBeaconAvailable = window.navigator && window.navigator.sendBeacon;

if (typeof window !== 'undefined') {
    window.addEventListener('beforeunload', function() {
        isWindowUnloading = true;
    });
}

export function log() {
    if (isWindowUnloading && isSendBeaconAvailable) {
        window.navigator.sendBeacon('http://my-metrics/', '');
    }
    // ...
}
```

## window.onerror and IE10-

We use window.onerror API to track browser-side errors in our apps. It's very helpful but old IEs don't support error
object in window.onerror handler. So you cannot trace the origin of error in these browsers. The messages from
`window.onerror` become almost useless in this case..
