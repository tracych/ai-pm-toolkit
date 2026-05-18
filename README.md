# ai-pm-toolkit

Battle-tested AI skills, prompts, and workflows that make product managers 10x faster. Built for [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), adaptable to any LLM.

Each sub-folder is a self-contained Claude Code plugin you can install independently.

---

## Plugins

### 🔬 [pm-deep-dive](./pm-deep-dive/)

Multi-agent PM research methodology. For **ramping into a new domain** or **pressure-testing a strategic claim** before bringing it to leadership.

Frame a falsifiable question → run parallel research agents across orthogonal angles → adversarially validate → cross-validate and synthesize → ship a post or exec brief → land findings into persistent project knowledge.

**Use it when:** investigating a claim like *"X is whitespace"*, ramping into an unfamiliar product/technical domain, building a competitive landscape, or pressure-testing a strategy hypothesis.

Commands: `/pm-deep-dive`, `/pm-dive-frame`, `/pm-dive-run`, `/pm-dive-summarize`, `/pm-dive-ship`, `/pm-dive-land`.

### 🎨 [protopilot](./protopilot/)

Turn a problem statement into a clickable, self-explainable HTML prototype — without writing code.

Four gated phases: **Frame** (Jobs-to-be-Done) → **Flow** → **Design** → **Build**. Output is a single self-contained `prototype.html` (vanilla HTML/CSS/JS, zero CDN) with an embedded "PM notes" overlay that explains the JTBD, flow, and per-screen rationale to anyone who opens the file.

**Use it when:** prototyping an idea for stakeholder review, turning a JTBD into a clickable mock, producing a shareable demo without engineering time.

Commands: `/protopilot [optional brief]`.

---

## Install

Pick the plugin you want and symlink it into Claude Code's plugin directory:

```bash
cd ~/code
git clone https://github.com/tracych/ai-pm-toolkit.git

mkdir -p ~/.claude/plugins
ln -s ~/code/ai-pm-toolkit/pm-deep-dive ~/.claude/plugins/pm-deep-dive
ln -s ~/code/ai-pm-toolkit/protopilot   ~/.claude/plugins/protopilot
```

Restart Claude Code. Slash commands from each linked plugin will appear.

See each plugin's own README for detailed quickstarts and conventions.

---

## License

[MIT](./LICENSE)
