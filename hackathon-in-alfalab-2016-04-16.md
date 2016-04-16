# 16/04/2016 AlfaBot Hackathon

It happened in the last year on the 4th of December and I wrote this story right after it but didn't publicate it.
So I decided to do it now just to memorize it. The next goes the original story.


I participated in a hackathon recently. I'd like to tell you about it.

The hackathon was organized by the company where I'm currently employed. So it was like a private party and only people
who work in Alfa Bank or related organizations could take part in this event.

The theme of the hackathon was Telegram bots. I have to say a little about it. Telegram - is a messenger that is growing
very quickly and now has more than 50 millions active users. It is very similar in functionality to WhatsApp or Facebook
messenger. But it also supports an ability to create special programs called Bots. Users can connect with bots using
the same interface as when talking to their friends.

I have to mention that I didn't have a team, or idea what to do, but a willingness to code and create stuff.
So the day before the event my chief offered me a team and I agreed. Those guys were debt collectors, not actually the
ones who come to your house and knock on the door but those who support information systems for it and the other
developer was me.

We had to use real services and databases in our debt bot. That was the rule of the contest. We spent a lot of time
checking and supporting access to backend because it's a bank.

There were two developers in the team - me and [Volodya](https://bitbucket.org/v0v87/). I knew how to handle stuff with
node.js and Volodya was a Java-developer. So we decided to split our bot into frontend part with some UI logic and REST
API that uses ancient bank SOAP-services. It was a good idea because the UI wasn't simple and we had to implement some
complex branched scenarios. Also, Volodya was able to hack all the services independently.

Some statistics. I cannot show you the source code - just believe me:

```bash
➜  alfa-debt-bot git:(master) git summary

 project  : alfa-debt-bot
 repo age : 7 days
 active   : 2 days
 commits  : 40
 files    : 54
 authors  :
    31  Nikita Korotkih  77.5%
     9  vladimir         22.5%
```

The services that made Volodya:

```bash
➜  alfa-debt-bot git:(master) grep endpoints -A 10 front/config.js
    endpoints: {
        signIn: '/auth',
        debt: '/debt',
        isPtpExist: '/isPtpExist',
        savePtp: '/ptp',
        nextPays: '/nextPays',
    }
};
```

We also wanted to deploy our bot to the remote host and that's why the first task I made was ansible-scripts.
But we didn't get all the required accesses to inner services. So the bot worked only on my Mac wired to local bank
network.

After about twenty hours of working the code became so messy and fragile that I was scared to make commits.
I was afraid that I would be exhausted at the end of the day, but surprisingly I was really ok and motivated to work
the whole night.

Finally we built a bot that could authorize you, show information about user's debts and show the schedule of next ones.
Also users could send a promise of repayment to our bot.

I have to say about my team. There were three analitics who bring the idea of application and made a huge work analyzing
stuff. They were great and without them it wouldn't be possible to hack the stuff.

The demo was on Saturday afternoon. I can't say that we failed it but the guy who was presenting our bot was so slow
that he didn't fit the presentation into 7 minutes and didn't show all the features we made.

By the way, taking part in this hackathon was a great idea. My takeaways from it:
 - the team is very important - so you better code with friends
 - choose one main feature of the app. And make it perfect and clear for the audience
 - prepare a good presentation

![late at night]
(./images/alfa-bot-hackathon.png)
