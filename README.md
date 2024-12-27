# Obsidian-SADE

> “Hello. I’m Julien, this vessel’s SADE, a self-aware digital entity. How are you called?” - _The Silver Ships by S.H. Jucha_

Okay, that's a little ambitious.

Obsidian-SADE is a Rails API that watches over your Obsidian vault.

It can:
- Create new notes
    - Like [Templater](https://github.com/SilentVoid13/Templater) but with the power of Ruby to generate or add dynamic sections.
- A REST API to be triggered by other services like Node-RED or Home Assistant
- Watch for changes in your Obsidian vault:
    - Modify the content of a note using local AI models, running the commands through fabric
