# Model Families — Capability Anchors

The 10 canonical model families this skill maps against. Use these names verbatim. Capability descriptions reflect the current model generation; revisit when the frontier moves.

Each entry has: **What it reliably does**, **Where it cliffs**, and **Typical input/output shape**.

---

1. **LLM-frontier** — the largest closed-weights general-purpose language models (the current top-tier reasoning/chat models from major labs).
   - **Reliably does:** open-ended reasoning, code generation, summarization, structured extraction, multi-turn dialogue, instruction following over short-to-medium context, JSON/tool-call outputs.
   - **Cliffs:** long-horizon multi-step agentic planning drifts after ~5 sequential steps; numerical reasoning over tabular data is unreliable without tool use; hallucinated citations on unseen documents; cost and latency are high for real-time UX; private-data fine-tuning is limited.
   - **Shape:** text in, text/JSON out. Multimodal in for top-tier models.

2. **LLM-open** — open-weights language models (small to large) you can host yourself or fine-tune.
   - **Reliably does:** the same task surface as frontier LLMs at noticeably lower capability ceilings — chat, extraction, classification, summarization on narrower domains; cheap inference at scale; full control over weights and data.
   - **Cliffs:** complex multi-step reasoning is materially worse than frontier; instruction-following on novel tasks is brittle; smaller models hallucinate more; hosting and ops cost engineering time.
   - **Shape:** text in, text out. Self-hosted or via inference providers.

3. **vision-LLM** — multimodal models that accept images (and sometimes video) alongside text.
   - **Reliably does:** describe scenes, OCR printed and clean handwriting, answer questions about a single image, classify visual content, ground references in an image, read charts and diagrams at a high level.
   - **Cliffs:** precise spatial reasoning (counting small objects, exact bounding boxes); fine-grained visual discrimination (medical, defect detection) without fine-tuning; reliable video understanding beyond short clips; tracking objects across frames.
   - **Shape:** image(s) + text in, text/JSON out.

4. **speech** — speech-to-text (ASR), text-to-speech (TTS), and voice-to-voice models.
   - **Reliably does:** high-quality transcription in major languages on clean audio; natural-sounding synthesis; speaker diarization on cooperative inputs; near-real-time streaming for both directions.
   - **Cliffs:** robust ASR in heavy noise, code-switching, or low-resource dialects; emotional and prosodic control in TTS; sub-100ms turn-taking for fully natural duplex conversation; reliable voice cloning ethics and detection.
   - **Shape:** audio in/out, text intermediate.

5. **recsys/ranking** — recommender systems and learned ranking models (collaborative filtering, two-tower, sequence models, learning-to-rank).
   - **Reliably does:** personalized ranking and recommendation given sufficient interaction data; cold-start fallbacks via content features; large-scale low-latency serving; A/B-testable optimization toward business metrics.
   - **Cliffs:** cold-start with no data; explainability of why an item was recommended; capturing intent shifts within a session; offline-online metric mismatch; long-tail item coverage.
   - **Shape:** user/context features in, ranked list of items out.

6. **world-models** — models that learn predictive dynamics of an environment (video prediction, physics simulators, learned game/world simulators).
   - **Reliably does:** short-horizon video and physics prediction in narrow domains; useful priors for simulation, robotics, and game agents; controllable scene rollout in research demos.
   - **Cliffs:** long-horizon prediction without compounding error; generalization across physical domains; precise causal counterfactuals; running fast enough for real-time control on consumer hardware.
   - **Shape:** state/observation in, predicted future state(s) out.

7. **3D-generative** — models that produce 3D assets (meshes, NeRFs, Gaussian splats) from text, image, or scan.
   - **Reliably does:** generate plausible single 3D objects from text or image prompts at draft quality; produce neural reconstructions from multi-view captures; usable assets for prototyping and concept art.
   - **Cliffs:** production-grade topology and UVs without manual cleanup; precise control over geometry, scale, and articulation; multi-object scenes with correct relationships; real-time generation on consumer hardware.
   - **Shape:** text/image/scan in, 3D asset out.

8. **agents-with-tools** — LLMs orchestrated into multi-step loops that call tools, browse, or execute code.
   - **Reliably does:** short structured workflows (3–5 tool calls) with well-defined tools; retrieval + reasoning + answer patterns; deterministic glue tasks; demos that look impressive on rails.
   - **Cliffs:** long-horizon autonomy without human checkpoints (errors compound); tool selection in large tool catalogs; robust error recovery when a tool returns garbage; reliable behavior on novel sites or unseen environments; cost predictability per task.
   - **Shape:** goal in, sequence of (tool call → observation → reasoning) → final output.

9. **embeddings/retrieval** — dense and sparse embedding models plus vector search / RAG infrastructure.
   - **Reliably does:** semantic search over text/image corpora; clustering and deduplication; nearest-neighbor lookup at scale; the retrieval half of RAG; cheap and fast inference.
   - **Cliffs:** retrieval quality on domain-specific jargon without fine-tuning; chunking and freshness pipelines are most of the real work; semantic ≠ relevance for ranking; multi-hop reasoning needs orchestration, not just retrieval.
   - **Shape:** text/image in, fixed-dim vector out (or top-k results).

10. **classical-ML** — non-deep-learning methods (gradient-boosted trees, logistic regression, SVMs, clustering, time-series models).
    - **Reliably does:** tabular prediction with strong feature engineering; calibrated probabilities; fast training and inference; high interpretability; works with small labeled datasets.
    - **Cliffs:** unstructured inputs (text, image, audio) without heavy feature engineering; capturing complex non-linear interactions deep models handle automatically; large-scale representation learning.
    - **Shape:** structured features in, prediction/score out.
