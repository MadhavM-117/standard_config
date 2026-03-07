/**
 * Clarify Extension - Back-and-forth workflow for clarifying task requirements
 *
 * Usage:
 *   /clarify - Start the clarification workflow
 *   LLM calls clarify_ask to ask questions
 *   LLM calls clarify_complete when done
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { Editor, type EditorTheme, Key, matchesKey, Text, truncateToWidth } from "@mariozechner/pi-tui";

interface ClarifyState {
	questions: { q: string; a: string; isCustom: boolean }[];
	mode: "idle" | "active";
}

interface AnswerResult {
	answer: string;
	isCustom: boolean;
}

export default function (pi: ExtensionAPI) {
	// State for tracking clarification progress
	let state: ClarifyState = {
		questions: [],
		mode: "idle",
	};

	// Helper to reset state
	function resetState() {
		state = { questions: [], mode: "idle" };
	}

	// Helper to format the current progress
	function formatProgress(): string {
		if (state.questions.length === 0) {
			return "No questions asked yet.";
		}
		const lines = ["Clarification Progress:", ""];
		for (let i = 0; i < state.questions.length; i++) {
			const { q, a, isCustom } = state.questions[i];
			const prefix = isCustom ? "(wrote) " : "";
			lines.push(`${i + 1}. Q: ${q}`);
			lines.push(`   A: ${prefix}${a}`);
			lines.push("");
		}
		return lines.join("\n");
	}

	// Register /clarify command
	pi.registerCommand("clarify", {
		description: "Start a clarification workflow to define task requirements",
		handler: async (_args, ctx) => {
			resetState();
			state.mode = "active";

			// Send a message to inform the LLM about clarification mode
			pi.sendMessage({
				customType: "clarify-mode",
				content:
					"Clarification mode started. Use the clarify_ask tool to ask questions and clarify requirements. Use clarify_complete when done.",
				display: true,
			});

			ctx.ui.notify("Clarification mode activated", "info");
			ctx.ui.setStatus("clarify", "Clarification mode - use clarify_ask / clarify_complete");
		},
	});

	// Register /clarify-progress command to show current state
	pi.registerCommand("clarify-progress", {
		description: "Show current clarification progress",
		handler: async (_args, ctx) => {
			if (state.questions.length === 0) {
				ctx.ui.notify("No clarification in progress", "info");
			} else {
				ctx.ui.notify(formatProgress(), "info");
			}
		},
	});

	// Register /clarify-cancel command
	pi.registerCommand("clarify-cancel", {
		description: "Cancel the current clarification workflow",
		handler: async (_args, ctx) => {
			resetState();
			ctx.ui.notify("Clarification cancelled", "info");
			ctx.ui.setStatus("clarify", undefined);
		},
	});

	// Register clarify_ask tool
	pi.registerTool({
		name: "clarify_ask",
		label: "Clarify Ask",
		description:
			"Ask the user a question to clarify requirements. Use during /clarify workflow. Shows interactive UI for user to answer.",
		parameters: Type.Object({
			question: Type.String({ description: "The question to ask the user" }),
			options: Type.Optional(
				Type.Array(
					Type.Object({
						value: Type.String({ description: "The value returned when selected" }),
						label: Type.String({ description: "Display label for the option" }),
						description: Type.Optional(Type.String({ description: "Optional description" })),
					}),
				),
			),
		}),

		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (state.mode !== "active") {
				return {
					content: [
						{
							type: "text",
							text: "Error: Not in clarification mode. Run /clarify first.",
						},
					],
					details: { error: "not_in_mode" },
				};
			}

			if (!ctx.hasUI) {
				return {
					content: [
						{
							type: "text",
							text: "Error: UI not available (running in non-interactive mode)",
						},
					],
					details: { error: "no_ui" },
				};
			}

			const hasOptions = params.options && params.options.length > 0;

			// Build options list (with "Type something" option)
			const allOptions = hasOptions
				? [...params.options, { value: "__other__", label: "Type something...", isOther: true }]
				: [{ value: "__other__", label: "Type your answer...", isOther: true }];

			const result = await ctx.ui.custom<AnswerResult | null>((tui, theme, _kb, done) => {
				let optionIndex = 0;
				let inputMode = false;
				let cachedLines: string[] | undefined;

				// Editor theme for custom input
				const editorTheme: EditorTheme = {
					borderColor: (s) => theme.fg("accent", s),
					selectList: {
						selectedPrefix: (t) => theme.fg("accent", t),
						selectedText: (t) => theme.fg("accent", t),
						description: (t) => theme.fg("muted", t),
						scrollInfo: (t) => theme.fg("dim", t),
						noMatch: (t) => theme.fg("warning", t),
					},
				};
				const editor = new Editor(tui, editorTheme);

				// Editor submit callback
				editor.onSubmit = (value) => {
					const trimmed = value.trim();
					if (trimmed) {
						done({ answer: trimmed, isCustom: true });
					} else {
						// Don't submit empty, go back to options
						inputMode = false;
						editor.setText("");
						refresh();
					}
				};

				function refresh() {
					cachedLines = undefined;
					tui.requestRender();
				}

				function handleInput(data: string) {
					// Input mode: route to editor
					if (inputMode) {
						if (matchesKey(data, Key.escape)) {
							inputMode = false;
							editor.setText("");
							refresh();
							return;
						}
						editor.handleInput(data);
						refresh();
						return;
					}

					// Option navigation
					if (matchesKey(data, Key.up)) {
						optionIndex = Math.max(0, optionIndex - 1);
						refresh();
						return;
					}
					if (matchesKey(data, Key.down)) {
						optionIndex = Math.min(allOptions.length - 1, optionIndex + 1);
						refresh();
						return;
					}

					// Select option
					if (matchesKey(data, Key.enter)) {
						const selected = allOptions[optionIndex];
						if (selected.isOther) {
							inputMode = true;
							editor.setText("");
							refresh();
							return;
						}
						done({ answer: selected.label, isCustom: false });
						return;
					}

					// Cancel
					if (matchesKey(data, Key.escape)) {
						done(null);
					}
				}

				function render(width: number): string[] {
					if (cachedLines) return cachedLines;

					const lines: string[] = [];
					const add = (s: string) => lines.push(truncateToWidth(s, width));

					add(theme.fg("accent", "─".repeat(Math.min(width, 60))));

					if (inputMode) {
						// Input mode - show question + editor
						add(theme.fg("text", ` ${params.question}`));
						lines.push("");
						// Show options for reference
						for (let i = 0; i < allOptions.length; i++) {
							const opt = allOptions[i];
							const selected = i === optionIndex;
							const prefix = selected ? theme.fg("accent", "> ") : "  ";
							const color = selected ? "accent" : "text";
							add(prefix + theme.fg(color, `${i + 1}. ${opt.label}`));
						}
						lines.push("");
						add(theme.fg("muted", " Your answer:"));
						for (const line of editor.render(width - 2)) {
							add(` ${line}`);
						}
						lines.push("");
						add(theme.fg("dim", " Enter to submit • Esc to go back"));
					} else {
						// Options mode
						add(theme.fg("text", ` ${params.question}`));
						lines.push("");

						for (let i = 0; i < allOptions.length; i++) {
							const opt = allOptions[i];
							const selected = i === optionIndex;
							const prefix = selected ? theme.fg("accent", "> ") : "  ";
							const color = selected ? "accent" : "text";

							if (opt.isOther && selected) {
								add(prefix + theme.fg("accent", `${i + 1}. ${opt.label} ✎`));
							} else if (selected) {
								add(prefix + theme.fg(color, `${i + 1}. ${opt.label}`));
							} else {
								add(`  ${theme.fg(color, `${i + 1}. ${opt.label}`)}`);
							}

							// Show description if present
							if (opt.description) {
								add(`     ${theme.fg("muted", opt.description)}`);
							}
						}
					}

					lines.push("");
					if (inputMode) {
						add(theme.fg("dim", " Enter to submit • Esc to go back"));
					} else {
						add(theme.fg("dim", " ↑↓ navigate • Enter select • Esc cancel"));
					}
					add(theme.fg("accent", "─".repeat(Math.min(width, 60))));

					cachedLines = lines;
					return lines;
				}

				return {
					render,
					invalidate: () => {
						cachedLines = undefined;
					},
					handleInput,
				};
			});

			// Handle result
			if (result === null) {
				return {
					content: [{ type: "text", text: "User cancelled the question" }],
					details: { cancelled: true },
				};
			}

			// Store the answer
			state.questions.push({
				q: params.question,
				a: result.answer,
				isCustom: result.isCustom,
			});

			// Also update status line
			ctx.ui.setStatus("clarify", `Clarification: ${state.questions.length} question(s) answered`);

			return {
				content: [
					{
						type: "text",
						text: result.isCustom
							? `User wrote: ${result.answer}`
							: `User selected: ${result.answer}`,
					},
				],
				details: {
					question: params.question,
					answer: result.answer,
					isCustom: result.isCustom,
					progress: state.questions.length,
				},
			};
		},

		renderCall(args, theme) {
			const q = args.question as string;
			const opts = args.options as Array<{ label: string }> | undefined;
			let text = theme.fg("toolTitle", theme.bold("clarify_ask "));
			text += theme.fg("text", truncateToWidth(q, 50));
			if (opts && opts.length > 0) {
				const labels = opts.map((o) => o.label).slice(0, 3);
				text += `\n${theme.fg("dim", `  Options: ${labels.join(", ")}...`)}`;
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, _options, theme) {
			const details = result.details as
				| { answer?: string; isCustom?: boolean; cancelled?: boolean; error?: string }
				| undefined;

			if (details?.cancelled) {
				return new Text(theme.fg("warning", "Cancelled"), 0, 0);
			}
			if (details?.error) {
				return new Text(theme.fg("error", `Error: ${details.error}`), 0, 0);
			}
			if (details?.isCustom) {
				return new Text(
					theme.fg("success", "✓ ") + theme.fg("muted", "(wrote) ") + theme.fg("accent", details.answer || ""),
					0,
					0,
				);
			}
			return new Text(
				theme.fg("success", "✓ ") + theme.fg("accent", details?.answer || ""),
				0,
				0,
			);
		},
	});

	// Register clarify_complete tool
	pi.registerTool({
		name: "clarify_complete",
		label: "Clarify Complete",
		description:
			"Complete the clarification workflow. Generates a summary of all Q&A and injects it as a user message to continue with implementation.",
		parameters: Type.Object({
			summary: Type.Optional(
				Type.String({
					description: "Optional brief summary or context to add to the injected message",
				}),
			),
		}),

		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (state.mode !== "active") {
				return {
					content: [
						{
							type: "text",
							text: "Error: Not in clarification mode. Run /clarify first.",
						},
					],
					details: { error: "not_in_mode" },
				};
			}

			if (state.questions.length === 0) {
				return {
					content: [
						{
							type: "text",
							text: "Error: No questions have been answered. Ask at least one question first.",
						},
					],
					details: { error: "no_answers" },
				};
			}

			// Build the summary
			const lines: string[] = [];

			if (params.summary) {
				lines.push(params.summary);
				lines.push("");
			}

			lines.push("Based on the clarification:");
			lines.push("");

			for (const { q, a, isCustom } of state.questions) {
				const prefix = isCustom ? "(user input) " : "";
				lines.push(`- ${q}: ${prefix}${a}`);
			}

			const summaryText = lines.join("\n");

			// Inject as user message to continue
			pi.sendUserMessage(summaryText, { deliverAs: "steer" });

			// Reset state
			const questionCount = state.questions.length;
			resetState();
			ctx.ui.setStatus("clarify", undefined);

			return {
				content: [
					{
						type: "text",
						text: `Injected clarification summary (${questionCount} Q&A) and ready to continue.`,
					},
				],
				details: {
					questionCount,
					injected: true,
				},
			};
		},

		renderCall(args, theme) {
			const summary = args.summary as string | undefined;
			let text = theme.fg("toolTitle", theme.bold("clarify_complete "));
			text += theme.fg("muted", `${state.questions.length} Q&A`);
			if (summary) {
				text += `\n${theme.fg("dim", `  ${truncateToWidth(summary, 50)}`)}`;
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, _options, theme) {
			const details = result.details as
				| { questionCount?: number; error?: string }
				| undefined;

			if (details?.error) {
				return new Text(theme.fg("error", `Error: ${details.error}`), 0, 0);
			}

			return new Text(
				theme.fg("success", "✓ ") +
					theme.fg("text", `Completed ${details?.questionCount || 0} Q&A, injected summary`),
				0,
				0,
			);
		},
	});

	// Listen for session end to reset
	pi.on("session_shutdown", async () => {
		resetState();
	});
}
