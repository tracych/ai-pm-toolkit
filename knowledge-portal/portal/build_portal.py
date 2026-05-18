#!/usr/bin/env python3
"""
build_portal.py — render a knowledge base into a single self-contained HTML portal.

Stdlib only. Run from the portal/ directory:
    python3 build_portal.py

NOTE: this file is also copied into assets/example_kb/portal/ so the example KB
is runnable standalone. Keep both copies in sync when editing.

Inputs:
    ../knowledge/*.md                 → topic tabs
    ../knowledge/deep_dives/*.md      → deep-dives submenu
    explainers/*.html                 → linked from topic pages (already HTML)

Output:
    index.html  (single file, inlined CSS, no external deps)
"""

import re
import sys
import html
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
KB_ROOT = HERE.parent / "knowledge"
DEEP_DIVES = KB_ROOT / "deep_dives"
EXPLAINERS = HERE / "explainers"
OUT = HERE / "index.html"
TEMPLATE = HERE / "index.html.tmpl"

# Preferred topic ordering — files not in this list go after, alphabetically.
TOPIC_ORDER = [
    "domain_knowledge",
    "systems_and_models",
    "metrics_and_measurement",
    "people_and_org",
    "processes_and_rituals",
    "gotchas_and_tips",
    "resources",
    "skills",
    "industry_landscape",
    "intake",
    "conflict_log",
]


# ---------- minimal markdown → HTML ----------
# Intentionally tiny. Supports: headers, paragraphs, bold/italic, code (inline + fenced),
# unordered/ordered lists, tables, links, blockquotes. No HTML escape inside code fences.

def md_to_html(text: str) -> str:
    lines = text.split("\n")
    out = []
    i = 0
    in_code = False
    code_lang = ""
    code_buf = []
    para_buf = []
    list_stack = []  # list of ('ul' or 'ol')
    in_table = False
    table_rows = []

    def flush_para():
        if para_buf:
            joined = " ".join(para_buf).strip()
            if joined:
                out.append(f"<p>{inline(joined)}</p>")
            para_buf.clear()

    def close_lists():
        while list_stack:
            kind = list_stack.pop()
            out.append(f"</{kind}>")

    def flush_table():
        nonlocal in_table, table_rows
        if not in_table:
            return
        if len(table_rows) >= 2:
            header = table_rows[0]
            body = table_rows[2:]  # row 1 is the separator
            out.append('<table class="kb-table">')
            out.append("<thead><tr>" + "".join(f"<th>{inline(c.strip())}</th>" for c in header) + "</tr></thead>")
            out.append("<tbody>")
            for row in body:
                # pad/truncate to header length
                row = row + [""] * (len(header) - len(row))
                out.append("<tr>" + "".join(f"<td>{inline(c.strip())}</td>" for c in row[: len(header)]) + "</tr>")
            out.append("</tbody></table>")
        in_table = False
        table_rows = []

    def ensure_list(kind: str, depth: int):
        # Pop deeper levels.
        while len(list_stack) > depth + 1:
            out.append(f"</{list_stack.pop()}>")
        # If at the right depth but wrong kind, close + reopen.
        if len(list_stack) == depth + 1 and list_stack[-1] != kind:
            out.append(f"</{list_stack.pop()}>")
        # Open missing levels.
        while len(list_stack) < depth + 1:
            list_stack.append(kind)
            out.append(f"<{kind}>")

    def split_row(line: str):
        # strip leading/trailing pipe, split on |
        s = line.strip()
        if s.startswith("|"):
            s = s[1:]
        if s.endswith("|"):
            s = s[:-1]
        return [c for c in s.split("|")]

    while i < len(lines):
        line = lines[i]

        # fenced code
        m = re.match(r"^```(\w*)\s*$", line)
        if m:
            if not in_code:
                flush_para()
                close_lists()
                flush_table()
                in_code = True
                code_lang = m.group(1)
                code_buf = []
            else:
                lang_attr = f' class="lang-{code_lang}"' if code_lang else ""
                out.append(f'<pre><code{lang_attr}>{html.escape("".join(code_buf))}</code></pre>')
                in_code = False
                code_lang = ""
                code_buf = []
            i += 1
            continue
        if in_code:
            code_buf.append(line + "\n")
            i += 1
            continue

        # tables — detect when current line and next look table-y
        if "|" in line and (in_table or (i + 1 < len(lines) and re.match(r"^\s*\|?[\s\-:|]+\|?\s*$", lines[i + 1]) and "---" in lines[i + 1])):
            flush_para()
            close_lists()
            in_table = True
            table_rows.append(split_row(line))
            i += 1
            continue
        else:
            if in_table:
                flush_table()

        # headings
        m = re.match(r"^(#{1,6})\s+(.*?)\s*$", line)
        if m:
            flush_para()
            close_lists()
            flush_table()
            level = len(m.group(1))
            heading_text = m.group(2)
            slug = re.sub(r"[^a-z0-9]+", "-", heading_text.lower()).strip("-")
            out.append(f'<h{level} id="{slug}">{inline(heading_text)}</h{level}>')
            i += 1
            continue

        # blockquote
        m = re.match(r"^>\s?(.*)$", line)
        if m:
            flush_para()
            close_lists()
            out.append(f"<blockquote>{inline(m.group(1))}</blockquote>")
            i += 1
            continue

        # unordered list
        m = re.match(r"^(\s*)[-*]\s+(.*)$", line)
        if m:
            flush_para()
            depth = len(m.group(1)) // 2
            ensure_list("ul", depth)
            out.append(f"<li>{inline(m.group(2))}</li>")
            i += 1
            continue

        # ordered list
        m = re.match(r"^(\s*)\d+\.\s+(.*)$", line)
        if m:
            flush_para()
            depth = len(m.group(1)) // 2
            ensure_list("ol", depth)
            out.append(f"<li>{inline(m.group(2))}</li>")
            i += 1
            continue

        # horizontal rule
        if re.match(r"^\s*---+\s*$", line):
            flush_para()
            close_lists()
            out.append("<hr>")
            i += 1
            continue

        # blank line ends paragraph
        if line.strip() == "":
            flush_para()
            close_lists()
            i += 1
            continue

        # default: paragraph line
        if list_stack:
            close_lists()
        # strip HTML comments out of body
        if line.strip().startswith("<!--") and line.strip().endswith("-->"):
            i += 1
            continue
        para_buf.append(line.strip())
        i += 1

    flush_para()
    close_lists()
    flush_table()
    return "\n".join(out)


