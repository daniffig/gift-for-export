# Gift for Export

## Quick reference
* **Maintained by** [daniffig](github.com/daniffig/)
* **Where to get help?** You can [submit your ticket](https://github.com/daniffig/gift-for-export/issues) as an issue.
* **Live demo** at [Gift for Export Demo](https://gift.noack.net.ar/)

## What is Gift for Export?
Gift for Export is a small Rails application that helps you to convert a XLS file to the [GIFT format](https://docs.moodle.org/311/en/GIFT_format). It was developed as an emergency solution for the teachers of [UBA XXI](https://ubaxxi.uba.ar/) and their [Moodle](https://moodle.org/) platform under the restrictions derived from COVID-19 pandemic in Argentina. Its purpose is to let the teachers work on a collaborative environment such as [Google Docs](https://docs.google.com) and then convert the resulting file to a format suitable to be imported by Moodle.

This application was led by [Ornella Buzzi](https://www.linkedin.com/in/ornella-buzzi0297/) and developed by [daniffig](https://www.linkedin.com/in/ldigiacomo/).

## How to setup this application

### Docker
The easiest wat to get this app working is to run it as a Docker container.

```console
docker run -p 3000:3000/tcp --rm ghcr.io/daniffig/gift-for-export:latest
```

### Docker Compose
You can also set up this project with a *docker-compose.yml* file.

```yaml
version: '3'
services:
  web:
    image: ghcr.io/daniffig/gift-for-export
    ports:
      - 3000:3000/tcp
```

### Environment Variables
Even though it is not required that you provide a secret key for this application since you will not be using it, you can set it using the *SECRET_KEY_BASE* variable.


