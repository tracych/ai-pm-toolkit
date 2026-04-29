# pm-deep-dive — assets

Files in this folder are read by the `/pm-dive-*` commands. Edit them to customize behavior.

| File | Edited by | Read by |
|---|---|---|
| `domain_angles.md` | PM community (PRs welcome) | `/pm-dive-frame` |
| `confidence_rubric.md` | Maintainer (rare) | `/pm-dive-run`, `/pm-dive-summarize` |
| `adversarial_prompts.md` | Maintainer | `/pm-dive-run` (Phase 2 validator) |
| `templates/blog_post.md` | PMs (copy + customize per project) | `/pm-dive-ship --format post` |
| `templates/exec_brief.md` | PMs | `/pm-dive-ship --format exec` |
| `examples/synthetic_*` | Maintainer | (reference only — show what good looks like) |

## How to add a domain preset

Edit `domain_angles.md`. Add a section keyed by domain name. Provide 5–6 orthogonal angles with a short instruction each (every preset includes a `user_research` angle as the 6th). Submit a PR or open an issue.

Today's presets: `ads`, `creator`, `integrity`, `infra`, `commerce`. Domain `other` falls back to a generic 6-angle template in `domain_angles.md`.

## How to customize templates

Templates in `templates/` are starting points. For a project-specific spin, copy into your project and modify, then point `/pm-dive-ship` at your version with `--template <path>` (TODO v0.3).
