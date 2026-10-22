# Contributing

Thanks for considering a contribution — this guide gets better every time someone tests it on a setup slightly different from the original.

## You don't need to be a Linux expert to contribute

Genuinely useful contributions include:

- "Step 6 didn't work for me on Raspberry Pi OS / Linux Mint / [other Debian derivative] — here's what I had to change"
- A typo fix
- A clearer explanation of something that confused you
- A screenshot of a router UI not already covered
- A troubleshooting entry for an error you hit and solved

You do not need to fully understand every layer of the boot process to notice "this command didn't work" and say so.

## How to contribute

1. **Open an issue first for anything beyond a small fix** (typos, broken links) — this avoids duplicate work if someone's already looking at the same thing.
2. **Fork the repo, make your change, open a pull request.**
3. **Keep PRs focused.** One fix or one addition per PR is easier to review than a bundle of unrelated changes.

## Style guidelines for this repo

- Explain *why*, not just *what to type* — that's the whole point of this guide existing instead of a bare command list
- Use placeholders, never real IPs/keys/hostnames, in any example (`<SERVER-IP>`, not a real address)
- Keep beginner-friendliness in mind: if you're adding a technical term, either explain it inline or add it to `docs/glossary.md`
- Lowercase, hyphen-separated filenames, no spaces

## Licensing note

By contributing, you agree your contribution is licensed under this repository's `LICENSE` (MIT) for the original documentation/scripts/examples. Don't submit content you don't have the right to license this way — and never submit copied text from another guide or site without it being your own original writing or properly attributed under its own terms.

## Code of Conduct

This project follows the guidelines in `CODE_OF_CONDUCT.md`. Be kind — most people reading this guide are new to homelabbing and encryption concepts, and a lot of them are here specifically because it's intimidating.