def inline(text: str) -> str:
    # escape first, then re-introduce the patterns we render
    text = html.escape(text, quote=False)
    # inline code: `...`
    text = re.sub(r"`([^`]+)`", lambda m: f"<code>{m.group(1)}</code>", text)
    # links: [text](url)
    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", lambda m: f'<a href="{m.group(2)}">{m.group(1)}</a>', text)
    # bold: **text**
    text = re.sub(r"\*\*([^*]+)\*\*", lambda m: f"<strong>{m.group(1)}</strong>", text)
    # italic: *text* (avoid colliding with already-handled bold)
    text = re.sub(r"(?<![*])\*([^*\s][^*]*?)\*(?![*])", lambda m: f"<em>{m.group(1)}</em>", text)
    return text


# ---------- portal assembly ----------

def find_topics():
    if not KB_ROOT.exists():
        sys.exit(f"error: {KB_ROOT} does not exist. Run /portal-init first.")
    topics = []
    for p in KB_ROOT.glob("*.md"):
        topics.append(p)
    # sort: TOPIC_ORDER first (in order), then alphabetical
    def key(p):
        stem = p.stem
        try:
            return (0, TOPIC_ORDER.index(stem), stem)
        except ValueError:
            return (1, 0, stem)
    return sorted(topics, key=key)


def find_deep_dives():
    if not DEEP_DIVES.exists():
        return []
    return sorted(DEEP_DIVES.glob("*.md"))


def find_explainers():
    if not EXPLAINERS.exists():
        return []
    return sorted(EXPLAINERS.glob("*.html"))


def render_topic(md_path: Path) -> dict:
    text = md_path.read_text(encoding="utf-8")
    body = md_to_html(text)
    title = md_path.stem.replace("_", " ").title()
    # first H1 wins as title
    m = re.search(r"^#\s+(.*?)\s*$", text, re.MULTILINE)
    if m:
        title = m.group(1).strip()
    slug = md_path.stem
    return {"slug": slug, "title": title, "body": body, "path": str(md_path)}


def build():
    if not TEMPLATE.exists():
        sys.exit(f"error: template missing at {TEMPLATE}")

    topics = [render_topic(p) for p in find_topics()]
    deep_dives = [render_topic(p) for p in find_deep_dives()]
    explainer_links = [
        {"slug": p.stem, "title": p.stem.replace("-", " ").title(), "href": f"explainers/{p.name}"}
        for p in find_explainers()
    ]

    # build nav
    nav_topics = "\n".join(
        f'<li><a href="#topic-{t["slug"]}" data-target="topic-{t["slug"]}">{html.escape(t["title"])}</a></li>'
        for t in topics
    )
    nav_deep = "\n".join(
        f'<li><a href="#deep-{d["slug"]}" data-target="deep-{d["slug"]}">{html.escape(d["title"])}</a></li>'
        for d in deep_dives
    )
    nav_explainers = "\n".join(
        f'<li><a href="{e["href"]}" target="_blank">{html.escape(e["title"])} ↗</a></li>'
        for e in explainer_links
    )

    # build sections
    sections = []
    for t in topics:
        sections.append(f'<section id="topic-{t["slug"]}" class="kb-section">{t["body"]}</section>')
    for d in deep_dives:
        sections.append(f'<section id="deep-{d["slug"]}" class="kb-section">{d["body"]}</section>')
    sections_html = "\n".join(sections)

    template = TEMPLATE.read_text(encoding="utf-8")
    rendered = (
        template
        .replace("{{NAV_TOPICS}}", nav_topics)
        .replace("{{NAV_DEEP_DIVES}}", nav_deep)
        .replace("{{NAV_EXPLAINERS}}", nav_explainers)
        .replace("{{SECTIONS}}", sections_html)
        .replace("{{BUILD_TS}}", datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"))
        .replace("{{TOPIC_COUNT}}", str(len(topics)))
        .replace("{{DEEP_COUNT}}", str(len(deep_dives)))
        .replace("{{EXPLAINER_COUNT}}", str(len(explainer_links)))
    )

    OUT.write_text(rendered, encoding="utf-8")
    size_kb = OUT.stat().st_size / 1024
    print(
        f"build_portal.py — rendered {len(topics)} topics, "
        f"{len(deep_dives)} deep dives, {len(explainer_links)} explainers "
        f"→ {OUT.name} ({size_kb:.1f}KB)"
    )


if __name__ == "__main__":
    build()
