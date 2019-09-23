# Mariposta 4

_UPDATE:_ this project has been depricated in favor of our upcoming release of **Yarii**. The goal is the same: a "drop-in" Rails engine that will allow you to create and edit static content. Stay tuned!

----

Mariposta started out life as a proprietary CMS primarily intended for creating app-like websites specially formatted for the iPad. This was before responsive design techniques and  "minimalist" design (flat UI, etc.) became the norm. So Mariposta didn't really catch on in that incarnation.

But since building and using specialized CMSes is in our DNA at [Whitefusion](http://whitefusion.io), we ended up pursuing a very different path and are now in the business of designing custom admin portals (aka the editing side of a CMS) for our clients and using Rails + Jekyll under the hood. Jekyll is an absolutely fantastic static site generator, but something else needs to be integrated with it in order to allow normal/non-technical users to create and edit their website content.

Mariposta 4, when "complete" (like any software is ever complete!), will be a Rails engine you can load inside a standard Rails application and use to provide a sophisticated editing front-end to a Jekyll site. Create and define various content types (what we call Front Matter Models), review current changes, and commit changes to the Git repository and push. Combined with a solid hosting solution such as Netlify, this provides a near seamless experience for users and helps them transition from legacy solutions such as WordPress.

We're already using Mariposta 4 in production and will be rolling out several sites in the coming year. Once we feel like this codebase is ready for the wider world, we'll announce it and engage with the open source community in an intentional fashion.

In the meantime, feel free to poke around—and let us know if you have any comments or ideas!

-Jared White  
[Whitefusion](http://whitefusion.io)
