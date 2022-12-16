# Private npm registry

Last week I set up the private npm registry for our projects. I'd like to explain our motivations to have it,
some technical details and also the benefits of using it.

My colleges are crazy about continuous delivery and building a new infrastructure for it. We are using
[Jenkins Pipeline plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin) - so all the projects have to be
deployed using it. Frontend projects are no exception.

The first hard problem we came across was `Connection reset by peer` error that happened frequently. This error
occurred during the pulling packages from our local git repository. Yes, we use git as a transport in our dependencies like:
```json
{
    "dependencies": {
        "my-lib": "git+ssh://git@git/my-lib#0.0.1"
    }
}
```
One error breaks the whole building process and you have to start again. That's very annoying and demotivating and
spoils the healthy initiative of CD. Our network engineers have been trying to fix it but have had no luck till now.

Obviously, there is another transport to deliver our packages and it's a private npm registry. I believe that there are
a few solutions for it like [npm enterprise](https://www.npmjs.com/enterprise). I haven't checked it because we already
have one [Artifactory](https://www.jfrog.com/open-source/) - so the choice was predetermined. Artifactory offers a great
[support for npm](https://www.jfrog.com/confluence/display/RTF/Npm+Registry) and it seems very easy to set everything up.

The registry contains three parts - local-npm, remote-npm, virtual-npm. Local-npm registry is where your own packages
should live. The remote-npm registry is like a cache for global npm packages - so when you pull something from the
registry.npm.com it stores in this registry. The virtual-npm registry combines the former ones and provides a union
interface for npm clients. It's very simple and convenient btw.

Your local npm-client should be configured properly. The only thing that I needed for reading packages was .npmrc like so:
```
registry=http://path-to-artifactory-npm-registry
```
For publishing packages you also need to add your credentials. Also it's better not to add `always-auth = true` because
it causes more harm - for example artifactory returned a 403 error while reading.

The one thing that I didn't know well was npm scope packages. If I have understood correctly, it's a good practice to
use scope for your native packages - so it won't be messed up with the packages from remote npm. You should use it.

Ok, we fixed our problem and can continue building CD process. We've benefitted from it too - we can run
prepublish scripts and process sources and include only necessary files for distribution. Another thing is that we
cache remote packages in our servers - so we can get packages faster and don't need internet.
