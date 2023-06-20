# Automations

Some useful automations I use for work or per
I automate parts of my life. Not because I have to; but because it's fun.
These are some useful scripts when automating those parts of my life.

## When getting a new laptop
When I get a new laptop I usually flush it to install some debian variant of linux(These days I am on Ubuntu after having gone through a whole range of distros).
When I finish installing the distro I use my [setup](setup.sh) scripts to install all the necessary devtools, software and environments I minimally need to start hacking right away on anything.

## When starting new projects
When starting new projects I use another [script](create_envs_dirs.sh) to create an environment and directly setup a directory structure that changes depending on the type of project I want to work on. <br />
If I am just trying out new stuff and exploring I will just use the [basic script](create_envs.sh) to create an environment, update pip and activate it.