# zstack thesis mode

Used when STATE.md has `Type: thesis`. Same sprint, same STATE.md, logs and checkpoints; each stage swaps its software steps for the ones below. The "deliverable" is one assembled document; "tests" are evidence and consistency checks.

## Rules for every stage
1. **The student owns the argument.** Agents research, structure, critique, check and edit; the student approves every claim of substance. Follow the university's and supervisor's AI rules; record each AI use in STATE.md `## AI use log` (date, tool, purpose) so the declaration can be written truthfully.
2. **Never fabricate.** No invented data, counts, quotes, citations, page numbers, ethics numbers, pilot details or reflexive entries. A gap becomes a highlighted placeholder `[[STUDENT: what is needed]]` and a row in STATE.md `## Student-only items`.
3. **Privacy.** Never open, quote or send anywhere folders the project marks private (raw transcripts, consent forms, ID mappings). Work only from de-identified data. Nothing from the data goes into web searches or external services.
4. **Supervisor feedback outranks general advice.** Read the project's feedback/handover files first and treat their rules as acceptance criteria.
5. **Originals stay untouched.** Write the assembled thesis to a new file (`Thesis/<id>_Thesis_vN.docx`); never edit the source drafts in place. One writer per file.
6. **Word I/O:** read with `pandoc file.docx -t gfm`; build or edit .docx with the `anthropic-skills:docx` skill; PDF via `soffice --headless --convert-to pdf`.

## Stage mapping
| Stage | Do this instead of the code steps |
|---|---|
| **Think** | Read the handover/supervisor files and every draft (as markdown). Pin the **golden thread**: one-sentence argument, main question, sub-questions, objectives, theory, method. If the question or theory is still open, run `/ars-plan` (Socratic) with the student; if the literature is thin, ask the `researcher` (or `/ars-lit-review`, `/ars-3w`). Record the thread in STATE.md `Goal`. |
| **Plan** | Ask the `planner` for `plan-<milestone>.md` containing: (a) chapter map with a word/page budget per chapter that fits the length limit; (b) a **golden-thread matrix**: each sub-question → literature section → method element → findings section → discussion/conclusion section; (c) ordered tasks per chapter, each with acceptance criteria taken from the supervisor rules and the review rubric below; (d) the student-only items. `/ars-outline` can draft (a)–(b). The student approves; freeze as usual. |
| **Build** | One writer (lead or `implementer`) assembles the document chapter by chapter with the docx skill, cutting repetition and changing tense as planned. Use `scientific-writing` for prose, `citation-management` for references, `dataviz` for figures. Each task ends with the chapter's word count and a list of placeholders left. |
| **Review** | In parallel, report only: (1) `/ars-reviewer` as an examiner panel with the rubric below; (2) `/ars-citation-check`: every in-text citation is in the list and vice versa, APA 7; (3) the `tester` runs the **evidence checks**: every quote matches the de-identified transcript verbatim (allowing filler removal), every count matches the analysis files, every cross-reference and table/figure number resolves; (4) the `reviewer` checks the supervisor's format and style rules. Grade P1 = wrong fact, quote, count or citation, or a rubric fail; P2 = a supervisor rule broken, an unclear argument; P3 = polish. P1/P2 go back to the writer; max 2 rounds. |
| **Test** | Submission gate: length within the limit; front matter complete (title page, declaration, abstract, contents, lists of tables/figures); a COREQ pass for interview studies (research team and reflexivity / study design / analysis and findings: each item located or marked N/A); zero `[[STUDENT:` placeholders, or each one confirmed with the student; the golden-thread matrix still holds against the final text. Record pass/fail per criterion. |
| **Ship** | Final .docx and PDF; `/ars-abstract` drafts the abstract (the student edits it); `/ars-disclosure` helps the student write the AI declaration from the AI use log, in the student's own words. The student submits; agents never submit or email anything. Defence deck: `academic-pptx` + the `pptx` skill. |
| **Reflect** | `/retro` on the sprint. When supervisor or examiner feedback arrives: `/ars-revision-coach` turns it into a revision roadmap, which becomes the next milestone's plan. |

## Review rubric (examiner view)
- **Golden thread:** questions → objectives → literature → method → findings → conclusions line up; each sub-question is answered explicitly in the conclusion.
- **Argument:** a clear goal in the first paragraph; the contribution is stated and is not overclaimed; findings are interpreted, not just described (Braun & Clarke 2006, 2019).
- **Literature:** critical, not a list of summaries; current; gaps lead into the study; no repetition of Chapter 1.
- **Method:** each choice is justified and was applied consistently; deviations from the design are declared; the analysis is traceable (codebook, decision memo, audit trail).
- **Interpretive quality** (IS, Klein & Myers 1999): hermeneutic circle; contextualisation; researcher–participant interaction; abstraction and generalisation; dialogical reasoning; multiple interpretations; suspicion. Check the wording against the paper before citing it.
- **Trustworthiness:** credibility, dependability, confirmability, transferability; reflexivity; negative cases; limitations named.
- **Presentation:** consistent styles, numbering and captions; reference format; length; no section ending on a table or figure (if the supervisor asks for that).
