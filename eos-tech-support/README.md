eos-user-stress-test
====================
`eos-user-stress-test` is meant to be a reproducible simulation of user-based
stressing of a system. It should always be realistic to how we expect an average
user (see note below) to use the system. Testing for specific user profiles
should be done in a different test component as this one is focused on ways most
users might easily stress a system.

Specifically, we expect users to:
* launch apps by clicking icons (or hitting enter after searching on the
  desktop)
* fail to close apps proactively
* open browser tabs without consideration of performance implications
* fail to close browser tabs proactively
* install apps from the App Center, possibly triggering as many as a dozen
  installs before the first completes (in the case they're new to and excited
  about the possibilities of the platform)
* in general, not consider performance implications of their actions

We expect users NOT to:
* open a terminal
* be malicious (this is simulating them using their own computer, after all)
* do things to specifically stress the system, like:
    * launch tens of apps at once (several at once might be reasonable though)
    * open tens of browser tabs at once (though they might accumulate slowly
      over time)
    * launch fork bombs

Usage
=======
`eos-user-stress-test` defines multiple "levels" of stress with each level
adding more and different apps and websites to the current system load.

Each level is meant to be triggered cumulatively. So, to get a system to
"medium" stress, you would run:

```
$ eos-user-stress-test light
```

(possibly wait for the system to settle)

```
$ eos-user-stress-test medium

```

For "heavy" stress, follow this with `eos-user-stress-test heavy`.
