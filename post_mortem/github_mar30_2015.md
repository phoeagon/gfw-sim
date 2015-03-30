This describes a new feature of *gfw-router*: hijacking.

## What happened

At some point on Mar 27, 2015, it was discovered that an URL to
a Baidu Ad (similar to Google Adsense) script was hijacked to return
a script that repeatedly pulls some repo at [github](https://github.com/).

The hijack was only found targetting some traffic from mostly northern America.

Github mitigated by returning 'alert("malicious script found on this domain")', which blocks the execution of the JavaScript in question before user clicks on 
the prompt.

Thanks to [@yegle](http://twitter.com/yegle) and [his discovery](https://twitter.com/yegle/status/581315307811180544).

## What to simulate

Hijacking an URL to return a certain script (similar to XSS).

## How to simulate

HTTP requests to some domains are redirected to the router itself on port 80,
which serves a Javascript file using `netcat`.

## How do I use it

Use the latest version of GFWRouter.
